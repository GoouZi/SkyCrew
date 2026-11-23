# 昼夜、天空与光照

打开 `world.tscn`，选择 `Environment/SkyRig`，在 Inspector 调节 `Preview Hour`。天空、太阳和云在 3D 视口立即使用该时刻。在普通视口或相机预览中都可调节。视口菜单中的「查看环境」应保持开启。

## 时间和太阳

`WorldClock` 在运行时按帧累加时数，每帧增加 `24 × delta / DayDurationSeconds`，满 24 小时后回绕。默认从 08:30 起步，一天经过现实时间 240 秒。在该节点可分别设置 `StartHour`、`StartRunning`、`DayDurationSeconds`。编辑器预览时刻独立，进入游戏时由时钟应用开场时间。

太阳节点固定倾角，`SkyRig` 把时刻换成 `Orbit` 的绕 Z 轴角度。06:00 和 18:00 经过水平线，12:00 到达最高点。太阳颜色、光能、环境光颜色和能量都按太阳高度连续变化。24:00 与 00:00 的方向和光照一致。

`SkyRig.cs` 以 `[Tool]` 在编辑器执行预览，并将太阳的全局基向量 +Z 写入共享着色器参数 `skycrew_sun_direction`。Godot 的方向光沿本地 -Z 照射，因此 +Z 指向天空中的太阳。同一个应用函数也供游戏时钟调用。调试滑块直接设置运行时钟。

## 调色和太阳盘

- `daylight_palette.gdshaderinc` 根据太阳高度混合白昼、晨昏和夜间色彩。天空与云雾共用这套过渡，调整一个文件即可同步色温。
- `soft_sky.gdshader` 用观察方向到太阳方向的距离绘制亮核、暖色盘沿、近晕与宽范围散射。低太阳高度时增加暖色，盘与光晕一起淡出。可在 `soft_sky.tres` 调整 `sun_radius` 和 `halo_strength`。
- 方向光与动画驱动的固定色环境光负责场景照明。动态天空用于可见背景，天空反射关闭，立方体通道保持低分辨率的固定颜色。

同时检查 06:15、08:30、12:00、18:15 和 00:00。更改太阳轨道时，核对太阳盘、方向光和云表面明暗是否同步。正午太阳较高，可在编辑器里抬起相机查看盘面。 [Godot 天空着色器](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/sky_shader.html)
