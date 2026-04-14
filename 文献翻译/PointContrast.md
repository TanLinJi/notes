# PointContrast: Unsupervised Pre-training for 3D Point Cloud Understanding

### Abstract

​		深度学习最成功的案例之一可以说是**迁移学习** (Transfer Learning) 。在丰富的**源数据集** (Source Set)（例如 ImageNet）上**预训练** (Pre-training) 网络，然后在通常小得多的**目标数据集** (Target Set) 上进行**微调** (Fine-tuning)，可以帮助提升性能，这一发现在语言和视觉的许多应用中起到了关键作用 。然而，关于它在**三维点云理解** (3D Point Cloud Understanding) 中的有用性却知之甚少 。考虑到在 3D 中标注数据所需的巨大工作量，我们将此视为一个机遇 。在这项工作中，我们旨在促进 **3D 表示学习** (3D Representation Learning) 的研究 。与以往的工作不同，我们专注于**高级场景理解** (High-level Scene Understanding) 任务 。为此，我们选择了一套多样化的数据集和任务，以衡量在大型 3D 场景源数据集上进行**无监督预训练** (Unsupervised Pre-training) 的效果 。我们的发现非常令人振奋：利用由架构、源数据集和**对比损失** (Contrastive Loss) 组成的统一三元组进行预训练，我们在涵盖室内和室外、真实和合成数据集的 6 个不同基准测试的**分割** (Segmentation) 和**检测** (Detection) 任务中，均实现了对近期最佳结果的超越，这证明了学习到的表示能够跨域泛化 。此外，这种改进与**有监督预训练** (Supervised Pre-training) 相似，这表明未来的努力应该倾向于扩大数据收集的规模，而不是追求更详细的标注 。我们希望这些发现能鼓励更多关于 3D 深度学习中无监督**前置任务** (Pretext Task) 设计的研究 。我们的代码已在 <https://github.com/facebookresearch/PointContrast> 公开 。

### 1 Introduction

​		**表示学习 (Representation Learning)** 是深度学习研究的主要驱动力之一 。在**二维视觉 (2D vision)** 中，人们发现，在一个丰富的源数据集（如 ImageNet 分类）上进行网络**预训练 (pre-training)** ，一旦在通常规模小得多的目标数据集上进行**微调 (fine-tuned)** ，就能帮助提升性能，这已成为许多应用成功的关键 。一种特别重要的设定是当预训练阶段是**无监督 (unsupervised)** 的时候，因为这开启了利用几乎无限规模的训练集大小的可能性 。无监督预训练在自然语言处理中取得了显著的成功 [49, 13] ，并且最近在二维视觉领域吸引了越来越多的关注 [42, 3, 27, 63, 23, 42, 3, 40, 27, 69, 28, 87, 8] 。

​		在过去的几年里，三维深度学习领域见证了许多进展，出现了越来越多的**三维表示学习 (3D representation learning)** 方案 [1, 16, 74, 21, 36, 67, 22, 15, 81, 12, 9] 。然而，与二维领域的对应研究相比，它仍然处于落后状态，因为显然，在所有的三维场景理解任务中，针对目标数据进行的特定**从零开始训练 (training from scratch)** 仍然是主导方法 。值得注意的是，所有现有的表示学习方案都是在单个物体或低级任务（如**配准 (registration)** ）上进行测试的 。这种现状可以归因于多种原因：1) 缺乏大规模和高质量的数据：与二维图像相比，三维数据更难收集，标注成本更高，且传感设备的多样性可能会引入显著的**域偏移 (domain gaps)** ；2) 缺乏统一的**骨干架构 (backbone architectures)** ：与二维视觉中 ResNets 等架构已被证明作为预训练和微调的骨干网络非常成功不同，**点云 (point cloud)** 网络架构设计仍在不断演进 ；3) 缺乏一套全面的数据集和高级任务用于评估 

​		这项工作的目的是通过启动针对三维场景理解的深度学习中带有监督微调的无监督预训练研究，来推动该领域的实质性进展 。为此，我们涵盖了四个重要的组成部分：1) 选择一个用于预训练的大型数据集；2) 确定一个可以跨越许多不同任务共享的主干架构；3) 评估用于预训练骨干网络的两个无监督目标；以及 4) 在一组多样化的下游数据集和任务上定义一套评估协议。

