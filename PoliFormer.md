PoliFormer 是一个基于 Transformer 的强化学习项目，专注于机器人导航任务，特别是对象导航（Object Navigation）。该项目使用 AllenAct 框架、DINO 视觉编码器和 LLaMA 风格的 Transformer 来训练强大的导航代理。

### 项目结构

```text
PoliFormer/
├── README.md                         # 项目介绍、数据/训练/评测与环境变量
├── TRAINING_README.md                # 训练/评测命令与自定义模型规范
├── pyproject.toml                    # black/isort/构建后端配置
├── requirements.txt                  # 精简依赖（torch、lightning、xformers、open-clip）
├── spoc_constants.py                 # 项目根路径常量
├── docker/
│   ├── Dockerfile
│   ├── README.md
│   ├── create_image.sh
│   └── create_session.sh
├── architecture/                     # 模型与预处理
│   ├── agent.py                      # 在线评测 Agent 封装
│   ├── allenact_preprocessors/
│   │   └── dino_preprocessors.py     # DINO 特征预处理
│   └── models/
│       └── allenact_transformer_models/
│           ├── allenact_dino_transformer.py  # DINO + Transformer 模型
│           └── inference_agent.py            # 推理专用 Agent
├── environment/                      # 环境传感器与机器人封装
│   ├── navigation_sensors.py
│   ├── vision_sensors.py
│   ├── manipulation_sensors.py
│   ├── stretch_state.py
│   ├── stretch_controller.py
│   └── spoc_objects.py
├── tasks/                            # 任务定义与采样器
│   ├── abstract_task.py
│   ├── abstract_task_sampler.py
│   ├── multi_task_eval_sampler.py
│   ├── object_nav_task.py
│   └── task_specs.py
├── training/
│   └── online/                       # 在线训练与评测
│       ├── base.py
│       ├── allenact_trainer.py
│       ├── chores_dataset.py
│       ├── dataset_mixtures.py
│       ├── dinov2_vits_tsfm_rgb_augment_objectnav.py  # 训练入口脚本
│       ├── online_eval.py                             # 评测入口脚本
│       ├── reward/
│       │   └── reward_shaper.py
│       └── third_party_models/
│           └── llama/
│               └── model.py
├── online_evaluation/                # 在线评测框架
│   ├── online_evaluator.py
│   ├── online_evaluator_worker.py
│   ├── online_evaluation_types_and_utils.py
│   ├── max_episode_configs.py
│   └── local_logging_utils.py
├── utils/                            # 辅助工具集合
│   ├── bbox_utils.py
│   ├── data_utils.py
│   ├── detic_utils.py
│   ├── distance_calculation_utils.py
│   ├── local_logging.py
│   ├── nn_utils.py
│   ├── objaverse_annotation.py
│   ├── sel_utils.py
│   ├── sensor_constant_utils.py
│   ├── string_utils.py
│   ├── task_datagen_utils.py
│   ├── task_sampler_utils.py
│   ├── task_spec_to_instruction.py
│   ├── task_type_mapping_utils.py
│   ├── transformation_util.py
│   ├── type_utils.py
│   ├── visualization_utils.py
│   ├── wandb_logging.py
│   ├── wandb_utils.py
│   ├── synset_to_best_lemma.json
│   ├── constants/
│   │   ├── objaverse_data_dirs.py
│   │   ├── object_constants.py
│   │   ├── stretch_initialization_utils.py
│   │   └── template_verbs.py
│   └── data_generation_utils/
│       ├── exception_utils.py
│       ├── loc_grid_conversion.py
│       ├── mp4_utils.py
│       └── navigation_utils.py
├── scripts/                          # 数据/权重下载脚本
│   ├── download_training_data.py
│   ├── download_objaverse_houses.py
│   └── download_trained_ckpt.py
├── models/
│   └── flan-t5-small/                # HF 权重与 tokenizer
│       ├── config.json
│       ├── tokenizer.json
│       └── pytorch_model.bin ...
├── data/                             # 训练/评测数据（体量大，不逐文件展开）
│   ├── fifteen/
│   ├── objaverse_assets/
│   └── objaverse_houses/
├── checkpoints/                      # 预训练权重
│   ├── text_nav/model.ckpt
│   ├── box_nav/model.ckpt
│   └── text_box_nav/model.ckpt
├── result/                           # 训练/评测输出
│   ├── training/ ...
│   └── OnlineEval-training_run_id=.../
├── wordnet2022/                      # WordNet 词库
│   ├── data.noun
│   ├── index.noun
│   └── ...
├── src/
│   └── clip/                         # OpenAI CLIP 第三方仓库（完整）
├── allenact/                         # AllenAct 框架副本（完整）
├── Detic/                            # 目标检测仓库（完整）
└── dinov2/                           # 视觉表征仓库（完整）
```

