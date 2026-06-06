```python
# 方式1：用方括号 []（如果键不存在会报错）
info = {'name': '班长', 'id': 100}
print(info['name'])      # 输出: 班长（存在，正常）
print(info['age'])       # 报错！KeyError: 'age'

# 方式2：用 get()（如果键不存在返回 None 或默认值）
print(info.get('name'))  # 输出: 班长
print(info.get('age'))   # 输出: None（不报错）
print(info.get('age', 0)) # 输出: 0（指定默认值）
```

