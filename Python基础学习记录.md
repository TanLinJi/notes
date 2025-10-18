## 第一章

### 1.1 注释

- 单行注释： 

  ```python
  # 这是一个单行注释
  ```

- 多行注释：

  ```python
  """
  这是一个多行注释
  这是一个多行注释
  这是一个多行注释
  多行注释本质上是一个字符串
   - 一般对文件、类进行解释说明
  """
  ```

- 中文文档声明注释：

  ```python
  # coding=utf-8
  # 该类注释必须放在文档的第一行代码
  ```

- ‘#’ 和注释内容之间空一格



### 1.2 标识符和保留字

- 可以是字母数字下划线，首字符不能是数字

- 不能使用python中的保留字

- 严格区分大小写

- python文件名应使用小写字母和下划线：simple_message.py

- 以下划线开头的标识符一般有特殊意义，应当避免使用相似的标识符

- 允许使用中文作为标识符

- **模块名**尽量短小，并且全部使用小写字母，可以使用下划线分隔多个字母。如：grame_main

- **包名**尽量短小，并且全部使用小写字母，不推荐使用下划线。如：com.ysjpython

- **类名**采用首字母大写形式（Pascal风格）。如：MyClass

- **模块内部的类**采用 “_” + Pascal风格的类名组成，例如阿紫Myclass中的内部类 _InnerMyClass

- **函数、类的属性和方法**的命名全部使用小写字母，多个字母之间使用下划线分隔

- 常量命名时全部采用大写字母，可以使用下划线

- 使用单下划线开头的模块变量或函数是受保护的，在使用 “from ... import ... ”语句从模块中导入时，这些模块变量或函数不能被导入

- 使用双下划线开头的实例变量或方法是类私有的

- 在类中，使用一个空行来分隔方法

- 在模块中，使用两个空行来分隔类

- 以双下划线开头和结尾的是Python的专用标识，例如：`__init__()`表示初始化函数

- 对于每个类，都应在其后紧跟一个文档字符串说明此类的用途

- 对于每个模块，都应包含一个文档字符串来说明这个模块中的类的大体作用

- 需要同时导入标准库中的模块和自己的模块时，应该先导入标准库中的模块，再添加一个空行，再导入自己的模块

- 判断一个标识符是否合法：

  ```python
  def is_valid_identifier(name):
      try:
          exec(f"{name} = None")
          return True
      except:
          return False
  
  print(is_valid_identifier("2var"))  # False
  print(is_valid_identifier("var2"))  # True
  ```

  函数的核心逻辑是利用 Python 解释器自身的语法检查能力，通过`exec`函数 动态执行代码 来验证标识符的合法性，在`try`块中，通过`exec(f"{name} = None")`生成一段代码，试图将`None`赋值给以`name`为名称的变量。如果`name`是有效的标识符，这段赋值语句是合法的 Python 代码，能够正常执行，不会抛出异常。如果`name`是无效的标识符，这段代码会触发语法错误（`SyntaxError`），进入`except`块。

- python中的保留字：

  | 关键字   |            |         |          |            |          |
  | -------- | ---------- | ------- | -------- | ---------- | -------- |
  | `False`  | `None`     | `True`  | `and`    | `as`       | `assert` |
  | `async`  | `await`    | `break` | `class`  | `continue` | `def`    |
  | `del`    | `elif`     | `else`  | `except` | `finally`  | `for`    |
  | `from`   | `global`   | `if`    | `import` | `in`       | `is`     |
  | `lambda` | `nonlocal` | `not`   | `or`     | `pass`     | `raise`  |
  | `return` | `try`      | `while` | `with`   | `yield`    |          |

  查询python中的保留字：

  ```python
  import keyword
  print(keyword.kwlist)
  print('关键词个数为：', len(keyword.kwlist), sep='')
  ```

  保留字是严格区分大小写的

  

## 第二章

### 2.1 字面量

- 字面量是在代码中写下来的固定的值

