#include <iostream>
#include <math.h>


// Kernal function
// add elements in x and y and sets the result in y
// n is the number of elements in array
__global__
void add(int n, float* x, float* y){
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;
    for(int i = index; i < n; i+=stride){
        y[i] = x[i] + y[i];
    }
}


int main(void){

    int N = 1<<20; // 1M elements aprox
    // memory allocation in cuda
    float* x;
    float* y;
    cudaMallocManaged(&x,N*sizeof(float));
    cudaMallocManaged(&y,N*sizeof(float));

    // init x and y
    for (int i = 0; i < N; i++){
        x[i] = 1.0f;
        y[i] = 2.0f;
    }
    
    //  move to GPU
    cudaMemPrefetchAsync(x, N*sizeof(float), 0, 0);
    cudaMemPrefetchAsync(y, N*sizeof(float), 0, 0);

    // run the kernal on 1M elemetns on the GPU on 1024 threads
    int blockSize = 1024;
    int numBlocks = (N + blockSize -1) / blockSize; // cealing division trick blocks cancel out but help with cealing
    add<<<numBlocks,blockSize>>>(N,x,y);

    // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    // check for errors all values should be 3.0f
    float maxError = 0.0f;

    for(int i = 0; i < N; i++){
        maxError = fmax(maxError,fabs(y[i]-3.0f));
        
    }
    std::cout << "Max error: " << maxError << std::endl;
    // Free memory
    cudaFree(x);
    cudaFree(y);
    


    
    return 0;
}