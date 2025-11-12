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