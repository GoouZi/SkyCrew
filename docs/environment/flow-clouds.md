# Flow Cloud 与生成规则

世界中使用 scenes/world/environment/flow_cloud.tscn。该组件包含原版 CloudModel，复用 assets 里的原网格和原版材质。完整原版演示保存在 scenes/debug/flow_cloud_original.tscn，可按 F6 比对上游天空、曝光和相机条件。

## 原版动画原理

顶点先转换为世界坐标，叠加 A、B、C 三档 simplex 噪声。每档有独立的频率、方向、时间速度和强度。叠加值沿世界法线偏移，乘 procedural_displacement_strength，再通过模型矩阵的逆变换换回局部坐标。云实例放大时，位移仍以世界单位计算。

片元按 flow_size 缩放世界坐标，按 flow_speed 推进表面采样。噪声图通过三平面投影融合，并由 3D 与 2D 噪声共同调制表面颜色。材质的假光照来自世界高度和 fake_light_direction，当前数值产生蓝色云。世界昼夜控制天空与灯光，原版 unshaded 云材质使用自身的假光照。

## 程序化分布

CloudField 覆盖默认 5.2 × 5.2 千米，中心位于世界 Z=-1200。生成器先把区域分成约 720 米的格子，打乱格子顺序，再按默认 0.65 的占用概率选择位置。每格最多一朵，偏移不超过格宽的 18%。尺寸为原版组件的 8–13 倍，默认种子 128 生成 37 朵，最接近的云心约相距 534 米。

MinimumAltitude 约束世界坐标中的最低云底，默认 450 米。生成时由网格 AABB、原版 CloudModel 的 -4 米偏移、实例缩放计算云底，再为原版顶点最大位移预留 0.31 米。HeightBand 决定最低云底之上的随机高度带，默认 300 米。

运行时所有云按同一水平 WindVelocity 平移，超出范围后循环到另一端。相对间隔保持稳定，数量受 MaxClouds 限制。所有实例共享同一网格和材质。云体没有物理碰撞，可直接飞过。

编辑器选择 Environment/CloudField，调节属性即可重建。生成位置可由种子复现。CloudScene 指向可编辑的云组件，预览实例在 Remote 场景树中检查。

[上游实现](https://github.com/ffttasd/Didi-Dev-Lab/tree/fe8bb31ed09eebd89f2ff87a8df84354bbb1858f/flow_cloud)
