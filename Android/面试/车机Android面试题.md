### AAOS基础概念
1. Android Auto(手机投屏)和Android Automotive OS(车机原生系统)的本质区别
2. AAOS的系统架构和手机Android相比，多了哪些专属组件(CarService/Car Api/ VHAL /CarSystemUI)
3. 车载Android的GAS(Google Automotive Services)和手机的GMS有什么区别
4. 车机IVI的生命周期和手机App有什么不同，车机App有被杀进程的概念吗
5. 一心多屏架构下，一个SoC如何驱动仪表盘+中控+后排多个屏幕，对APP开发有什么影响

### Car API应用层开发
1. CarUxRestrictionManager的作用，行驶中的UX限制有哪些(内容长度、视频、列表帧数)
2. 如何监听车速变化？CarSensorManager获取车速的流程？和手机GPS测速的区别
3. CarAppFocusManager管理音频焦点的规则？导航、电话、音乐抢焦点的优先级
4. CarCabinManager/CarHvacManager控制座舱温度/空调的流程
5. androidx.car.app库是用来开发什么类型的应用的，他的模版约束是什么
6. 车机App的输入方式(触控/旋钮/语音/方向盘按键)如何统一适配

### VHAL/CAN总线
1. VHAL(Vehicla HAL)在AAOS架构中的位置和作用
2. App调用CarSensorManager获取数据的完整链路(App->CarService->VHAL->CAN-ECU)
3. CAN总线的基本帧格式(11位/29位ID+数据域)？CAN FD的改进
4. DBC文件是什么，他和CAN信号的映射关系
5. 你之前设计的BLE二进制协议和CAN通信在设计思想上的共同点

### 车机特有性能问题
1. 车机冷启动时间要求一般是多少，倒车影像为什么要求<2秒出画面
2. 车机启动优化的策略，和手机App启动优化的异同
3. 车机内存限制，低内存设备上如何保证APP稳定性
4. 车机系统需要满足哪些质量标准

### 行业和架构
1. 车机SOA(面向服务架构)的设计思想和微服务架构的类比
2. OTA升级的流程，车机Ap更新和整车固件更新的区别
3. 多车型适配的挑战，一个APK适配所有车型 vs 车型独立分治的trade-off
4. 车机App的测试有什么特殊性，HIL(硬件在环)测试的概念
5. 车载语音助手的架构，云端ASR和本地热词唤醒的配合