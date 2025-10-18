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


### 3.2 列表排序

- 使用 sort() 方法对列表进行永久性排序

  ```Python
  cars = ['bmw','audi','toyota','subaru']
  cars.sort()   #  对cars列表按字母进行永久性排序(升序)
  print(cars)   #  ['audi', 'bmw', 'subaru', 'toyota']
  cars.sort(reverse=True)   #  对cars列表按字母进行永久性排序(升序)
  print(cars)   #  ['toyota', 'subaru', 'bmw', 'audi']
  ```

- 使用 sorted() 函数对列表进行临时性排序

  ```Python
  cars = ['bmw','audi','toyota','subaru']
  print(sorted(cars))   #  ['audi', 'bmw', 'subaru', 'toyota']   使用 sorted() 函数后，列表本来的顺序并没有改变
  print(sorted(cars,reverse=True))   #  ['toyota', 'subaru', 'bmw', 'audi']
  print(cars)   #  ['audi', 'bmw', 'subaru', 'toyota']
  ```

- 接收一个 使用 sorted() 函数对列表进行临时性排序后的列表

  ```
  cars = ['bmw','audi','toyota','subaru']
  sorted_cars = sorted(cars)
  print(sorted_cars)   #  ['audi', 'bmw', 'subaru', 'toyota']
  ```

- 使用方法 reverse() 永久性反转列表的顺序

  ```Python
  cars = ['bmw','audi','toyota','subaru']
  cars.reverse()
  print(cars)  #  ['subaru', 'toyota', 'audi', 'bmw']
  ```

- 使用 len() 函数确定列表的长度

  ```Python
  cars = ['bmw','audi','toyota','subaru']
  car_num = len(cars)
  print(car_num)   #  4
  ```

### 3.3 操作列表

- 使用 for 循环打印列表元素

  ```Python
  cars = ['bmw','audi','toyota','subaru']
  for car in cars:
  	print(car)
  ```

- for循环中，靠的是缩进来区分内部或外部的语句

  ```Python
  cars = ['bmw','audi','toyota','subaru']
  for car in cars:
  	print("I have a car: " + car)
  	print("That's beautiful!\n")
  ```

  在for循环后，没有缩进的代码都只执行一次

### 3.4 数字列表

- 使用 range 函数创建一系列数字

  ```Python
  for value in range(1,5):  #  是左闭右开区间
  	print(value)  # 1 2 3 4
  ```

- 使用 list() 函数将 range() 的结果直接转换成列表

  ```Python
  numbers = list(range(1,6)) 
  print(numbers)  #  [1, 2, 3, 4, 5]
  ```

- 使用 range() 函数指定步长

  ```Python
  numbers = list(range(1,12,2))  # 从 1 开始，以 2 为步长，不断增加到 12
  print(numbers)  #  [1, 3, 5, 7, 9, 11]
  ```

- 将1~10的平方放在一个列表中

  ```Python
  squares = []
  for value in range(1,11):
  	squares.append(value**2)
  print(squares)  #  [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]
  ```

- 对数字列表进行简单的统计计算

  ```Python
  digits = [1,2,3,4,5,6,7,8,9,0]
  min(digits)  # 0
  max(digits)  # 9
  sum(digits)  # 45
  ```

- 列表解析：

  ```Python
  squares = [value**2 for value in range(1,11)]
   1. squares是列表名
   2. value**2 是表达式
   3. 最后是循环语句，用于给表达式提供值
      
  等价于上边的平方列表
  ```

### 3.5 使用列表的一部分

- 切片

  ```Python
  players = ['charles','martina','michael','florence','eli']
  print(players[0:3])  # ['charles', 'martina', 'michael']  打印列表的一部分（一个切片）
  print(players[:2]) # 没有指定第一个索引，将自动从列表头开始    ['charles', 'martina']
  print(players[2:]) # 没有治党第二个索引，将自动提取到列表末尾  ['michael', 'florence', 'eli']
  ```

