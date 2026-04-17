
#include <iostream>
#include <chrono>
#include <cstdlib>


#define N 1024



// A*B=C
__global__
void matmul(const float*A, const float*B, float* C, int n){
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if(row < n && col < n){
        float sum = 0.0f;
        for(int k = 0; k<n; k++){
            sum += A[row * n + k] * B[k*n + col];
        }
        C[row*n + col] = sum;
    }
}


int main(){
    // host memory
    size_t size = N*N*sizeof(float);
    float* A = new float[N*N];
    float* B = new float[N*N];
    float* C = new float[N*N]();

    srand(42);
    for(int i = 0; i < N*N; i++){
        A[i] = (float)rand()/RAND_MAX;
        B[i] = (float)rand()/RAND_MAX;
        
    }

    // device memory
    float *dA, *dB, *dC;
    cudaMalloc(&dA, size);
    cudaMalloc(&dB, size);
    cudaMalloc(&dC, size);

    cudaMemcpy(dA, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(dB, B, size, cudaMemcpyHostToDevice);

    dim3 blockDim(16, 16);      // 256 threads per block
    dim3 gridDim((N + 15) / 16, (N + 15) / 16);

   

    matmul<<<gridDim,blockDim>>>(dA,dB,dC,N);
    cudaDeviceSynchronize();

    cudaMemcpy(C, dC, size, cudaMemcpyDeviceToHost);
    std::cout << "C[0][0] = " << C[0] << "\n";

    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);

    delete[] A;
    delete[] B;
    delete[] C;

    return 0;

}