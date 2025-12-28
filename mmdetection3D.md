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
├── README.md  # 目录说明文档：介绍配置文件的版本限制（如MMCV版本）、链接更新等整体信息
├── metafile.yml   # 元数据文件：存储配置的元信息（如支持的数据集、依赖版本等），与README同步更新目的
├── `pointpillars_hv_fpn_sbn-all_8xb2-2x_lyft-3d-range100.py`  # PointPillars配置
│   ├── 模型：PointPillars（点云分pillars处理的3D检测模型）
│   ├── 方向：hv（处理水平+垂直方向目标）
│   ├── Neck：fpn（Feature Pyramid Network，特征金字塔融合）
│   ├── 归一化：sbn-all（所有层用SyncBN，多GPU同步批归一化）
│   ├── 训练：8xb2-2x（8张GPU，每张batch=2，训练2个epoch）
│   ├── 数据集：lyft-3d（Lyft 3D检测数据集）
│   └── 范围：range100（检测100米内目标）
├── `pointpillars_hv_fpn_sbn-all_8xb2-2x_lyft-3d.py`  # PointPillars配置（Lyft数据集，无100米范围限制）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：fpn
│   ├── 归一化：sbn-all
│   ├── 训练：8xb2-2x
│   └── 数据集：lyft-3d（默认检测范围）
├── `pointpillars_hv_fpn_sbn-all_8xb2-amp-2x_nus-3d.py`  # PointPillars配置（nuScenes数据集，混合精度训练）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：fpn
│   ├── 归一化：sbn-all
│   ├── 训练：8xb2-amp-2x（8张GPU，每张batch=2，AMP混合精度，训练2个epoch）
│   └── 数据集：nus-3d（nuScenes 3D检测数据集）
├── `pointpillars_hv_fpn_sbn-all_8xb4-2x_nus-3d.py`  # PointPillars配置（nuScenes数据集，更大batch）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：fpn
│   ├── 归一化：sbn-all
│   ├── 训练：8xb4-2x（8张GPU，每张batch=4，训练2个epoch）
│   └── 数据集：nus-3d
├── `pointpillars_hv_secfpn_bbox-6e-160e_kitti-3d-class.py`  # PointPillars配置（KITTI数据集，多类别检测）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn（Second FPN，改进的特征金字塔融合）
│   ├── 训练：bbox-6e-160e（训练160个epoch，bbox损失相关配置）
│   ├── 数据集：kitti-3d（KITTI 3D检测数据集）
│   └── 任务：3d-class（检测所有类别）
├── `pointpillars_hv_secfpn_bbox-6e-160e_kitti-3d-car.py`  # PointPillars配置（KITTI数据集，仅检测汽车）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn
│   ├── 训练：bbox-6e-160e
│   ├── 数据集：kitti-3d
│   └── 任务：3d-car（仅检测汽车类别）
├── `pointpillars_hv_secfpn_sbn-all_16xb2-2x_waymo-3d-class.py`  # PointPillars配置（Waymo数据集，多类别检测）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn
│   ├── 归一化：sbn-all
│   ├── 训练：16xb2-2x（16张GPU，每张batch=2，训练2个epoch）
│   ├── 数据集：waymo-3d（Waymo 3D检测数据集）
│   └── 任务：3d-class（检测所有类别）
├── `pointpillars_hv_secfpn_sbn-all_16xb2-2x_waymo-3d-car.py`  # PointPillars配置（Waymo数据集，仅检测汽车）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn
│   ├── 归一化：sbn-all
│   ├── 训练：16xb2-2x
│   ├── 数据集：waymo-3d
│   └── 任务：3d-car（仅检测汽车类别）
├── `pointpillars_hv_secfpn_sbn-all_16xb2-2x_waymoD5-3d-class.py`  # PointPillars配置（Waymo D5子集，多类别检测）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn
│   ├── 归一化：sbn-all
│   ├── 训练：16xb2-2x
│   ├── 数据集：waymoD5（Waymo数据集的D5子集）
│   └── 任务：3d-class（检测所有类别）
├── `pointpillars_hv_secfpn_sbn-all_16xb2-2x_waymoD5-3d-car.py`  # PointPillars配置（Waymo D5子集，仅检测汽车）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn
│   ├── 归一化：sbn-all
│   ├── 训练：16xb2-2x
│   ├── 数据集：waymoD5
│   └── 任务：3d-car（仅检测汽车类别）
├── `pointpillars_hv_secfpn_sbn-all_8xb2-2x_lyft-3d-range100.py`  # PointPillars配置（Lyft数据集，secFPN+100米范围）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn
│   ├── 归一化：sbn-all
│   ├── 训练：8xb2-2x
│   ├── 数据集：lyft-3d
│   └── 范围：range100（检测100米内目标）
├── `pointpillars_hv_secfpn_sbn-all_8xb2-2x_lyft-3d.py`  # PointPillars配置（Lyft数据集，secFPN，无100米限制）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn
│   ├── 归一化：sbn-all
│   ├── 训练：8xb2-2x
│   └── 数据集：lyft-3d（默认检测范围）
├── `pointpillars_hv_secfpn_sbn-all_8xb2-amp-2x_nus-3d.py`  # PointPillars配置（nuScenes数据集，secFPN+混合精度）
│   ├── 模型：PointPillars
│   ├── 方向：hv
│   ├── Neck：secfpn
│   ├── 归一化：sbn-all
│   ├── 训练：8xb2-amp-2x（AMP混合精度）
│   └── 数据集：nus-3d
└── `pointpillars_hv_secfpn_sbn-all_8xb4-2x_nus-3d.py`  # PointPillars配置（nuScenes数据集，secFPN+更大batch）
├── 模型：PointPillars
├── 方向：hv
├── Neck：secfpn
├── 归一化：sbn-all
├── 训练：8xb4-2x（8张GPU，每张batch=4）
└── 数据集：nus-3d
```

在深度学习中，**Neck** 是模型架构中连接 **Backbone**（骨干网络，负责特征提取）与 **Head**（检测头，负责预测目标位置和类别） 的中间模块，核心作用是**多尺度特征融合**，让模型同时利用 “浅层特征的空间细节” 和 “深层特征的语义信息”，提升检测精度（尤其是小目标和多尺度目标）。

​		在 PointPillars（3D 点云检测算法）中，Neck 通常以 **FPN（Feature Pyramid Network，特征金字塔网络）** 或 **secFPN（Second FPN，改进版特征金字塔）** 的形式存在，针对点云的 “伪图像” 特征进行融合：

- **FPN**：通过 “自顶向下” 路径，将深层语义特征传递到浅层，增强小目标检测能力。
- **secFPN**：基于 FPN 改进，增加 “自底向上” 路径，同时传递浅层细节到深层，进一步优化多尺度特征的一致性。

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