- 输出名单最后三名队员

  ```Python
  players = ['charles','martina','michael','florence','eli']
  print(players[-3:])  #  ['michael', 'florence', 'eli']
  
  ```

- 遍历切片

  ```Python
  players = ['charles','martina','michael','florence','eli']
  for player in players[:3]:
      print(player.title())   #  遍历前三名队员
  ```

- 复制列表

  ```Python
  foods = ['pizza','falafel','carrot cake']
  new_foods = foods[:]  # 同时省略起始索引和终止索引来创建一个包含整个列表的切片
  
  foods 和 new_foods 的内容相同，但是地址不同，对 new_foods 中的元素进行修改不会影响原来的 foods 中的元素
  
  new_foods = foods  # 这种方式会使 new_foods 关联到 foods 包含的列表，对其中任意一个的修改都会影响对方
  ```

## 第四章 元组

- 列表是可以被修改的，元组的值是不能被修改的

- Python 将不能修改的值称为不可变的，而不可变的 列表 被称为元组

- 定义一个元组：

  ```python
  dimensions = (100, 200)
  print(dimensions[0])   # 像访问列表元素一样访问元组元素
  print(dimensions[1])
  
  dimensions[0] = 20   # 会报错，Python 不运行修改元组元素
  ```

- 遍历元组：

  ```python
  dimensions = (100, 200)
  for dim in dimensions:
      print(dim)
  ```

- 修改元组变量的值

  ```python
  dimensions = (100, 200)
  dimensions = (200, 400)   # 定义了一个新的元组存储到dimensions中，因为给元组变量赋值是可以的
  ```

## 第五章 条件语句

- `if` 语句

  ```python
  cars = ['audi','bmw','subaru','toyota']
  for car in cars:
      if car == 'bmw':   #  == 运算符，值相等时返回True,否则返回False
          print(car.upper())
      elif car == 'subaru':
          print(car.lower())
      else:
          print(car.title())
  
  age = 12
  if age < 4:
      price = 0
  elif age < 18:
      price = 10
  else:
      price = 20 
  print("The price is " , price)  # price 看似是局部变量，但是对python来说都可以使用
  ```

- 条件语句中可以包含各种数学比较： > , < , >= , <= , == , !=

- 使用 `and` 检查多个条件

  ```Python
  my_age = 23
  his_age = 27
  if my_age <= 24 and his_age >=26:  # 可以添加括号 if (my_age <= 24) and (his_age >=26):
  	print('haha')
  ```

- 使用 `or` 检查多个条件

  ```Python
  my_age = 15
  his_age = 27
  if my_age <= 10 or his_age >=26:  # 可以添加括号 if (my_age <= 10) or (his_age >=26):
  	print('haha')
  ```

- 使用 `in` 关键字检查特定值是否包含在列表中

  ```Python
  cars = ['audi','bmw','subaru','toyota']
  if 'bmw' in cars:
      print("yes!")
  else:
      print("No!")
  ```

- 使用关键字 `not in` 检查特定值是否不包含在列表中

  ```Python
  cars = ['audi','bmw','subaru','toyota']
  if 'kasa' not in cars:
      print("yes!")
  else:
      print("No!")
  ```

## 第六章 字典

### 6.1 字典的基本操作

- 字典是一系列 键—值 对，每一个键都与一个值关联，值可以是数字，字符串，甚至是列表或字典，可以把任何python对象都作为字典中的值

  ```Python
  alien = {'color':'green','points':5}
  ```

  键和值之间用 ：分隔，而不同的键值对之间用 ，分隔 ，字典中可以包含任意数量的键值对

- 访问字典中的值

  ```Python
  alien = {'color':'green'}
  print(alien['color'])   #  green
  ```

  ```Python
  alien = {'color':'green','points':5}
  
  new_points = alien['points']
  print("You just earned " + str(new_points) + "points!")
  ```

- 添加 键—值 对

  ```Python
  alien = {'color':'green','points':5}
  
  alien['x_position'] = 0  # 添加新的键值对  x_position:0
  alien['y_position'] = 25 # 添加新的键值对  y_position:25
  print(alien)  # {'color': 'green', 'points': 5, 'x_position': 0, 'y_position': 25}
  ```

