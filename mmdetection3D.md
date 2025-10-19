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

### 一、项目组织架构

mmdetection3d/
├── 📄 CITATION.cff, LICENSE, MANIFEST.in, ...  # 项目元数据、引用和许可信息
├── 📄 setup.py, requirements.txt             # Python 包安装和依赖配置文件
├── 📁 configs/                                 # 核心配置目录
│   ├── 📁 _base_/                             # 基础配置，包含数据集、模型、调度器等通用设置
│   │   ├── datasets/
│   │   ├── models/
│   │   └── schedules/
│   └── 📁 centerpoint/, 
│   └── 📁 pointpillars/, ...     # 各种 3D 检测模型的具体配置文件
├── 📁 mmdet3d/                                 # 核心源代码
│   ├── 📁 apis/                                # 高层 API，用于模型训练、测试和推理
│   ├── 📁 datasets/                            # 数据集处理
│   │   ├── 📁 transforms/                      # 数据增强和预处理流水线
│   │   ├── 📁 samplers/                        # 数据采样策略
│   │   └── kitti_dataset.py, ...              # 针对不同数据集（如 KITTI）的 Dataset 类实现
│   ├── 📁 models/                              # 模型组件
│   │   ├── 📁 backbones/                       # 3D 主干网络 (e.g., PointNet++, VoxelNet)
│   │   ├── 📁 necks/                           # 连接主干和头部的组件 (e.g., FPN)
│   │   ├── 📁 dense_heads/ / roi_heads/        # 检测头 (e.g., CenterHead, PartA2Head)
│   │   ├── 📁 losses/                          # 损失函数
│   │   └── 📁 detectors/                       # 检测器模型的整体架构定义
│   ├── 📁 engine/                              # 训练和评估引擎，包含钩子（Hooks）等
│   ├── 📁 evaluation/                          # 评估指标和工具 (e.g., mAP for KITTI)
│   ├── 📁 structures/                          # 3D 数据结构定义 (e.g., LiDARInstance3DBoxes)
│   ├── 📁 visualization/                       # 可视化工具
│   └── 📄 registry.py                          # 注册器，用于管理和构建模型、数据集等模块
│
├── 📁 tools/                                   # 主要的命令行工具脚本
│   ├── 📄 train.py                            # 模型训练脚本
│   ├── 📄 test.py                              # 模型测试脚本
│   ├── 📄 create_data.py                       # 数据集预处理脚本 (e.g., 创建 KITTI 数据 info)
│   └── 📁 analysis_tools/ & misc/              # 其他分析和辅助工具
│
├── data/
│   └── kitti/
│       ├── ImageSets/
│       ├── testing/
│       │   ├── calib/
│       │   └── velodyne/
│       └── training/
│           ├── calib/
│           ├── label_2/
│           └── velodyne/
├── configs/
├── tools/
└── ... (其他项目文件)
├── 📁 demo/                                    # 提供给用户的演示脚本和 Notebook
│   ├── 📄 pcd_demo.py                          # 点云检测演示
│   └── 📄 multi_modality_demo.py               # 多模态检测演示
│
├── 📁 projects/                                # 基于 mmdet3d 的独立研究项目 (e.g., BEVFusion)
│
├── 📁 tests/                                   # 单元测试和集成测试
│
├── 📁 work_dirs/                               # 默认的工作目录，用于存放训练日志和模型权重
│
└── 📁 docs/                                    # 项目文档

#### ./configs/pointpillars

mmdetection3d/configs/pointpillars/
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

​		在深度学习中，**Neck** 是模型架构中连接 **Backbone**（骨干网络，负责特征提取）与 **Head**（检测头，负责预测目标位置和类别） 的中间模块，核心作用是**多尺度特征融合**，让模型同时利用 “浅层特征的空间细节” 和 “深层特征的语义信息”，提升检测精度（尤其是小目标和多尺度目标）。

​		在 PointPillars（3D 点云检测算法）中，Neck 通常以 **FPN（Feature Pyramid Network，特征金字塔网络）** 或 **secFPN（Second FPN，改进版特征金字塔）** 的形式存在，针对点云的 “伪图像” 特征进行融合：

- **FPN**：通过 “自顶向下” 路径，将深层语义特征传递到浅层，增强小目标检测能力。
- **secFPN**：基于 FPN 改进，增加 “自底向上” 路径，同时传递浅层细节到深层，进一步优化多尺度特征的一致性。