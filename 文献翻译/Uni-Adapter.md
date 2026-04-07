# Adapt-As-You-Walk Through the Clouds: Training-Free Online Test-Time Adaptation of 3D Vision-Language Foundation Models



### Abstract

​		**三维视觉-语言基础模型** (3D Vision-Language Foundation Models, VLFMs) 在开放世界的**点云处理** (point cloud processing) 任务中展现出了强大的泛化能力与**零样本识别** (zero-shot recognition) 能力。然而，在数据存在噪声、不完整，或采自与训练数据不同分布的实际场景中，其性能往往会显著下降。为了应对这一挑战，我们提出了 Uni-Adapter，这是一种基于**动态原型学习** (dynamic prototype learning) 的、用于三维视觉-语言基础模型的新型免训练**在线测试时自适应** (online test-time adaptation, TTA) 策略。Uni-Adapter 维护了一个三维缓存，用于存储特定类别的聚类中心作为原型，这些原型会被持续更新，以捕获异构数据分布下的**类内变异性** (intra-class variability)。这些动态原型作为锚点，通过相似度打分进行基于缓存的**对数几率计算** (logit computation)。同时，一个基于图的**标签平滑** (label smoothing) 模块对原型间的相似度进行建模，以在相关原型之间强制保持标签一致性。最后，来自原始三维视觉-语言基础模型和优化后三维缓存的预测结果通过**熵权聚合** (entropy-weighted aggregation) 进行统一，以确保可靠的自适应。在无需重新训练的情况下，Uni-Adapter 有效缓解了**分布偏移** (distribution shifts)，并在多种三维视觉-语言基础模型的多个三维基准测试中取得了最先进的性能——相比源三维视觉-语言基础模型，其在 ModelNet-40C 上提升了 10.55%，ScanObjectNN-C 上提升了 8.26%，ShapeNet-C 上提升了 4.49%。

Code：https://mehran-tam.github.io/Uni-Adapter/

### Introduction

​		诸如 Uni3D (Zhou et al. 2024) 等**三维视觉-语言基础模型** (3D Vision-Language Foundation Models, VLFMs) 在多模态点云处理任务中展现出了非凡的潜力。这些模型在网络规模的文本-图像-点云三元组上进行预训练，在一个共享的嵌入空间中学习**跨模态表示** (cross-modal representations)，从而实现了对新颖点云类别的**零样本识别** (zero-shot recognition)。尽管这些模型能力强大，但 VLFMs 在真实世界场景中仍面临着严重的局限性，在这些场景中，由于传感器限制和环境因素，获取的点云往往存在严重的噪声、稀疏性和低分辨率问题。**域适应** (domain adaptation) 和**泛化** (generalization) 旨在通过弥合源域和目标域之间的差距来解决这些**分布偏移** (distribution shifts) 问题。

​		在现有的 VLFMs 自适应方法中，**测试时自适应** (test-time adaptation, TTA) (Sharifdeen et al. 2025; Karmanov et al. 2024; Huang et al. 2025) 提供了一种特别高效的解决方案，它不需要带标签的目标数据，同时能够对未见过的条件进行动态调整。现有的针对 VLFMs 的 TTA 方法可以大致分为**基于训练的** (training-based) 和**免训练的** (training-free) 方法。基于训练的 TTA 方法通过在测试时更新模型参数的子集 (Osowiechi et al. 2024) 或**软提示** (soft prompts) (Shu et al. 2022; Yoon et al. 2024; Sharifdeen et al. 2025) 来适应目标域。这些方法通常优化诸如跨测试样本增强视图的**预测熵最小化** (prediction entropy minimization) 等目标 (Shu et al. 2022)，或使用额外的辅助损失 (Sharifdeen et al. 2025) 来引导自适应。虽然这些方法在减少域偏移方面是有效的，但它们通常需要迭代的**反向传播** (backpropagation)，这使得它们的计算成本很高，不太适合实时部署。相比之下，免训练的 TTA 方法，例如最近基于缓存的方法 (Karmanov et al. 2024; Sun et al. 2025)，通过动态缓存高置信度特征来避免参数微调。这些嵌入通过特征相似度来优化预测，从而为实时和流式场景提供轻量级、可扩展的自适应能力。

