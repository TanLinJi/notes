# Multi-Cache Enhanced Prototype Learning for Test-Time Generalization of  Vision-Language Models

### Abstract

​		在**零样本** (zero-shot) 设置下，**测试时适应** (test-time adaptation) 使用来自测试阶段的无标签数据对预训练模型进行调整，以提升在未知测试分布上的性能。现有的基于缓存增强的 TTA 方法依赖于低熵准则来选择样本以进行原型构建，其假设前提是**类内紧凑性** (intra-class compactness)。然而，在**分布偏移** (distribution shifts) 下，低熵样本可能是不可靠的，并且由此产生的原型可能无法保证紧凑的类内分布。本研究发现缓存增强性能与类内紧凑性之间存在正相关关系。基于这一观察结果，我们提出了一种多缓存增强的基于原型的测试时适应 (Multi-Cache enhanced Prototype-based Test-Time Adaptation, MCP) 方法，该方法包含三个缓存：一个用于使用低熵样本初始化原型表示的**熵缓存** (entropy cache)，一个用于整合视觉和文本信息以实现紧凑类内分布的**对齐缓存** (align cache)，以及一个使用高熵样本进行预测校准的**负缓存** (negative cache)。我们进一步开发了 MCP++，这是一个结合了**跨模态原型对齐** (cross-modal prototype alignment) 与**残差学习** (residual learning) 的框架，引入了原型残差微调。在 15 个下游任务上进行的对比与消融实验表明，所提出的方法和框架实现了最先进的泛化性能。项目主页：<https://zhaihaotian.github.io/MCP-ICCV25/>

### 1 Introduction









---

### 术语：

**类内紧凑性** (intra-class compactness)：[在模型的高维特征空间中，属于同一类别的所有样本特征点聚集在各自类别中心周围的紧密程度]。假设我们在整理办公桌，所有“红笔”都紧紧挨着放在同一个专属笔筒里，这就叫高紧凑性；如果红笔散落得到处都是，这就是低紧凑性（分布涣散）。