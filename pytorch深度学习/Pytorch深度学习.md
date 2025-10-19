### P3 法宝函数

`dir():`  能让我们知道工具箱以及工具箱中的分隔区有什么东西。

`help():`，能让我们知道每个工具是如何使用的，工具的使用方法。





### transforms中的一些重要类工具

#### 1.transforms.ToTensor()



#### 2.transforms.Resize()



#### 3.transforms.Normalize()



#### 4.transforms.Compose()

Compose 的主要功能是将多个图像变换（transform）操作串联成一个有序的、单一的操作序列。当你调用这个Compose对象时，它会按照你定义的顺序，依次对输入的图像执行每一个变换。

简单来说，它就像一个“流水线”，图像数据从一端进入，经过流水线上每个工位的处理，最后从另一端输出。

在创建实例时，只需要向其构造函数传入一个**包含多个 transform 对象的列表**。

- 输入数据与数据类型
  - **输入数据**: 通常是一个 **PIL Image** 对象。这是因为大多数 `torchvision` 的变换操作（如 [Resize](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html), [CenterCrop](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html), [RandomHorizontalFlip](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 等）默认都是为处理 PIL Image 设计的。
  - **数据流**: [Compose](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 本身不关心初始输入类型，它只负责将数据传递给列表中的**第一个**变换。因此，你需要确保你的输入数据类型与第一个变换的要求相匹配。在上面的例子中，[Resize](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 接收的就是一个 PIL Image。
- 输出数据与数据类型
  - **输出数据**: 经过列表中**最后一个**变换处理后的结果。
  - 数据类型: 输出的数据类型完全取决于流水线中最后一个变换的输出。
    - 在下面的例子中，最后一个变换是 [Normalize](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，它的输出是一个 [torch.Tensor](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，所以 `processed_tensor` 的类型就是 [torch.Tensor](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)。
    - 如果你的最后一个变换是 [transforms.ToPILImage()](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)，那么最终输出就会变回 PIL Image。

```python
from torchvision import transforms
from PIL import Image

# 1. 定义一个由多个步骤组成的 transform 流水线
transform_pipeline = transforms.Compose([
    transforms.Resize(256),              # 步骤1: 调整图像大小到 256x256
    transforms.CenterCrop(224),          # 步骤2: 从中心裁剪出 224x224 的区域
    transforms.ToTensor(),               # 步骤3: 将图像转换为 Tensor
    transforms.Normalize(                # 步骤4: 对 Tensor 进行归一化
        mean=[0.485, 0.456, 0.406], 
        std=[0.229, 0.224, 0.225]
    )
])

# 2. 加载一张图片
img = Image.open("path/to/your/image.jpg")

# 3. 将图片送入流水线进行处理
processed_tensor = transform_pipeline(img)

# 现在 processed_tensor 就是一个经过所有预处理步骤的张量，可以直接送入模型
```

注意：**顺序至关重要**：变换列表中的顺序直接决定了处理流程，错误的顺序会导致程序报错。最经典的例子是 [ToTensor()](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 和 [Normalize()](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html)：

- **正确顺序**: `[..., transforms.ToTensor(), transforms.Normalize(...)]`
- **错误顺序**: `[..., transforms.Normalize(...), transforms.ToTensor()]`
- **原因**: [Normalize](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 只能操作 [Tensor](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 类型的数据。如果你在 [ToTensor](vscode-file://vscode-app/d:/Microsoft VS Code/resources/app/out/vs/code/electron-browser/workbench/workbench.html) 之前调用它，它会收到一个 PIL Image，从而引发错误。

#### 5.transforms.RandomCrop()



## DataLoadeer()的使用

```python
class torch.utils.data.DataLoader(
    dataset, 
    batch_size=1, 
    shuffle=None, 
    sampler=None, 
    batch_sampler=None, 
    num_workers=0, # 采用一个主进程或者多个进程进行处理
    collate_fn=None, 
    pin_memory=False, 
    drop_last=False, 
    timeout=0, 
    worker_init_fn=None, 
    multiprocessing_context=None, 
    generator=None, *, 
    prefetch_factor=None, 
    persistent_workers=False, 
    pin_memory_device='', 
    in_order=True
)
```

其中各参数的具体含义及作用如下：

1. **dataset（必选）**
   - 含义：需要加载的数据集对象，必须是继承自`torch.utils.data.Dataset`的实例（需实现`__getitem__`和`__len__`方法）。
   - 作用：提供数据的来源（如样本和标签），`DataLoader`通过该对象获取原始数据。
2. **batch_size（常用）**
   - 含义：每个批次（batch）包含的样本数量，默认为 1。
   - 作用：将数据集拆分为多个批次，模型每次训练一个批次的数据（而非整个数据集），平衡计算效率（批次越大，并行计算效率越高）和内存占用（批次过大会导致 OOM）。
   - 场景：训练时通常设为 16、32、64 等（依 GPU 内存调整）；验证 / 测试时可适当增大（如 128），因无需反向传播，内存压力小。
3. **shuffle（常用）**
   - 含义：布尔值，是否在每个 epoch（训练轮次）开始时打乱数据顺序，默认为`False`。
   - 作用：避免模型学习到数据的 “顺序规律”（如样本按类别排序时，模型可能仅记忆顺序而非特征），提升泛化能力。
   - 场景：训练时设为`True`（打乱数据）；验证 / 测试时设为`False`（保持数据顺序，方便结果对齐）。
4. **sampler**
   - 含义：自定义采样器（需是`Sampler`类的实例），用于生成样本的索引（决定从`dataset`中取哪些样本）。
   - 作用：灵活控制采样逻辑，如处理类别不平衡数据（过采样少数类）、按特定比例采样等。
   - 注意：若设置`sampler`，`shuffle`需设为`False`（采样器已决定顺序）。
5. **batch_sampler**
   - 含义：自定义批次采样器（需是`BatchSampler`类的实例），直接生成 “批次索引列表”（每个元素是一个包含`batch_size`个索引的列表）。
   - 作用：替代`batch_size`和`sampler`的组合，更灵活地控制批次生成逻辑（如动态调整每个批次的大小）。
   - 注意：若设置`batch_sampler`，`batch_size`、`shuffle`、`sampler`等参数会被忽略。
6. **num_workers（常用）**
   - 含义：数据加载时使用的子进程数量，默认为 0（主进程加载）。
   - 作用：通过多进程并行加载数据，解决 “数据加载速度慢于模型计算速度” 的瓶颈（IO 密集型优化）。
   - 场景：设为 CPU 核心数的 1/2 或相等（如 8 核 CPU 设为 4 或 8），过大会导致进程切换开销增加，反而变慢。
7. **collate_fn**
   - 含义：自定义函数，用于将一个批次的样本（列表形式，每个元素是`dataset.__getitem__`的返回值）整理为模型可输入的格式（如拼接张量、处理变长数据）。
   - 作用：解决样本格式不一致的问题，例如文本数据长度不同时，需用`collate_fn`填充到相同长度；或自定义标签的拼接逻辑。
   - 示例：默认`collate_fn`会将列表中的张量自动拼接为更大的批次张量。
8. **pin_memory（常用）**
   - 含义：布尔值，是否将加载到 CPU 的数据复制到 “CUDA 固定内存”（pinned memory），默认为`False`。
   - 作用：加速数据从 CPU 到 GPU 的传输（普通内存→GPU 需先经 PCIe 复制到临时缓存，固定内存可直接传输）。
   - 场景：当使用 GPU 训练时设为`True`，能显著减少数据传输耗时；CPU 训练时无需设置。
9. **drop_last（常用）**
   - 含义：布尔值，若数据集样本数不能被`batch_size`整除，是否丢弃最后一个不完整的批次，默认为`False`。
   - 作用：避免最后一个批次因样本数少而导致的训练波动（如批次归一化层计算不稳定）。
   - 场景：训练时通常设为`True`（确保每个批次大小一致）；验证 / 测试时设为`False`（充分利用所有数据）。
10. **timeout**
    - 含义：当`num_workers>0`时，主进程等待子进程返回数据的超时时间（秒），默认为 0（不超时）。
    - 作用：防止子进程卡死导致的程序挂起，超过超时时间会抛出异常。
11. **worker_init_fn**
    - 含义：每个子进程初始化时调用的函数（如设置随机种子）。
    - 作用：确保不同子进程的随机性不同（如数据增强的随机操作），避免多进程加载数据时的 “随机重复”。
12. **persistent_workers**
    - 含义：布尔值（PyTorch 1.6 + 支持），是否在数据集迭代结束后保持子进程存活（而非销毁），默认为`False`。
    - 作用：多次迭代（如多轮训练）时复用子进程，减少进程创建 / 销毁的开销，加速数据加载。

## Torch.nn

```plaintext
torch.nn
├── Containers（组织和管理神经网络模块/参数的容器,其实就是一个骨架，往结构中添加不同的内容可以构成不同的神经网络）
│   ├── Module：所有神经网络模块的基类，自定义网络需继承，提供参数管理等核心功能，也就是说为所有的神经网络提供一个基本的骨架
│   ├── Sequential：顺序容器，按添加顺序执行子模块，简化层串联（如CNN的卷积+激活串联）
│   ├── ModuleList：列表式容器，以列表存储子模块，支持索引访问，便于批量操作
│   ├── ModuleDict：字典式容器，以键值对存储子模块，支持按key动态选择子模块
│   ├── ParameterList：列表式容器，专门存储Parameter对象，方便批量管理可学习参数
│   └── ParameterDict：字典式容器，专门存储Parameter对象，支持按key访问特定参数
│
├── Convolution Layers（通过滑动卷积核提取局部特征，处理网格/序列数据）
│   ├── Conv1d：1D卷积，沿序列长度滑动，用于文本、音频等1D数据（提取局部时序特征）
│   ├── Conv2d：2D卷积，沿高/宽滑动，用于图像等2D数据（提取局部空间特征）
│   ├── Conv3d：3D卷积，沿深度/高/宽滑动，用于视频、3D图像等3D数据（提取时空特征）
│   ├── ConvTranspose1d/2d/3d：转置卷积（反卷积），实现上采样，恢复特征图尺寸
│   └── Unfold：滑动窗口拆分，将输入按窗口拆分为子张量，辅助手动实现卷积
│
├── Pooling Layers（通过聚合局部特征下采样，降低维度并增强鲁棒性）
│   ├── MaxPool1d/2d/3d：最大池化，取窗口内最大值，保留显著特征，抗噪声
│   ├── AvgPool1d/2d/3d：平均池化，取窗口内平均值，平滑特征，减少尖锐变化
│   ├── AdaptiveMaxPool1d/2d/3d：自适应最大池化，输出固定尺寸（自动调整窗口）
│   ├── AdaptiveAvgPool1d/2d/3d：自适应平均池化，同上，用平均操作实现固定输出
│   └── LPPool1d/2d：Lp范数池化，按p范数聚合窗口特征，平衡最大与平均池化
│
├── Padding Layers（在张量边缘填充值，调整尺寸以匹配卷积/池化需求）
│   ├── ZeroPad1d/2d/3d：零填充，边缘补0，常用于保持卷积后尺寸或控制感受野
│   ├── ReflectionPad1d/2d：反射填充，边缘按镜像反射补值，减少图像边缘 artifacts
│   ├── ReplicationPad1d/2d/3d：复制填充，边缘按最外层值复制，适合语义连续场景
│   └── ConstantPad1d/2d/3d：常数填充，边缘补指定常数（如按业务需求补特定值）
│
├── Non-linear Activations (weighted sum, nonlinearity)（引入非线性能力，基于“加权和+非线性”）
│   ├── ReLU：修正线性单元，输入>0时输出自身，缓解梯度消失，加速训练
│   ├── LeakyReLU：带泄漏的ReLU，输入<0时输出小斜率值，避免神经元“死亡”
│   ├── PReLU：参数化ReLU，负斜率为可学习参数，自适应调整非线性特性
│   ├── Sigmoid：S型激活，映射到[0,1]，适合二分类概率输出或门控机制
│   └── Tanh：双曲正切，映射到[-1,1]，零中心化输出，适合循环网络
│
├── Non-linear Activations (other)（其他非线性激活，适应特定场景需求）
│   ├── Softmax：沿维度归一化，输出和为1的概率分布，用于多分类任务
│   ├── GELU：高斯误差线性单元，Transformer中常用，平滑ReLU变体
│   ├── Swish：x*sigmoid(βx)，带自门控机制，深层模型性能优于ReLU
│   └── ELU：指数线性单元，输入<0时输出e^x-1，使均值接近0，抗噪声强
│
├── Normalization Layers（标准化特征分布，稳定训练，加速收敛）
│   ├── BatchNorm1d/2d/3d：批归一化，对批次内样本的每个特征归一化，减少内部协变量偏移
│   ├── LayerNorm：层归一化，对单个样本的所有特征归一化，不受批次大小影响，适合RNN/Transformer
│   ├── InstanceNorm1d/2d/3d：实例归一化，对单个样本的单个通道归一化，适合风格迁移
│   ├── GroupNorm：组归一化，将通道分组后对每组特征归一化，小批量替代BatchNorm
│   └── SyncBatchNorm：同步批归一化，多GPU训练时跨设备同步批次统计量
│
├── Recurrent Layers（处理序列数据，通过记忆机制捕捉时序依赖）
│   ├── RNN：基础循环网络，按时间步递归计算，易梯度消失/爆炸，适合短序列
│   ├── LSTM：长短期记忆网络，通过三门控机制控制信息流动，缓解梯度消失，捕捉长依赖
│   ├── GRU：门控循环单元，LSTM简化版（合并输入门和遗忘门），参数更少，训练更快
│   └── RNNCell/LSTMCell/GRUCell：循环单元版本，一次处理单个时间步（手动控制时序循环）
│
├── Transformer Layers（基于自注意力机制，并行处理序列，捕捉长距离依赖）
│   ├── MultiHeadAttention：多头自注意力，拆分输入为多个头并行计算，捕捉多尺度关联
│   ├── TransformerEncoder：Transformer编码器，由多个EncoderLayer堆叠，输出序列特征
│   ├── TransformerDecoder：Transformer解码器，由多个DecoderLayer堆叠，用于生成任务
│   ├── TransformerEncoderLayer：编码器单层，含多头自注意力+前馈网络+残差连接
│   └── TransformerDecoderLayer：解码器单层，含多头自注意力+交叉注意力+前馈网络
│
├── Linear Layers（实现特征线性变换，用于维度映射或输出预测）
│   ├── Linear：全连接层，y = xA^T + b，将输入特征映射到指定输出维度（如分类器最后一层）
│   └── Bilinear：双线性层，y = x1*A*x2 + b，融合两个输入的特征（如多模态数据融合）
│
├── Dropout Layers（随机失活神经元实现正则化，防止过拟合）
│   ├── Dropout：随机失活，按概率将输入元素置0，通用正则化（适用于全连接、卷积层）
│   ├── Dropout2d/3d：空间维度失活，按概率将整个特征图/体素置0，增强空间鲁棒性
│   └── AlphaDropout：自归一化失活，配合SELU激活，保持输出均值和方差不变
│
├── Sparse Layers（处理离散输入（如索引），映射为稠密特征）
│   ├── Embedding：嵌入层，将离散索引（如词ID）映射为固定维度的稠密向量（如词嵌入）
│   └── EmbeddingBag：嵌入聚合层，对多个索引的嵌入向量求和/平均，高效处理变长序列
│
├── Distance Functions（计算张量间相似度或距离，用于度量学习）
│   ├── PairwiseDistance：成对距离，计算两个张量间的Lp距离（如L2欧氏距离）
│   └── CosineSimilarity：余弦相似度，计算张量夹角余弦值，衡量方向一致性（忽略幅值）
│
├── Loss Functions（衡量预测与标签差异，指导参数优化）
│   ├── CrossEntropyLoss：交叉熵损失，结合LogSoftmax和NLLLoss，用于多分类
│   ├── MSELoss：均方误差损失，计算预测与真实值的平方差，用于回归任务
│   ├── BCEWithLogitsLoss：带sigmoid的二分类交叉熵，输入logits自动过sigmoid
│   ├── NLLLoss：负对数似然损失，配合LogSoftmax使用，用于多分类
│   └── L1Loss：L1损失，计算绝对差，对回归任务的异常值更稳健
│
├── Vision Layers（计算机视觉专用操作层）
│   ├── Upsample：上采样，通过插值（最近邻、双线性等）放大特征图（如语义分割解码器）
│   ├── PixelShuffle：像素重排，将通道特征“重排”到空间维度，实现高效上采样（超分辨率）
│   ├── RoIPool：感兴趣区域池化，从特征图提取固定尺寸ROI特征（目标检测）
│   └── RoIAlign：ROI对齐，解决RoIPool量化误差，更精确提取ROI特征（提升检测精度）
│
├── Shuffle Layers（打乱特征维度，促进信息交互）
│   └── ChannelShuffle：通道打乱，将分组卷积的输出通道随机打乱，促进组间信息交流（如ShuffleNet）
│
├── DataParallel Layers (multi-GPU, distributed)（多设备并行训练，加速计算）
│   ├── DataParallel：数据并行，单进程控制多GPU，拆分数据到不同GPU并行计算（单机多卡）
│   └── DistributedDataParallel：分布式数据并行，多进程多GPU，支持多机多卡，同步效率更高
│
├── Utilities（网络构建辅助工具类）
│   ├── Parameter：参数封装类，标记张量为可学习参数，自动纳入优化器更新范围
│   ├── Buffer：缓冲区，存储非学习参数（如BatchNorm的均值/方差），随模型保存/加载
│   └── Flatten：展平层，将多维张量展平为1D（如卷积层连接全连接层时使用）
│
├── Quantized Functions（模型量化压缩，加速推理并减少存储）
│   ├── Quantize：量化层，将浮点张量转换为量化张量（降低精度，减少计算/存储）
│   ├── DeQuantize：反量化层，将量化张量转回浮点张量（便于后续浮点操作）
│   └── QFunctional：量化功能集合，提供量化版本的基础操作（如add、mul）
│
└── Lazy Modules Initialization（延迟初始化，自动推断输入维度，简化定义）
    ├── LazyLinear：延迟初始化线性层，无需指定in_features，运行时自动推断
    └── LazyConv2d：延迟初始化卷积层，无需指定in_channels，运行时自动推断
```

### torch.nn.Module()

Module是所有神经网络的基类，为所有的神经网络提供了模板，基本的使用方法是：

```python
import torch.nn as nn
import torch.nn.functional as F


class Model(nn.Module):  # 继承了 Module 类
    def __init__(self) -> None:
        super().__init__() # 必须调用父类的初始化函数
        self.conv1 = nn.Conv2d(1, 20, 5)
        self.conv2 = nn.Conv2d(20, 20, 5)

    def forward(self, x): # 这个也是比较重要的前向传播 input-->(nn: forward)-->ouput  所有的子类都应该重写这个方法
        x = F.relu(self.conv1(x))  # 对输入x进行卷积，再经过ReLu进行非线性处理
        return F.relu(self.conv2(x))  # x-->卷积-->ReLU-->卷积-->ReLu-->输出
```

基本上，所有的神经网络都是使用这样的模板