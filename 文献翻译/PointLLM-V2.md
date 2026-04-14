# PointLLM-V2: Empowering Large Language Models to Better Understand Point Clouds

### Abstract

**大语言模型 (Large Language Models, LLMs)** 的空前进步已经对自然语言处理产生了深远的影响，但尚未完全融入三维理解领域。本文介绍了 PointLLM，这是填补这一空白的一项初步尝试，它赋予了 LLMs 理解**点云 (Point Clouds)** 的能力，并提供了一条超越 2D 数据的新途径。PointLLM 能够结合人类指令（包括基于坐标的部件规范）理解彩色物体点云，并生成符合上下文的适当响应，这说明了它对点云和常识的掌握。具体而言，它利用**点云编码器 (Point Cloud Encoder)** 和强大的 LLM，以有效地融合几何、外观和语言信息。为了克服点-文本指令跟随 (Instruction Following) 数据稀缺的问题，我们开发了一个自动化的数据生成流水线，收集了一个包含约 180 万个样本和 100 万个不同 3D 物体的大规模数据集，这促进了在**多模态大语言模型 (Multi-modal LLM, MLLM)** 开发中盛行的两阶段训练策略的采用。此外，为了解决缺乏合适基准以及现有评估指标局限性的问题，我们提出了两个新颖的基准测试：**生成式 3D 物体分类 (Generative 3D Object Classification)** 和 **3D 物体描述 (3D Object Captioning)**，这两个基准得到了源自人类和 GPT 分析的全新、综合性评估指标的支持。通过探索各种训练策略，我们开发了 PointLLM，它显著优于 2D 和 3D 基线模型，并实现了**最先进 (State-of-the-Art, SOTA)** 的性能，其中在物体描述任务中取得了一项显著成就，即在超过 50% 的样本中超越了人类标注者。代码、数据集和基准测试将在 <https://github.com/OpenRobotLab/PointLLM> 上发布。

1 Introduction

