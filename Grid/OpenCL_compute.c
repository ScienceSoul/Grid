//
//  OpenCL_compute.c
//  Grid
//
//  Created by Hakime Seddik on 16/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#include <stdio.h>
#include <sys/stat.h>

#include <mach/mach_time.h>

#include "OpenCL_compute.h"
#include "Timing.h"

int device_stats(cl_device_id device_id)
{
	int err;
	size_t returned_size;
	
	// Device number and name
	cl_char vendor_name[1024] = {0};
	cl_char device_name[1025] = {0};
	cl_char device_profile[1024] = {0};
	cl_char device_extensions[1024] = {0};
	cl_device_local_mem_type local_mem_type;
	
	cl_ulong global_mem_size, global_mem_cache_size, local_mem_size;
	cl_ulong max_mem_alloc_size;
	
	cl_uint clock_frequency, vector_width, max_compute_units;
	
	size_t max_work_item_dims, max_work_group_size, max_work_item_sizes[3];
	
	cl_uint vector_types[] = {CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR, CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT, CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT, CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG, CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT, CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE};
	char *vector_type_names[] = {"char", "short", "int", "long", "float", "double"};
	
	err = clGetDeviceInfo(device_id, CL_DEVICE_VENDOR, sizeof(vendor_name), vendor_name, &returned_size);
	err |= clGetDeviceInfo(device_id, CL_DEVICE_NAME, sizeof(device_name), device_name, &returned_size);
	err |= clGetDeviceInfo(device_id, CL_DEVICE_PROFILE, sizeof(device_profile), device_profile, &returned_size);
	err |= clGetDeviceInfo(device_id, CL_DEVICE_EXTENSIONS, sizeof(device_extensions), device_extensions, &returned_size);
	err |= clGetDeviceInfo(device_id, CL_DEVICE_LOCAL_MEM_TYPE, sizeof(local_mem_type), &local_mem_type, &returned_size);
	
	err |= clGetDeviceInfo(device_id, CL_DEVICE_GLOBAL_MEM_SIZE, sizeof(global_mem_size), &global_mem_size, &returned_size);
	err |= clGetDeviceInfo(device_id, CL_DEVICE_LOCAL_MEM_SIZE, sizeof(local_mem_size), &local_mem_size, &returned_size);
	err |= clGetDeviceInfo(device_id, CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE, sizeof(global_mem_cache_size), &global_mem_cache_size, &returned_size);
	err |= clGetDeviceInfo(device_id, CL_DEVICE_MAX_MEM_ALLOC_SIZE, sizeof(max_mem_alloc_size), &max_mem_alloc_size, &returned_size);
	
	err |= clGetDeviceInfo(device_id, CL_DEVICE_MAX_CLOCK_FREQUENCY, sizeof(clock_frequency), &clock_frequency, &returned_size);
	
	err |= clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_GROUP_SIZE, sizeof(max_work_group_size), &max_work_group_size, &returned_size);
	
	err |= clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS, sizeof(max_work_item_dims), &max_work_item_dims, &returned_size);
	
	err |= clGetDeviceInfo(device_id, CL_DEVICE_MAX_WORK_ITEM_SIZES, sizeof(max_work_item_sizes), &max_work_item_sizes, &returned_size);
	
	err |= clGetDeviceInfo(device_id, CL_DEVICE_MAX_COMPUTE_UNITS, sizeof(max_compute_units), &max_compute_units, &returned_size);
	
	printf("Vendor: %s\n", vendor_name);
	printf("Device Name: %s\n", device_name);
	printf("Profile: %s\n", device_profile);
	printf("Supported Extensions: %s\n\n", device_extensions);
	
	printf("Local Mem Type (Local=1, Global=2): %i\n", (int)local_mem_type);
	printf("Global Mem Size (MB): %i\n", (int)global_mem_size/(1024*1024));
	printf("Global Mem Cache Size (Bytes): %i\n", (int)global_mem_cache_size);
	printf("Local Mem Size (MB): %i\n", (int)local_mem_size);
	printf("Max Mem Alloc Size (MB): %ld\n", (long int)max_mem_alloc_size/(1024*1024));
	
	printf("Clock Frequency (MHz): %i\n\n", clock_frequency);
	
	for(int i=0;i<6;i++) {
		err |= clGetDeviceInfo(device_id, vector_types[i], sizeof(clock_frequency), &vector_width, &returned_size);
		printf("Vector type width for: %s = %i\n", vector_type_names[i], vector_width);
	}
	
	printf("\nMax Work Group Size: %lu\n", max_work_group_size);
	printf("Max Compute Units: %i\n", max_compute_units);
	printf("\n");
	
	return CL_SUCCESS;
}

