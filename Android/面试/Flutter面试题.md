### 渲染原理
1. Flutter的三棵树(Wieget/Element/RenderObject)各自的生命周期和职责
2. setState调用后，从Wieget到屏幕上像素的完整链路
3. Widget的canUpdate方法判断依据是什么？key和runtimeType的作用
4. GlobalKey vs ValueKey vs ObjectKey vs UniqueKey的使用场景和区别
5. RepaintBoundary的原理，什么时候使用他能减少重绘
6. const构造函数对性能的影响，编译器能做什么优化
7. Flutter的渲染引擎Skia/Impleller的区别，Impeller解决了Skia的什么问题

### 状态管理
1. setState->InheritedWidget->Provider->BLoC->GetX，各自的使用规模
2. BLoc的核心思想？Stream作为状态管道的优缺点
3. GetX的响应式原理？obs变量的Rx机制是如何追踪依赖的
4. Provider的ChangeNotifierProvider和StreamProvider的区别
5. Riverpod解决了Provider的什么问题
6. 你做的BLE项目为什么选择GetX，如果重做会选什么(参考问题1)

### Platform Channel和原生混编
1. Platform Channel的三种类型(MethodChannel /EventChannel/ BasicMessageChannel)的区别
2. MethodChannel的通信是异步的，底层BinaryMessenger的实现原理
3. Flutter调用原生代码的性能开销有多大，频繁调用时如何优化
4. PlatformView(AndroidView/UiKitView)的性能问题和替代方案
5. Texture Widget渲染原生内容的原理？和PlatformView的对比
6. 你在T11设计的跨端通信协议和Platform Channel的异同

### 性能优化
1. Flutter 列表性能优化：ListView.Builder vs ListView的区别？itemExtent参数的作用
2. 图片缓存：ImageCache的maximumSIze和maximumSizeBytes如何调优
3. SkSL预热时什么，为什么首次运行Flutter App会有着色器编译耗时
4. Widget build方法中做了耗时计算怎么办，compute/Isolate如何迁移到Dart后台线程
5. Flutter DevTools的Performance面板怎么定位卡顿？Frame Chart的红色，紫色帧代表什么

### 工程化
1. Flutter项目的模块化拆分策略？pubspec.yaml的依赖管理和版本冲突解决
2. 热重载和热重启的区别，什么情况下热重载不生效
3. --release vs --profile vs --debug模式的区别
4. Flutter和原生代码混合路由管理，Flutter页面和Native页面如何相互跳转