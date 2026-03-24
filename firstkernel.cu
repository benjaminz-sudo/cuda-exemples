#include <stdio.h>

__global__ void add(int* a, int* b, int* c) { //avant était : (int a,int b,int *c)
	*c = *a + *b; // avant était : *c = a + b;
}
int main(void) {
	int x = 2, y = 7, z;
	int* dev_x, * dev_y, * dev_z;
	cudaMalloc((void**)&dev_x, sizeof(int));
	cudaMalloc((void**)&dev_y, sizeof(int));
	cudaMalloc((void**)&dev_z, sizeof(int));
	cudaMemcpy(dev_x, &x, sizeof(int), cudaMemcpyHostToDevice) ;
	cudaMemcpy(dev_y, &y, sizeof(int), cudaMemcpyHostToDevice) ;
	add << <1, 1 >> > (dev_x, dev_y, dev_z); //avant était : (x,y, dev_z)
	cudaMemcpy(&z, dev_z, sizeof(int), cudaMemcpyDeviceToHost) ;
	printf("%d + %d = %d\n", x, y, z);
	cudaFree(dev_x);
	cudaFree(dev_y);
	cudaFree(dev_z);
	return 0;
}