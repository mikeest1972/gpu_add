
#include <iostream>
#include <chrono>
#include <cstdlib>


#define N 1024



// A*B=C
void matmul(const float*A, const float*B, float* C, int n){
    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            float sum = 0.0f;
            for(int k = 0; k < n; k++){
                sum += A[i*n+k] * B[k*n+j];
            }
            C[i*n+j] = sum;
        }
    }
}


int main(){

    float* A = new float[N*N];
    float* B = new float[N*N];
    float* C = new float[N*N]();

    srand(42);
    for(int i = 0; i < N*N; i++){
        A[i] = (float)rand()/RAND_MAX;
        B[i] = (float)rand()/RAND_MAX;
        
    }
    auto start = std::chrono::high_resolution_clock::now();

    matmul(A,B,C,N);
    auto end = std::chrono::high_resolution_clock::now();
    double elapsed = std::chrono::duration<double, std::milli>(end - start).count();

    std::cout << "Matrix size: " << N << "x" << N << "\n";
    std::cout << "CPU time:    " << elapsed << " ms\n";
    std::cout << "C[0][0] =    " << C[0] << "\n";

    delete[] A;
    delete[] B;
    delete[] C;

    return 0;

}