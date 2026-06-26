
## 协程（Coroutines）

### 1. launch 里抛出异常和 async 里抛出异常，传播路径有什么不同？

**答题要点：**

- `launch` 抛出的异常会**立即传播**，如果没有被 `CoroutineExceptionHandler` 捕获，会直接崩溃
- `async` 抛出的异常会被**封装在 Deferred 内部**，只有在调用 `await()` 时才会重新抛出
- 这意味着 `async` 的异常是「延迟暴露」的——你可以在合适的时机处理它

```kotlin
// launch —— 异常立即抛出，如果不捕获会崩溃
scope.launch {
    throw RuntimeException("launch 异常")  // 直接传播
}

// async —— 异常被包裹，await 时才抛出
val deferred = scope.async {
    throw RuntimeException("async 异常")
}
try {
    deferred.await()  // 这里才抛出
} catch (e: Exception) {
    // 可以在这里处理
}
```

---

### 2. SupervisorJob 用在什么场景？为什么 viewModelScope 默认不用它？

**答题要点：**

- `SupervisorJob`：一个子协程失败时，**不会取消兄弟协程和父协程**
- `Job`（默认）：一个子协程失败，会导致父协程和所有兄弟协程被取消
- 适用场景：**多个独立的子任务并行执行，一个失败不应影响其他**——比如首页同时请求三个接口，用户信息接口挂了，不能让 banner 和推荐列表也跟着挂
- `viewModelScope` 用的是 `Job`：ViewModel 销毁时所有协程应该**一起取消**，不需要 SupervisorJob 的「单点容错」语义

```kotlin
// SupervisorJob 示例
val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
scope.launch {
    launch { error("子协程1挂了") }
    launch { delay(1000); println("子协程2仍会执行") }  // 不受影响
}
```

---

### 3. StateFlow 和 LiveData 的对比，什么时候选哪个？

**答题要点：**

| 对比维度 | StateFlow | LiveData |
|---------|-----------|----------|
| 初始值 | **必须有初始值** | 可为 null，等第一次赋值 |
| 去重 | equals 比较，自动去重 | 默认不去重（需要用 DistinctLiveData） |
| 生命周期感知 | 需要手动在 Lifecycle 中 collect | 自动感知，observe 即可 |
| 线程 | 不限定线程 | setValue 主线程，postValue 任意线程 |
| Kotlin 原生 | 是，协程生态 | 否，Android 组件 |
| 运算符 | 支持 map/filter/combine | 需要用 Transformations |

**选择策略：**
- 纯 Kotlin 层（ViewModel 内部、Repository）用 `StateFlow`
- 和 UI 层的快速绑定，老项目或团队习惯用 `LiveData`
- Compose 项目直接用 `StateFlow` + `collectAsStateWithLifecycle()`

---

### 4. 写一个 callbackFlow 把单次回调转成 Flow，并处理取消时注销监听。

**答题要点：**

```kotlin
fun SensorEventFlow(sensorManager: SensorManager): Flow<FloatArray> = callbackFlow {
    val sensor = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
    val listener = SensorEventListener { event ->
        trySend(event.values.clone())  // 发送数据
    }
    sensorManager.registerListener(listener, sensor, SensorManager.SENSOR_DELAY_NORMAL)

    // awaitClose 是必须的：协程取消时回调会被调用
    awaitClose {
        sensorManager.unregisterListener(listener)  // 释放资源
    }
}
```

**关键点：**
- `callbackFlow` 内部是一个挂起的作用域，可以使用 `trySend` / `send`
- `awaitClose` 是**必须调用的**，否则协程取消时资源不会被释放
- 如果不调用 `awaitClose`，callbackFlow 会抛出异常

---

### 5. 结构化并发的核心原则是什么？

- **父子关系**：每个协程必须在一个 Scope 中启动，形成父子树
- **取消传播**：父协程取消 → 所有子协程取消；子协程异常 → 取消兄弟和父协程（除非 SupervisorJob）
- **完成等待**：父协程会等待所有子协程完成才结束
- 这三个原则保证了**不会出现「协程泄漏」**——协程永远不会「跑丢」

