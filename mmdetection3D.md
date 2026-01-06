# MMDetection3D

​		MMDetection3D是一个开源 3D 目标检测工具箱，属于 OpenMMLab 项目的一部分。它基于 PyTorch 深度学习框架，旨在提供一个统一的平台来开发和评估各种 3D 检测算法。

## 1 项目简介

​		MMDetection3D 是一个通用的 3D 感知平台，它不仅支持 **3D 目标检测**（如检测汽车、行人），还支持 **3D 语义分割**。它的特点是高度模块化，支持多种传感器模态（激光雷达 LiDAR、单目/多目相机、多模态融合）。

- **核心功能**：从点云或图像中检测 3D 物体。
- **支持算法**：包含了大量最先进的（SOTA）算法，例如 PointPillars, SECOND, PV-RCNN, CenterPoint, VoteNet, FCOS3D 等。
- **支持数据集**：支持主流的自动驾驶和室内场景数据集，如 KITTI, nuScenes, Waymo, Lyft, ScanNet, SUN RGB-D 等。

## 2 目录结构

```reStructuredText
mmdetection3d/
├── configs/                     # [核心] 模型配置文件 (.py)
│   ├── _base_/                  # 基础配置 (数据集、模型架构、训练策略)
│   │   ├── datasets/                # [数据基类] 定义数据路径、Pipeline、增强策略
│   │   ├── kitti-3d-3class.py       # KITTI 数据集配置 (检测 Car, Pedestrian, Cyclist)
│   │   ├── kitti-3d-car.py          # KITTI 数据集配置 (只检测 Car)
│   │   ├── nus-3d.py                # nuScenes 数据集配置
│   │   ├── waymoD5-3d-3class.py     # Waymo 数据集配置 (D5代表采样频率)
│   │   └── ...
│   ├── models/                      # [模型基类] 定义模型的基本架构 (Backbone, Neck, Head)
│   │   ├── pointpillars_hv_secfpn_kitti.py  # PointPillars 在 KITTI 上的基础架构
│   │   ├── second_hv_secfpn_kitti.py        # SECOND 在 KITTI 上的基础架构
│   │   ├── centerpoint_...nus.py            # CenterPoint 在 nuScenes 上的基础架构
│   │   └── ...
│   ├── schedules/                   # [训练计划] 定义优化器、学习率、Epoch 数
│   │   ├── schedule-2x.py           # 2x 训练时长 (通常 24 epochs)
│   │   ├── cyclic-40e.py            # 循环学习率策略，训练 40 epochs
│   │   ├── cosine.py                # 余弦退火学习率策略
│   │   └── ...
│   └── default_runtime.py           # [运行环境] 定义日志、Checkpoint 保存、分布式参数
│   ├── pointpillars/            # PointPillars 模型的特定配置
│   ├── second/                  # SECOND 模型的特定配置
│   └── ...                      # 其他模型的配置目录
├── data/                        # [数据] 数据集存放目录 (通常建议放软链接)
│   ├── kitti/                   # KITTI 数据集 (示例)
│   └── ...
├── mmdet3d/                     # [源码] 核心 Python 代码库
│   ├── apis/                    # 推理 (inference) 和训练 (train) 的高层接口
│   ├── datasets/                # 数据集定义与加载
│   │   ├── transforms/          # 数据增强 (如旋转、缩放、裁剪)
│   │   └── ...                  # 各个数据集的类 (KittiDataset, WaymoDataset 等)
│   ├── engine/                  # 训练流程控制 (Hooks 等)
│   ├── evaluation/              # 评测指标与计算代码
│   ├── models/                  # 模型组件实现
│   │   ├── backbones/           # 主干网络 (如 PointNet2, SECOND)
│   │   ├── dense_heads/         # 检测头 (如 Anchor3DHead, CenterHead)
│   │   ├── detectors/           # 整体检测器框架 (如 MVXTwoStageDetector)
│   │   ├── middle_encoders/     # 中间编码层 (如 PointPillars 的 Scatter)
│   │   ├── voxel_encoders/      # 体素编码器 (如 PillarFeatureNet)
│   │   └── ...
│   ├── structures/              # 3D 核心数据结构 (如 LiDARInstance3DBoxes)
│   └── visualization/           # 可视化相关代码
├── tools/                       # [工具] 各种实用脚本
│   ├── analysis_tools/          # 分析工具 (画 Loss 曲线、计算 FLOPs 等)
│   ├── dataset_converters/      # 数据集格式转换脚本 (如 create_gt_database)
│   ├── create_data.py           # 数据预处理入口脚本 (生成 .pkl 索引)
│   ├── train.py                 # 模型训练启动脚本
│   ├── test.py                  # 模型测试/评估启动脚本
│   └── ...
├── demo/                        # 演示脚本 (用于单张图片/点云的快速推理)
├── docker/                      # Docker 镜像构建文件
├── docs/                        # 项目文档 (教程、API 文档)
├── requirements.txt             # Python 依赖包列表
├── setup.py                     # 项目安装脚本
└── README_zh-CN.md              # 中文项目介绍与安装指南
```