- 字面量包含：数字、字符串、列表、元组、集合、字典

  | 类型               | 描述                   | 说明                                           |
  | ------------------ | ---------------------- | ---------------------------------------------- |
  | 数字（Number）     | 支持：                 |                                                |
  |                    | • 整数（int）          | 如：10、-10                                    |
  |                    | • 浮点数（float）      | 如：13.14、-13.14                              |
  |                    | • 复数（complex）      | 如：4+3j，以`j`结尾表示复数                    |
  |                    | • 布尔（bool）         | True表示真，False表示假；True记作1，False记作0 |
  | 字符串（String）   | 描述文本的一种数据类型 | 由任意数量的字符组成                           |
  | 列表（List）       | 有序的可变序列         | Python中使用最频繁的数据类型，可有序记录数据   |
  | 元组（Tuple）      | 有序的不可变序列       | 可有序记录一堆不可变的Python数据集合           |
  | 集合（Set）        | 无序不重复集合         | 可无序记录一堆不重复的Python数据集合           |
  | 字典（Dictionary） | 无序Key-Value集合      | 可无序记录一堆Key-Value型的Python数据集合      |

  说明：

  ​	a. 数字类型包含4种子类型，其中布尔值是`int`的子类

  ​	b. 复数类型通过`j`表示虚数部分（如`3j`）

  ​	c. 列表和元组的主要区别是可变性（列表可修改，元组不可修改）

  ​	d. 集合会自动去重，字典通过键值对存储数据

### 2.2 变量

- 格式：变量名称 = 变量值

### 2.3 数据类型

- 可以使用type()来查看数据的类型

  ```python
  # 使用type()查看数据的类型
  # 字符串类型
  print(type("牛犇"))  # <class 'str'>
  # 整数类型
  int_type = type(666)
  print(int_type)     # <class 'int'>
  # 浮点类型
  num = 12.56
  print(type(num))  	# <class 'float'>
  ```

  注意：使用type(变量)的方式查看的是数据的类型而不是变量的类型，因为变量无类型

- 字符串类型：用引号(单引号，双引号)括起来的都是字符串

  ```python
  "I'm beautiful!"   # 这样可以灵活的在字符串中包含引号和撇号
  ```

  一些常用的字符串方法：

  ```python
  name = "ada lovelace"
  print(name.title())  # Ada Lovalace   以首字母大写的方式显示每个单词
  print(name.upper())  # ADA LOVELACE   将字符串改为全部大写
  print(name.lower())  # ada lovelace   将字符串改为全部小写
  
  lanu = "   python    "
  print(lanu.rstrip())   #  删除字符串末尾的空白
  print(lanu.lstrip())   #  删除字符串开头的空白
  print(lanu.strip())	   #  同时删除字符串开头和末尾的空白
  ```

  字符串的拼接：使用 `+` 运算符

  ```python
  first_name = "ada"
  last_name = "lovelace"
  full_name = first_name + " " + last_name
  message = "Hello, " + full_name.title() + "!"
  print("Hello, " + full_name.title() + "!")   # Hello, Ada Lovelace!
  print(message)
  ```

  注意：字符串拼接时， `+` 运算符两边的操作数必须都是字符串类型，否则会报错：

  ```python
  age = 23   # age实际上是一个整型的变量
  pirnt("I am " + age + "year old.")    # 会报错 
  
  print("I am " + str(age) + "year old.")  # 使用str方法先将非字符串值显示成字符串
  ```

### 2.4 数据类型转换

- int(x) 将x转换为一个整数

  - 如果将字符串转为数字要求字符串内的内容都是数字
  - 浮点数转为整数会丢失小数部份

- float(x) 将x转换为一个浮点数

- str(x) 将x转换为一个字符串

  任何数据类型都可以转换成字符串：

  ```python
  # 类型转换
  # 转换为int
  num_int = int('11')
  print(type(num_int), num_int)
  
  # 转化为str
  num_str = str(11)
  print(type(num_str), num_str)
  
  # 转换为float
  num_float = str("12.65")
  print(type(num_float), num_float)
  ```

### 2.5 运算符

