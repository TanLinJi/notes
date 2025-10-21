# PointSlice: Accurate and Efficient Slice-Based Representation for 3D Object Detection from Point Clouds



> https://github.com/qifeng22/PointSlice2

### 0 Absract

​		从**点云**中进行**3D 目标检测**在**自动驾驶**领域发挥着关键作用。目前，**点云**处理的主要方法为**基于体素的**方法和**基于柱体的**方法。**基于体素的**方法通过**细粒度空间分割**实现了较高的精度，但存在推理速度较慢的问题；**基于柱体的**方法提升了**推理速度**，但精度仍不及**基于体素的**方法。为解决这些问题，我们提出了一种新颖的**点云**处理方法 ——PointSlice，该方法沿水平面对**点云**进行切片处理，并包含一个专用的检测网络。PointSlice 的主要贡献如下：（1）一种新的**点云**处理技术，该技术将 3D**点云**转换为多组 2D（x-y）数据切片。该模型仅学习 2D 数据分布，将 3D**点云**视为独立的 2D 数据批次，这减少了**模型参数**数量并提升了**推理速度**；（2）引入**切片交互网络（Slice Interaction Network, SIN）**。为维持不同切片间的垂直关系，我们将 SIN 融入**2D 骨干网络**，这提升了模型的**3D 目标感知能力**。大量实验表明，PointSlice 实现了较高的检测精度和推理速度。在 Waymo 数据集上，与最先进的**基于体素的**方法（SAFDNet）相比，PointSlice 的**推理速度**快 1.13 倍，**模型参数**少 0.79 倍，而航向精度加权平均精度（mAPH）仅下降 1.2。在 nuScenes 数据集上，我们实现了 66.74 的平均精度（mAP），这是当前最先进的检测结果。在 Argoverse 2 数据集上，PointSlice 的**推理速度**快 1.10 倍，模型参数少 0.66 倍，而平均精度（mAP）仅下降 1.0。



### 1 Introduction

​		**基于 LiDAR 的 3D 目标检测**（LiDAR-based 3D object detection）因其在自动驾驶和**机器人技术**（robotics）中的应用而得到了广泛研究 [1]。点云固有的稀疏性和不均匀空间分布，使得将**2D 图像网络架构**（2D image network architectures）直接应用于点云数据面临挑战。为应对这些特性，处理点云的主流方法是**体素化**（voxelization）。两种主要的体素化方法为基于体素的方法和基于柱体的方法（见图 1）。

![1760953375398](PointSlice.assets/1760953375398.png)

<center><strong>图 1：</strong>不同点云处理方法的比较：基于柱体的（方法）、基于体素的（方法）以及批量切片（方法）（本文提出）</center>

​		基于体素的方法将点云空间划分为**3D 体素网格**（3D voxel grid）；诸如 HEDNet [2] 和 SAFDNet [3] 等模型采用**分层编码器 - 解码器架构**（hierarchical encoder-decoder architectures）和**稀疏检测头结构**（sparse detection head structures），实现了优异的检测性能。然而，基于体素的方法需要在 x、y、z 三个维度上进行学习，这导致其推理速度相较于基于柱体的方法更慢。基于柱体的方法将点云数据压缩到 x-y 平面，降低了**输入维度**（input dimensionality），从而提升了**推理效率**（inference efficiency）。例如，PillarNet [4] 采用**空间特征语义融合**（spatial feature semantic fusion）进一步提升检测精度。鉴于基于柱体方法的效率优势，一个自然的问题随之产生：基于体素的网络结构能否直接应用于以柱体格式初始化的点云？我们在**Waymo Open 数据集**（Waymo Open dataset）上开展实验以探究该问题。如表 1 所示，尽管使用柱体格式的点云（即**SAFD-Pillar（柱体格式适配的 SAFD 模型）**）相较于 SAFDNet 实现了 1.17 倍的推理速度提升，但其检测精度仅达到 69.3 的**航向精度加权平均精度（mAPH）**。