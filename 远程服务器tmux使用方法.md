1. 登录远程服务器后，创建一个 tmux 会话

   ```python
   tmux new -s train_session
   ```

2. 在 tmux 会话中运行命令
3. 断开连接但保持训练继续运行

当你需要关闭本地电脑或断开远程连接时，**不要直接关闭终端**，而是按以下快捷键让 tmux 会话在后台运行：

​	a. 先按 `Ctrl + b`（松开这两个键）

​	b. 再按 `d`（detach 的缩写）

执行后，会回到服务器的原始终端（非 tmux 会话），此时训练程序已经在 `train_session` 会话的后台继续运行了，即使断开 SSH 连接也不会终止。

4. 重新连接到训练会话（查看进度或操作）

   ```python
   tmux attach -t train_session
   ```


### **额外说明**

- 如果需要临时离开会话（但保持连接），再次按 `Ctrl + b + d` 即可后台挂起。
- 如果训练完成或需要终止程序，在 tmux 会话中按 `Ctrl + c` 即可终止命令，然后输入 `exit` 退出 tmux 会话。
- 若忘记会话名称，可通过 `tmux ls` 查看所有正在运行的会话（会显示会话名和状态）。

###  GPU_Busy 脚本

```python
python /root/autodl-tmp/keep_gpu_busy.py --utilization 20
```

脚本有两个参数可以调整：

- `--utilization`: 目标 GPU 利用率的百分比 (例如, `20` 代表 20%)。

- `--tensor-size`: 用于计算的张量大小。如果默认的设置不能达到期望的利用率，您可以尝试调整这个值。增加它会增加 GPU 的负载，减小它则会降低负载。例如：

  ```python
  # 尝试使用更大的张量
  nohup python /root/autodl-tmp/keep_gpu_busy.py --utilization 20 --tensor-size 25000 > /dev/null 2>&1 &
  ```