### 2.1 Configs

```text
configs/
├── _base_/                          # [基类配置] 所有配置的根基，被其他具体模型继承
│   ├── datasets/                    # [数据基类] 定义数据路径、Pipeline、增强策略
│   │   ├── kitti-3d-3class.py       # KITTI 数据集配置 (检测 Car, Pedestrian, Cyclist)
│   │   ├── kitti-3d-car.py          # KITTI 数据集配置 (只检测 Car)
│   │   ├── nus-3d.py                # nuScenes 数据集配置
│   │   ├── waymoD5-3d-3class.py     # Waymo 数据集配置
│   │   └── ...
│   ├── models/                      # [模型基类] 定义模型的基本架构 (Backbone, Neck, Head)
│   │   ├── pointpillars_hv_secfpn_kitti.py  # PointPillars 在 KITTI 上的基础架构
│   │   ├── second_hv_secfpn_kitti.py        # SECOND 在 KITTI 上的基础架构
│   │   ├── centerpoint_...nus.py            # CenterPoint 在 nuScenes 上的基础架构
│   │   └── ...
│   ├── schedules/                   # [训练计划] 定义优化器、学习率、Epoch 数
│   │   ├── schedule-2x.py           # 2x 训练时长 (通常 24 epochs)
│   │   ├── cyclic-40e.py            # 循环学习率策略，训练 40 epochs
│   │   ├── cosine.py                # 余弦退火学习率策略
│   │   └── ...
│   └── default_runtime.py           # [运行环境] 定义日志、Checkpoint 保存、分布式参数
│
├── pointpillars/                    # [具体模型] PointPillars 算法的所有变体配置
│   ├── pointpillars_hv_secfpn_8xb6-160e_kitti-3d-car.py  # 最终使用的配置文件，只检测 Car
│   └── ...
│
├── second/                          # [具体模型] SECOND 算法的所有变体配置
│   ├── second_hv_secfpn_8xb6-80e_kitti-3d-3class.py      # SECOND 算法在 KITTI 上的配置
│   └── ...
│
├── centerpoint/                     # [具体模型] CenterPoint 算法的所有变体配置
│   └── ...
│
├── fcos3d/                          # [具体模型] FCOS3D (单目 3D 检测)
│   └── ...
│
└── votenet/                         # [具体模型] VoteNet (室内点云检测)
    └── ...
```

#### 2.1.1 PointPillars

