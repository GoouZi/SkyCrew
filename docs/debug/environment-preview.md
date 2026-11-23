# 环境调试与预览

在 `world.tscn` 里实例化了 `environment_debug_panel.tscn` 和 `environment_preview.tscn`。面板使用 Godot 默认主题的 `PanelContainer`、`Label`、`HSlider`、`CheckButton`、`OptionButton` 与容器。场景中的信号连接可在 Inspector 的节点面板中找到。

| 控件 | 行为 |
| --- | --- |
| F3 | 显示或隐藏调试面板，继续当前环境和镜头状态 |
| 时间滑块 | 拖动或使用方向键，以一分钟为步长定位到 00:00–24:00。手动拖动会暂停自动昼夜 |
| 自动昼夜 | 从当前时刻继续播放，或暂停在当前时刻 |
| 预览镜头 | 在云海全景、云层上方、空中巡览和云底仰视之间切换 |

在面板场景的根节点上，Inspector 导出引用连接到时间滑块、标签和播放开关。`world.tscn` 还负责连接时钟、四台相机和航线动画。手动拖动通过 `drag_started` 暂停，通过 `value_changed` 定位。自动播放时面板用 `SetValueNoSignal` 回填滑块，避免更新控件时再次触发暂停。

穿云相机挂在 `PathFollow3D` 下。`cloud_flight.tres` 在 24 秒内将路程比例从 0 播到 1，随后回到起点。航线途经近处 `Near/Cloud10` 和中段 `Middle/Cloud11` 的中心。打开 `environment_preview.tscn` 编辑 `FlightPath` 的曲线点，或在 Animation 面板定位 `fly_through`。回到任一固定相机时，预览动画会停止。