- python 不关心键值对的添加顺序，只关心键和值之间的练习，因此同一个字典中的键值对之间不存在先后顺序之说

- 创建一个空字典，并添加键值对

  ```Python
  alien = {}
  alien['color'] = 'green'
  alien['points'] = 5
  ```

- 修改字典中的值

  ```Python
  alien = {'color':'green','points':5}
  alien['color'] = 'blue'
  print(alien['color'])
  
  alien = {'x_position':0, 'y_position':25, 'speed':'medium'}
  if alien['speed'] == 'slow':
      x_increment = 1
  elif alien['speed'] == 'medium':
      x_increment = 2
  else:
      x_increment = 3
  alien['x_position'] = alien['x_position'] + x_increment
  print("New x_position: " + str(alien['x_position']))  # New x_position: 2
  ```

- 使用 del 语句删除键值对

  ```Python
  alien = {'color':'green','points':5}
  del alien['points']
  print(alien) # {'color': 'green'}
  ```

- 由类似对象组成的字典

  ```Python
  favorite_languages = {
  	'jen':'python',
      'sara':'C',
      'wdwa':'java',
      'alice':'python',  # 最后一个键值对后边的逗号可以有也可以没有
  }
  ```

### 6.2 字典的遍历

- 遍历字典的键和值

  ```Python
  favorite_nums = {
      'Bob': 5,
      'Alan':32,
      'kasy':56,
  }
  
  for name,num in favorite_nums.items():
      print(name + "'s favorite num is " + str(num))
      
  Bob's favorite num is 5
  Alan's favorite num is 32
  kasy's favorite num is 56
  ```

- 遍历字典的所有键

  ```Python
  favorite_languages = {
  	'jen':'python',
      'sara':'C',
      'wdwa':'java',
      'alice':'python',  
  }
  
  for name in favorite_languages.keys():   #  因为遍历字典会默认比哪里其所有的键，因此，使用for name in favorite_languages: 也可以
      print(name.title())
  ```

- 按顺序遍历字典中的所有键(对键进行排序)

  ```Python
  favorite_languages = {
      'jen': 'python',
      'bon': 'C',
      'kasy': 'pyhton',
      'sda': 'C++',
  }
  
  for name in sorted(favorite_languages.keys()):
      print(name.title() + ", thank you for taking the poll.")
  ```

- 遍历字典的所有值

  ```Python
  favorite_languages = {
      'jen': 'python',
      'bon': 'C',
      'kasy': 'java',
      'sda': 'C++',
  }
  
  for language in favorite_languages.values():
      print(language.title())
  ```

- 为了避免出现重复的值，可以用 集合，集合中的每个元素都是独一无二的

  ```Python
  favorite_languages = {
      'jen': 'Python',
      'bon': 'C',
      'kasy': 'Python',
      'sda': 'C++',
  }
  
  for language in set(favorite_languages.values()):  # 通过对包含重复元素的列表带调用set(),可以让python找出其中独一无二的元素
      print(language.title())
  ```

## 第七章 嵌套

### 7.1 字典列表

- 创建一个所有元素均为字典的列表

  ```Python
  alien_0 = {'color': 'green', 'points': 5}
  alien_1 = {'color': 'yellow', 'points': 10}
  alien_2 = {'color': 'red', 'points': 15}
  
  aliens = [alien_0, alien_1, alien_2]
  for alien in aliens:
      print(alien)
  ```

  ```Python
  # 创建一个用于存储外星人的空列表
  aliens = []
  
  # 创建30个绿色的外星人
  for alien_number in range(30):
      new_alien = {'color': 'green','points':5, 'speed':'slow'}
      aliens.append(new_alien)
      
  # 显示前五个外星人
  for alien in aliens[:5]:
      print(alien)
  
  # 显示创建了多少个外星人
  print("Total number: " + str(len(aliens)))
  ```

  ```Python
  # 创建一个用于存储外星人的空列表
  aliens = []
  
  # 创建30个绿色的外星人
  for alien_number in range(30):
      new_alien = {'color': 'green','points':5, 'speed':'slow'}
      aliens.append(new_alien)
  
  for alien in aliens[:3]:
      if alien['color'] == 'green':
          alien['color'] = 'red'
          alien['points'] = 10
          alien['speed'] = 'medium'
      
  # 显示前五个外星人
  for alien in aliens[:5]:
      print(alien)
  ```