```text
configs/pointpillars/                                      # PointPillars 算法相关的所有配置
├── README.md                                              # 本目录下配置的说明文档 (英文)
│                                                          # - 介绍 PointPillars 在各数据集上的设置与复现结果
│
├── metafile.yml                                           # 模型元信息索引文件
│                                                          # - 供 OpenMMLab 模型库/网页展示使用
│                                                          # - 记录每个配置对应的权重下载地址、指标 (mAP 等)
│
├── pointpillars_hv_fpn_sbn-all_8xb2-2x_lyft-3d-range100.py
│   # PointPillars + FPN，Lyft 数据集，检测距离 100m
│   # - hv: 硬体素化
│   # - fpn: 使用 FPN 作为 Neck
│   # - sbn-all: 全网络使用 SyncBN
│   # - 8xb2: 8 卡，每卡 batch=2，总 batch=16
│   # - 2x: 训练时长为标准 schedule 的 2 倍
│   # - lyft-3d-range100: Lyft 3D 检测，半径 100m 范围
│
├── pointpillars_hv_fpn_sbn-all_8xb2-2x_lyft-3d.py
│   # PointPillars + FPN，Lyft 数据集，普通 3D 检测设置
│   # - 与上一个配置类似，但不限制到 range100 (或使用默认范围)
│
├── pointpillars_hv_fpn_sbn-all_8xb2-amp-2x_nus-3d.py
│   # PointPillars + FPN，nuScenes 数据集，使用混合精度训练
│   # - amp: 开启自动混合精度 (可加速训练并节省显存)
│   # - nus-3d: nuScenes 3D 检测任务
│
├── pointpillars_hv_fpn_sbn-all_8xb4-2x_nus-3d.py
│   # PointPillars + FPN，nuScenes 数据集，标准精度训练
│   # - 8xb4: 8 卡，每卡 batch=4，总 batch=32
│   # - 2x: 较长的训练 schedule
│
├── pointpillars_hv_secfpn_8xb6-160e_kitti-3d-3class.py
│   # PointPillars + SECOND 风格 FPN，在 KITTI 上做 3 类 3D 检测
│   # - secfpn: 使用 SECOND 类型的 FPN 结构
│   # - 8xb6: 8 卡，每卡 batch=6，总 batch=48
│   # - 160e: 训练 160 个 epochs，适合从头训练
│   # - kitti-3d-3class: Car / Pedestrian / Cyclist 三类
│   # 用途：
│   # - 作为 3 类检测的标准配置，复现论文或基线结果
│
├── pointpillars_hv_secfpn_8xb6-160e_kitti-3d-car.py
│   # PointPillars + SECOND FPN，在 KITTI 上只检测 Car
│   # - 在上一份 3class 配置的基础上，修改类别为单类 Car
│   # 典型用途：
│   # - 专注车辆检测任务 (如自动驾驶仅关心车)
│   # - 训练时间、结构基本与 3 类版本一致
│
├── pointpillars_hv_secfpn_sbn-all_16xb2-2x_waymo-3d-3class.py
│   # PointPillars + SECOND FPN，在 Waymo 上做 3 类 3D 检测 (旧式 Waymo 配置)
│   # - 16xb2: 16 卡，每卡 batch=2，总 batch=32
│   # - 2x: 2 倍标准训练时长
│   # - waymo-3d-3class: Waymo 三类检测 (如 Vehicle / Pedestrian / Cyclist)
│
├── pointpillars_hv_secfpn_sbn-all_16xb2-2x_waymo-3d-car.py
│   # 同上，但在 Waymo 上只检测 Car (车辆)
│   # - 适用于只关心车辆的场景
│
├── pointpillars_hv_secfpn_sbn-all_16xb2-2x_waymoD5-3d-3class.py
│   # PointPillars + SECOND FPN，Waymo D5 版本，3 类检测
│   # - waymoD5: Waymo 数据集，按 D5 策略抽帧/处理 (如每 5 帧采样一帧)
│   # - 其他设置与前面的 Waymo 3-class 类似
│   # 用途：
│   # - 面向 D5 采样策略的官方基线
│
├── pointpillars_hv_secfpn_sbn-all_16xb2-2x_waymoD5-3d-car.py
│   # PointPillars + SECOND FPN，Waymo D5 版本，只检测 Car
│   # - 适用于 D5 子集上，以车辆为主的实验
│
├── pointpillars_hv_secfpn_sbn-all_8xb2-2x_lyft-3d-range100.py
│   # PointPillars + SECOND FPN，Lyft 数据集，检测范围 100m
│   # - 与 FPN 版本区别：这里 backbone+neck 使用 SECOND 风格
│   # - 8xb2: 8 卡 batch=2
│
├── pointpillars_hv_secfpn_sbn-all_8xb2-2x_lyft-3d.py
│   # PointPillars + SECOND FPN，Lyft 数据集，普通 3D 检测设置
│   # - 不限制到 range100，或使用默认的检测范围
│
├── pointpillars_hv_secfpn_sbn-all_8xb2-amp-2x_nus-3d.py
│   # PointPillars + SECOND FPN，nuScenes 数据集，混合精度训练
│   # - 与非 amp 版本相比，只是在训练环节打开 AMP
│
└── pointpillars_hv_secfpn_sbn-all_8xb4-2x_nus-3d.py
    # PointPillars + SECOND FPN，nuScenes 数据集，标准精度训练
    # - 8xb4: 8 卡，每卡 batch=4，总 batch=32
    # - 2x: 2 倍训练时长
    # - nus-3d: nuScenes 3D 检测
```

`1 关于NECK解释`

“使用 FPN 作为 Neck” 可以拆开理解：

- **Backbone（主干）**：负责从输入（图像/点云）里提取特征，比如 ResNet、SECOND backbone。
- **Head（检测头）**：负责在特征图上做分类、回归，输出目标框和类别。
- **Neck（颈部）**：夹在 Backbone 和 Head 中间，用来**加工与融合特征**。