​		虽然主要为二维视觉-语言基础模型 (Radford et al. 2021a) 设计，但基于缓存的策略在三维视觉-语言基础模型中的探索仍然不足，目前只有少数为设计有效缓存模块的早期尝试。最近，Point-Cache (Sun et al. 2025) 引入了一种用于三维视觉-语言基础模型的 TTA 框架，提出了一种由全局和局部缓存组成的**双缓存结构** (dual-cache structure)。这两种缓存都是基于高置信度测试样本构建的，假设这些样本足以充分代表完整的数据分布。然而，这种假设在实际应用中往往不成立——尤其是对于三维数据——其中每个语义类别都能表现出显著的**结构多样性** (structural diversity)。如图 1(a) 所示，对应于单个类别（例如“飞机”）的特征在特征空间中形成了多个不同的簇，反映了不同的结构模式。因此，高置信度原型通常只能捕获这些变化的一个子集，导致次优的自适应性能。图 1(b) 的上半部分展示了这种局限性，其中缓存的**高置信度原型** (high-confidence prototypes)（三角形标记）导致了不正确的决策边界。

​		为了克服以往基于置信度的缓存策略的局限性，我们提出了 Uni-Adapter（统一三维适配器），这是一种用于三维视觉-语言基础模型的新型在线 TTA 框架。我们的方法采用了一种基于聚类的缓存策略，该策略动态地存储和更新聚类中心，确保对底层特征分布的全面覆盖。图 1(b) 的下半部分对该设计进行了可视化，其中黄色圆形标记表示用作原型的缓存聚类中心。这些原型提供了对分布更真实的表示，从而实现了改进的亲和度计算和更鲁棒的自适应。为了在测试时设置中实现基于聚类的原型学习，我们采用了一种**在线聚类策略** (online clustering strategy)，其中不断到达的测试样本增量式地更新特定类别的聚类中心，并以此作为原型。每个类别在一个统一的缓存中维护多个基于聚类的原型，确保全面覆盖多样化的数据分布模式。该策略捕获了类内变异性，并防止了对少数主导模式的过度依赖。此外，我们观察到现有的基于缓存的模型性能会受到**噪声伪标签** (noisy pseudo-labels) 的影响，这使得被错误分类的样本污染了缓存。为了解决这个问题，我们在缓存的原型上构建了一个相似度图，并应用**基于图的标签平滑** (graph-based label smoothing) 来优化它们的标签。这使得标签能够在相似的原型之间进行有效传播，从而减轻了噪声伪标签的影响，并产生了一个更可靠、更具适应性的缓存。我们使用**共轭梯度法** (conjugate gradient method) 来求解由此产生的**拉普拉斯系统** (Laplacian system)，因为它对于大型稀疏系统具有很高的效率和可扩展性。最后，我们使用**熵驱动的置信度加权** (entropy-driven confidence weighting) 来融合原始的三维视觉-语言基础模型得分和三维缓存的对数几率，从而得出最终预测。

​		`总结` 所提出方法的贡献如下：1) 我们引入了一种基于聚类的缓存策略，该策略对每个类别使用多个聚类中心来捕获类内变异性，从而实现对多样化测试分布的自适应。2) 我们在缓存原型上应用基于图的标签平滑，利用原型间的相似度来优化噪声伪标签，并改善在分布偏移下基于缓存的自适应。3) 我们在不同三维视觉-语言基础模型和多样化的基准测试上进行了广泛的实验以验证我们的方法——包括 ShapeNet-C (Mirza et al. 2023)、ModelNet-40C (Sun et al. 2022) 和 ScanObjectNN-C (Mirza et al. 2023) 等受损数据集，以及干净的数据集（大规模和小规模）——取得了新的最先进结果。

### Related Work