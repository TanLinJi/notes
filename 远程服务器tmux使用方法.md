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




```python
import torch
import time
import os
import argparse

def keep_gpu_busy(utilization_target=20, tensor_size=20000):
    """
    Keeps the GPU busy to maintain a certain utilization level.

    Args:
        utilization_target (int): The target GPU utilization in percent.
        tensor_size (int): The size of the tensors to use for computation.
                           Adjust this to fine-tune the GPU load.
    """
    if not torch.cuda.is_available():
        print("CUDA is not available. Exiting.")
        return

    device = torch.device("cuda:0")
    print(f"Using device: {torch.cuda.get_device_name(device)}")
    print(f"Target GPU utilization: {utilization_target}%")
    print(f"Tensor size: {tensor_size}x{tensor_size}")

    try:
        a = torch.randn(tensor_size, tensor_size, device=device)
        b = torch.randn(tensor_size, tensor_size, device=device)
    except torch.cuda.OutOfMemoryError:
        print(f"Error: GPU out of memory with tensor size {tensor_size}.")
        print("Try reducing the tensor size using the --tensor-size argument.")
        return


    print("Starting GPU workload...")
    while True:
        try:
            start_time = time.time()
            # Perform a heavy computation
            c = torch.matmul(a, b)
            torch.cuda.synchronize() # Wait for the operation to complete
            end_time = time.time()
            
            busy_time = end_time - start_time
            
            # We want to achieve utilization_target %.
            # Let T be the total cycle time.
            # busy_time / T = utilization_target / 100
            # T = busy_time * 100 / utilization_target
            # sleep_time = T - busy_time = busy_time * (100 / utilization_target - 1)
            
            if utilization_target > 0:
                sleep_time = busy_time * (100 / utilization_target - 1)
            else:
                sleep_time = 0 # Should not happen with default args

            print(f"Operation took {busy_time:.4f} seconds. Sleeping for {sleep_time:.4f} seconds.")
            
            if sleep_time > 0:
                time.sleep(sleep_time)

        except KeyboardInterrupt:
            print("Stopping GPU workload.")
            break
        except Exception as e:
            print(f"An error occurred: {e}")
            break

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Keep GPU busy.")
    parser.add_argument(
        "--utilization",
        type=int,
        default=20,
        help="Target GPU utilization in percent (e.g., 20 for 20%%).",
    )
    parser.add_argument(
        "--tensor-size",
        type=int,
        default=20000,
        help="Size of the tensors for matrix multiplication. Adjust to control load.",
    )
    args = parser.parse_args()

    keep_gpu_busy(utilization_target=args.utilization, tensor_size=args.tensor_size)
```

