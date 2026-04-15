online_eval.py

添加了注释



```text
你是一名点云语义分割专业的专家，你对点云数据的处理和分析，点云语义分割的大模型都非常熟悉请你学习我上传的论文，包括文中的图，表，公式等等，你需要对其中涉及的专业技术进行全面系统的学习。在你仔细学习过后，我将上传一篇论文以执行论文理解与阅读任务。
```



`/home/jitl/PoliFormer/tasks/__init__.py`  ： 添加了一行注释





以下是对这个文件的解释：

 `__init__.py` 文件的作用是自动发现并注册所有定义在 tasks 目录下的、继承自 AbstractSPOCTask 的具体任务类。

当你运行代码时，REGISTERED_TASKS 这个字典会包含所有可用的任务类型。虽然代码没有直接列出它们的名字，但我们可以推断出，[tasks](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 目录下的每个任务实现文件（例如 `object_nav_task.py`）都会向这里注册一个任务类型。

最常见的单个任务类型就是 ObjectNavType，它对应于 `object_nav_task.py` 中定义的物体导航任务。





online_evaluator_worker.py 已经修改

为了保证输出动作指令为json文件



____

新添加文件：/home/jitl/PoliFormer/scripts/offline_infer_from_video.py

我已经为你加好了一个可直接使用的“离线视频推理”脚本，支持把你录制的视频帧喂给 PoliFormer，让它在每帧上输出针对“找到一个苹果”的动作序列；同时可选输出叠加了动作文本的视频。

我已为你添加的脚本

- 新文件：[offline_infer_from_video.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)
- 作用：从视频或帧目录读取图像，构建 InferenceAgentVIDA，逐帧调用策略，输出：
  - `actions.json`：动作序列及相对时间戳
  - 可选 `overlay.mp4`：叠加了 goal 与每步动作文字的可视化视频

输入要点：

- 最少只需要提供 `raw_navigation_camera`（脚本自动用视频帧填充）
- 若你能提供检测框，可扩展脚本把 per-frame bboxes 填入 `nav_task_relevant_object_bbox` 或 `nav_accurate_object_bbox`，策略会更稳

```bash
# 仅输出动作 JSON
python scripts/offline_infer_from_video.py \
  --video_path /path/to/your/video.mp4 \
  --goal "find an apple" \
  --ckpt_path /path/to/your/model.ckpt \
  --output_dir ./offline_outputs \
  --device cuda:0 \
  --greedy

# 或者从帧目录读取
python scripts/offline_infer_from_video.py \
  --frames_dir /path/to/frames_dir \
  --goal "find an apple" \
  --ckpt_path /path/to/your/model.ckpt \
  --output_dir ./offline_outputs \
  --device cuda:0 \
  --greedy

# 额外保存叠加动作文本的视频
python scripts/offline_infer_from_video.py \
  --video_path /path/to/your/video.mp4 \
  --goal "find an apple" \
  --ckpt_path /path/to/your/model.ckpt \
  --output_dir ./offline_outputs \
  --device cuda:0 \
  --greedy \
  --save_overlay \
  --fps 5
```

输出：

- ```
  offline_outputs/actions.json
  ```

   

  包含

  - goal: 你的文本目标
  - actions: ["m", "r-90", ...]（复合动作按 “-” 拆分记录）
  - actions_with_timestamps: [{"t": 0.12, "a": "m"}, ...]

- 若加了 `--save_overlay`，还会有 `offline_outputs/overlay.mp4`，帧上显示 step/goal/action 文字

可选增强（如需更强“找苹果”能力）

- 加入检测框（Detic）：对每帧跑一次 Detic，把和 “apple” 相关的 bbox（xyxy、score）填入 observation 的 `nav_task_relevant_object_bbox`，脚本中预留了示例位置（注释里的 keys）。
- 固定动作词典：若你有自定义 `action_dict.json`，可设置环境变量 `ACTION_DICT` 指向该文件，使动作索引→动作名映射一致。

适用场景建议

- 想用真实视频评估策略输出的“动作趋势”：适合
- 想要“自动移动并到达苹果位置”：需要联动可控环境（AI2-THOR/机器人）；单凭视频无法闭环导航

如果你愿意，我也可以帮你把 Detic 集成到这个离线脚本里，自动生成每帧的苹果检测框再交给策略使用，让“找苹果”的目标更明确、更稳。



----

创建新文件：/home/jitl/PoliFormer/scripts/act_once.py

很明确，你的目标是“半闭环”在线控制：机器狗实时上传当前相机帧，你输入指令（如“去找到一个苹果”），PoliFormer立刻输出一个下一步动作给机器狗执行。可以实现。我已经为你加好了最小落地方案，并给出实用对接方式。

方案概览

- 快速开始（单步动作）：使用我新加的脚本 [act_once.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，给它一张当前帧和目标指令，它会输出一个动作字符串（例如 m, r-90, pickup 等）。
- 批量/视频推理：你也可以用 [offline_infer_from_video.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 对一段视频或帧目录做“开环”策略输出，便于批量评估趋势。
- 实时集成建议：将 `act_once.py` 的逻辑抽为一个常驻进程（或简单HTTP/ROS节点），保持模型常驻内存，机器狗每来一帧就调用一次，延迟更低。

已提供的工具

1. 单步动作 CLI（适合接入你的机器人控制循环）

- 文件：[act_once.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)
- 作用：加载模型 → 基于一张 RGB 图与文本目标 → 产出一个动作字符串
- 依赖：只用到项目已有依赖（PIL/numpy/torch等），无需安装新包
- 用法示例（Linux bash）：

```bash
# 返回纯文本动作字符串，适合直接管道传给你的控制程序
python scripts/act_once.py \
  --image_path /path/to/current_frame.jpg \
  --goal "find an apple" \
  --ckpt_path /path/to/model.ckpt \
  --device cuda:0 \
  --greedy

# 返回 JSON（包含动作和概率张量的形状）
python scripts/act_once.py \
  --image_path /path/to/current_frame.jpg \
  --goal "find an apple" \
  --ckpt_path /path/to/model.ckpt \
  --device cuda:0 \
  --greedy \
  --print_json
```

- 输出说明：
  - 纯文本：例如输出 m 或 r-90 等，适合直接驱动机器人动作执行模块
  - JSON：{"action": "m", "probs_shape": [X, Y]}，便于调试/记录

2. 离线视频/帧推理（便于评估策略趋势）

- 文件：[offline_infer_from_video.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)
- 作用：对视频/帧目录执行“开环”推理，输出 actions.json 和可选的带文字叠加的 overlay.mp4
- 用法示例：

```bash
# 从视频推理，输出动作序列
python scripts/offline_infer_from_video.py \
  --video_path /path/to/video.mp4 \
  --goal "find an apple" \
  --ckpt_path /path/to/model.ckpt \
  --output_dir ./offline_outputs \
  --greedy

# 加上叠加视频
python scripts/offline_infer_from_video.py \
  --video_path /path/to/video.mp4 \
  --goal "find an apple" \
  --ckpt_path /path/to/model.ckpt \
  --output_dir ./offline_outputs \
  --greedy --save_overlay --fps 5
```

与“机器狗”集成的推荐方式

为了满足你“当前时刻 → 立即出动作 → 执行”的需求，并降低延迟，建议采用以下任一方式将策略常驻内存：

- 方式 A：长驻 Python 进程（最简单）
  - 写一个小的 Python 服务，把 [build_agent(...)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 放在进程启动时执行一次（加载模型较重），随后暴露一个函数/循环，接收相机帧（numpy/PIL），调用 [agent.get_action(observations, goal)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，立即返回动作字符串。
  - 你的控制主程序通过本地队列/管道调用它，延迟会明显低于每次启动 CLI。
- 方式 B：轻量 HTTP 服务
  - 用标准库 `http.server` 或者简单的 Flask/FastAPI（需要安装依赖）搭一个 POST /act 接口，上传图像+目标，返回动作字符串。
  - 优点：跨语言与跨进程对接容易；缺点：需管理端口与外部依赖。
- 方式 C：ROS/ROS2 节点
  - 封装为一个 ROS 节点，订阅相机话题与目标消息，发布动作话题。
  - 这是机器人系统中最常见的方式，如果你已有 ROS 流水线，强烈建议走这条。

无论哪一种，你都可以直接复用 `act_once.py` 的核心片段：

- 模型只加载一次（保持 agent 常驻）
- 每帧构造 observations = {"raw_navigation_camera": frame_rgb}
- 调用 [agent.get_action(observations, goal)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) → 拆分 “-” 组合动作时，你可以按需拆分/保留



精度与鲁棒性的可选增强

- 目标检测辅助：若你能给每帧跑一次 Detic，并将与“苹果”相关的 bbox 作为 `nav_task_relevant_object_bbox` 或 `nav_accurate_object_bbox` 放进 observations，策略通常会更稳（PoliFormer在训练时可用到 bbox 线索）。
- 自定义动作表：如有特定的机器人动作集合或映射规则，提供 `ACTION_DICT` 环境变量指向你的 `action_dict.json`，让策略输出与你的动作空间一致的字符串。
- 贪心模式：上线控制建议加 `--greedy`，使策略稳定输出最可能的动作（避免随机采样导致抖动）。

注意事项

- 这是“半闭环”：PoliFormer根据单帧+文本做出下一步动作，它不会改变画面本身。要实现完整闭环导航（走过去、判断成功），需要一个可交互的环境（模拟器 AI2-THOR 或真实机器人）推进世界和状态。
- 实时性能：首次加载权重较慢，务必常驻；每帧推理延迟取决于显卡/分辨率/预处理（DINO特征）等。
- 终止条件与安全：在真实机器



如果你希望，我可以进一步：

- 帮你把 `act_once.py` 封装成一个常驻的本地 HTTP 服务（不引入额外依赖的话可以用标准库）。
- 或者写一个最小 ROS 节点，把“帧话题+目标消息→动作话题”的桥接骨架搭好。