### 7.2 列表字典

- 包含列表元素的字典

  ```Python
  # 存储点的pizza的信息
  pizza = {
      'crust':'thick',
      'toppings':['mushrooms','extra cheese'],
  }
  
  #  概述信息
  print("You ordeered  a" + pizza['crust'] + "-crust pizza"+
       " with the following topppings: ")
  for topping in pizza['toppings']:
      print('\t ' + topping)
  ```

  每当需要在字典中将一个键关联到多个值时，就可以在字典中嵌入一个列表

  ```Python
  favorite_languages = {
      'jen': ['python','ruby'],
      'sarah':['c'],
      'edward':['ruby','go'],
      'phil':['pyhotn','hashkell'],
  }
  
  for name,languages in favorite_languages.items():
      print("\n" + name.title() + "'s favorite languages are:")
      for language in languages:
          print("\t" + language.title())
  ```

### 7.3 存储字典的字典

- 在字典中存储字典，可以存储更复杂的信息

  ```Python
  users = {
      'endis': {
          'first': 'albert',
          'last': 'ensid',
          'location':'princeton'
      },
      'John':{
          'first':'marie',
          'last':'curie',
          'location':'Beijing'
      }
  }
  
  for username , user_info in users.items():
      print("UserName: " + username)
      fullName = user_info['first'] + " " + user_info['last']
      location = user_info['location']
      print('\t FullName: ' + fullName)
      print("\tLocation: " + location)
  ```

  尽量保证字典内每个字典的结构都相同，这样循环遍历起来更容易



## 第八章 输入输出

### 8.1 输入

- input的工作原理：

  ```Python
  name = input("please input your name:")   # input里的参数是提示输入的内容
  print("Hello, " + name + "!")
  ```

- 如果提示内容太长，可以存在一个变量里：

  ```Python
  prompt = "If you tell us who you are, \  
  	\n I will tell you how to do!"
  name = input(prompt)
  print("Hello, " + name + "!")
  ```

  ```Python
  prompt = "If you tell us who you are"
  prompt += "\nTell me your name: "
  name = input(prompt)
  print("Hello, " + name + "!")
  ```

- 使用 int() 来获取数值型输入

  ```Python
  age = int(input("Please tell me your age: "))
  print(age >= 18)
  ```



### 8.2 输出

- 完整格式

  ```python
  print(*objects, sep=' ', end='\n', file=sys.stdout)
  ```

  参数的具体含义如下：

  objects --表示输出的对象。输出多个对象时，需要用 , （逗号）分隔。

  sep -- 用来间隔多个对象，以sep指定的内容作为分隔符

  end -- 用来设定以什么结尾。默认值是换行符 \n，我们可以换成其他字符。

  file -- 要写入的文件对象。

- 其他用法
  - 使用连接符连接两个字符串(只能是字符串和字符串之间连接，整数和字符串不能做连接)

    ```python
    print('a'+'b')
    ```

  - 如果想要同时输出字符串和整数，用逗号分隔即可

    ```python
    print('a',2)
    ```

    ```python
    print(a + b, a, b)
    print(chr(65), chr(97)) # 使用 chr 函数可以得到 对应的ASCII字符
    print(ord('北'))  # 使用 ord 函数可以得到字符对应的ASCII值
    print(ord('京'))
    ```



## 第九章 While循环

- 让用户选择何时退出

  ```Python
  prompt = "Tel me something, and I will repeat it back to you \n"
  prompt += "(Enter 'quit' to end the program.) : "
  message = ""
  while message != 'quit':
      message = input(prompt)
      if message != 'quit':
      	print(message)
  ```

