# Moveable postProcessGL example

There are a few steps we have to take to make the samples from the
CUDA toolkit portable (able to sit in any directory).

1. Update the paths in the Makefile
   a. Add a line that says `CUDA_SAMPLE_PATH ?= /usr/local/cuda/samples`
   b. Find and replace `../..` with `$(CUDA_SAMPLE_PATH)`
2. Prevent the Makefile from breaking everything else
   a. Delete the marked lines below:
	```main.o:main.cpp
	$(EXEC) $(NVCC) $(INCLUDES) $(ALL_CCFLAGS) $(GENCODE_FLAGS) -o $@ -c $<

postProcessGL.o:postProcessGL.cu
	$(EXEC) $(NVCC) $(INCLUDES) $(ALL_CCFLAGS) $(GENCODE_FLAGS) -o $@ -c $<

postProcessGL: main.o postProcessGL.o
	$(EXEC) $(NVCC) $(ALL_LDFLAGS) $(GENCODE_FLAGS) -o $@ $+ $(LIBRARIES)
	$(EXEC) mkdir -p $(CUDA_SAMPLE_PATH)/bin/$(OS_ARCH)/$(OSLOWER)/$(TARGET)$(if $(abi),/$(abi)) # delete this
	$(EXEC) cp $@ $(CUDA_SAMPLE_PATH)/bin/$(OS_ARCH)/$(OSLOWER)/$(TARGET)$(if $(abi),/$(abi))	 # delete this

run: build
	$(EXEC) ./postProcessGL

clean:
	rm -f postProcessGL main.o postProcessGL.o
	# rm -rf $(CUDA_SAMPLE_PATH)/bin/$(OS_ARCH)/$(OSLOWER)/$(TARGET)$(if $(abi),/$(abi))/postProcessGL # delete this
	```