**# ULIP 项目结构**

下面是 `ULIP` 项目的详细结构说明，按源码、配置、数据、脚本和实验产物分层整理。

\```text

ULIP/

├── .vscode/

│   └── settings.json

├── AI_ETHICS.md

├── CODEOWNERS

├── CODE_OF_CONDUCT.md

├── CONTRIBUTING-ARCHIVED.md

├── CONTRIBUTING.md

├── LICENSE.txt

├── README.md

├── SECURITY.md

├── main.py

├── test_dataloader.py

├── requirements.txt

├── assets/

│   ├── figure2_resize.gif

│   └── pipeline_8s_timing.gif

├── data/

│   ├── dataset_3d.py

│   ├── dataset_catalog.json

│   ├── labels.json

│   ├── templates.json

│   ├── ModelNet40.yaml

│   ├── Objaverse_Lvis_Colored.yaml

│   ├── ShapeNet-55.yaml

│   ├── modelnet40_colored_10k_pc.npy

│   ├── modelnet40_test_split_10k_colored.json

│   ├── ShapeNetCore.v2.zip

│   ├── modelnet40_normal_resampled/

│   └── __pycache__/

├── models/

│   ├── ULIP_models.py

│   ├── losses.py

│   ├── customized_backbone/

│   │   └── customized_backbone.py

│   ├── pointbert/

│   │   ├── checkpoint.py

│   │   ├── dvae.py

│   │   ├── logger.py

│   │   ├── misc.py

│   │   ├── point_encoder.py

│   │   ├── PointTransformer_8192point.yaml

│   │   └── ULIP_2_PointBERT_10k_colored_pointclouds.yaml

│   ├── pointmlp/

│   │   └── pointMLP.py

│   ├── pointnet2/

│   │   ├── pointnet2.py

│   │   └── pointnet2_utils.py

│   └── pointnext/

│       ├── pointnext.py

│       ├── pointnext-s.yaml

│       └── PointNeXt/

├── pretrained_models/

│   ├── ULIP-2-PointBERT-10k-xyzrgb-pc-vit_g-objaverse_shapenet-pretrained.pt

│   ├── ULIP-2-PointBERT-8k-xyz-pc-slip_vit_b-objaverse-pretrained.pt

│   ├── ULIP-2-PointNeXt-objavserse_shapenet-2KPTS-vit_g-pretrained.pt

│   └── open_clip_pytorch_model.bin

├── scripts/

│   ├── pretrain_pointbert.sh

│   ├── pretrain_pointmlp.sh

│   ├── pretrain_pointnet2_ssg.sh

│   ├── pretrain_pointnext.sh

│   ├── test_pointbert.sh

│   ├── test_pointmlp.sh

│   ├── test_pointnet2_ssg.sh

│   ├── test_pointnext.sh

│   ├── test_ulip2_custom.sh

│   ├── test_ulip2_pointbert_modelnet40.sh

│   └── test_ulip2_pointbert_objaverse_lvis.sh

├── scripts_new/

│   ├── test_ulip2_pointbert_10k_attack_pgd_modelnet40.sh

│   ├── test_ulip2_pointbert_10k_clean_modelnet40.sh

│   ├── test_ulip2_vitb16_8k_attack_pgd_modelnet40.sh

│   └── test_ulip2_vitb16_8k_clean_modelnet40.sh

├── experiments/

│   ├── 20260320_ulip2_modelnet40_airplane_visual_pgd_eps0.02_alpha0.004_steps3/

│   ├── 20260320_ulip2_modelnet40_attack_pgd_eps0.02_alpha0.004_steps1_bs1/

│   ├── 20260320_ulip2_modelnet40_attack_pgd_eps0.02_alpha0.004_steps3_bs1/

│   ├── 20260320_ulip2_modelnet40_clean_bs1/

│   ├── 20260320_ulip2_modelnet40_clean_bs32/

│   ├── 20260321_ulip2_modelnet40_attack_pgd_eps0.02_alpha0.004_steps3_bs1/

│   ├── 20260321_ulip2_modelnet40_clean_anchor_10k_bs1/

│   └── 20260324_ulip2_modelnet40_clean_anchor_10k_bs1/

└── outputs/

​    ├── test_pointbert_10k_bs1/

​    ├── test_pointbert_10k_bs16/

​    ├── test_pointbert_10k_bs1_clean/

​    ├── test_pointbert_10k_bs1_pgd/

​    ├── test_pointbert_10k_bs32/

​    ├── test_pointbert_10k_bs32_clean/

​    ├── test_pointbert_10k_bs32_pgd/

​    ├── test_pointbert_10k_bs8_pgd/

​    ├── test_pointbert_8kpts/

​    ├── test_ulip2_clean_modelnet40/

​    ├── test_ulip2_clean_modelnet40_bs1/

​    ├── test_ulip2_modelnet40_attack_pgd_eps0.02_alpha0.004_steps3_bs1/

​    ├── test_ulip2_modelnet40_clean_anchor_10k_bs1/

​    └── test_ulip2_clean_modelnet40/

\```

**## 目录说明**

**### 1. 源码主干**

\- `main.py`: 训练、评测、零样本测试入口

\- `models/`: 模型定义、3D backbone、损失函数

\- `data/`: 数据集读取、配置文件、类别标签和模板

\- `utils/`: 工具函数、日志、配置、tokenizer、注册表

**### 2. 数据与配置**

\- `data/modelnet40_normal_resampled/`: ModelNet40 的重采样数据与缓存

\- `data/*.yaml`: 不同数据集或实验设置的配置文件

\- `data/*.json`: 类别、模板、数据集目录和划分信息

**### 3. 预训练权重**

\- `pretrained_models/`: ULIP2 和 OpenCLIP 相关 checkpoint

**### 4. 脚本**

\- `scripts/`: 传统训练与测试脚本

\- `scripts_new/`: 新版本的 clean / attack / 8k / 10k 评测脚本

**### 5. 实验产物**

\- `experiments/`: 历史实验记录、运行日志、结果 JSON、可视化导出脚本

\- `outputs/`: 评测输出日志与结果目录

**### 6. 第三方子工程**

\- `models/pointnext/PointNeXt/`: 嵌入式上游工程，包含独立文档、配置和脚手架

**## 常用入口**

\- 运行主程序: `main.py`

\- 查看数据加载: `test_dataloader.py`

\- 评测 ULIP2 PointBERT: `scripts_new/test_ulip2_pointbert_10k_clean_modelnet40.sh`

\- 评测当前清洁基线: `scripts_new/test_ulip2_clean_modelnet40.sh`

**## 备注**

\- `experiments/` 和 `outputs/` 属于运行生成内容，不是源码核心

\- `pretrained_models/` 中的权重和 `data/` 中的缓存文件对复现实验很重要

\- `models/pointnext/PointNeXt/` 更像独立依赖工程，目录较深，建议单独维护