| 运算符   | 描述                     | 例子                                   |
| -------- | ------------------------ | -------------------------------------- |
| `+`      | 加法                     | `5 + 3 → 8`                            |
| `-`      | 减法                     | `5 - 3 → 2`                            |
| `*`      | 乘法                     | `5 * 3 → 15`                           |
| `/`      | 除法                     | `10 / 2 → 5.0`                         |
| `//`     | 整除                     | `10 // 3 → 3`                          |
| `%`      | 取模                     | `10 % 3 → 1`                           |
| `**`     | 幂运算                   | `2 ** 3 → 8`                           |
| `=`      | 赋值                     | `x = 5`                                |
| `+=`     | 加后赋值                 | `x += 3`（等价于 `x = x + 3`）         |
| `-=`     | 减后赋值                 | `x -= 2`（等价于 `x = x - 2`）         |
| `*=`     | 乘后赋值                 | `x *= 4`（等价于 `x = x * 4`）         |
| `/=`     | 除后赋值                 | `x /= 2`（等价于 `x = x / 2`）         |
| `//=`    | 整除赋值                 | `x //= 3`（等价于 `x = x // 3`）       |
| `%=`     | 取模赋值                 | `x %= 3`（等价于 `x = x % 3`）         |
| `**=`    | 幂运算赋值               | `x **= 2`（等价于 `x = x ** 2`）       |
| `&=`     | 按位与赋值               | `x &= 3`（等价于 `x = x & 3`）         |
| `|=`     | 按位或赋值               | `x |= 3`（等价于 `x = x | 3`）         |
| `^=`     | 按位异或赋值             | `x ^= 3`（等价于 `x = x ^ 3`）         |
| `<<=`    | 左移赋值                 | `x <<= 1`（等价于 `x = x << 1`）       |
| `>>=`    | 右移赋值                 | `x >>= 1`（等价于 `x = x >> 1`）       |
| `==`     | 等于                     | `5 == 5 → True`                        |
| `!=`     | 不等于                   | `5 != 3 → True`                        |
| `>`      | 大于                     | `5 > 3 → True`                         |
| `<`      | 小于                     | `5 < 3 → False`                        |
| `>=`     | 大于等于                 | `5 >= 5 → True`                        |
| `<=`     | 小于等于                 | `5 <= 3 → False`                       |
| `and`    | 逻辑与                   | `(5>3) and (2<4) → True`               |
| `or`     | 逻辑或                   | `(5<3) or (2<4) → True`                |
| `not`    | 逻辑非                   | `not (5<3) → True`                     |
| `&`      | 按位与                   | `5 & 3 → 1`                            |
| `|`      | 按位或                   | `5 | 3 → 7`                            |
| `^`      | 按位异或                 | `5 ^ 3 → 6`                            |
| `~`      | 按位取反                 | `~5 → -6`                              |
| `<<`     | 左移                     | `5 << 1 → 10`                          |
| `>>`     | 右移                     | `5 >> 1 → 2`                           |
| `in`     | 成员存在检查             | `3 in [1,2,3] → True`                  |
| `not in` | 成员不存在检查           | `4 not in [1,2,3] → True`              |
| `is`     | 对象身份相同             | `a is b`（当 `a` 和 `b` 是同一对象时） |
| `is not` | 对象身份不同             | `a is not b`                           |
| `:=`     | 海象运算符（赋值表达式） | `if (n := len(a)) > 5:`                |

注意：

​	**位运算符**操作的是整数的二进制形式（如 `5` 的二进制为 `101`）。

​	**身份运算符**（`is`/`is not`）比较对象的内存地址，而 `==` 比较值。

​	**海象运算符**（Python 3.8+）允许在表达式中赋值（如条件判断、列表推导式等）。

### 2.6 字符串扩展方法

- 字符串的三种定义方法：

  ```python
  # 单引号
  name = '牛犇'
  # 双引号
  name = "牛犇"
  # 三引号(接收了是变量，没接收就是注释)
  name = """牛犇"""
  ```