int LoadFileIntoString(const char *filename, char **text, size_t *len)
{
    struct stat statbuf;
    FILE        *fh;
    int         file_len;
	
    fh = fopen(filename, "r");
    if (fh == 0)
        return -1;
	
    stat(filename, &statbuf);
    file_len = (int)statbuf.st_size;
    *len = file_len;
    *text = (char *) malloc(file_len + 1);
    fread(*text, file_len, 1, fh);
    (*text)[file_len] = '\0';
	
    fclose(fh);
    return 0;
}

int exec_kernel(float *gx,float *gy, float *triangles, float *serialized_griddedData, int *serialized_gridMaskData, int ngrid, int NI, int NJ, const char * filename, int firstTime)
{
	cl_context         context;
	
	cl_command_queue   cmd_queue;
	cl_device_id       devices;
	
	cl_int             err;
	
	size_t src_len;
	int return_value;
	char *program_source;
	
	// Connect to a compute devise
	err = clGetDeviceIDs(NULL, CL_DEVICE_TYPE_GPU, 1, &devices, NULL);
	
	size_t returned_size = 0;
	cl_char vendor_name[1024] = {0};
	cl_char device_name[1024] = {0};
	err = clGetDeviceInfo(devices, CL_DEVICE_VENDOR, sizeof(vendor_name), vendor_name, &returned_size);
	err = clGetDeviceInfo(devices, CL_DEVICE_NAME, sizeof(device_name), device_name, &returned_size);
	
	if (firstTime == 1) {
		printf("Connecting to %s %s...\n\n", vendor_name, device_name);
		device_stats(devices);
	}
	
	// Read the program
	if (firstTime == 1) {
		printf("Loading program '%s'\n\n", filename);
	}
    
	return_value = LoadFileIntoString(filename, &program_source, &src_len);
	if (return_value) {
		printf("Error: Can't load kernel source\n");
        exit(-1);
	}
	
	//printf("%s\n", program_source);
	
	// Create the context of the command queue
	context = clCreateContext(0, 1, &devices, NULL, NULL, &err);
	cmd_queue = clCreateCommandQueue(context, devices, 0, NULL);
	
	// Allocate memory for program and kernels
	cl_program program;
	cl_kernel kernel;
	
	// Create the program .cl file
	program = clCreateProgramWithSource(context, 1, (const char**)&program_source, NULL, &err);
	if (err) {
		printf("Can't create program. Error was: %d\n", err);
		exit(-1);
	}
	
	// Build the program (compile it)
	err = clBuildProgram(program, 0, NULL, NULL, NULL, &err);
	char build[2048];
	clGetProgramBuildInfo(program, devices, CL_PROGRAM_BUILD_LOG, 2048, build, NULL);
	if (err) {
		printf("Can't build program. Error was: %d\n", err);
		printf("Build Log:\n%s\n", build);
		exit(-1);
	}
	
	// Create the kernel
	kernel = clCreateKernel(program, "interpolate", &err);
	if (err) {
		printf("Can't create kernel. Error was: %d\n", err);
		exit(-1);
	}
	
	size_t thread_size;
	clGetKernelWorkGroupInfo(kernel, devices, CL_KERNEL_WORK_GROUP_SIZE, sizeof(size_t), &thread_size, NULL);
	
	if (firstTime == 1) {
		printf("Recommended Work Group Size: %lu\n", thread_size);
	}
	
	uint64_t mbeg, mend;
	double cl_alloc, cl_enqueue, cl_read;
	
	size_t ngrid_buffer_size = sizeof(float) * ngrid;
	size_t ngrid_buffer_size_int = sizeof(int) * ngrid;
	size_t triangles_buffer_size = sizeof(float) * (NJ*(NI/3)*12);
	
#ifdef DEBUG
	mbeg = mach_absolute_time();
#endif
	
	// Allocate memory and queue it to be written to the device	
	cl_mem gx_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, ngrid_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, gx_mem, CL_TRUE, 0, ngrid_buffer_size, (void*)gx, 0, NULL, NULL);
	
	cl_mem gy_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, ngrid_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, gy_mem, CL_TRUE, 0, ngrid_buffer_size, (void*)gy, 0, NULL, NULL);
	
	cl_mem triangles_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, triangles_mem, CL_TRUE, 0, triangles_buffer_size, (void*)triangles, 0, NULL, NULL);
	
	cl_mem grid_mem = clCreateBuffer(context, CL_MEM_READ_WRITE, ngrid_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, grid_mem, CL_TRUE, 0, ngrid_buffer_size, (void*)serialized_griddedData, 0, NULL, NULL);
	
	cl_mem gridMask_mem = clCreateBuffer(context, CL_MEM_READ_WRITE, ngrid_buffer_size_int, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, gridMask_mem, CL_TRUE, 0, ngrid_buffer_size_int, (void*)serialized_gridMaskData, 0, NULL, NULL);
	
	// Push the data out to the device
	clFinish(cmd_queue);
	
