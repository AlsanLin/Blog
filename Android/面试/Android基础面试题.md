### 四大组件
1. Activity的四种启动模式及使用场景
2. singleTask的onNewIntent调用时机和taskAffinity的关系
3. onSaveInstanceState和onRestoreInstanceState的调用时机？哪些场景会触发
4. Activity A启动Activity B，两个Activity的生命周期回调顺序是怎样的
5. Service的onStartCommand返回值的区别(START_STICKY/START_NOT_STICKY/START_REDELIVER_INTENT)
6. IntentService和普通Service的区别？为什么IntentService可以不手动stop
7. BroadcastReceiver的静态注册和动态注册的区别？Android 8.0后对隐式广播的限制？哪个版本后，不再支持静态广播的注册？
8. LocalBroadcastReceiver和BroadcastReceiver的区别
9. ContentProvider为什么适合跨进程数据共享？他的onCreate在什么时候调用

### Fragment
1. Fragment的生命周期和Activity生命周期的对应关系
2. Fragment的懒加载方案演进：setUserVisibleHint->FragmentMaxLifecycle->ViewPager2的BEHAVIOR_RESUME_ONLY_CURRENT_FRAGMENT
3. FragmentManager回退栈的原理？addToBackStack和popBackStack做了什么
4. Fragment重叠问题(Activity重建后Fragment被重复添加)怎么解决
5. replace和add+hide/show的区别和使用场景

### RecyclerView
1. RecyclerView的缓存机制：mAttachedScrap、mCachedViews、mRecyclePool、mViewCacheExtension各自的作用和最大容量
2. onCreateViewHolder和onBindViewHolder的调用时机？什么情况下onCreateViewHolder不调用
3. DiffUtil的原理？areItemsTheSame和areContentsTheSame的区别
4. notifyItemChanged和notifyDataSetChanged的性能差异
5. setHasFixedSize(true)的作用是什么
6. ItemDecoration是在onDraw还是onDrawOver中绘制的，与Item的Z序关系

### 版本适配
1. Android 6.0：运行时权限模型的变化
2. Android7.0：FileProvider替代file://URI的原因和用法
3. Android8.0：通知渠道、后台服务限制、隐式广播限制
4. Android9.0：限制HTTP明文流量(network_security_config)、限制非SDK接口的调用
5. Android10：分区存储、后台定位权限分离
6. Android11：包可见性(queries)、分区存储强制执行
7. Android12：SplashScreen API、PendingIntent可变性声明、精确闹钟权限
8. Android13：通知运行时权限(POST_NOTIFICATIONS)、细粒度媒体权限
9. Android14：前台服务类型声明、scheduleExactAlarm权限收紧
10. Android15：边缘到边缘强制、16KB页面大小
11. Android16：
12. Android17：

### 杂项基础

1. Serializable和Parcelable的区别？Parcelable为什么更快
2. SparseArray和HashMap[Integer]的区别，什么场景用哪个
3. WeakReference、SoftReference、PhantomReference的区别？GC是的行为差异？
4. LayoutInflater.inflate的attachToRoot参数的作用
5. Java和Kotlin互相调用时，什么情况下会出现NullPointerException？@Nullable/@NonNull注解的作用