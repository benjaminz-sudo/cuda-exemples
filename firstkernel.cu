#include <stdio.h>

#define CUDA_CHECK(call) \
    do { \
        cudaError_t err = (call); \
        if (err != cudaSuccess) { \
            printf("CUDA error at %s:%d — %s\n", __FILE__, __LINE__, cudaGetErrorString(err)); \
            return 1; \
        } \
    } while(0)

__global__ void add(int a, int b, int* c) {
    *c = a + b;
}

int main(void) {
    int x = 2, y = 7, z;
    int* dev_z;

    CUDA_CHECK(cudaMalloc((void**)&dev_z, sizeof(int)));
    add << <1, 1 >> > (x, y, dev_z);
    CUDA_CHECK(cudaGetLastError());      // catches kernel launch errors
    CUDA_CHECK(cudaDeviceSynchronize()); // catches kernel execution errors
    CUDA_CHECK(cudaMemcpy(&z, dev_z, sizeof(int), cudaMemcpyDeviceToHost));

    printf("%d + %d = %d\n", x, y, z);
    cudaFree(dev_z);
    return 0;
}