---

## Flow

### 6. 冷流和热流的本质区别？

**答题要点：**

- **冷流（Cold Flow）**：每次 `collect` 都会**重新执行生产者代码**，每个收集者是独立的——`flow { }` 构建器创建的就是冷流
- **热流（Hot Flow）**：生产者独立于收集者运行，多个收集者**共享同一份数据流**——`SharedFlow` / `StateFlow` 是热流

```kotlin
// 冷流：每次 collect 都重新发射
val cold = flow { println("开始发射"); emit(1); emit(2) }
cold.collect { println("收集者A: $it") }  // 打印"开始发射"
cold.collect { println("收集者B: $it") }  // 再次打印"开始发射"

// 热流：多个收集者共享
val hot = MutableSharedFlow<Int>()
scope.launch { hot.emit(1); hot.emit(2) }
hot.collect { println("A: $it") }
hot.collect { println("B: $it") }
```

---

### 7. SharedFlow 的三个关键参数怎么理解？

- `replay`：新订阅者加入时，**重放最近 N 个值**（默认 0）
- `extraBufferCapacity`：除 replay 外**额外的缓冲区大小**
- `onBufferOverflow`：缓冲区满了怎么办——`SUSPEND`（挂起等待）、`DROP_OLDEST`（丢弃最旧）、`DROP_LATEST`（丢弃最新）

---

### 8. Flow 的背压处理策略有哪些？

- `buffer()`：添加缓冲区，生产者不等待消费者
- `conflate()`：跳过中间值，消费者只处理最新的
- `collectLatest()`：新值到来时，取消当前正在处理的任务，立即处理新值（适合搜索联想等场景）

```kotlin
flow { for (i in 1..100) { delay(10); emit(i) } }
.conflate()
.collect { delay(100); println(it) }  // 慢速消费，跳过中间值
```

---

### 9. flowOn 改变的是哪个线程？

- `flowOn` 改变的是**上游操作符**的执行线程
- **不影响下游** collect 的线程（collect 在哪里调用就在哪个线程运行）

```kotlin
flow {
    println("emit: ${Thread.currentThread().name}")  // 受 flowOn 影响
    emit(1)
}
.map { println("map: ${Thread.currentThread().name}") } // 受 flowOn 影响
.flowOn(Dispatchers.IO)
.collect { println("collect: ${Thread.currentThread().name}") }  // 不受 flowOn 影响
```

---

## 泛型

### 10. inline + reified 的原理是什么？为什么非内联函数不能用 reified？

**答题要点：**

- Java 的泛型在运行时会被**擦除**（Type Erasure），`T` 在运行时就是 `Object`
- `inline` 函数在编译时会被**内联到调用处**，此时类型信息还在，所以可以用 `reified` 保留
- 非内联函数在运行时独立存在，泛型信息已经丢失，无法获取 `T::class`

```kotlin
inline fun <reified T> Gson.fromJson(json: String): T {
    return fromJson(json, T::class.java)  // reified 让 T::class.java 成为可能
}
```

---

### 11. 为什么 MutableList<String> 不能赋值给 MutableList<Any>？

**答题要点：** 如果允许就会导致类型安全问题——你往一个声称接受 `Any` 的列表里放 `Int`，实际底层是 `String` 列表，读取时就 ClassCastException。`MutableList` 既是生产者又是消费者，所以既不能协变也不能逆变——它是**不变的（Invariant）**。

---

### 12. out（协变）和 in（逆变）分别用在什么场景？

- `out`（协变，PECS 中的 Producer）：**只出不进**——`List<out Number>` 只能读，可以接受 `List<Int>` 作为参数
- `in`（逆变，PECS 中的 Consumer）：**只进不出**——`Comparable<in String>` 可以接受 `Comparable<Any>`、`Comparable<CharSequence>`

```kotlin
fun sum(numbers: List<out Number>): Double = numbers.sumOf { it.toDouble() }
fun fill(dest: MutableList<in String>, value: String) { dest.add(value) }
```