#### online_eval.py

##### 训练流程

​		入口脚本 [online_eval.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 解析命令行参数 → 构建 [OnlineEvaluatorManager](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)（评估调度器）→ 给它一个 Agent 类 `InferenceAgentVIDA` 和构造参数 → 调度器按任务样本把工作分发到一个或多个“评估 Worker 进程”（[online_evaluator_worker.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)）→ 每个 Worker 在 AI2-THOR 仿真器中跑若干条 Episode：取观测→Agent 出动作→环境步进→收集帧与指标 → 回传主进程 → 主进程按任务/类别聚合并用本地 W&B（`LocalWandb`）记录指标与视频表格，最终输出到 `--output_basedir`。

在本地“wandb”日志中会记录什么



##### Wandb中的内容

LocalWandb 会把 evaluator 生成的所有表格与度量用“键值对 + PrettyTable”的形式写入 [wandb//logs.txt](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，包括：

- 数据分布统计表：`DataStat/{task_type}/{key}`（比如 synsets、room_types、reference_synsets 等计数表）
- 每任务聚合表：`AggregatedResults/{task_type}`
- 按对象类型聚合表：`PerObjectType/{task_type}`
- 跨任务总表：`FullAggregatedResults`
- 视频表：`VideoTable/{task_type}`（行内包含本地 `mp4` 路径、俯视图 `png` 路径及若干辅助字段）

注意：LocalWandb 的 [Video(...)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)、[Image(...)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 返回的是“文件路径字符串”，不会上传到远端服务，都会写进 `logs.txt`。



online_eval用 AI2-THOR/ProcTHOR 的仿真器进行在线评估；任务样本来自 VIDA/SPOC 数据集，环境由 `PoliFormer/environment/stretch_controller.py` 驱动，使用云渲染渲染观测帧。



##### Episode的含义

- Episode 包含哪些要素
  - 房屋场景与起点
    - 从房屋集里选定一个 house（ProcTHOR/Objaverse），并设置初始位姿；参考 [OnlineEvaluatorWorker.get_house/get_agent_starting_*](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 与 [MultiTaskSampler(...)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)。
  - 任务定义
    - 任务类型与目标文本，如 ObjectNav/Pickup 等，带有目标类别、目标对象 id 列表、专家最短长度等；见 [task.task_info](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 中的 [task_type/natural_language_spec/synsets/…/eval_info.expert_length](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)。
  - 传感器
    - 至少包含导航/操作相机帧，可选目标检测 bbox、可见像素、当前房间 id 等；由 [get_extra_sensors()](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 与 `--input_sensors` 控制。
  - 最大步数
    - 来自 [MAX_EPISODE_LEN_PER_TASK[task_type\]](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，或命令行 `--max_eps_len` 强制覆盖

- Episode 的生命周期

  1. 取样本 → 构建 Task
     - [OnlineEvaluatorManager](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 把样本放入 [tasks_queue](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)；
     - [OnlineEvaluatorWorker.distribute_evaluate](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 从队列取出一个样本，用 [MultiTaskSampler](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 在 AI2-THOR 中实例化出对应的任务与控制器。
  2. 循环交互（一步就是一次“Step”）
     - 取观测：[task.get_observations()](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，筛选 `--input_sensors` 指定的键；
     - 决策：`agent.get_action(observations, goal)` 输出动作及分布；
     - 执行：[task.step_with_action_str(action)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 在仿真器里推进一步；
     - 记录：叠加 bbox/文字等，生成一帧可视化视频；见 [evaluate_on_task(...)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)。
  3. 终止条件
     - [task.is_done()](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 为真（通常是到达目标并执行结束动作）；或达到最大步数 [task.max_steps](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)；
     - 若传了 `--skip_done`，遇到 `done/end` 会改成 `sub_done` 以避免过早结束。
  4. 成功判定与指标
     - 成功与否：[task.is_successful()](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)（依任务类型内部判定；Pickup/FETCH 还会看 [TargetObjectWasPickedUp](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 传感器）；
     - 指标：[eps_len](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)（步数）、[success](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)、`sel`（效率：相对专家路径）、`percentage_collision`、房间访问、可见像素等；见 [calculate_metrics(...)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)。
     - 可能附带按对象的细粒度指标 `extra/{object}/...`，用于后续“PerObjectType”表。

  5. 产物与上报

     - 若样本被标注为需要视频（节省开销只挑部分样本），把帧写成 mp4、top-down 俯视图写成 png；

     - 将 `(metrics, 视频/图信息)` 放入 [results_queue](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，主进程做聚合与本地 W&B 记录；见 [log_results](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 与 [log_aggregated_results](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)。

### 数据集结构

```text
/home/jitl/PoliFormer/data
├── fifteen/
│   └── ObjectNavType/
│       ├── .lock
│       ├── constants.yaml
│       ├── house_id_to_sub_house_id_train.json
│       ├── house_id_to_sub_house_id_val.json
│       ├── train/
│       │   ├── 000001/
│       │   │   ├── hdf5_sensors.hdf5
│       │   │   ├── raw_manipulation_camera__0.mp4
│       │   │   ├── raw_manipulation_camera__1.mp4
│       │   │   ├── … (manipulation camera 分段视频，编号0–9)
│       │   │   ├── raw_navigation_camera__0.mp4
│       │   │   ├── raw_navigation_camera__1.mp4
│       │   │   ├── … (navigation camera 分段视频，编号0–9)
│       │   │   └── success.txt
│       │   ├── 000002/
│       │   ├── 000004/
│       │   ├── … (大量六位数字ID目录，每个结构与 000001 类似)
│       └── val/
│           ├── 000018/
│           ├── 000027/
│           ├── 000028/
│           ├── … (验证集同样由大量六位数字ID目录组成)
├── nltk_data/
│   └── corpora/
│       ├── wordnet/        (展开后的 WordNet 语义词典目录)
│       ├── wordnet.zip     (压缩包原文件，可能保留用于重复构建或校验)
│       ├── wordnet2022/    (新版或扩展版 WordNet 2022 版本解压目录)
│       ├── wordnet2022.zip (2022版压缩包)
├── objaverse_assets/
│   └── 2023_07_28/
│       ├── annotations.json.gz
│       ├── annotations.lock
│       ├── assets/         (实际 3D 资源文件：如 .glb/.obj/贴图 等，未深入列出)
│       └── objects.lock
└── objaverse_houses/
    └── houses_2023_07_28/
        ├── hdf5_sensors.hdf5
        ├── raw_manipulation_camera__0.mp4
        ├── … (与 train/000001 示例结构一致的多段操作/导航视频)
        ├── raw_navigation_camera__0.mp4
        └── success.txt
```

   

### 训练模型

```bash
python training/online/dinov2_vits_tsfm_rgb_augment_objectnav.py train \
	--num_train_processes NUM_OF_TRAIN_PROCESSES \
	--output_dir PATH_TO_RESULT \
	--dataset_dir PATH_TO_DATASET
```



### 使用预训练模型进行评估 

#### 预备工作

下载与训练的ckpt模型：

```bash
python scripts/download_trained_ckpt.py --save_dir checkpoints
```

#### 模型评估

`1.使用文本导航模型运行评估:`

```bash
# 模板
python training/online/online_eval.py \
	--output_basedir PATH_TO_RESULT \
	--num_workers NUM_WORKERS \
	--ckpt_path ckpt/text_nav/model.ckpt \ 
	--training_tag text-nav \
	--house_set objaverse \
	--gpu_devices 0 1 2 3 4 5 6 7
```

```bash
python training/online/online_eval.py \
	--output_basedir result/text_nav \
    --num_workers 2 \
    --ckpt_path ckpt/text_nav/model.ckpt \
    --training_tag text-nav \
    --house_set objaverse \
    --gpu_devices 0
```

`2.使用纯 box-nav 模型运行评估： `

```bash
python training/online/online_eval.py \
	--output_basedir result/box_nav \
	--num_workers 2 \
	--ckpt_path checkpoints/box_nav/model.ckpt \
	--training_tag text-nav \
	--house_set objaverse \
	--gpu_devices 0 \
	--input_sensors raw_navigation_camera nav_task_relevant_object_bbox nav_accurate_object_bbox \
	--ignore_text_goal
```

`3. 使用文本框导航模型运行评估：`

```bash
python training/online/online_eval.py \
	--output_basedir result/text_box_nav \
	--num_workers 2 \
	--ckpt_path checkpoints/text_box_nav/model.ckpt \
	--training_tag text-nav \
	--house_set objaverse \
	--gpu_devices 0 \
	--input_sensors raw_navigation_camera nav_task_relevant_object_bbox nav_accurate_object_bbox
```

```
python training/online/single_video_eval.py \
  --model_config InferenceDINOv2ViTSLLAMATxTxObjectNavDist \
  --training_tag your_training_run \
  --ckpt_path /path/to/checkpoint.pth \
  --sample_index 0 \
  --dataset_path /data/datasets \
  --output_basedir /data/results/single_evaluation \
  --eval_subset minival \
  --house_set objaverse \
  --gpu_devices 0
```



#### 调试代码

```bash
python -m pdb training/online/online_eval.py \
  --output_basedir result/box_nav \
  --num_workers 1 \
  --ckpt_path checkpoints/box_nav/model.ckpt \
  --training_tag text-nav \
  --house_set objaverse \
  --gpu_devices 0 \
  --input_sensors raw_navigation_camera nav_task_relevant_object_bbox nav_accurate_object_bbox \
  --ignore_text_goal
```

pdb 常用命令

- n：执行下一行
- s：步入函数
- c：继续到下一个断点
- l：查看当前源码
- b 路径:行号 或 b 函数名：加断点；例如
  - b online_evaluation/online_evaluator_worker.py:146 # evaluate_on_task 开头
  - b online_evaluation/online_evaluator_worker.py:210 # step 前
- p 变量名 / pp 变量名：打印变量
- q：退出



#### 评估流程

​	为了处理**一个单独的评估任务**（比如1000个中的第1个），程序到底加载了哪些东西，以及这些东西是如何协同工作的。

​	我将以一个具体的例子，即处理**第一个评估数据**，来为你完整地追踪整个加载和准备流程。

为了处理一个任务，程序需要加载**两大类核心资产**：

1. **任务规格 (Task Specification)**：一个 JSON 对象，定义了任务的**目标**。它就像一张“任务卡”，告诉 Agent“你要做什么”。这包括：
   - **目标物体**：比如“找到一个苹果 (apple)”。
   - **起始位置**：Agent 在房子里的初始坐标和朝向。
   - **所在房屋**：这个任务发生在哪一个具体的房子里。
   - **专家路径长度**：最优解需要多少步（用于计算 `SEL` 指标）。
2. **环境资产 (Environment Assets)**：任务卡中指定的“房子”本身，以及房子里所有物体的 3D 模型和纹理。这包括：
   - **房屋场景文件 (House JSON)**：一个大的 JSON 文件，描述了整个房子的结构，包括房间、墙壁、门、窗户，以及所有家具和物体的初始位置、旋转、大小等。
   - **3D 模型文件 (Object GLB/Asset)**：房子里每一个物体（比如桌子、椅子、苹果）的 3D 模型文件（通常是 `.glb` 格式）。这些文件由你设置的 `OBJAVERSE_DATA_DIR` 环境变量指向。



你说的一个 JSON 对象，定义了任务的目标，在项目的哪个位置，怎么指定目标物体，起始位置，所在房屋等等，专家路径长度是自己指定的吗？我事先应该不知道这个专家路径长度吧？

1. **分析启动参数**：在 [online_eval.py](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 中，`parse_args()` 函数会解析你的命令。你没有指定 `--dataset_type` 和 `--eval_subset`，所以程序会使用它们的**默认值**：
   - `--dataset_type`: 默认为 `"object_nav_v0.3"`
   - `--eval_subset`: 默认为 `"minival"`
2. **定位数据集文件**：`OnlineEvaluatorManager` 在初始化时，会根据这些参数构建数据集文件的路径。它会在 [data](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 目录下寻找一个名为 `object_nav_v0.3.json.gz` 的文件。
   - **具体文件**：`/home/jitl/PoliFormer/data/object_nav_v0.3.json.gz`
   - 这个压缩的 JSON 文件里包含了成千上万个“任务规格”（Task Specifications），每一个都是一个独立的评估任务

我在那里去查看有哪些dataset_type，eval_subset是什么意思
请你具体解释一下object_nav_v0.3.json.gz这个文件的内容，我每次运行都要执行完这里边的所有任务吗？每次程序都要自己解压这个文件吗？而且事实上我的data目录下并没有这个文件





第 1 步：确定要评估的数据集文件



### 附录

#### 1. 环境安装

```markdown
# requirements.txt  start
flake8==3.9.2
mypy==1.2.0
black==23.3.0
pytest==7.1.1
pytest-xdist
flaky
invoke==2.0.0
attrs
prior
stringcase
nltk @ git+https://github.com/nltk/nltk@582e6e35f0e6c984b44ec49dcb8846d9c011d0a8
phonemizer==3.1.1
networkx==2.8.7
numpy-quaternion==2022.4.1
tensorboardx==2.3
setproctitle==1.3.1
moviepy==2.1.1 
filelock==3.19.1
phonemizer # 3.1.1
invoke  # 2.0.0
prior   # 1.0.3
attrs>=21.4.0 # 25.4.0
wheel>=0.36.2 # 0.45.1
numpy==1.26.4  # 1.26.4
matplotlib>=3.3.1
opencv-python==4.10.0.82
scipy==1.11.1
canonicaljson==1.6.5
plotly==5.18.0
shapely==1.8.5
h5py==3.10.0
pyquaternion==0.9.9
omegaconf==2.2.3
boto3==1.40.50
petname==2.1
wget==3.1
pandas==2.1.3
python-sat==1.8.dev24
python-fcl==0.7.0.8
wandb==0.17.6
scikit-video==1.1.10
nbformat==5.10.4
pre-commit==4.2.0
black==23.3.0
scikit-image==0.22.0
torchmetrics==1.7.3
av==13.1.0
shortuuid==1.0.3
transformers==4.39.3
ipdb==0.13.11
prettytable==3.13.0
fire==0.7.1
decorator==4.4.2
timeout-decorator==0.4.1
objathor==0.0.5
xformers==0.0.23.post1
torchvision==0.16.2
lightning
open-clip-torch
-e git+https://github.com/openai/CLIP.git@a1d071733d7111c9c014f024669f959182114e33#egg=clip
swing

# requirements.txt  end

# 这两个会报错
-e "git+https://github.com/allenai/allenact.git@d055fc9d4533f086e0340fe0a838ed42c28d932e#egg=allenact&subdirectory=allenact"
-e "git+https://github.com/allenai/allenact.git@d055fc9d4533f086e0340fe0a838ed42c28d932e#egg=allenact_plugins[all]&subdirectory=allenact_plugins"

# 上边这两个可以通过如下命令执行
1. git clone https://github.com/allenai/allenact.git
2. cd allenact
3. git checkout d055fc9d4533f086e0340fe0a838ed42c28d932e
4. pip install --use-pep517 -e .  # 在allenact/allenact下执行这个命令
5. cd /allenact/allenact_plugins
6. pip install --use-pep517 -e . 

pip install --extra-index-url https://ai2thor-pypi.allenai.org ai2thor==0+966bd7758586e05d18f6181f459c0e90ba318bec
pip install --extra-index-url https://miropsota.github.io/torch_packages_builder detectron2==0.6+864913fpt2.1.2cu121
git clone https://github.com/facebookresearch/Detic.git --recurse-submodules && cd Detic && $pip install -r requirements.txt && mkdir models && wget --no-check-certificate https://dl.fbaipublicfiles.com/detic/Detic_LCOCOI21k_CLIP_SwinB_896b32_4x_ft4x_max-size.pth -O models/Detic_LCOCOI21k_CLIP_SwinB_896b32_4x_ft4x_max-size.pth

pip install --extra-index-url https://ai2thor-pypi.allenai.org ai2thor==0+966bd7758586e05d18f6181f459c0e90ba318bec
pip install --extra-index-url https://miropsota.github.io/torch_packages_builder detectron2==0.6+864913fpt2.1.2cu121
cd DETIC_PATH && git clone https://github.com/facebookresearch/Detic.git --recurse-submodules && cd Detic && $pip install -r requirements.txt && mkdir models && wget --no-check-certificate https://dl.fbaipublicfiles.com/detic/Detic_LCOCOI21k_CLIP_SwinB_896b32_4x_ft4x_max-size.pth -O models/Detic_LCOCOI21k_CLIP_SwinB_896b32_4x_ft4x_max-size.pth
```

#### 2. 下载数据集

```bash
python -m scripts.download_training_data --save_dir data --types fifteen
python -m objathor.dataset.download_annotations --version 2023_07_28 --path /path/to/objaverse_assets
python -m objathor.dataset.download_assets --version 2023_07_28 --path /path/to/objaverse_assets
python -m scripts.download_objaverse_houses --save_dir /path/to/objaverse_houses --subset val
python -m scripts.download_objaverse_houses --save_dir /path/to/objaverse_houses --subset train
```

#### 3. 设置环境变量

```bash
export PYTHONPATH=/home/jitl/PoliFormer
export OBJAVERSE_HOUSES_DIR=/home/jitl/PoliFormer/data/objaverse_houses/houses_2023_07_28
export OBJAVERSE_DATA_DIR=/home/jitl/PoliFormer/data/objaverse_assets/2023_07_28
export DETIC_REPO_PATH=/home/jitl/PoliFormer/Detic
export ALLENACT_DEBUG=True
export ALLENACT_DEBUG_VST_TIMEOUT=2000
export WANDB_DIR=/home/jitl/PoliFormer/wandb_dir
export TORCH_HUB_OFFLINE=1
```



### 运行中的警告信息

#### 1 

```python
WARNING:py.warnings:/home/jitl/anaconda3/envs/poliformer_copy/lib/python3.10/site-packages/torchvision/transforms/functional.py:1603: UserWarning: The default value of the antialias parameter of all the resizing transforms (Resize(), RandomResizedCrop(), etc.) will change from None to True in v0.17, in order to be consistent across the PIL and Tensor backends. To suppress this warning, directly pass antialias=True (recommended, future default), antialias=None (current default, which means False for Tensors and True for PIL), or antialias=False (only works on Tensors - PIL will still use antialiasing). This also applies if you are using the inference transforms from the models weights: update the call to weights.transforms(antialias=True).
  warnings.warn(
```

这是一个“即将变更默认行为”的提醒，

- 含义：
  - 在 torchvision v0.17 起，所有缩放相关变换（Resize、RandomResizedCrop 等）的 antialias 参数默认值会从 None 改为 True。
  - 当前版本里，antialias=None 表示：
    - 对 Tensor 后端等同于 False（不抗锯齿）
    - 对 PIL 后端等同于 True（抗锯齿）
  - 为了统一，未来会默认 True（无论是 PIL 还是 Tensor）。

- 影响：
  - 仅影响图像缩放的插值细节，可能让结果更平滑，数值上略有差异。训练/评估复现时要注意这一点。
- 处理方法：
  - 在你自己的变换中显式指定 antialias，消除警告并固定行为：
    - 推荐：antialias=True
      - transforms.Resize((224, 224), antialias=True)
      - transforms.RandomResizedCrop(224, antialias=True)
  - 若使用预训练权重自带的 transforms，调用时也加：
    - weights.transforms(antialias=True)

#### 2. 无法解析导入某个包

![1761743318514](PoliFormer.assets/1761743318514.png)`Ctrl + Shift + P` 打开VSCode命令面板，输入“Python: Select Interpreter”，选择解释器为当前的环境



#### 3.allenact包导入问题

后边不知道是怎么解决的

![1762231078151](PoliFormer.assets/1762231078151.png)



### 动作指令

`1. utils/type_utils.py：`

```python
class THORActions:
    """
    定义在 AI2-THOR 环境中所有可执行动作的简写形式。
    这使得代码更简洁，同时通过一个中心位置管理所有动作。
    """
    # 基本导航动作
    move_ahead = "m"  	# 向前移动
    move_back = "b"   	# 向后移动
    rotate_right = "r"  # 向右旋转
    rotate_left = "l"   # 向左旋转
    rotate_right_small = "rs"  # 小幅度右转
    rotate_left_small = "ls"   # 小幅度左转
    done = "end"  		# 结束任务

    # 机械臂动作
    move_arm_up = "yp"  # 机械臂向上
    move_arm_up_small = "yps"  # 机械臂小幅度向上
    move_arm_down = "ym"  # 机械臂向下
    move_arm_down_small = "yms"  # 机械臂小幅度向下
    move_arm_out = "zp"  # 机械臂伸出
    move_arm_out_small = "zps"  # 机械臂小幅度伸出
    move_arm_in = "zm"  # 机械臂缩回
    move_arm_in_small = "zms"  # 机械臂小幅度缩回

    # 手爪动作
    wrist_open = "wp"  	# 张开手爪
    wrist_close = "wm"  # 闭合手爪
    pickup = "p"  	# 拾取物体
    dropoff = "d"  	# 放下物体

    # 将动作按类型分组，方便使用
    ARM_ACTIONS = [  # 机械臂动作
        move_arm_in,
        move_arm_out,
        move_arm_up,
        move_arm_down,
        move_arm_in_small,
        move_arm_out_small,
        move_arm_up_small,
        move_arm_down_small,
    ]
    MOVE_ACTIONS = [  # 移动动作
        move_ahead,
        move_back,
    ]
    ROTATE_ACTIONS = [  # 旋转动作
        rotate_right,
        rotate_left,
        rotate_right_small,
        rotate_left_small,
    ]
    sub_done = "sub_done"  # 子任务完成

    @classmethod
    def get_action_name(cls, short_string):
        """
        一个类方法，根据动作的简写字符串返回其完整的变量名。
        例如，输入 "m"，返回 "move_ahead"。
        """
        for name, value in cls.__dict__.items():
            if value == short_string:
                return name
        return None
```



### Q

好像这是在仿真上运行的结果，经过Poliformer输出的动作指令序列是在哪里生成的，有传送到了哪里，我可以保存这个动作指令吗，动作指令的格式是怎样的，包括哪些内容，请你分析整个项目代码，找到这个部分，帮我进行详细的分析。



现在，针对评估过程的数据集输入，我还比较疑惑，输入是什么，我通过python training/online/online_eval.py \
	--output_basedir result/text_nav \
    --num_workers 2 \
    --ckpt_path ckpt/text_nav/model.ckpt \
    --training_tag text-nav \
    --house_set objaverse \
    --gpu_devices 0
命令执行的时候，会读取我数据集里的哪些东西，我事先已经设置了环境变量：export OBJAVERSE_HOUSES_DIR=/home/jitl/PoliFormer/data/objaverse_houses/houses_2023_07_28
export OBJAVERSE_DATA_DIR=/home/jitl/PoliFormer/data/objaverse_assets/2023_07_28
export DETIC_REPO_PATH=/home/jitl/PoliFormer/Detic

我看到输出的结果，似乎他是进行批量处理的，我现在不懂这个，我给你举个例子，比如他一共处理1000个数据，但是处理每个数据，都需要很多的配套信息，你需要告诉我，比如说，处理第一个数据，他需要加载哪些东西，这些东西你不要只是给你认为的，而是直接给出我项目里的东西，



请你针对我的数据集进行说明，说明一下哪些文件是什么，有什么作用，都是需要真实的，你不要自己想想，一切从项目代码出发进行分析，比如/fifteen/ObjectNavType，fifteen是什么，ObjectNavType是什么，下边有train和val子文件夹和一些文件，train是训练集，train里边又有000001，000002,这些是什么，000001下又有什么，分别又是什么



- 模型推理与动作字符串由 inference_agent.py 负责：

  - get_action(...) -> act(...)

  - act(...) 调用 actor_critic 网络得到分布（ActorCriticOutput），

  - 采样：`action = actor_critic_output.distributions.sample()`

  - 或取贪心：`action_greedy = actor_critic_output.distributions.mode()`

  - flatten 索引：`self.last_action_flat = su.flatten(self.actor_critic.action_space, action)`

  - 将索引映射成字符串：通过 [get_action_list()](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 返回的 action_list（默认为 [ALL_STRETCH_ACTIONS](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 或者由环境变量 ACTION_DICT 指定的文件），再用 [su.action_list(...)](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 取第 0 个索引，得到 [action_str](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)。

  - 函数实际返回：

    ```
    return action_str, actor_critic_output.distributions.probs[0][0]
    ```

    - 即第一项是动作字符串，第二项是该分布给出的概率（当前实现返回一个 prob 标量）。