#ifdef DEBUG
	mend = mach_absolute_time();
	cl_alloc = machcore(mend, mbeg);
#endif
	
	//set work-item dimensions
	size_t global_work_size, local_work_size;
	global_work_size = ngrid;
	local_work_size = 64;
	
	// Set kernel arguments
	err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &gx_mem);
	err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &gy_mem);
	err |= clSetKernelArg(kernel, 2, sizeof(cl_mem), &triangles_mem);
	err |= clSetKernelArg(kernel, 3, sizeof(cl_mem), &grid_mem);
	err |= clSetKernelArg(kernel, 4, sizeof(cl_mem), &gridMask_mem);
	err |= clSetKernelArg(kernel, 5, sizeof(int), &NI);
	err |= clSetKernelArg(kernel, 6, sizeof(int), &NJ);
	
	
#ifdef DEBUG
	mbeg = mach_absolute_time();
#endif
	
	//Queue up the kernels
	err = clEnqueueNDRangeKernel(cmd_queue, kernel, 1, NULL, &global_work_size, NULL, 0, NULL, NULL);
	
	// Finish the calculation
	clFinish(cmd_queue);
	
#ifdef DEBUG
	mend = mach_absolute_time();
	cl_enqueue = machcore(mend, mbeg);
#endif
	
#ifdef DEBUG
	mbeg = mach_absolute_time();
#endif
	
	// Read results data from the device
	err = clEnqueueReadBuffer(cmd_queue, grid_mem, CL_TRUE, 0, ngrid_buffer_size, serialized_griddedData, 0, NULL, NULL);
	err = clEnqueueReadBuffer(cmd_queue, gridMask_mem, CL_TRUE, 0, ngrid_buffer_size_int, serialized_gridMaskData, 0, NULL, NULL);
	clFinish(cmd_queue);
	
#ifdef DEBUG
	mend = mach_absolute_time();
	cl_read = machcore(mend, mbeg);
#endif
	
#ifdef DEBUG
	printf("Allocation: %1.12g Enqueue: %1.12g Read: %1.12g\n",cl_alloc,cl_enqueue,cl_read);
#endif
	
	// Release kernel, program and memory objects
	clReleaseKernel(kernel);
	clReleaseProgram(program);
	clReleaseCommandQueue(cmd_queue);
	clReleaseContext(context);
	
	clReleaseMemObject(gx_mem);
	clReleaseMemObject(gy_mem);
	clReleaseMemObject(triangles_mem);
	clReleaseMemObject(grid_mem);
	clReleaseMemObject(gridMask_mem);
	
	return CL_SUCCESS;
	
}

