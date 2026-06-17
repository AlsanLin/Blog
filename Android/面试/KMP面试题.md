# Kotlin Multiplatform (KMP) 面试题

> KMP 是 Kotlin 生态的差异化方向。面试重点在于理解它的边界——什么能共享，什么不能。

---

### 1. KMP 和 Flutter/React Native 的本质区别是什么？

| 对比维度 | KMP | Flutter / RN |
|---------|-----|-------------|
| 共享范围 | 业务逻辑（网络、数据、Domain 层） | UI + 业务逻辑 |
| UI 层 | 各平台原生 UI（或 Compose Multiplatform） | 自绘引擎 / JS Bridge |
| 定位 | "Write business logic once" | "Write whole app once" |
| 与原生关系 | 补充原生开发，不强占 UI | 替代原生 UI 层 |
| 集成难度 | 低：以库的形式嵌入原生项目 | 中高：需要完整替换或桥接 |

一句话总结：Flutter/RN 想做「一套代码全部平台」，KMP 只想做「业务逻辑写一遍，UI 各平台自己来」。

---

### 2. expect / actual 的工作机制

`expect` + `actual` 是 KMP 的核心机制：
- `expect`：在 commonMain 中声明「这里有一个平台相关的功能」
- `actual`：在 androidMain / iosMain 中提供具体实现

```kotlin
// commonMain
expect fun getPlatform(): Platform

// androidMain
actual fun getPlatform(): Platform = object : Platform {
    override val name = "Android ${android.os.Build.VERSION.SDK_INT}"
}

// iosMain
actual fun getPlatform(): Platform = object : Platform {
    override val name = UIDevice.currentDevice.systemName()
}
```

不用 expect/actual 的替代方案：接口 + 依赖注入（commonMain 定义接口，各平台注入不同实现）。

---

### 3. Ktor 在 Android 和 iOS 上分别用什么引擎？为什么？

- Android：OkHttp 引擎——Android 生态最成熟的 HTTP 客户端，支持 HTTP/2、连接池、拦截器链
- iOS：Darwin 引擎——底层调用 NSURLSession，Apple 原生网络框架，无额外二进制体积

---

### 4. Compose Multiplatform 在 iOS 上的渲染原理是什么？

CMP iOS 使用 Skia 自绘引擎，不是 UIKit 原生控件。渲染流程：Compose 描述 UI → Skia 画到 Canvas → Metal/OpenGL 渲染到屏幕。

这意味着：UI 外观统一，但不等于原生 iOS 体验（手势、动画曲线、无障碍等需要额外适配）。iOS 原生 View 可通过 UIKitView 嵌入 Compose。

> Compose Multiplatform for iOS 在 2024 年 5 月发布 Stable 版本。

---

### 5. KMP 项目的模块怎么组织？依赖注入怎么处理？

模块结构：
```
project/
├── shared/                          # KMP 共享模块
│   └── src/
│       ├── commonMain/              # 跨平台公共代码
│       ├── androidMain/             # Android 特定实现
│       └── iosMain/                 # iOS 特定实现
├── androidApp/
└── iosApp/
```

shared 内部按 Clean Architecture 分层：data（Ktor API + SQLDelight）、domain（model + usecase）、di（依赖注入）。

DI 方案：首选 Koin（KMP 原生支持最广泛），简单项目用手动 DI。

---

### 6. KMP 目前有哪些坑或限制？

1. Kotlin/Native 编译慢：iOS 端编译比纯 Swift 慢很多
2. 库生态不如原生：部分库可能没有 KMP 版本
3. 调试体验：iOS 侧 Kotlin/Native 的调试不如 Swift 方便
4. ObjC/Swift 互操作：复杂的 Swift 特性互操作有限
5. 并发模型差异：Kotlin/Native 有自己的一套内存模型（已大幅改善）