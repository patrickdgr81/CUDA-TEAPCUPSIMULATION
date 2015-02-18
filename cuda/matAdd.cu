// Simple CUDA example
 
#include <stdio.h>
 
const int N = 16; 
 
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

// Kernel definition Matrix Add
__global__ void MatAdd(float *A, float *B, float *C, int N)
{
 int i = threadIdx.x;
 int j = threadIdx.y;
 if (i < N && j < N)
 {
	 C[i*N+j] = A[i*N+j] + B[i*N+j];
 }
}

void printMat(float *a, int N, const char* name)
{
	printf("%s\n",name);
 	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < N; ++j)
		{
			printf("%.2f\t", a[i*N+j]);
		}
		printf("\n");
	}
}
 
int main()
{
//	float a[N][N], b[N][N], c[N][N];
	float *a, *b, *c;

	a = (float *)malloc(N*N*sizeof(float));
	b = (float *)malloc(N*N*sizeof(float));
	c = (float *)malloc(N*N*sizeof(float));

	// Initial values
	for (int i = 0; i < N; ++i)
	{
		for (int j = 0; j < N; ++j)
		{
			a[i*N+j] = 0.1f*i*j;
			b[i*N+j] = 0.1f*(i+j*N);
		}
	}
 
 // NxN now
 float *ad, *bd, *cd;
 const int size = N*N*sizeof(float);
 
 // print a, b, c before
 	printMat(a,N,"a");
 	printMat(b,N, "b");
 	printMat(c,N, "c before");
 
 cudaMalloc( (void**)&ad, size ); 
 cudaMalloc( (void**)&bd, size ); 
 cudaMalloc( (void**)&cd, size ); 
 cudaMemcpy( ad, a, size, cudaMemcpyHostToDevice ); 
 cudaMemcpy( bd, b, size, cudaMemcpyHostToDevice ); 
 
 // NxN block now
 dim3 dimBlock( N, N );
 dim3 dimGrid( 1, 1 );
 MatAdd<<<dimGrid, dimBlock>>>(ad, bd, cd, N);
 cudaMemcpy( c, cd, size, cudaMemcpyDeviceToHost ); 
 cudaFree( ad );
 cudaFree( bd );
 cudaFree( cd );
 
 // print results
 	printMat(a,N, "a");
 	printMat(b,N, "b");
 	printMat(c,N, "c after");

 return EXIT_SUCCESS;
}