​		具体而言，我们选择 ScanNet [11] 作为我们进行预训练的**源数据集** (Source Set) ，并在所有的实验中利用**稀疏残差 U-Net** (Sparse Residual U-Net) [51, 9] 作为**骨干架构** (Backbone Architecture)，同时专注于 3D 数据的**点云** (Point Cloud) 表示 。对于预训练目标，我们评估了两种不同的**对比损失** (Contrastive Losses)：**最难对比损失** (Hardest-contrastive Loss) [10] 以及 **PointInfoNCE**——它是二维视觉预训练中所使用的 InfoNCE 损失 [42] 的扩展 。接着，我们选择了一套广泛的**目标数据集** (Target Datasets) 和**下游任务** (Downstream Tasks)，包括：在 S3DIS [2]、ScanNetV2 [11]、ShapeNetPart [77] 和 Synthia 4D [52] 上的**语义分割** (Semantic Segmentation) ；以及在 SUN RGB-D [57, 55, 32, 70] 和 ScanNetV2 上的**目标检测** (Object Detection) 。值得注意的是，我们的结果表明所有数据集和任务的性能均有所提升（结果摘要见表 1） 。此外，我们发现有监督预训练仅具有相对较小的优势 。这暗示了未来在收集预训练数据方面的努力应更倾向于扩大规模，而非追求更详细的标注 。

​		我们的贡献可以总结如下 ：

- 我们首次评估了学习到的**表示** (Representation) 在 3D 点云到**高级场景理解** (High-level Scene Understanding) 任务中的迁移能力 。
- 我们的结果表明，在使用单一统一的架构、源数据集和目标函数的情况下，无监督预训练提升了各下游任务和数据集的性能 。
- 在无监督预训练的驱动下，我们在 6 个不同的基准测试中取得了新的**最先进** (State-of-the-art) 性能 。
- 我们相信这些发现将鼓励我们在处理 3D 识别问题的方法论上发生转变，并推动关于 **3D 表示学习** (3D Representation Learning) 的研究。

### 2 Related work

​		`3D 深度神经网络中的表示学习` (Representation learning in 3D Deep neural networks) 是众所周知的“数据渴求型” 。这使得在不同数据集和任务之间迁移学到的表示变得极其强大 。在二维 (2D) 视觉中，这引发了寻找最佳**前置无监督任务** (pretext unsupervised tasks) 的热潮 [43, 83, 84, 14, 41, 18, 5, 42, 3, 40, 27, 69, 28, 87, 8, 10] 。我们注意到，尽管其中许多任务属于低级任务（例如像素或补丁级重建），但评估它们时是基于其向高级任务（如**目标检测** (object detection)）的可迁移性 。由于标注难度大得多，3D 任务可能是无监督学习和**迁移学习** (transfer-learning) 最大的受益者 。这一点在关于单物体任务（如重建、分类和零件分割）的几项工作中得到了证明 [1, 16, 74, 21, 36, 67, 22, 53] 。然而，通常很少有注意力被投入到超越单物体水平的 3D 表示学习上 。此外，在少数研究该领域的案例中，重点也放在了**配准** (registration) 等低级任务上 [15, 81, 12] 。相比之下，我们希望通过专注于更复杂场景中更高级任务的可迁移性，来推动 3D 表示学习的研究 。

​		`用于点云处理的深度架构` (Deep architectures for point cloud processing) 在这项工作中，我们专注于为**点云** (point cloud) 数据学习有用的表示 。受 2D 领域成功的启发，我们推测实现这种进步的一个重要因素是**神经架构的标准化** (standardization of neural architectures) 显而易见 。典型的例子包括 VGGNet [56] 和 ResNet/ResNeXt [26, 71] 。相比之下，点云神经网络设计还远不够成熟，这从近期提出的大量新架构中可见一斑 。这有多个原因：首先是处理无序集合的挑战 [47, 50, 80, 39] ；其次是**领域聚合机制** (neighborhood aggregation mechanism) 的选择，它可以是层次化的 [48, 33, 82, 16, 35]、类空间 CNN 的 [30, 73, 37, 85, 59]、谱方法的 [78, 62, 65] 或基于图的 [72, 64, 68, 54] 。最后，由于点是底层表面的离散样本，**连续卷积** (continuous convolutions) 也被考虑在内 [66, 4, 75] 。最近，Choy 等人提出了 **Minkowski 引擎** (Minkowski Engine) [9]，这是**子流形稀疏卷积网络** (submanifold sparse convolutional networks) [20] 向更高维度的扩展 。特别地，**稀疏卷积网络** (sparse convolutional networks) 促进了对 2D 视觉中常用深度架构的采用，这反过来有助于标准化点云深度学习 。在这项工作中，我们在所有实验中使用基于 Minkowski 引擎构建的统一 **U-Net** [51] 架构作为**骨干网络** (backbone network)，并展示它可以在任务和数据集之间优雅地迁移 。



### 5 Conclusion

​		我们已经对学习到的三维点云**表示 (Representations)** 向**高级三维理解 (High-level 3D Understanding)** 任务的**可迁移性 (Transferability)** 进行了广泛的评估 。在我们的无监督预训练 (Unsupervised Pre-training) 框架 **PointContrast** 的帮助下，我们在 6 个不同的基准测试中取得了**最先进 (State-of-the-art)** 的结果，并证明了学习到的表示可以实现**跨域泛化 (Generalize across domains)** 。我们希望这些发现能鼓励更多关于 **3D 表示学习 (3D Representation Learning)** 的研究 。