- 使用标志：定义一个变量，判断整个程序是否处于活动状态，这个变量称为标志

  ```Python
  prompt = "Tel me something, and I will repeat it back to you \n"
  prompt += "(Enter 'quit' to end the program.) : "
  active = True  # active 就是程序状态的标志
  while active:
      message = input(prompt)
      if message == 'quit':
          active = False
      else:
          print(message)
  ```

- 使用break退出循环

  ```Python
  prompt = "Tel me something, and I will repeat it back to you \n"
  prompt += "(Enter 'quit' to end the program.) : "
  
  while True:
      message = input(prompt)
      if message == 'quit':
          break
      else:
          print(message)
  ```

  任何python的循环都可以使用break语句跳出循环。如：可以使用break语句跳出遍历列表或字典的for循环

- 在循环中使用continue

  ```Python
  # 实现打印 1-10内的奇数
  
  current_num = 0
  while current_num < 10:
      current_num += 1
      if current_num % 2 == 0:
          continue
      else:
          print(current_num)
  ```

- 使用 while 循环来处理列表和字典

  ```Python
  # 在列表之间移动元素
  unconfirmed_users = ['alice', 'brain', 'wow']
  confirmed_users = []
  
  while unconfirmed_users:
  	current_user = unconfirmed_users.pop()
      print("Verifying user: " + current_user.title())
      confirmed_users.append(current_user)
  print("\nThe following users are confirmed: ")
  for user in confirmed_users:
      print(user.title())
  ```

- 删除包含特定值的所有列表元素

  ```Python
  pets = ['cat','dog','goldfish','cat','dog','rabbit','cat']
  print(pets)
  
  while 'cat' in pets:
  	pets.remove('cat')
  
  print(pets)
  ```

- 使用用户输入来填充字典

  ```Python
  responses = {}
  
  active = True
  while active:
      name = input("please input your name: ")
      response = input("Please input your advice: ")
      responses[name] = response
      repeat = input("Would you like to let another person respond?(yes/no): ")
      if repeat == 'NO' or repeat == "no" or repeat == 'No':
          active = False
  
  print("Polling results: ")
  for name, response in responses.items():
      print(name + ": " + response + "\n")
  ```

  

## 第10章 函数

- 定义函数--> 原则：每个函数都应只负责一项具体的工作

  ```Python
  def greet_user(username):
      print("Hello, " + str(username).title())
  greet_user("John")
  ```

- 函数应该包含注释，其注释应该紧跟在函数定义后边，并使用文档字符串的形式注释

- 多个函数之间用两个空行分开

- 实参--位置实参（实参的顺序必须和形参的顺序完全相同）

  ```Python
  def describe_pet(animal_type, pet_name):
      print("I have a " + animal_type + ".")
      print("My " + animal_type + "'s name is " + pet_name.title() + '.' )
  
  describe_pet('dog', 'John')
  ```

- 实参--关键字实参(传递给函数的名称-值对)

  ```Python
  def describe_pet(animal_type, pet_name):
      print("I have a " + animal_type + ".")
      print("My " + animal_type + "'s name is " + pet_name.title() + '.' )
  
  describe_pet(animal_type = 'dog', pet_name =  'John')
  describe_pet(pet_name =  'John', animal_type = 'dog')   # 两种方式输出一样
  ```

  此时不用考虑参数的顺序，但是必须准确的指定函数定义中形参的名字

- 默认值（可以在编写函数时，给每个参数一个默认值，）

  ```Python
  def describe_pet(pet_name, animal_type='dog'):  # 注意参数的顺序发生了改变，pet_name位置处传入的参数时位置参数
      print("I have a " + animal_type + ".")
      print("My " + animal_type + "'s name is " + pet_name.title() + '.' )
  describe_pet("john")
  ```

  使用默认值时，把给定了默认值的参数放在后边，把那些没有给默认值的形参放在前边：

  ```Python
  def describe_pet(animal_type='dog',pet_name):   # 会报错 SyntaxError: non-default argument follows default argument
      print("I have a " + animal_type + ".")
      print("My " + animal_type + "'s name is " + pet_name.title() + '.' )
  describe_pet("john")
  ```

