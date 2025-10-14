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

##### 5.transforms.RandomCrop()