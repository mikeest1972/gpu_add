import torch
import time

N = 1 << 20  # 1M elements

# Allocate on GPU directly
x = torch.ones(N, dtype=torch.float32, device='cuda')
y = torch.full((N,), 2.0, dtype=torch.float32, device='cuda')

# Warmup (important! first run includes CUDA context init overhead)
for _ in range(10):
    y = x + y

torch.cuda.synchronize()

# Benchmark
iterations = 1000
start = time.perf_counter()
for _ in range(iterations):
    y = x + y
torch.cuda.synchronize()  # wait for GPU before stopping timer
elapsed = (time.perf_counter() - start) / iterations

gflops = (N / elapsed) / 1e9
print(f"Time: {elapsed*1000:.4f} ms")
print(f"GFLOPS: {gflops:.2f}")