**FPN = Feature Pyramid Network（特征金字塔网络）**：

- 它把 Backbone 不同层级（高分辨率、低语义；低分辨率、高语义）的特征图拿出来，
- 通过自顶向下 + 横向连接的方式，把多尺度特征融合，
- 输出一组多尺度的特征图（一般是 P3, P4, P5...），再交给 Head 使用。

“使用 FPN 作为 Neck” 就是说：
在 Backbone 和 检测头之间，插入一个 FPN 模块，
让 Head 不是只用单一尺度的特征，而是用 **多尺度融合后的特征**，
这样对大物体、小物体都更友好，检测效果通常更好。

在深度学习中，**Neck** 是模型架构中连接 **Backbone**（骨干网络，负责特征提取）与 **Head**（检测头，负责预测目标位置和类别） 的中间模块，核心作用是**多尺度特征融合**，让模型同时利用 “浅层特征的空间细节” 和 “深层特征的语义信息”，提升检测精度（尤其是小目标和多尺度目标）。

​		在 PointPillars（3D 点云检测算法）中，Neck 通常以 **FPN（Feature Pyramid Network，特征金字塔网络）** 或 **secFPN（Second FPN，改进版特征金字塔）** 的形式存在，针对点云的 “伪图像” 特征进行融合：

- **FPN**：通过 “自顶向下” 路径，将深层语义特征传递到浅层，增强小目标检测能力。
- **secFPN**：基于 FPN 改进，增加 “自底向上” 路径，同时传递浅层细节到深层，进一步优化多尺度特征的一致性。

`2 关于HV 硬体素化解释`

- 在点云中，**体素化（voxelization）**就是把连续的 3D 空间切成很多规则小立方体（voxel），然后把每个 voxel 里的点聚在一起做特征。
- **hv = hard voxelization（硬体素化）** 的“硬”指的是：
  对每个 voxel 内部的点数，设置**硬上限**，超出的点直接丢弃；同时 voxel 总数也有上限，多出来的 voxel 也会被丢掉或忽略。

更具体一点：

- 你会在配置里看到类似：
  - `max_num_points_per_voxel = 32`（每个 voxel 最多 32 个点）
  - `max_voxels = 16000`（一帧最多保留 16000 个 voxel）
- 硬体素化过程：
  1. 把点按照坐标分到各自 voxel 里。
  2. 如果一个 voxel 里有 80 个点，只保留前 32 个，其余 48 个**不再参与后续计算**。
  3. 如果一帧产生了 30000 个 voxel，只保留前 16000 个，其余的 voxel 整个丢弃。

这样做的目的：

- **稳定显存和计算量**：每一帧进入网络的 voxel 数、每个 voxel 的点数都是有固定上限的，便于 GPU 批处理。
- 代价是：会损失一部分点云信息，但通常对检测精度影响不大，是 PointPillars / SECOND 等模型里常用做法。

`3 关于sbn-all解释`

`sbn-all` 里的 **sbn = SyncBatchNorm（同步 BatchNorm）**，`all` 表示**全网络所有 BatchNorm 层都换成 SyncBN**。

含义可以拆成两点：

1. **普通 BatchNorm（BN）怎么做？**
   - 每块 GPU 只用**自己这块卡上的 mini-batch** 计算均值/方差。
   - 如果你 8 卡训练，每卡 batch=2，其实 BN 看到的 batch size 只有 2，统计量很不稳定。
2. **SyncBN（同步 BN）怎么做？**
   - 多块 GPU 之间会通信，把各自的均值/方差**汇总起来共同计算**。
   - 例如 8 卡 × 2 = 16 的有效 batch size，用这 16 个样本的统计量来做 BN，结果更稳定，尤其在 3D 检测这类 batch 很小的任务里很重要。

### 2.2 Demo

