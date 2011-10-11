//
//  OpenCL_compute.h
//  Grid
//
//  Created by Hakime Seddik on 16/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#include <OpenCL/opencl.h>

int device_stats(cl_device_id device_id);
int LoadFileIntoString(const char *filename, char **text, size_t *len);
int exec_kernel(float *gx,float *gy, float *triangles, float *serialized_griddedData, int *serialized_gridMaskData, int ngrid, int NI, int NJ, const char * filename, int firstTime);