// Simple CUDA example
 
#include <stdio.h>
 
const int N = 16; 
const int blocksize = 16; 
 
__global__ void hello(char *a, int *b) 
{
	a[threadIdx.x] += b[threadIdx.x];
}

// Kernel definition Vector Add
__global__ void VecAdd(float* A, float* B, float* C)
{
 int i = threadIdx.x;
 C[i] = A[i] + B[i];
}
 
int main()
{
	float a[N], b[N], c[N];

	// Initial values
	for (int i = 0; i < N; ++i)
	{
		a[i] = 0.1f*i*i;
		b[i] = 0.1f*i;
	}
 
 float *ad, *bd, *cd;
 const int size = N*sizeof(float);
 
 // print a, b, c before
	printf("a\tb\tc\n");
 	for (int i = 0; i < N; ++i)
	{
		printf("%.2f\t%.2f\t%.2f\n", a[i], b[i], c[i]);
	}
 
 cudaMalloc( (void**)&ad, size ); 
 cudaMalloc( (void**)&bd, size ); 
 cudaMalloc( (void**)&cd, size ); 
 cudaMemcpy( ad, a, size, cudaMemcpyHostToDevice ); 
 cudaMemcpy( bd, b, size, cudaMemcpyHostToDevice ); 
 
 dim3 dimBlock( blocksize, 1 );
 dim3 dimGrid( 1, 1 );
 VecAdd<<<dimGrid, dimBlock>>>(ad, bd, cd);
 cudaMemcpy( c, cd, size, cudaMemcpyDeviceToHost ); 
 cudaFree( ad );
 cudaFree( bd );
 cudaFree( cd );
 
 // print results
	printf("a\tb\tc\n");
 	for (int i = 0; i < N; ++i)
	{
		printf("%.2f\t%.2f\t%.2f\n", a[i], b[i], c[i]);
	}

 return EXIT_SUCCESS;
}