- 等效的函数调用

  ```Python
  def describe_pet(pet_name, animal_type='dog'):
      print("I have a " + animal_type + ".")
      print("My " + animal_type + "'s name is " + pet_name.title() + '.' )
  
  # 一只名为wille的小狗
  describe_pet('wille')
  describe_pet(pet_name = 'wille')
  
  # 一只名为harry的仓鼠
  describe_pet('harry','hamster')
  describe_pet(pet_name = 'harry', animal_type = 'hamster')
  describe_pet(animal_type = 'hamster', pet_name = 'harry')
  describe_pet(pet_name = 'harry', 'hamster') # 不能这样写，要么全部写成位置参数，要么全部写成关键词参数
  ```

- 返回值（使用return语句）

  ```Python
  def get_fullname(first_name, last_name):
      fullname = first_name.title() + " " + last_name.title()
      return fullname
  musician = get_fullname("john",'Alan')
  print(musician)
  ```

- 让实参变成可选的

  ```Python
  def get_fullname(first_name, last_name, middle_name=''):  # 中间名是可选的，应该在最后列出该形参，并将其值设置为空字符串
      if middle_name:   
          fullname = first_name + ' ' + middle_name + ' ' + last_name  # 这样没有中间名字时，也能合理的显示
      else:
          fullname = first_name + ' '  + last_name
      return fullname.title()
  
  musician = get_fullname('jimi','hendrix')
  print(musician)
  musician = get_fullname('jimi','hendrix','Lee')
  print(musician)
  ```

- 返回字典

  ```Python
  def build_person(first_name,last_name,age=''):
      person = {'first_name':first_name, 'last_name':last_name}
      if age:
          person['age'] = age
      return person
  
  musician = build_person('jimi', 'hendrix',age=27)
  print(musician)
  ```

- 综合训练

  ```Python
  def get_fullname(first_name, last_name):
      fullname = first_name + " " + last_name
      return fullname.title()
  
  while True:
      print("\nTell me your name（input 'q' to edn program.）: ")
      f_name = input("\tfirst name:")
      if f_name == 'q' or f_name == 'Q':
          break
      l_name = input("\tlast name: ")
      if l_name == 'q' or l_name == 'Q':
          break
      full_name = get_fullname(f_name,l_name)
      print("Hello, " + full_name)
  ```

- 传递列表

  ```Python
  def greet_users(names):
      for name in names:
          print("hello, " + name.title() + '.')
  usernames = ['John','ALan','Alice']
  greet_users(usernames)
  ```

- 在函数中修改传递的列表

  ```Python
  def print_models(unprinted_designs, completed_designs):
      while unprinted_designs:
          current_design = unprinted_designs.pop()
          print("Printing model: " + current_design + " ...")
          completed_designs.append(current_design)
  
  def show_completed_models(completed_designs):
      print("\nThe following modesl have benn printed:")
      for design in completed_designs:
          print(design)
          
  unprint_designs = ['iphone case', 'robot pendant', 'dodecahdrom']
  completed_models = []
  print_models(unprint_designs,completed_models)
  show_completed_models(completed_models)
  ```

- 静止函数修改列表-->向函数传递列表的副本而不是原件

  ```Python
  function_name(list_name[:]) # 使用切片表示法[:]创建列表的副本
  ```

  ```Python
  def print_models(unprinted_designs, completed_designs):
      while unprinted_designs:
          current_design = unprinted_designs.pop()
          print("Printing model: " + current_design + " ...")
          completed_designs.append(current_design)
  
  def show_completed_models(completed_designs):
      print("\nThe following modesl have benn printed:")
      for design in completed_designs:
          print(design)
          
  unprint_designs = ['iphone case', 'robot pendant', 'dodecahdrom']
  completed_models = []
  print_models(unprint_designs[:],completed_models)  # 使用切片表示法创建副本，原来的列表能够继续存在
  show_completed_models(completed_models)
  print("======")
  show_completed_models(unprint_designs)
  ```