```text
demo/                                      # 演示与可视化示例目录
├── data/                                  # 演示所用的示例数据
│   ├── kitti/                             # KITTI 示例数据 (通常包含点云/标注等小样本)
│   ├── nuscenes/                          # nuScenes 示例数据
│   ├── waymo/                             # Waymo 示例数据 (若存在)
│   └── ...                                # 其他用于 demo 的数据子目录/文件
├── inference_demo.ipynb                   # Jupyter Notebook 推理演示
│                                          # - 典型流程：加载配置和权重 -> 读取样例数据 -> 可视化 3D 检测结果
├── mono_det_demo.py                       # 单目相机 3D 检测 Demo
│                                          # - 使用单张/多张图像，演示基于相机的 3D 检测 (如 FCOS3D, MonoFlex)
│                                          # - 一般流程：
│                                          #   1) 加载模型配置和权重
│                                          #   2) 读取 demo 图像
│                                          #   3) 可视化 2D/3D 框结果
├── multi_modality_demo.py                 # 多模态融合检测 Demo (相机 + 雷达/点云)
│                                          # - 展示融合 LiDAR + Camera 的 3D 检测器 (如 MVXNet, BEVFusion)
│                                          # - 典型步骤：
│                                          #   1) 同时加载图像和点云
│                                          #   2) 模型前向推理
│                                          #   3) 输出并可视化多模态 3D 检测结果
├── pcd_demo.py                            # 点云检测 Demo (LiDAR 检测)
│                                          # - 仅使用 .pcd/.bin 等点云文件进行 3D 目标检测
│                                          # - 常用于演示 PointPillars / SECOND / CenterPoint 等 LiDAR-only 模型
├── pcd_seg_demo.py                        # 点云分割 Demo (3D 语义/实例分割)
│                                          # - 对点云中的每个点进行类别预测
│                                          # - 用于展示 Cylinder3D、SPVCNN 等分割模型的效果
├── result_bev_final.png                   # BEV 视角的结果示例图片
│                                          # - 通常是官方 README 或 docs 中展示的可视化效果截图
└── vis_demo.py                            # 统一可视化 Demo 脚本
                                           # - 封装多种可视化方式：点云、BEV、3D 框叠加等
                                           # - 可作为你自己写可视化工具的参考模板
```



## 训练步骤

第 1 步： 生成数据信息文件

```python
python tools/create_data.py kitti --root-path ./data/kitti --out-dir ./data/kitti --extra-tag kitti
```

第 2 步：开始训练模型

数据准备好后，我们就可以使用预设的配置文件来启动训练。

1. PointPillars 在 KITTI 上的标准配置文件是 `pointpillars_hv_secfpn_8xb6-160e_kitti-3d-3class.py`。这个文件已经为您配置好了模型结构、数据路径和训练策略，通常无需修改。

  2. 执行训练命令：

     ```python
     python tools/train.py configs/pointpillars/pointpillars_hv_secfpn_8xb6-160e_kitti-3d-3class.py
     ```

  3. 监控训练过程

     - 训练启动后，终端会持续输出日志，包括当前的 `epoch`、`iter`、`loss`（损失）、`lr`（学习率）等信息。
     - 所有的训练产物，包括日志文件和模型权重（`.pth` 文件），都会被保存在 [work_dirs](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 目录下。例如，本次训练的产物会存放在 `work_dirs/pointpillars_hv_secfpn_8xb6-160e_kitti-3d-3class/` 中。

第 3 步 验证模型效果

训练完成后，我们使用 `test.py` 脚本来评估模型在验证集上的性能（mAP），并进行可视化。

1. 找到模型权重文件
   在 `work_dirs/pointpillars_hv_secfpn_8xb6-160e_kitti-3d-3class/` 目录中，找到训练完成的权重文件，通常是最后一个 epoch 保存的文件，例如 `epoch_160.pth`。

2. 执行验证和可视化命令
   在项目根目录下运行以下命令：

   ```python
   python tools/test.py \
       configs/pointpillars/pointpillars_hv_secfpn_8xb6-160e_kitti-3d-3class.py \
       work_dirs/pointpillars_hv_secfpn_8xb6-160e_kitti-3d-3class/epoch_160.pth \
       --show \
       --show-dir ./work_dirs/pointpillars_results
   ```

   - 第一个参数是您的**配置文件**。
   - 第二个参数是您要验证的**模型权重文件路径**。
   - `--show`: 这个标志会启用在线可视化。程序会逐帧处理验证集数据，并使用 Open3D 弹出一个窗口，实时显示点云和模型预测的 3D 边界框。
   - `--show-dir`: 这个参数会将可视化结果（带边界框的点云）保存为文件到指定目录，方便您后续查看。

3. 查看评估结果
   可视化窗口关闭或程序运行结束后，终端会打印出详细的评估结果，通常是不同类别（Car, Pedestrian, Cyclist）在不同难度（Easy, Moderate, Hard）下的 **AP (Average Precision)** 分数。这是衡量模型性能的核心指标。




​		
