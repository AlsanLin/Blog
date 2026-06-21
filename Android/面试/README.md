
# Android 面试系列

> 整理自实际面试经验，覆盖中高级 Android 开发的核心考点。按模块分类，每题附答题要点。
> 共 14 个模块，约 300+ 道面试题，覆盖 武汉 Android 高阶/专家岗 的全部考察范围。

---

## 分类导航

### 基础层

| 模块 | 内容 |
|------|------|
| [**Java 基础**](/Android/面试/Java基础面试题.md) | 面向对象、集合框架、多线程与并发、JVM 内存模型、异常处理、基础语法、I/O |
| [**Android 基础**](/Android/面试/Android基础面试题.md) | 四大组件、Fragment、RecyclerView 缓存、版本适配（Android 6-15）、杂项 |
| [**Framework 源码**](/Android/面试/Framework源码面试题.md) | Handler 机制、Binder 跨进程通信、AMS/WMS/系统服务、View 体系 |

### Kotlin 核心

| 模块 | 内容 |
|------|------|
| [**Kotlin 协程 / Flow / 泛型**](/Android/面试/Kotlin协程Flow泛型面试题.md) | 挂起函数原理、结构化并发、冷流热流、型变、reified |

### UI 与架构

| 模块 | 内容 |
|------|------|
| [**Jetpack Compose**](/Android/面试/Compose面试题.md) | 重组机制、状态管理、副作用 API、Modifier 顺序、性能优化 |
| [**Clean Architecture**](/Android/面试/CleanArchitecture面试题.md) | 三层分层、依赖反转、UseCase 设计、Repository 模式、DI |

### 性能与工程

| 模块 | 内容 |
|------|------|
| [**性能优化**](/Android/面试/性能优化面试题.md) | 启动优化、内存优化、卡顿优化、包体积优化 |
| [**设计模式**](/Android/面试/设计模式面试题.md) | 创建型 / 结构型 / 行为型 + Android 源码中的应用 |
| [**算法**](/Android/面试/算法面试题.md) | 链表、二叉树、数组/字符串、动态规划（入门）、排序、HashMap 原理 |

### 跨平台与扩展

| 模块 | 内容 |
|------|------|
| [**Flutter**](/Android/面试/Flutter面试题.md) | 渲染原理、状态管理、Platform Channel、性能优化、工程化 |
| [**车机 Android**](/Android/面试/车机Android面试题.md) | AAOS 基础、Car API、VHAL/CAN 总线、车机特有性能问题、行业架构 |

### 差异化竞争力

| 模块 | 内容 |
|------|------|
| [**TensorFlow Lite**](/Android/面试/TFLite面试题.md) | 模型量化、GPU/NNAPI 加速、输入预处理、部署策略 |
| [**Kotlin Multiplatform**](/Android/面试/KMP面试题.md) | expect/actual、Ktor、SQLDelight、Compose Multiplatform |

### 软技能

| 模块 | 内容 |
|------|------|
| [**项目及团队管理**](/Android/面试/项目及团队管理面试题.md) | 项目深度追问、架构设计、技术领导力、团队管理、跨团队协作、职业发展 |

---

## 学习建议

### 备考优先级

1. **Java 基础 → Framework 源码 → 性能优化 → 协程/Flow** 是硬通货，面试绕不开，优先吃透
2. **Android 基础 → Compose → Clean Architecture** 高频必考，紧跟其后
3. **设计模式 → 算法** 基础扎实才不怕追问
4. **Flutter → 车机 Android** 差异化竞争力，按目标公司选择侧重
5. **KMP ≈ TFLite** 加分项，有余力时再补
6. **项目及团队管理** 高阶岗必问，准备 3 个 STAR 故事

### 备考方法

- 每题不止于背结论，要能说出 **为什么** 和 **怎么选**
- 把每个知识点和你自己做过的项目挂钩——面试官更想听你的故事
- 算法每天刷 3 题，重在讲清楚时间复杂度 + 空间复杂度 + 为什么选这个解法
- 车机方向的面试知识在武汉市场权重高，建议优先熟悉 Car API 和 AAOS 基础