- 如果字符串的内容本身就有单引号或者多引号：

  a. 单引号定义法：可以包含双引号

  b. 双引号定义发：可以包含单引号

  c. 使用转义字符‘\’来解除效用，变成普通字符串

  ```python
  name = '牛犇"'
  name = "牛犇'"
  name = "牛犇\'"
  ```

- 字符串格式化

  - 多个变量占位，变量要用括号括起来，并按照占位的顺序填入
  - 使用小写的s，不能使用大写的s

  ```python
  name = "张三"
  message = "姓名：%s" % name
  print(message)
  
  name = "张三"
  salary = 12569
  message = "姓名：%s, 工资：%s" % (name, salary)
  print(message)
  ```

  - 占位符有：%s, %d ,%f 



## 第三章 列表

### 3.1 列表的基础操作

- 列表是由一系列按特定顺序排列的元素组成，是`有序集合`，列表的元素之间没有任何关系，通常列表名称是一个表示复数的名字

  ```python
  names = ['john', 'Alan', 'Bob']  #  列表由方括号括起来
  print(names)   # 输出['john', 'Alan', 'Bob']
  ```

- 列表元素的访问（下标从0开始）

  ```python
  names = ['john', 'Alan', 'Bob'] 
  print(names[0])   # john  只打印该元素，不包含方括号和引号
  print(names[0].title())  # John
  print(names[-1])  # 使用 -1 访问列表的最后一个元素
  ```

- 可以使用索引 -1 访问最后一个元素，-2 访问倒数第二个元素等等

- 判断列表是否为空：

  ```python
  cars = []
  if cars:
      print("Welcome!")
  else:
      print("We have no car!")
  ```

- 修改列表元素

  ```python
  motors = ['honda', 'yamaha', 'suzuki']
  motors[0] = 'ducati'
  print(motors)   #  ['ducati', 'yamaha', 'suzuki']
  ```

- 在列表末尾添加元素, 使用 append()

  ```python
  motors = ['honda', 'yamaha', 'suzuki']
  motors.append('ducati')
  print(motors)  #  ['honda', 'yamaha', 'suzuki', 'ducati']
  ```

- 可以使用方法 append 动态的创建列表（这种方式非常常用）

  ```python
  motors = []
  motors.append('honda')
  motors.append('yamaha')
  motors.append('suzuki')
  ```

- 使用 insert() 方法在列表中指定位置插入元素 

  ```python
  motors = ['honda', 'yamaha', 'suzuki']
  motors.insert(0,'ducati')   #  在索引值为 0 的位置添加新元素
  print(motors)   #  ['ducati', 'honda', 'yamaha', 'suzuki']
  ```

- 使用 del 语句删除列表中元素（删除之后无法再访问这个被删除的元素）

  ```python
  motors = ['honda', 'yamaha', 'suzuki']
  del motors[0]    #  删除索引值为 0 处的元素
  print(motors)  #  ['yamaha', 'suzuki']
  ```

- 使用 pop() 方法删除列表末尾的元素

  ```Python
  motors = ['honda', 'yamaha', 'suzuki']
  my_motor = motors.pop()
  print(motors)     #   ['honda', 'yamaha']
  print(my_motor)   #   suzuki
  ```

- 使用 pop() 方法来删除列表中指定位置的元素

  ```Python
  motors = ['honda', 'yamaha', 'suzuki']
  my_motor = motors.pop(0)  #  弹出索引位置为 0 处的元素
  print(motors)     #  ['yamaha', 'suzuki']
  print(my_motor)   #  honda
  ```

- 关于 pop() 方法和 del 语句，这两个都会从列表中删除一个元素，如果这个元素以后不再使用就用 del 语句，如果要使用就用 pop 方法

- 使用方法 remove() 根据值删除列表中的元素

  ```python
  motors = ['honda', 'yamaha', 'suzuki']
  motors.remove('honda')   # 如果试图删除一个列表中不存在的元素则会报错
  print(motors)   #  ['yamaha', 'suzuki'] 	
  ```

  注意：remove() 方法只删除列表中第一个符合条件的值，如果存在多个，应该使用循环

  可以把要删除的元素先存储在变量中：

  ```python
  motors = ['honda', 'yamaha', 'suzuki']
  too_expensive = 'honda'
  motors.remove(too_expensive)
  print(motors)   #  ['yamaha', 'suzuki'] 
  ```

  

