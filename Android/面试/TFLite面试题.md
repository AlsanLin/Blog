# TensorFlow Lite 面试题

> 移动端 AI 是加分项。面试中通常不会要求写复杂模型，但需要理解部署流程和性能优化思路。

---

### 1. TFLite 的 INT8 量化原理是什么？为什么不直接用 FP32？

量化原理：把 FP32 的浮点权重和激活值映射到 INT8 整数范围。公式：`real_value = (int8_value - zero_point) * scale`。

为什么不直接用 FP32：
- 模型体积缩小约 4 倍（32 bit → 8 bit）
- 推理速度提升 2-3 倍（整型运算比浮点快）
- 内存占用更低，耗电更少
- 某些移动端 NPU/DSP 只支持 INT8
- 精度损失通常在 1-3% 以内，大多数场景可接受

---

### 2. GPU Delegate 和 NNAPI 的区别，各自适用什么场景？

| 维度 | GPU Delegate | NNAPI |
|-----|-------------|-------|
| 运行硬件 | GPU | 取决于设备（DSP/NPU/GPU/CPU） |
| 适用场景 | 视觉模型（CNN），并行计算密集型 | 各类模型，Android 官方推荐 |
| 兼容性 | 基于 OpenGL ES 3.1+/OpenCL | Android 8.1+，不同厂商实现差异大 |
| 首帧延迟 | 有初始化开销 | 较小 |
| 稳定性 | 相对稳定 | 部分厂商实现有 bug |

选择策略：优先尝试 NNAPI（自动选最优硬件），CNN 类视觉模型可额外测试 GPU Delegate。最终要在目标设备上实测。

```kotlin
// GPU Delegate
val options = Interpreter.Options().apply { addDelegate(GpuDelegate()) }
// NNAPI
val options = Interpreter.Options().apply { setUseNNAPI(true) }
```

---

### 3. 如果模型太大放不进 APK，有哪些方案？

1. 动态下载：APK 只放轻量版，首次启动时从服务器下载完整模型
2. Firebase ML Kit 远程模型：Google 托管，自动处理下载和更新
3. AAB (Android App Bundle)：用 Play Feature Delivery 按需分发
4. 模型拆分：把模型拆成 encoder + decoder，按需加载
5. 量化 + 剪枝：先用 INT8 量化，再对不重要的通道做剪枝

---

### 4. 怎么衡量一个模型在移动端跑得好不好？

四个核心指标：

1. 推理延迟（Inference Latency）：P50/P90/P99 都要看，在低端机型上测试更有意义
2. 内存占用：模型加载后的内存增量 + 运行时的峰值内存
3. 耗电量：连续推理 10 分钟的电池消耗
4. APK 体积增量：.tflite 文件 + 依赖库的 zip 增量

实用工具：Android Studio Profiler + TFLite Benchmark Tool

---

### 5. 输入图像预处理一般要做哪些步骤？为什么必须和训练时保持一致？

典型预处理流程：
1. 缩放：Bitmap → 模型输入尺寸（如 224x224）
2. 类型转换：Bitmap → ByteBuffer
3. 归一化：像素值从 [0,255] 映射到 [-1,1] 或 [0,1]
4. 通道顺序：RGB → 模型期望的格式（如 BGR）

为什么要一致：训练时的预处理决定了模型「看到的」数据分布。预处理不一致 = 输入数据分布偏移 → 推理结果完全不可靠。

---

### 6. 动态范围量化 vs 全整数量化 vs FP16 量化怎么选？

| 量化方式 | 模型大小 | 速度提升 | 精度损失 | 复杂度 |
|---------|---------|---------|---------|-------|
| 动态范围 | ~75% 缩小 | 2-3x（CPU） | 极小 | 最简单 |
| 全整数 INT8 | ~75% 缩小 | 3-4x | 1-3% | 需要校准数据集 |
| FP16 | ~50% 缩小 | GPU 加速明显 | 几乎无损 | 简单，GPU 专用 |

通用策略：先试动态范围量化，效果不够 → 全整数量化（准备代表性数据做校准）→ CNN 模型加试 FP16 + GPU Delegate。