- 传递任意数量的实参（使用 * 创建空元组）

  ```Python
  def make_pizza(*toppings):  # 创建了一个名为toppings的空元组
      print(toppings)
  make_pizza('pepper')   # ('pepper',)
  make_pizza('pepper','green pepp','dogds')  # ('pepper', 'green pepp', 'dogds')   
  ```

  使用这种方法，无论传入多少个实参，都是按照元组对待，可以使用遍历的方法：

  ```Python
  def make_pizza(*toppings):  # 创建了一个名为toppings的空元组
      print("The toppings are following: ")
      for topping in toppings:
          print(topping)
  make_pizza('pepper','green pepp','dogds')
  ```

- 结合使用位置实参和任意数量实参

  如果同时有位置实参和任意数量参数，必须把任意数量实参的形参放在最后，Python会先匹配位置实参和关键字实参，再将剩下的实参都放在最后一个形参中

  ```Python
  def make_pizza(size,*toppings):
      print("Making a "+ str(size) + "-size pizza.")
      print("The toppings are following: ")
      for topping in toppings:
          print("\t-"+ topping)
  make_pizza(12,'pieer')
  make_pizza(16,'asds','sada','pospdo')
  ```

- 使用任意数量的关键字实参（使用 ** 创建空字典）

  ```Python
  def build_person(first,last, **user_info):  # 告诉Python创建一个名为  user_info的空字典
      person = {}
      person['first_name']= first
      person['last_name'] = last
      for key,value in user_info.items():
          person[key] = value
      return person
  
  user_profile = build_person('alberit','ensten',
                             location='princeton',   # 注意写法，这里的 键 不用加引号
                             field='Computer Science')
  print(user_profile) # {'first_name': 'alberit', 'last_name': 'ensten', 'location': 'princeton', 'field': 'Computer Science'}
  ```

- 将函数存储在模块中

  模块是一个单独存放函数的文件，可以隐藏程序代码的细节，模块的扩展名为.py。使用import语句将模块导入主程序中

  ```Python
  # pizza.py
  def make_pizza(size,*toppings):
      print("Making a "+ str(size) + "-size pizza.")
      print("The toppings are following: ")
      for topping in toppings:
          print("\t-"+ topping)
  ```

  ```Python
  import pizza   # 导入后，可以使用pizza.py中的所有函数
  
  pizza.make_pizza(12,'pieer')  # 使用 模块名.函数名()的方法调用模块中的任意一个函数
  pizza.make_pizza(16,'asds','sada','pospdo')
  ```

  python导入模块时，是将模块中的代码整个的复制到当前的程序中

- 导入特定的函数，使用逗号分隔函数名

  ```Python
  from moudle_name import function_name
  from moudle_name import function1_name,function2_name,function3_name
  ```

  ```Python
  from pizza import make_pizza
  make_pizza(12,'pieer')  # 使用导入特定函数的方法，就不用再使用句点的方式，因为显示的导入了make_pizza函数，所以可以直接使用其名称
  make_pizza(16,'asds','sada','pospdo')
  ```

- 使用 as 给函数起别名

  ```Python
  from pizza import make_pizza as mp
  
  mp(12,'pieer')
  mp(16,'asds','sada','pospdo')
  ```

- 使用 as 给模块起别名

  ```Python
  import pizza as p
  
  p.make_pizza(12,'pieer')  
  p.make_pizza(16,'asds','sada','pospdo')
  ```

- 使用 * 导入模块中的所有函数（尽量少用，因为可能不同的模块中有名字相同的函数）

  ```Python
  from pizza import *
  make_pizza(12,'pieer')  # 由于导入了所有函数，也不用再使用句点的方式，可以直接使用其名称
  make_pizza(16,'asds','sada','pospdo')
  ```

  python在遇到多个名字相同的变量或函数时，会覆盖，而不是分别导入不同的函数

## 







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