#include <iostream>
#include <math.h>


// add elements in x and y and sets the result in y
// n is the number of elements in array
void add(int n, float* x, float* y){
    for(int i = 0; i < n; i++){
        y[i] = x[i] + y[i];
    }
}


int main(void){

    int N = 1<<20; // 1M elements aprox
    float* x = new float[N];
    float* y = new float[N];

    // init x and y
    for (int i = 0; i < N; i++){
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    // run the kernal on 1M elemetns on the CPU
    add(N,x,y);

    // check for errors all values should be 3.0f
    float maxError = 0.0f;

    for(int i = 0; i < N; i++){
        maxError = fmax(maxError,fabs(y[i]-3.0f));
        
    }
    std::cout << "Max error: " << maxError << std::endl;
    // Free memory
    delete []x;
    delete []y;


    
    return 0;
}