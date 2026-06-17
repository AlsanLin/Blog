# Clean Architecture 面试题

> Google 官方的 Android 架构指南本质上就是 Clean Architecture 的落地版。面试中重点考察分层意识和依赖方向。

---

### 1. 为什么 Domain 层不能依赖 Android Framework？举个例子说明。

核心原则：Domain 层是纯 Kotlin/Java 代码，不应该 import 任何 `android.*` 包。

反面案例——Domain 层依赖了 Context：
```kotlin
class GetUserUseCase(private val context: Context) {
    operator fun invoke(userId: String): User {
        val prefs = context.getSharedPreferences("user", Context.MODE_PRIVATE)
        // ...
    }
}
```

问题：
1. 无法单元测试：测试时没有 Android 环境，mock Context 非常痛苦
2. 无法跨平台复用：如果未来想用 KMP 共享这个 UseCase，不行
3. 耦合太重：业务逻辑变得和存储方式、Android 版本强绑定
4. 违反依赖反转：Domain 应该定义接口，Data 层提供实现

正确做法：Domain 定义 UserCache 接口，Data 层用 SharedPreferences 实现它。

---

### 2. UseCase 是不是必须的？什么时候可以跳过？

UseCase 不是必须的，取决于场景。

需要 UseCase 的场景：
- 一个业务操作需要组合多个 Repository
- 调用 Repository 前后需要做额外的业务逻辑（校验、转换）
- 同一个业务逻辑被多个 ViewModel 复用

可以跳过的场景：
- 就是简单的 CRUD，ViewModel 直接调 Repository 一行搞定
- 项目很小，加 UseCase 纯粹是过度设计

判断标准：如果 UseCase 的代码只有一行 `repository.xxx()`，那它就不值得存在。

---

### 3. Repository 里怎么处理网络和缓存策略？

五种常见策略：

```kotlin
sealed class FetchStrategy {
    object CacheFirst : FetchStrategy()      // 缓存优先：先读缓存，没命中再请求网络
    object NetworkFirst : FetchStrategy()    // 网络优先：每次都请求网络，失败才用缓存兜底
    object NetworkOnly : FetchStrategy()      // 仅网络：支付、下单等实时数据
    object CacheOnly : FetchStrategy()        // 仅缓存：离线模式
    object CacheAndNetwork : FetchStrategy()   // 并行：先返回缓存，同时请求网络更新
}
```

Cache-First 实现示例：
```kotlin
class UserRepository(
    private val remote: UserRemoteDataSource,
    private val local: UserLocalDataSource
) {
    suspend fun getUser(id: String): Result<User> {
        local.getUser(id)?.let { return Result.success(it) }
        return try {
            val user = remote.getUser(id)
            local.saveUser(user)
            Result.success(user)
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
```

---

### 4. DTO → Domain Model → UI State 三层映射有必要吗？

这三层映射不是教条，各自有职责：

| 层 | 类型 | 职责 |
|----|------|------|
| Data | DTO | 适配 API 返回的 JSON 结构，加 @SerializedName |
| Domain | Domain Model | 纯业务实体，不含任何框架注解 |
| Presentation | UI State | 描述 UI 需要的所有状态（loading/data/error） |

大多数真实项目中这三者结构是不同的：API 返回 `first_name` + `last_name`，UI 要显示 `fullName`；API 返回时间戳，UI 要显示 "3 分钟前"。

---

### 5. sealed class 封装 UI State 的 Loading / Success / Error 三态怎么设计？

```kotlin
sealed class UiState<out T> {
    object Loading : UiState<Nothing>()
    data class Success<T>(val data: T) : UiState<T>()
    data class Error(val message: String, val throwable: Throwable? = null) : UiState<Nothing>()
}
```

为什么不直接用 `Result<T>`：Result 没有 Loading 状态，且 exception 类型是 Throwable，不方便自定义错误信息。

带空状态的设计：
```kotlin
sealed class ListUiState<out T> {
    object Loading : ListUiState<Nothing>()
    object Empty : ListUiState<Nothing>()
    data class Success<T>(val data: List<T>) : ListUiState<T>()
    data class Error(val message: String) : ListUiState<Nothing>()
}
```

---

### 6. Clean Architecture 的三层依赖规则

```
Presentation Layer (ViewModel + Compose/View)
        ↓ depends on
   Domain Layer (UseCase + Repository Interface + Domain Model)
        ↑ implements
    Data Layer (Repository Impl + DataSource + DTO + Mapper)
```

核心规则：
1. 依赖只能由外向内：Presentation → Domain ← Data（Data 实现 Domain 定义的接口）
2. Domain 是核心，不依赖任何框架、平台、数据库
3. Data 层依赖 Domain 层，实现 Repository 接口（依赖反转）