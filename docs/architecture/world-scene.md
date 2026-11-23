# 世界与程序化云场

唯一入口为 scenes/world/world.tscn。

World
├── Environment
│   ├── SkyRig（天空、太阳、WorldEnvironment、运行时钟）
│   └── CloudField（程序化实例化云组件）
├── Preview（四种预览相机与巡览路径）
└── EnvironmentDebugPanel（Godot 原生调试控件）

云组件位于 scenes/world/environment/flow_cloud.tscn，保留上游 CloudModel 的原网格、材质和节点变换。世界只共享一套天空与相机系统。完整上游示例归入 scenes/debug/flow_cloud_original.tscn，供单独 F6 比对。

CloudField 是可在场景中编辑的 [Tool] 节点。生成实例不设置 Owner，因此编辑器预览生成的节点不会写入场景文件。场景保存生成参数，运行时由相同种子重新生成。运行中的实例可在 Remote 场景树查看。

修改生成参数后编辑器自动重建，也可点击「重新生成云」。改变 Seed 可得到另一组可复现的分布。编辑器保持云的位置静止便于观察，着色器表面动画照常执行。游戏内按 WindVelocity 移动，并在生成区域边缘回绕。
