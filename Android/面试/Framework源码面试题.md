### Handler 机制

1. Handler、Looper、MessageQueue三者关系，用一句话讲清楚

2. Looper.loop()是个死循环，为什么不会导致ANR？

3. MessageQueue的next()方法在没有消息时做了什么，为什么不会阻塞UI线程？

4. IdleHandler的原理和使用场景是什么？Glide/LeakCanary中是怎么用的

5. 屏障消息(SyncBarrier)是什么，异步消息(setAsynchronous)的典型使用场景？

6. Message复用池(obtain/recycle)的实现原理？为什么不直接用new?

7. postDelayed的延时精度能达到毫秒级吗，误差来源是什么？

8. 主线程Looper什么时候创建的，为什么new Handler()在主线程可以直接用，子线程不行

9. 子线程可以创建Handler吗？需要做什么

10. HandlerThread和普通的Thread+Looper.prepare()有什么区别

### Binder跨进程通信

1. Binder为什么只需要一次拷贝？他和Linux传统IPC(管道/Socket/共享内存)的本质区别是什么
2. 从App调用startActivity到AMS处理，Binder调用链路是怎样的？
3. Binder线程池默认多少个线程？线程不够时会怎样，如何配置
4. oneway关键词的作用是什么？什么场景适合用
5. Binder传递数据的大小限制是多少，为什么会有这个限制，超大了怎么办
6. Parcel vs Serializable的区别，为什么Android不用Java原始的Serializable
7. AIDL生成代码中，Stub和Proxy分别扮演什么角色，和设计模式有什么关系
8. Binder的死亡代理(DeathRecipient)是什么？什么时候需要用到
9. ContentProvider的底层也是Binder，他的Crud是同步还是异步执行的
10. Binder和mmap的关系-共享内存的角色是什么

### AMS、WMS、系统服务

1. 从点击桌面图标到Activity启动完成，系统层(AMS/Zygote/Binder)发生了什么
2. startActivity和Activity.onCreate之间经历了哪些进程和步骤
3. AMS中Activity的Task和Stack的管理模型是怎样的
4. singleInstance启动模式的任务栈有什么特殊性，实际使用场景举例
5. WMS如何管理Window的Z序，Dialog、PopupWindow、Toast的WindowType分别是什么
6. ViewRootImpl的职责？他和WIndow、DecorView、WMS的关系？
7. SurfaceFlinger做了什么？SurfaceView和普通View的渲染路径有什么不同

### View体系

1. MeasureSpec的三种模式(Exactly、AT_MOST、UNSPECIFIED)分别由什么条件产生
2. requestLayout、invalidate、postInvalidate的区别和调用时机
3. View的onMeasure、onLayout、onDraw调用链是怎么样的，父View和子View的调度顺序？
4. getWidth()和getMeasureWidth()的区别
5. 事件分发：dispatchTouchEvent->onInterceptTouchEvent->onTouchEvent的完整决策流程
6. requestDisallowInterceptTouchEvent的使用场景，内部实现原理
7. ViewGroup和子View的滑动冲突如何解决？外部拦截法和内部拦截法的区别和适用场景
8. getX()/getRawX()/translationX/scrollX分别是什么含义
9. 自定义View的三个核心步骤？onMeasure中如何正确处理wrap_content
10. View.setVisibility(GONE)和View.setVisibility(INVISIBLE)在测量/布局/绘制阶段的区别
