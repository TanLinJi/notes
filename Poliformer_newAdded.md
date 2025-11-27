# 指令下发到狗

New File: /home/jitl/PoliFormer/scripts/ros2_poliformer_node.py

```python
python3 -m py_compile scripts/ros2_poliformer_node.py
```

要通过 ROS 2 将 PoliFormer 生成的动作指令下发到机器狗，需要一个“桥梁”节点。这个节点负责接收图像、运行模型推理，并将结果转换为机器狗能听懂的指令（通常是 `cmd_vel` 速度指令）。

这个脚本 ([ros2_poliformer_node.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)) 实现了以下功能：

1. **加载模型**：启动时加载 PoliFormer 模型（只加载一次，避免延迟）。
2. **订阅图像**：监听 `/camera/color/image_raw`（你可以通过参数修改话题名）。
3. **订阅目标**：监听 [/poliformer/goal](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) (std_msgs/String)，你可以随时发送新的文本指令（如 "find the apple"）。
4. 发布动作：
   - **字符串动作**：发布到 [/poliformer/action](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) (如 "MoveAhead", "RotateLeft")。
   - **速度指令**：发布到 `/cmd_vel` (geometry_msgs/Twist)，直接控制机器人移动。



前置条件：

需要在一个同时安装了 **ROS 2** (如 Humble) 和 **PoliFormer 依赖** (PyTorch 等) 的环境中运行。

```python
# 在 conda 环境中安装 ROS 2 桥接库 (示例)
pip install rospkg empy lark
# 注意：直接在 conda 中完美运行 ROS 2 可能比较麻烦，
# 另一种方法是在系统 Python (已安装 ROS) 中安装 pytorch，或者使用 --system-site-packages
```

运行命令：

```python
# 1. 激活环境
conda activate poliformer
source /opt/ros/humble/setup.bash  # 或者是你的 ROS 2 安装路径

# 2. 运行节点
python3 scripts/ros2_poliformer_node.py \
    --ckpt_path /path/to/your/model.ckpt \
    --device cuda:0
```

参数说明：

你可以通过 ROS 2 参数或命令行参数修改话题：

- `--ros-args -p image_topic:=/dog_camera/image`：修改输入的图像话题。
- `--ros-args -p cmd_vel_topic:=/dog/cmd_vel`：修改输出的速度控制话题。

动作映射（Action Mapping）：

在代码中内置了一个简单的映射函数 `action_to_twist`，将离散动作转换为速度：

| PoliFormer 动作 | 机器狗指令 (Twist)                                           | 说明           |
| --------------- | ------------------------------------------------------------ | -------------- |
| `MoveAhead`     | [linear.x = 0.2](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) | 前进 0.2 m/s   |
| `RotateLeft`    | `angular.z = 0.5`                                            | 左转 0.5 rad/s |
| `RotateRight`   | `angular.z = -0.5`                                           | 右转 0.5 rad/s |
| `Stop` / `Done` | [linear.x = 0](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) | 停止           |

可以以根据你机器狗的实际运动能力，在 [ros2_poliformer_node.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 的 `action_to_twist` 函数中调整这些数值。

测试流程：

1. 启动机器狗的驱动节点（确保它发布图像并接收 `cmd_vel`）。

2. 启动 `ros2_poliformer_node.py`。

3. 发送一个目标指令：

   ```python
   ros2 topic pub /poliformer/goal std_msgs/msg/String "data: 'find the apple'" -1
   ```

   