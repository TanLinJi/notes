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