----





## 其他

- 默认情况下，Python3 源码文件以 **UTF-8** 编码，所有字符串都是 unicode 字符串。
- isinstance 和 type 的区别在于：
  - type()不会认为子类是一种父类类型。
  - isinstance()会认为子类是一种父类类型
  - **type(obj)**：返回对象 `obj` 的确切类型（即创建该对象的类）。
    例如：`type(5)` 返回 `<class 'int'>`，`type([])` 返回 `<class 'list'>`。
  - **isinstance(obj, cls)**：判断对象 `obj` 是否是类 `cls`（或 `cls` 的子类）的实例，返回布尔值 `True` 或 `False`。
    例如：`isinstance(5, int)` 返回 `True`，`isinstance([], list)` 返回 `True`。
  - **type() 只判断 “精确类型”**：它不会考虑继承关系，仅检查对象的类型是否与目标类型完全一致。
  - **isinstance() 考虑 “继承关系”**：它会判断对象是否是目标类**或其子孙类**的实例。



----





**注意：***Python3 中，bool 是 int 的子类，True 和 False 可以和数字相加，* ***True==1、False==0*** *会返回* **True***，但可以通过* ***is*** *来判断类型。*



Python 还支持复数，复数由实数部分和虚数部分构成，可以用 **a + bj**，或者 **complex(a,b)** 表示， 复数的实部 **a** 和虚部 **b** 都是浮点型。



Python 使用反斜杠 转义特殊字符，如果你不想让反斜杠发生转义，可以在字符串前面添加一个 r，表示原始字符串：

```python
>>> print('Ru\noob')
Ru
oob
>>> print(r'Ru\noob')
Ru\noob
>>>
```

另外，反斜杠(\)可以作为续行符，表示下一行是上一行的延续。也可以使用 **"""..."""** 或者 **'''...'''** 跨越多行。
与 C 字符串不同的是，Python 字符串不能被改变。向一个索引位置赋值，比如 **word[0] = 'm'** 会导致错误。



- 1、反斜杠可以用来转义，使用r可以让反斜杠不发生转义。
- 2、字符串可以用+运算符连接在一起，用*运算符重复。
- 3、Python中的字符串有两种索引方式，从左往右以0开始，从右往左以-1开始。
- 4、Python中的字符串不能改变。



- 可以使用 `bool()` 函数将其他类型的值转换为布尔值。以下值在转换为布尔值时为 `False`：`None`、`False`、零 (`0`、`0.0`、`0j`)、空序列（如 `''`、`()`、`[]`）和空映射（如 `{}`）。其他所有值转换为布尔值时均为 `True`。



列表可以完成大多数集合类的数据结构实现。列表中元素的类型可以不相同，它支持数字，字符串甚至可以包含列表（所谓嵌套）。

和字符串一样，列表同样可以被索引和截取，列表被截取后返回一个包含所需元素的新列表。



与Python字符串不一样的是，列表中的元素是可以改变的：



- 1、列表写在方括号之间，元素用逗号隔开。 ['2',2.3,'avfd',['1']]
- 2、和字符串一样，列表可以被索引和切片。
- 3、列表可以使用 **+** 操作符进行拼接。(字符串一样的可以)
- 4、列表中的元素是可以改变的。
- 

- Pycharm中的保留字

| Ctrl + /            | 行注释                           |
| ------------------- | :------------------------------- |
| Ctrl + Shift + /    | 块注释                           |
| Ctrl + D            | 复制选定的区域或行到后面或下一行 |
| shift + alt + 上/下 | 将当前行代码同上下行代码交换     |

- IPO程序编写方法：

  ​	input Process output

  ​	输入数据->处理数据->输出数据

- 编译型语言(静态语言)：java

- 解释型语言(脚本语言)：python