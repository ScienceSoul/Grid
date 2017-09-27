//
//  OpenCL_utils.h
//  Grid
//
//  Created by Hakime Seddik on 06/10/11.
//  Copyright © 2011 ScienceSoul. All rights reserved.
//

#include <OpenCL/opencl.h>

int device_stats(cl_device_id device_id);
int LoadFileIntoString(const char *filename, char **text, size_t *len);
