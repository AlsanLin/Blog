
### 1. Compose 的 Recomposition 和传统 View 的 invalidate/requestLayout 有什么本质区别？

| 维度 | Compose | View 体系 |
|-----|---------|----------|
| 触发 | State 变化自动触发 | 手动 invalidate/requestLayout |
| 范围 | 智能跳过，只重组读取了变化状态的 Composable | 手动控制，容易多余绘制 |
| 时机 | 同一帧内合并多次变化 | 可能多次 measure/layout/draw |
| 理念 | 描述 UI 应该是什么样 | 命令式把 View 变成什么样 |

核心区别：Compose 编译器插件在编译时就知道哪些 Composable 读取了哪个 State，所以能做到精准的局部重组。

---

### 2. remember 和 rememberSaveable 的区别

- `remember`：仅在重组期间保持状态，配置变更或进程重建后状态丢失
- `rememberSaveable`：配置变更和进程重建后状态仍然保留，原理是将状态存入 Bundle

自定义类型需要用 Saver：
```kotlin
val FormStateSaver = mapSaver(
    save = { mapOf("name" to it.name, "age" to it.age) },
    restore = { FormState(it["name"] as String, it["age"] as Int) }
)
```

---

### 3. LaunchedEffect(key) 的 key 变化时会发生什么？

旧 key 对应的协程被取消，新协程重新启动。如果 key 不变则持续运行。离开组合时协程自动取消。

---

### 4. Modifier 的顺序为什么重要？

Modifier 从左到右依次包裹，外层先应用。
- `padding(16).clickable()`：点击区域不包括 padding
- `clickable().padding(16)`：点击区域包括 padding

---

### 5. 怎么在 Compose 中避免不必要的重组？

1. @Stable / @Immutable：标记稳定类型
2. derivedStateOf：只有计算结果真正变化时才触发重组
3. key()：帮助 Compose 正确识别列表项 identity
4. lambda 记忆化：remember { { doSomething() } }
5. 参数尽量是基本类型、String、data class
6. 状态读取位置下移：只在需要状态的 Composable 中读取

---

### 6. mutableStateListOf vs mutableListOf + mutableStateOf？

- mutableStateListOf()：增删改都能触发重组
- mutableStateOf(mutableListOf())：只有整体赋值才触发重组，list.add() 不触发

---

### 7. CompositionLocal 的用途？

隐式传递数据给整个 Composable 子树（如 LocalContext.current）。注意：只用于全局稳定的数据，频繁变化的值会导致大量重组。

---

### 8. SubcomposeLayout 的原理？

在主组合之后延迟组合部分内容，子内容可以读取父布局的约束后再决定如何组合。典型场景：BoxWithConstraints、LazyColumn、Scaffold。