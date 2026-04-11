# GPU Add

The goal of this repository is to experiment/learn with CUDA and GPU parellization.

We will run comparisons with the GPU and CPU to ilustarte the performacne gain. Obvusly the GPU will be sevral times faster than CPU.

Using this guide [link](https://developer.nvidia.com/blog/even-easier-introduction-cuda/)

## Running the CPU program

1. run this script: `runCPU.sh`


## Experimetns

### Experiment 1 GPU

Ran the add kernal with this code: `add.cu` one thread on an RTX3060. 
Results:
![alt text](images/add_gpu_1.png)
Kernal ran for 99.726408M  nano sec

### Experiment 2 GPU

Will run with more threads by changing the `add<<<1,256>>>(N,x,y);` You can only increase it in multiple of 32 acording to nvidia. 

We will split the computation using `threadIdx` and `blockDim`
See `add2.cu`

Results:
![alt text](images/add_gpu_2.png)
Kernal ran for 2.7M  nano sec a 36x increase!


### Experiment 3 GPU

Lets try making out the number of threads we can use. To take it to the limist of the rtx3060

RTX-3060 has 3584 CUDA cores and runs on the Ampere architecture
Looked online for the whitepaper for the 3060 and couldn't find it I did finde the 3070 [link](https://www.nvidia.com/content/PDF/nvidia-ampere-ga-102-gpu-architecture-whitepaper-v2.pdf)

Based on thsi the RTX 3070 FE has 82 SMs the 3060 should probobly have something lower. I did finde out that the RTX 3060 uses GA106 [link](https://videocardz.com/newz/nvidia-launches-geforce-rtx-3060-with-12gb-memory-and-ga106-gpu) it uses 30 SMs but appernetly only 28 enabled. 

Will use 28 SMs


