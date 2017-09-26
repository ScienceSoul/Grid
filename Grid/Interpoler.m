//
//  Interpoler.m
//  Grid
//
//  Created by Hakime Seddik on 13/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import "Interpoler.h"

#import <stdbool.h>
#import <stdio.h>
#import <stdlib.h>
#import <sys/file.h>
#import <sys/param.h>
#import <sys/stat.h>
#import <sys/types.h>
#import <math.h>

#import <dispatch/dispatch.h>
#import <assert.h>
#import <time.h> 

#import <mach/mach_time.h>

#import <netcdf.h> 

#import "memory.h"
#import "Timing.h"
#import "OpenCL_utils.h"
#import "GridPoint.h"

#import "maxmin.h"
#import "scaleData.h"

#import "colormaps.h"

/* Handle errors by printing an error message and exiting with a
 * non-zero status. */
#define ERRCODE 2
#define ERR(e) {printf("Error: %s\n", nc_strerror(e)); exit(ERRCODE);}

@implementation Interpoler

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        headerString = @"Grid(Interpoler): ";
        
        // Initialize colormap and set its values to default
        colormap = [[RGBColorMap alloc] init];
        [colormap setRed:cmap_default];
        [colormap setGreen:cmap_default];
        [colormap setBlue:cmap_default];
        
        fieldView = [[ScalarDataView alloc] init];
        
        // By default scale factor is 1
        scaleFactor = 1;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(handleColorMapChange:) name:@"GRIDColorMapChanged" object:nil];
        [nc addObserver:self selector:@selector(handleScaleFactorChange:) name:@"GRIDScaleFactorChanged" object:nil];
    }
    
    return self;
}

-(BOOL)prepareData:(dataObject *)data {
    
    int i, nc1d, retval;
    int ngrid;
    float xyrange[2][2];
    size_t length;
    
    if ((retval = nc_open([[data netCDFFile] cStringUsingEncoding:NSASCIIStringEncoding], NC_NOWRITE, &ncid2))) {
        
        [data setMessage:@"The netCDF could not be opened. Please verify its location or if it's a valid file."];
        return NO;
    }
    
    /* Retrieve some informations dimensions size */
    if ((retval = nc_inq_dimid(ncid2, "x", &nc1d) )) {
        
        [data setMessage:@"Can't find variable x needed for interpolation."];
        return NO;
        
    }
    if ((retval = nc_inq_dimlen(ncid2, nc1d, &length) )) {
        
        [data setMessage:@"Can't determine length for variable x."];
        return NO;
    }
    NJ = (int) length;
    
    if ((retval = nc_inq_dimid(ncid2, "y", &nc1d) )) {
        
        [data setMessage:@"Can't find variable y needed for interpolation."];
        return NO;
    }
    if ((retval = nc_inq_dimlen(ncid2, nc1d, &length) )) {
        
        [data setMessage:@"Can't determine length for variable y."];
        return NO;
    }
    NI = (int) length;
    
    if ((retval = nc_inq_dimid(ncid2, "time", &nc1d) )) {
        
        [data setMessage:@"Can't find variable time needed for interpolation."];
        return NO;
    }
    if ((retval = nc_inq_dimlen(ncid2, nc1d, &length) )) {
        
        [data setMessage:@"Can't determine length for variable time."];
        return NO;
    }
    NZ = (int) length;
    
    NSLog(@"*** SUCCESS loading input NETCDF file!\n");
    
    NT = [data runInfoTimeLoop];
      
    xyrange[0][0] = [data coordFocusHorizMin];
    xyrange[0][1] = [data coordFocusHorizMax];
    xyrange[1][0] = [data coordFocusVertMin];
    xyrange[1][1] = [data coordFocusVertMax];
    
    NX = ( ( (int) xyrange[0][1] - (int) xyrange[0][0] ) / [data runInfoSpaceRes] );
    NY = ( ( (int) xyrange[1][1] - (int) xyrange[1][0] ) / [data runInfoSpaceRes] );
    
    ngrid = NX * NY;
    
    ElmercoordX = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
    ElmercoordY = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
    zs = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
    
    mask = i3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
    elements = i3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
    
    griddedData = f3tensor(0, NT-1, 0, NY-1, 0, NX-1);
    gridMask = i3tensor(0, NT-1, 0, NY-1, 0, NX-1);
    
    coordX = floatvec(0, NX-1);
	coordY = floatvec(0, NY-1);
    
    serialized_x = floatvec(0, ngrid-1);
    serialized_y = floatvec(0, ngrid-1);
    serialized_grid = floatvec(0, ngrid-1);
    serialized_gridMask = intvec(0, ngrid-1);
    
    coordX[0] = xyrange[0][0];
    coordY[0] = xyrange[1][0];
    
    for (i=1;i<NX;i++) {
        
        coordX[i] = coordX[i-1] + (float)[data runInfoSpaceRes];

    }

    for (i=1;i<NY;i++) {
        
        coordY[i] = coordY[i-1] + (float)[data runInfoSpaceRes];
        
    }
    
    incrTime = [data runInfoStartPos]-1;
    step = [data runInfoIncrement];
    
    return YES;
    
}

-(BOOL)dataReadVarIn:(const char *)var_in varIn2:(const char *)var_in2 varIn3:(const char *)var_in3 varOut:(const char *)var_out NbVarIn:(int)nb_var_in data:(dataObject *)data {
    
    int x, y, z;
    int retval;
    int varid, varid2, varid3;
    
    float ***buffer1, ***buffer2, ***buffer3;
    
    for (z=0; z<NZ; z++) {
        for (y=0; y<NJ; y++) {
            for (x=0; x<NI; x++) {
                ElmercoordX[z][y][x] = 0.0;
                ElmercoordY[z][y][x] = 0.0;
                zs[z][y][x] = 0.0;
                mask[z][y][x] = 0;
                elements[z][y][x] = 0;
            }
        }
    }
    
    if ((retval = nc_inq_varid(ncid2, "xcoord", &varid))) {
        
        [data setMessage:@"Can't find variable xcoord needed for interpolation."];
        return NO;
    }
    if ((retval = nc_get_var_float(ncid2, varid, &ElmercoordX[0][0][0]))) {
        
        [data setMessage:@"Can't determine length for variable xcoord."];
        return NO;
    }
    
    if ((retval = nc_inq_varid(ncid2, "ycoord", &varid))) {
        
        [data setMessage:@"Can't find variable ycoord needed for interpolation."];
        return NO;

    }
    if ((retval = nc_get_var_float(ncid2, varid, &ElmercoordY[0][0][0]))) {
        
        [data setMessage:@"Can't determine length for variable ycoord."];
        return NO;
    }
    
    if (nb_var_in > 3 || nb_var_in < 1) {
        
        [data setMessage:@"Maximum supported input variables at once in order to create one single output variable is 3. Mimumn input variable to create one single output variable is 1."];
        
        NSLog(@"Error: Maximum supported input variables at once in order to create one single output variable is 3\n");
        NSLog(@"Error: Mimumn input variable to create one single output variable is 1\n");
        return NO;
        
    } else if (nb_var_in > 1 && nb_var_in <= 3) {
        
        switch (nb_var_in) {
                
            case 2:
                
                buffer1 = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
                buffer2 = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
                
                if ((retval = nc_inq_varid(ncid2, var_in, &varid))) {
                    
                    [data setMessage:@"Can't find the variable Var.1 given by the user."];
                    return NO;
                }
                if ((retval = nc_get_var_float(ncid2, varid, &buffer1[0][0][0]))) {
                    
                    [data setMessage:@"Can't retrieve data for Var.1."];
                    return NO;
                }
                
                if ((retval = nc_inq_varid(ncid2, var_in2, &varid2))) {
                    
                    [data setMessage:@"Can't find the variable Var.2 given by the user."];
                    return NO;
                }
                if ((retval = nc_get_var_float(ncid2, varid2, &buffer2[0][0][0]))) {
                    
                    [data setMessage:@"Can't retrieve data for Var.2."];
                    return NO;
                }
                
                for (z=0; z<NZ; z++) {
                    for (y=0; y<NJ; y++) {
                        for (x=0; x<NI; x++) {
                            zs[z][y][x] = sqrtf( powf(buffer1[z][y][x], 2.0) + powf(buffer2[z][y][x], 2.0) );
                        }
                    }
                }
                
                free_f3tensor(buffer1, 0, NZ-1, 0, NJ-1, 0, NI-1);
                free_f3tensor(buffer2, 0, NZ-1, 0, NJ-1, 0, NI-1);
                
                break;
                
            case 3:
                
                buffer1 = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
                buffer2 = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
                buffer3 = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
                
                if ((retval = nc_inq_varid(ncid2, var_in, &varid))) {
                    
                    [data setMessage:@"Can't find the variable Var.1 given by the user."];
                    return NO;
                }
                if ((retval = nc_get_var_float(ncid2, varid, &buffer1[0][0][0]))) {
                    
                    [data setMessage:@"Can't retrieve data for Var.1."];
                    return NO;
                }
                
                if ((retval = nc_inq_varid(ncid2, var_in2, &varid2))) {
                    
                    [data setMessage:@"Can't find the variable Var.2 given by the user."];
                    return NO;
                }
                if ((retval = nc_get_var_float(ncid2, varid2, &buffer2[0][0][0]))) {
                    
                    [data setMessage:@"Can't retrieve data for Var.2."];
                    return NO;
                }
                
                if ((retval = nc_inq_varid(ncid2, var_in3, &varid3))) {
                    
                    [data setMessage:@"Can't find the variable Var.3 given by the user."];
                    return NO;
                }
                if ((retval = nc_get_var_float(ncid2, varid3, &buffer3[0][0][0]))) {
                    
                    [data setMessage:@"Can't retrieve data for Var.3."];
                    return NO;
                }
                
                for (z=0; z<NZ; z++) {
                    for (y=0; y<NJ; y++) {
                        for (x=0; x<NI; x++) {
                            zs[z][y][x] = sqrtf( powf(buffer1[z][y][x], 2.0) + powf(buffer2[z][y][x], 2.0) + powf(buffer3[z][y][x], 2.0) );
                        }
                    }
                }
                
                free_f3tensor(buffer1, 0, NZ-1, 0, NJ-1, 0, NI-1);
                free_f3tensor(buffer2, 0, NZ-1, 0, NJ-1, 0, NI-1);
                free_f3tensor(buffer3, 0, NZ-1, 0, NJ-1, 0, NI-1);
                
                break;
        }
    }
    else if (nb_var_in == 1) {
        
        if ((retval = nc_inq_varid(ncid2, var_in, &varid)))
            ERR(retval);
        if ((retval = nc_get_var_float(ncid2, varid, &zs[0][0][0])))
            ERR(retval);
        
    }
    
    if ((retval = nc_inq_varid(ncid2, "mask", &varid))) {
        
        [data setMessage:@"Can't find variable mask needed for interpolation."];
        return NO;
    }
    if ((retval = nc_get_var_int(ncid2, varid, &mask[0][0][0]))) {
        
        [data setMessage:@"Can't determine length for variable mask."];
        return NO;
    }
    
    if ((retval = nc_inq_varid(ncid2, "elements", &varid))) {
        
        [data setMessage:@"Can't find variable elements needed for interpolation."];
        return NO;
    }
    if ((retval = nc_get_var_int(ncid2, varid, &elements[0][0][0]))) {
        
        [data setMessage:@"Can't determine length for variable elements."];
        return NO;
    }
    
    return YES;
    
}

-(void)SerialCompute:(dataObject *)data {
    
    int x, y, z;
    
    int xx, yy, ii, jj, k;
    int indx, ngrid;
    float ***triangles;
    
    uint64_t beg, end;
    uint64_t gr_end, gr_beg;
    
    //NSAutoreleasePool* myAutoreleasePool = [[NSAutoreleasePool alloc] init];
    
    processedDataObject *processedData = [[processedDataObject alloc] init];
    
    cpuGridString = @"CPU Grid(sec): ";
    cpuLoopString = @"CPU Loop(sec): ";
    
    ngrid = NX * NY;
    
    [self isTerminatedThreadData1:data data2:processedData];
    
    if (![self dataReadVarIn:[[data variableVar1] cStringUsingEncoding:NSASCIIStringEncoding] varIn2:[[data variableVar2] cStringUsingEncoding:NSASCIIStringEncoding] varIn3:[[data variableVar3] cStringUsingEncoding:NSASCIIStringEncoding] varOut:[[data variableName] cStringUsingEncoding:NSASCIIStringEncoding] NbVarIn:[data variableNB] data:data]) {
        
        [ self performSelectorOnMainThread:@selector(manageFailure:)
                                withObject:data
                             waitUntilDone:YES];
        
        [[data serialButtonState] setState:NSOffState];
        [self memoryReleaseData1:data data2:processedData];
        
        return;
        
    }
    
    if ([data variableNB]> 1 && [data variableNB] <= 3) {
        
        switch ([data variableNB]) {
            case 2:
                NSLog(@"Interpolating SeaRise variable %@ from Elmer variables %@ and %@:.......\n", [data variableName], [data variableVar1], [data variableVar2]);
                break;
                
            case 3:
                NSLog(@"Interpolating SeaRise variable %@ from Elmer variables %@, %@ and %@:.......\n", [data variableName], [data variableVar1], [data variableVar2], [data variableVar3]);
                break;
        }
    }
    else if ([data variableNB] == 1) { 
        NSLog(@"Interpolating SeaRise variable %@ from Elmer variable %@:.......\n", [data variableName], [data variableVar1]);
    }     
       
    triangles = f3tensor(0, NJ, 0, NI/3, 0, 9);
    
    for (z=0; z<NT; z++) {
        for (y=0; y<NY; y++) {
            for (x=0; x<NX; x++) {
                griddedData[z][y][x] = 0.0;
                gridMask[z][y][x] = -1;
            }
        }
    }
    
    beg = mach_absolute_time();
    
    for (z=1; z<NT; z++) {
        
        [self isTerminatedThreadData1:data data2:processedData];
        
        for (yy=0; yy<NJ; yy++) {
            for (xx=0; xx<(NI/3); xx++) {
                for (ii=0;ii<10;ii++) {
                    triangles[yy][xx][ii] = 0.0;
                }
            }
        }
        
        indx = 0;
        
        for (jj=0; jj<NJ; jj++) {
            indx = 0;
            for (ii=0; ii<NI; ii=ii+3) {
                if (mask[incrTime][jj][ii] == 1 && mask[incrTime][jj][ii+1] == 1 && mask[incrTime][jj][ii+2] == 1) {
                    triangles[jj][indx][0] = incrTime;
                    triangles[jj][indx][1] = ElmercoordX[incrTime][jj][ii];
                    triangles[jj][indx][2] = ElmercoordY[incrTime][jj][ii];
                    triangles[jj][indx][3] = zs[incrTime][jj][ii];
                    triangles[jj][indx][4] = ElmercoordX[incrTime][jj][ii+1];
                    triangles[jj][indx][5] = ElmercoordY[incrTime][jj][ii+1];
                    triangles[jj][indx][6] = zs[incrTime][jj][ii+1];
                    triangles[jj][indx][7] = ElmercoordX[incrTime][jj][ii+2];
                    triangles[jj][indx][8] = ElmercoordY[incrTime][jj][ii+2];
                    triangles[jj][indx][9] = zs[incrTime][jj][ii+2];
                    indx++;
                }
            }
        }
        
        gr_beg = mach_absolute_time();
        
        [self Serial_work_functionGrid1:griddedData grid2:gridMask t:z entry1:triangles entry2:coordX entry3:coordY N1:NI N2:NJ N3:NX N4:NY data1:data data2:processedData];
        
        gr_end = mach_absolute_time();
        NSLog(@"CPU Grid: %1.12g\n", machcore(gr_end, gr_beg));
        
        incrTime = incrTime+step;
        
        k = 0;
        for (yy=0; yy<NY; yy++) {
            for (xx=0; xx<NX; xx++) {
                
                serialized_grid[k] = griddedData[z][yy][xx];
                serialized_gridMask[k] = gridMask[z][yy][xx];
                k++;
                
            }
        }
        
        // Timing data we want to display on user interface
        [processedData setString1:headerString];
        [processedData setString2:cpuGridString];
        [processedData setTiming:machcore(gr_end, gr_beg)];
        [processedData setview:[data view]];
        
        // Pass which scaling method we use
        [processedData setScaleMethod:[data scaleMethod]];
        
        [ self performSelectorOnMainThread:@selector(presentDataToUser:)
                                withObject:processedData
                             waitUntilDone:YES];
        
    } // End time loop
    
    end = mach_absolute_time();
    NSLog(@"CPU loop: %1.12g\n", machcore(end, beg));
    
    [processedData setString1:headerString];
    [processedData setString2:cpuLoopString];
    [processedData setTiming:machcore(end, beg)];
    [processedData setview:[data view]];
    
    [ self performSelectorOnMainThread:@selector(presentDataToUser:)
                            withObject:processedData
                         waitUntilDone:false];
    
    free_f3tensor(triangles, 0, NJ, 0, NI/3, 0, 9);
    
    // If we arrive until here, it means we completed the run so re-change the state of 
    // the interface button so that we are ready for next run
    [[data serialButtonState] setState:NSOffState];

    [self memoryReleaseData1:data data2:processedData];
    
    //[myAutoreleasePool release];
}

-(void)GCDCompute:(dataObject *)data{
    
    int x, y, z;
    
    int xx, yy, ii, jj, k;
    int indx, ngrid;
    float ***triangles;
    
    uint64_t beg, end;
    uint64_t gr_end, gr_beg;
    
    //NSAutoreleasePool* myAutoreleasePool = [[NSAutoreleasePool alloc] init];
    
    processedDataObject *processedData = [[processedDataObject alloc] init];
    
    gcdGridString = @"GCD Grid(sec): ";
    gcdLoopString = @"GCD Loop(sec): ";
    
    ngrid = NX * NY;
    
    [self isTerminatedThreadData1:data data2:processedData];
    
    if (![self dataReadVarIn:[[data variableVar1] cStringUsingEncoding:NSASCIIStringEncoding] varIn2:[[data variableVar2] cStringUsingEncoding:NSASCIIStringEncoding] varIn3:[[data variableVar3] cStringUsingEncoding:NSASCIIStringEncoding] varOut:[[data variableName] cStringUsingEncoding:NSASCIIStringEncoding] NbVarIn:[data variableNB] data:data]) {
        
        [ self performSelectorOnMainThread:@selector(manageFailure:)
                                withObject:data
                             waitUntilDone:YES];
        
        [[data gcdSButtonState] setState:NSOffState];
        [self memoryReleaseData1:data data2:processedData];
        
        return;
        
    }
    
    if ([data variableNB]> 1 && [data variableNB] <= 3) {
        
        switch ([data variableNB]) {
            case 2:
                NSLog(@"Interpolating SeaRise variable %@ from Elmer variables %@ and %@:.......\n", [data variableName], [data variableVar1], [data variableVar2]);
                break;
                
            case 3:
                NSLog(@"Interpolating SeaRise variable %@ from Elmer variables %@, %@ and %@:.......\n", [data variableName], [data variableVar1], [data variableVar2], [data variableVar3]);
                break;
        }
    }
    else if ([data variableNB] == 1) { 
        NSLog(@"Interpolating SeaRise variable %@ from Elmer variable %@:.......\n", [data variableName], [data variableVar1]);
    }
    
    triangles = f3tensor(0, NJ, 0, NI/3, 0, 9);
    
    for (z=0; z<NT; z++) {
        for (y=0; y<NY; y++) {
            for (x=0; x<NX; x++) {
                griddedData[z][y][x] = 0.0;
                gridMask[z][y][x] = -1;
            }
        }
    }
    
    beg = mach_absolute_time();
    
    for (z=0; z<NT; z++) {
        
        [self isTerminatedThreadData1:data data2:processedData];
        
        for (yy=0; yy<NJ; yy++) {
            for (xx=0; xx<(NI/3); xx++) {
                for (ii=0;ii<10;ii++) {
                    triangles[yy][xx][ii] = 0.0;
                }
            }
        }
        
        indx = 0;
        
        for (jj=0; jj<NJ; jj++) {
            indx = 0;
            for (ii=0; ii<NI; ii=ii+3) {
                if (mask[incrTime][jj][ii] == 1 && mask[incrTime][jj][ii+1] == 1 && mask[incrTime][jj][ii+2] == 1) {
                    triangles[jj][indx][0] = incrTime;
                    triangles[jj][indx][1] = ElmercoordX[incrTime][jj][ii];
                    triangles[jj][indx][2] = ElmercoordY[incrTime][jj][ii];
                    triangles[jj][indx][3] = zs[incrTime][jj][ii];
                    triangles[jj][indx][4] = ElmercoordX[incrTime][jj][ii+1];
                    triangles[jj][indx][5] = ElmercoordY[incrTime][jj][ii+1];
                    triangles[jj][indx][6] = zs[incrTime][jj][ii+1];
                    triangles[jj][indx][7] = ElmercoordX[incrTime][jj][ii+2];
                    triangles[jj][indx][8] = ElmercoordY[incrTime][jj][ii+2];
                    triangles[jj][indx][9] = zs[incrTime][jj][ii+2];
                    indx++;
                }
            }
        }
        
        gr_beg = mach_absolute_time();
        
        [self GCD_work_functionGrid1:griddedData grid2:gridMask t:z entry1:triangles entry2:coordX entry3:coordY N1:NI N2:NJ N3:NX N4:NY data1:data data2:processedData];
        
        gr_end = mach_absolute_time();
        NSLog(@"GCD Grid: %1.12g\n", machcore(gr_end, gr_beg));
        
        incrTime = incrTime+step;
        
        k = 0;
        for (yy=0; yy<NY; yy++) {
            for (xx=0; xx<NX; xx++) {
                
                serialized_grid[k] = griddedData[z][yy][xx];
                serialized_gridMask[k] = gridMask[z][yy][xx];
                k++;
                
            }
        }
        
        // Timing data we want to display on user interface
        [processedData setString1:headerString];
        [processedData setString2:gcdGridString];
        [processedData setTiming:machcore(gr_end, gr_beg)];
        [processedData setview:[data view]];
        
        // Pass which scaling method we use
        [processedData setScaleMethod:[data scaleMethod]];
        
        [ self performSelectorOnMainThread:@selector(presentDataToUser:)
                                withObject:processedData
                             waitUntilDone:YES];
        
    } // End time loop
    
    end = mach_absolute_time();
    NSLog(@"GCD loop: %1.12g\n", machcore(end, beg));
    
    [processedData setString1:headerString];
    [processedData setString2:gcdLoopString];
    [processedData setTiming:machcore(end, beg)];
    [processedData setview:[data view]];
    
    [ self performSelectorOnMainThread:@selector(presentDataToUser:)
                            withObject:processedData
                         waitUntilDone:false];
    
    free_f3tensor(triangles, 0, NJ, 0, NI/3, 0, 9);
    
    // If we arrive until here, it means we completed the run so re-change the state of 
    // the interface button so that we are ready for next run
    [[data gcdSButtonState] setState:NSOffState];

    [self memoryReleaseData1:data data2:processedData];
    
    //[myAutoreleasePool release];
}

-(void)OpenCLCompute:(dataObject *)data {
    
    int i, j, k;
    int z;
    int firstTime;
    
    int ii, jj, kk;
    int indx, ngrid;
    float *triangles;
    float *X1, *X2, *X3, *Y1, *Y2, *Y3, *Z1, *Z2, *Z3;
    
    uint64_t beg, end;
    uint64_t gr_end, gr_beg;
    
    //NSAutoreleasePool* workThreadPool = [[NSAutoreleasePool alloc] init];
    
    processedDataObject *processedData = [[processedDataObject alloc] init];
    
    openclGridString = @"OpenCL Grid(sec): ";
    openclLoopString = @"OpenCL Loop(sec): ";
    
    ngrid = NX * NY;
    
    k = 0;
    for (i=0; i<NY; i++) {
        for (j=0; j<NX; j++) {
            serialized_x[k] = coordX[j];
            k++;
        }
    }
    
    k = 0;
    for (i=0; i<NY; i++) {
        for (j=0; j<NX; j++) {
            serialized_y[k] = coordY[i];
            k++;
        }
    }
    
    firstTime = 1;
    
    [self isTerminatedThreadData1:data data2:processedData];
                
    if (![self dataReadVarIn:[[data variableVar1] cStringUsingEncoding:NSASCIIStringEncoding] varIn2:[[data variableVar2] cStringUsingEncoding:NSASCIIStringEncoding] varIn3:[[data variableVar3] cStringUsingEncoding:NSASCIIStringEncoding] varOut:[[data variableName] cStringUsingEncoding:NSASCIIStringEncoding] NbVarIn:[data variableNB] data:data]) {
        
        [ self performSelectorOnMainThread:@selector(manageFailure:)
                                withObject:data
                             waitUntilDone:YES];
        
        [[data openclButtonState] setState:NSOffState];
        [self memoryReleaseData1:data data2:processedData];
        
        return;
        
    }
    
    if ([data variableNB]> 1 && [data variableNB] <= 3) {
        
        switch ([data variableNB]) {
            case 2:
                NSLog(@"Interpolating SeaRise variable %@ from Elmer variables %@ and %@:.......\n", [data variableName], [data variableVar1], [data variableVar2]);
                break;
                
            case 3:
                NSLog(@"Interpolating SeaRise variable %@ from Elmer variables %@, %@ and %@:.......\n", [data variableName], [data variableVar1], [data variableVar2], [data variableVar3]);
                break;
        }
    }
    else if ([data variableNB] == 1) { 
        NSLog(@"Interpolating SeaRise variable %@ from Elmer variable %@:.......\n", [data variableName], [data variableVar1]);
    }
    
    triangles = floatvec(0, (NJ*(NI/3)*12)-1 );
    
    int aligned;
    aligned = (NJ*(NI/3)) + (512 - ((NJ*(NI/3)) & 511));
    
    X1 = floatvec(0, aligned-1);
    X2 = floatvec(0, aligned-1);
    X3 = floatvec(0, aligned-1);
    Y1 = floatvec(0, aligned-1);
    Y2 = floatvec(0, aligned-1);
    Y3 = floatvec(0, aligned-1);
    Z1 = floatvec(0, aligned-1);
    Z2 = floatvec(0, aligned-1);
    Z3 = floatvec(0, aligned-1);
    
    beg = mach_absolute_time();
    
    for (z=0; z<NT; z++) {
        
        [self isTerminatedThreadData1:data data2:processedData];
        
        for(ii=0; ii<ngrid; ii++) {
            serialized_grid[ii] = 0.0;
            serialized_gridMask[ii] = -1;
        }
        
        for (ii = 0; ii<(NJ*(NI/3)*12); ii++){
            triangles[ii] = 0.0;
        }
        
        for (ii = 0; ii<aligned; ii++){
            X1[ii] = 0.0;
            X2[ii] = 0.0;
            X3[ii] = 0.0;
            Y1[ii] = 0.0;
            Y2[ii] = 0.0;
            Y3[ii] = 0.0;
            Z1[ii] = 0.0;
            Z2[ii] = 0.0;
            Z3[ii] = 0.0;
        }

        
        indx = 0;
        
        for (jj=0; jj<NJ; jj++) {
            kk = 0;
            for (ii=0; ii<NI; ii=ii+3) {
                if (mask[incrTime][jj][ii] == 1 && mask[incrTime][jj][ii+1] == 1 && mask[incrTime][jj][ii+2] == 1) {
                    triangles[indx] = incrTime;
                    indx++;
                    triangles[indx] = ElmercoordX[incrTime][jj][ii];
                    indx++;
                    triangles[indx] = ElmercoordY[incrTime][jj][ii];
                    indx++;
                    triangles[indx] = zs[incrTime][jj][ii];
                    indx++;
                    triangles[indx] = ElmercoordX[incrTime][jj][ii+1];
                    indx++;
                    triangles[indx] = ElmercoordY[incrTime][jj][ii+1];
                    indx++;
                    triangles[indx] = zs[incrTime][jj][ii+1];
                    indx++;
                    triangles[indx] = ElmercoordX[incrTime][jj][ii+2];
                    indx++;
                    triangles[indx] = ElmercoordY[incrTime][jj][ii+2];
                    indx++;
                    triangles[indx] = zs[incrTime][jj][ii+2];
                    indx++;
                    triangles[indx] = jj;
                    indx++;
                    triangles[indx] = kk;
                    indx++;
                    kk++;
                }
            }
        }
        
        indx = 0;
        for (jj=0; jj<NJ; jj++) {
            for (ii=0; ii<NI; ii=ii+3) {
                if (mask[incrTime][jj][ii] == 1 && mask[incrTime][jj][ii+1] == 1 && mask[incrTime][jj][ii+2] == 1) {
                    
                    X1[indx] = ElmercoordX[incrTime][jj][ii];
                    X2[indx] = ElmercoordX[incrTime][jj][ii+1];
                    X3[indx] = ElmercoordX[incrTime][jj][ii+2];
                    Y1[indx] = ElmercoordY[incrTime][jj][ii];
                    Y2[indx] = ElmercoordY[incrTime][jj][ii+1];
                    Y3[indx] = ElmercoordY[incrTime][jj][ii+2];
                    Z1[indx] = zs[incrTime][jj][ii];
                    Z2[indx] = zs[incrTime][jj][ii+1];
                    Z3[indx] = zs[incrTime][jj][ii+2];
                    indx++;
                    
                }
            }
        }
        
        gr_beg = mach_absolute_time();
        
        [self exec_kernelgx:serialized_x gy:serialized_y triangles:triangles serializedGriddedData:serialized_grid serializedGridMaskData:serialized_gridMask ngrid:ngrid ni:NI nj:NJ filename:"interpolate.cl" firstTime:firstTime data1:data data2:processedData];
        //[self exec_kernel_optgx:serialized_x gy:serialized_y X1:X1 X2:X2 X3:X3 Y1:Y1 Y2:Y2 Y3:Y3 Z1:Z1 Z2:Z2 Z3:Z3 aligned:aligned serializedGriddedData:serialized_grid serialized_gridMaskData:serialized_gridMask ngrid:ngrid ni:NI nj:NJ filename:"interpolate_vectorized.cl" firstTime:firstTime data1:data data2:processedData];
        
        gr_end = mach_absolute_time();
        NSLog(@"GPU Grid: %1.12g\n", machcore(gr_end, gr_beg));
        
        incrTime = incrTime+step;
        
        if (firstTime == 1) {
            firstTime = 0;
        }
        
        // Timing data we want to display on user interface
        [processedData setString1:headerString];
        [processedData setString2:openclGridString];
        [processedData setTiming:machcore(gr_end, gr_beg)];
        [processedData setview:[data view]];
        
        // Pass which scaling method we use
        [processedData setScaleMethod:[data scaleMethod]];
        
        [ self performSelectorOnMainThread:@selector(presentDataToUser:)
                                withObject:processedData
                             waitUntilDone:YES];
        
    } // End time loop
    
    end = mach_absolute_time();
    NSLog(@"GPU loop: %1.12g\n", machcore(end, beg));
    
    [processedData setString1:headerString];
    [processedData setString2:openclLoopString];
    [processedData setTiming:machcore(end, beg)];
    [processedData setview:[data view]];
    [ self performSelectorOnMainThread:@selector(presentDataToUser:)
                            withObject:processedData
                         waitUntilDone:false];
    
    free_fvector(triangles, 0, (NJ*(NI/3)*12)-1);
    
    free_fvector(X1, 0, aligned-1);
    free_fvector(X2, 0, aligned-1);
    free_fvector(X3, 0, aligned-1);
    free_fvector(Y1, 0, aligned-1);
    free_fvector(Y2, 0, aligned-1);
    free_fvector(Y3, 0, aligned-1);
    free_fvector(Z1, 0, aligned-1);
    free_fvector(Z2, 0, aligned-1);
    free_fvector(Z3, 0, aligned-1);
    
    // If we arrive until here, it means we completed the run so re-change the state of 
    // the interface button so that we are ready for next run
    [[data openclButtonState] setState:NSOffState];
    
    [self memoryReleaseData1:data data2:processedData];
    
    //[myAutoreleasePool release];
}

-(void)Serial_work_functionGrid1:(float ***)grid1 grid2:(int ***)grid2 t:(int)t entry1:(float ***)entry1 entry2:(float *)entry2 entry3:(float *)entry3 N1:(int)N1 N2:(int)N2 N3:(int)N3 N4:(int)N4 data1:(dataObject *)data1 data2:(processedDataObject *)data2 {
    // entry1 -> triangles
    // entry2 -> x regular grid
    // entry3 -> y regular grid
    
    int jj, ii, xx, yy;
    int l, k;
    
    int **foundTriangles;
    
    l = 0;
    k = 0;
    
    foundTriangles = intmatrix(0, 9, 0, 1);
    
    for (yy=0; yy<N4; yy++) {
        
        [self isTerminatedThreadData1:data1 data2:data2];
        
		for (ii=0;ii<10;ii++) {
			for (jj=0;jj<2;jj++) {
				foundTriangles[ii][jj] = 0;
			}
		}
		
		for (xx=0; xx<N3; xx++) {
            
            [self isTerminatedThreadData1:data1 data2:data2];
			
			l = 0;
			for (jj=0; jj<N2; jj++) {
				for (ii=0; ii<N1/3; ii++) {
					k = pointInTriangle(entry2[xx], entry3[yy], entry1[jj][ii][1], entry1[jj][ii][2], entry1[jj][ii][4], entry1[jj][ii][5], 
										entry1[jj][ii][7], entry1[jj][ii][8]);
					if (k == 1) {
						foundTriangles[l][0] = jj;
						foundTriangles[l][1] = ii;
						//printf("%f %f %d %d\n", entry5[xx], entry6[yy], foundTriangles[l][0], foundTriangles[l][1]);
						l++;
					}
				}
			}
			//if (l > 1) printf("got %d triangles.\n", l);
			if (l > 0) { 
				grid1[t][yy][xx] = getInterpolatedValue(foundTriangles, l, entry2[xx], entry3[yy], entry1, 2.0);
				grid2[t][yy][xx] = 3;
			} else {
				grid1[t][yy][xx] = 0.0;
				grid2[t][yy][xx] = 0;
			}
			//printf("%d %d %d %f\n", t, (int) yy, xx, griddedData[t][yy][xx]);
		}
        
    }
    
    free_imatrix(foundTriangles, 0, 9, 0, 1);

    
}

-(void)GCD_work_functionGrid1:(float ***)grid1 grid2:(int ***)grid2 t:(int)t entry1:(float ***)entry1 entry2:(float *)entry2 entry3:(float *)entry3 N1:(int)N1 N2:(int)N2 N3:(int)N3 N4:(int)N4 data1:(dataObject *)data1 data2:(processedDataObject *)data2 {
    // entry1 -> triangles
    // entry2 -> x regular grid
    // entry3 -> y regular grid
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
	dispatch_apply(N4, queue, ^(size_t yy){
		
		int jj, ii, xx;
		int l, k;
		
		int **foundTriangles;
		
		l = 0;
		k = 0;
        
		foundTriangles = intmatrix(0, 9, 0, 1);
		
		for (ii=0;ii<10;ii++) {
			for (jj=0;jj<2;jj++) {
				foundTriangles[ii][jj] = 0;
			}
		}
		
		for (xx=0; xx<N3; xx++) {
			
            if ([data1 terminated] == YES) break;
            
			l = 0;
			for (jj=0; jj<N2; jj++) {
				for (ii=0; ii<N1/3; ii++) {
					k = pointInTriangle(entry2[xx], entry3[yy], entry1[jj][ii][1], entry1[jj][ii][2], entry1[jj][ii][4], entry1[jj][ii][5], 
										entry1[jj][ii][7], entry1[jj][ii][8]);
					if (k == 1) {
						foundTriangles[l][0] = jj;
						foundTriangles[l][1] = ii;
						//printf("%f %f %d %d\n", entry5[xx], entry6[yy], foundTriangles[l][0], foundTriangles[l][1]);
						l++;
					}
				}
			}
			//if (l > 1) printf("got %d triangles.\n", l);
			if (l > 0) { 
				grid1[t][yy][xx] = getInterpolatedValue(foundTriangles, l, entry2[xx], entry3[yy], entry1, 2.0);
				grid2[t][yy][xx] = 3;
			} else {
				grid1[t][yy][xx] = 0.0;
				grid2[t][yy][xx] = 0;
			}
			//printf("%d %d %d %f\n", t, (int) yy, xx, griddedData[t][yy][xx]);
		}
		
		free_imatrix(foundTriangles, 0, 9, 0, 1);
	});
    
}

-(int)exec_kernelgx:(float *)gx gy:(float *)gy triangles:(float *)triangles serializedGriddedData:(float *)serialized_griddedData serializedGridMaskData:(int *)serialized_gridMaskData ngrid:(int)ngrid ni:(int)ni nj:(int)nj filename:(const char *)filename firstTime:(int)firstTime data1:(dataObject *)data1 data2:(processedDataObject *)data2 {
    
    cl_context         context;
	
	cl_command_queue   cmd_queue;
	cl_device_id       devices;
	
	cl_int             err;
	
	size_t src_len;
	int return_value;
	char *program_source;
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
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
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
	// Read the program
	if (firstTime == 1) {
		printf("Loading program '%s'\n\n", filename);
	}
    
	return_value = LoadFileIntoString(filename, &program_source, &src_len);
	if (return_value) {
		printf("Error: Can't load kernel source\n");
        exit(-1);
	}
	
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
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
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
	size_t triangles_buffer_size = sizeof(float) * (nj*(ni/3)*12);
	
#ifdef DEBUG
	mbeg = mach_absolute_time();
#endif
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
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
	size_t global_work_size, local_work_size, shared_size;
	global_work_size = ngrid;
	local_work_size = 64;
    shared_size = (9 * local_work_size) * sizeof(float);
	
	// Set kernel arguments
	err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &gx_mem);
	err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &gy_mem);
	err |= clSetKernelArg(kernel, 2, sizeof(cl_mem), &triangles_mem);
	err |= clSetKernelArg(kernel, 3, sizeof(cl_mem), &grid_mem);
	err |= clSetKernelArg(kernel, 4, sizeof(cl_mem), &gridMask_mem);
	err |= clSetKernelArg(kernel, 5, sizeof(int), &ni);
	err |= clSetKernelArg(kernel, 6, sizeof(int), &nj);
    
#ifdef DEBUG
	mbeg = mach_absolute_time();
#endif
    
    [self isTerminatedThreadData1:data1 data2:data2];
	
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
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
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

-(int)exec_kernel_optgx:(float *)gx gy:(float *)gy X1:(float *)X1 X2:(float *)X2 X3:(float *)X3 Y1:(float *)Y1 Y2:(float *)Y2 Y3:(float *)Y3 Z1:(float *)Z1 Z2:(float *)Z2 Z3: (float *)Z3 aligned:(int)aligned serializedGriddedData:(float *)serialized_griddedData serialized_gridMaskData:(int *)serialized_gridMaskData ngrid:(int)ngrid ni:(int)ni nj: (int)nj filename:(const char *)filename firstTime:(int)firstTime data1:(dataObject *)data1 data2:(processedDataObject *)data2 {
    
    cl_context         context;
	
	cl_command_queue   cmd_queue;
	cl_device_id       devices;
	
	cl_int             err;
    
	size_t src_len;
	int return_value;
	char *program_source;
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
	// Connect to a compute devise
	err = clGetDeviceIDs(NULL, CL_DEVICE_TYPE_CPU, 1, &devices, NULL);
	
	size_t returned_size = 0;
	cl_char vendor_name[1024] = {0};
	cl_char device_name[1024] = {0};
	err = clGetDeviceInfo(devices, CL_DEVICE_VENDOR, sizeof(vendor_name), vendor_name, &returned_size);
	err = clGetDeviceInfo(devices, CL_DEVICE_NAME, sizeof(device_name), device_name, &returned_size);
	
	if (firstTime == 1) {
		printf("Connecting to %s %s...\n\n", vendor_name, device_name);
		device_stats(devices);
	}
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
	// Read the program
	if (firstTime == 1) {
		printf("Loading program '%s'\n\n", filename);
	}
    
	return_value = LoadFileIntoString(filename, &program_source, &src_len);
	if (return_value) {
		printf("Error: Can't load kernel source\n");
        exit(-1);
	}
	
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
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
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
	size_t triangles_buffer_size = sizeof(float) * aligned; //sizeof(float) * (nj*(ni/3));
	
#ifdef DEBUG
	mbeg = mach_absolute_time();
#endif
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
	// Allocate memory and queue it to be written to the device	
	cl_mem gx_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, ngrid_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, gx_mem, CL_TRUE, 0, ngrid_buffer_size, (void*)gx, 0, NULL, NULL);
	
	cl_mem gy_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, ngrid_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, gy_mem, CL_TRUE, 0, ngrid_buffer_size, (void*)gy, 0, NULL, NULL);
	
	cl_mem x1_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, x1_mem, CL_TRUE, 0, triangles_buffer_size, (void*)X1, 0, NULL, NULL);
    
    cl_mem x2_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, x2_mem, CL_TRUE, 0, triangles_buffer_size, (void*)X2, 0, NULL, NULL);
    
    cl_mem x3_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, x3_mem, CL_TRUE, 0, triangles_buffer_size, (void*)X3, 0, NULL, NULL);
    
    cl_mem y1_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, y1_mem, CL_TRUE, 0, triangles_buffer_size, (void*)Y1, 0, NULL, NULL);
    
    cl_mem y2_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, y2_mem, CL_TRUE, 0, triangles_buffer_size, (void*)Y2, 0, NULL, NULL);
    
    cl_mem y3_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, y3_mem, CL_TRUE, 0, triangles_buffer_size, (void*)Y3, 0, NULL, NULL);

    cl_mem z1_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, z1_mem, CL_TRUE, 0, triangles_buffer_size, (void*)Z1, 0, NULL, NULL);
    
    cl_mem z2_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, z2_mem, CL_TRUE, 0, triangles_buffer_size, (void*)Z2, 0, NULL, NULL);
    
    cl_mem z3_mem = clCreateBuffer(context, CL_MEM_READ_ONLY, triangles_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, z3_mem, CL_TRUE, 0, triangles_buffer_size, (void*)Z3, 0, NULL, NULL);
    
	cl_mem grid_mem = clCreateBuffer(context, CL_MEM_READ_WRITE, ngrid_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, grid_mem, CL_TRUE, 0, ngrid_buffer_size, (void*)serialized_griddedData, 0, NULL, NULL);
	
	cl_mem gridMask_mem = clCreateBuffer(context, CL_MEM_READ_WRITE, ngrid_buffer_size_int, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, gridMask_mem, CL_TRUE, 0, ngrid_buffer_size_int, (void*)serialized_gridMaskData, 0, NULL, NULL);
    
    float *output;
    output = floatvec(0, ngrid);    
    cl_mem output_mem = clCreateBuffer(context, CL_MEM_READ_WRITE, ngrid_buffer_size, NULL, NULL);
	err = clEnqueueWriteBuffer(cmd_queue, output_mem, CL_TRUE, 0, ngrid_buffer_size, (void*)output, 0, NULL, NULL);
	
	// Push the data out to the device
	clFinish(cmd_queue);
	
#ifdef DEBUG
	mend = mach_absolute_time();
	cl_alloc = machcore(mend, mbeg);
#endif
    
	//set work-item dimensions
	size_t global_work_size, local_work_size, shared_size;
	global_work_size = ngrid / 4;
	local_work_size = 1;
    shared_size = (9 * local_work_size) * sizeof(float);
	
	// Set kernel arguments
	err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &gx_mem);
	err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &gy_mem);
	err |= clSetKernelArg(kernel, 2, sizeof(cl_mem), &x1_mem);
    err |= clSetKernelArg(kernel, 3, sizeof(cl_mem), &x2_mem);
    err |= clSetKernelArg(kernel, 4, sizeof(cl_mem), &x3_mem);
    err |= clSetKernelArg(kernel, 5, sizeof(cl_mem), &y1_mem);
    err |= clSetKernelArg(kernel, 6, sizeof(cl_mem), &y2_mem);
    err |= clSetKernelArg(kernel, 7, sizeof(cl_mem), &y3_mem);
    err |= clSetKernelArg(kernel, 8, sizeof(cl_mem), &z1_mem);
    err |= clSetKernelArg(kernel, 9, sizeof(cl_mem), &z2_mem);
    err |= clSetKernelArg(kernel, 10, sizeof(cl_mem), &z3_mem);
	err |= clSetKernelArg(kernel, 11, sizeof(cl_mem), &grid_mem);
	err |= clSetKernelArg(kernel, 12, sizeof(cl_mem), &gridMask_mem);
	err |= clSetKernelArg(kernel, 13, sizeof(int), &ni);
	err |= clSetKernelArg(kernel, 14, sizeof(int), &nj);
    err |= clSetKernelArg(kernel, 15, sizeof(int), &aligned);
    err |= clSetKernelArg(kernel, 16, shared_size, NULL);
    err |= clSetKernelArg(kernel, 17, sizeof(cl_mem), &output_mem);
    
#ifdef DEBUG
	mbeg = mach_absolute_time();
#endif
    
    [self isTerminatedThreadData1:data1 data2:data2];
	
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
	
    [self isTerminatedThreadData1:data1 data2:data2];
    
	// Read results data from the device
	err = clEnqueueReadBuffer(cmd_queue, grid_mem, CL_TRUE, 0, ngrid_buffer_size, serialized_griddedData, 0, NULL, NULL);
	err = clEnqueueReadBuffer(cmd_queue, gridMask_mem, CL_TRUE, 0, ngrid_buffer_size_int, serialized_gridMaskData, 0, NULL, NULL);
    err = clEnqueueReadBuffer(cmd_queue, output_mem, CL_TRUE, 0, ngrid_buffer_size, output, 0, NULL, NULL);
    
	clFinish(cmd_queue);
    
//    for (int i=0; i<ngrid; i++) {
//        NSLog(@"%f\n", output[i]);
//    }
    free_fvector(output, 0, ngrid);
    
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
	clReleaseMemObject(x1_mem);
    clReleaseMemObject(x2_mem);
    clReleaseMemObject(x3_mem);
    clReleaseMemObject(y1_mem);
    clReleaseMemObject(y2_mem);
    clReleaseMemObject(y3_mem);
    clReleaseMemObject(z1_mem);
    clReleaseMemObject(z2_mem);
    clReleaseMemObject(z3_mem);
	clReleaseMemObject(grid_mem);
	clReleaseMemObject(gridMask_mem);
    clReleaseMemObject(output_mem);
	
	return CL_SUCCESS;
    
}

-(void)presentDataToUser:(processedDataObject *)processedData {
    
    int i, j, ngrid, colorIndex;
    
    float ratio;
    float max, min;
    
    NSString *str1, *str2, *str3;
        
    // Load the color lookup table
    [self colorTableLookUp];
    
    ngrid = (NX*scaleFactor) * (NY*scaleFactor);
    
    float *scaled_values = floatvec(0, ngrid-1);
    

    if (scaleFactor > 1) {
        
        expand_data(scaled_values, serialized_grid, ngrid, NX, NY, scaleFactor, [processedData scaleMethod]);
        
    } else {
        
        for (i=0; i<ngrid; i++) {
            scaled_values[i] = serialized_grid[i];
        }
    }
    
    max = computemax(scaled_values, ngrid);
    min = computemin(scaled_values, ngrid);
    
    // The pixelValues table contains NX*NY*3 data since we use RGB model
    if ([fieldView isAllocated] == NO) {
        [fieldView allocTablesRows:0 Cols:(ngrid*3)-1];
    }
    
    // Transform data to an color index and assign it to the pixelValues table for each RGB component
    for (i=0,j=0; i<ngrid; i++,j+=3) {
    
        if (scaled_values[i] < min) {
            
            [fieldView setPixelValues:0 index:j];
            [fieldView setPixelValues:0 index:j+1];
            [fieldView setPixelValues:0 index:j+2];
                        
        } else if (scaled_values[i] > max) {
            
            [fieldView setPixelValues:255 index:j];
            [fieldView setPixelValues:255 index:j+1];
            [fieldView setPixelValues:255 index:j+2];
            
        } else {
            
            ratio = 256.0 * ( (scaled_values[i] - min) / (max - min) );
            colorIndex = (int)ratio;            
            [fieldView setPixelValues:(unsigned char)colorIndex index:j];
            [fieldView setPixelValues:(unsigned char)colorIndex index:j+1];
            [fieldView setPixelValues:(unsigned char)colorIndex index:j+2];
        }
    
    }
    
    [fieldView setWidth:(NX*scaleFactor)];
    [fieldView setHeight:(NY*scaleFactor)];
    
    [self drawData];
    
    str1 = [[processedData string1] stringByAppendingFormat:@"%@", [processedData string2]];
    str2 = [NSString stringWithFormat:@"%1.12g",[processedData timing]];
    str3 = [str1 stringByAppendingFormat:@"%@", str2];
    
    [[processedData view] insertText:str3];
    [[processedData view] insertNewlineIgnoringFieldEditor:self];
    
    //[fieldView releaseTablesRows:0 Cols:(ngrid*3)-1];
    
    free_fvector(scaled_values, 0, ngrid-1);
    
}

-(void)colorTableLookUp {

    int i;
    
    for (i=0; i<256; i++) {
        [fieldView setColorTableRed:[colormap red:i] green:[colormap green:i] blue:[colormap blue:i] index:i];
    }
}

-(void)drawData {
    
    [fieldView draw2DField];
}

-(void)memoryReleaseData1:(dataObject *)data1 data2:(processedDataObject *)data2 {
    
    int retval;
    
    /* Close the input netcdf file, freeing all resources. */
    if ((retval = nc_close(ncid2)))
        ERR(retval);
    
    free_f3tensor(griddedData, 0, NT-1, 0, NY-1, 0, NX-1);
    free_i3tensor(gridMask, 0, NT-1, 0, NY-1, 0, NX-1);
    
    free_f3tensor(ElmercoordX, 0, NZ-1, 0, NJ-1, 0, NI-1);
    free_f3tensor(ElmercoordY, 0, NZ-1, 0, NJ-1, 0, NI-1);
    free_f3tensor(zs, 0, NZ-1, 0, NJ-1, 0, NI-1);
    
    free_i3tensor(mask, 0, NZ-1, 0, NJ-1, 0, NI-1);
    free_i3tensor(elements, 0, NZ-1, 0, NJ-1, 0, NI-1);
    
    free_fvector(coordX, 0, NX);
	free_fvector(coordY, 0, NY);
    
    free_fvector(serialized_x, 0, (NX*NY)-1);
    free_fvector(serialized_y, 0, (NX*NY)-1);
    free_fvector(serialized_grid, 0, (NX*NY)-1);
    free_ivector(serialized_gridMask, 0, (NX*NY)-1);
    
    [data1 release];
    [data2 release];
    
}

-(void)isTerminatedThreadData1:(dataObject *)data1 data2:(processedDataObject *)data2 {
    
    if ([[NSThread currentThread] isCancelled]) {
        
        NSLog(@"Terminating now!!!\n");
        [self memoryReleaseData1:data1 data2:data2];
        [NSThread exit];
    }
    
}

-(void)manageFailure:(dataObject *)data {
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", [data message]];
    [alert beginSheetModalForWindow:[[data view] window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
    
}

-(void)handleColorMapChange:(NSNotification *)note {
    
    int tag;
    tag = [[[note userInfo] objectForKey:@"MenuTag"] intValue];
    
    // Get red, green and blue components from color table
    switch (tag) {
        case 1:
            [colormap setRed:cmap_3gauss];
            [colormap setGreen:cmap_3gauss];
            [colormap setBlue:cmap_3gauss];
            break;
            
        case 2:
            [colormap setRed:cmap_3saw];
            [colormap setGreen:cmap_3saw];
            [colormap setBlue:cmap_3saw];
            break;
            
        case 3:
            [colormap setRed:cmap_banded];
            [colormap setGreen:cmap_banded];
            [colormap setBlue:cmap_banded];
            break;
            
        case 4:
            [colormap setRed:cmap_blue_red1];
            [colormap setGreen:cmap_blue_red1];
            [colormap setBlue:cmap_blue_red1];
            break;
            
        case 5:
            [colormap setRed:cmap_blue_red2];
            [colormap setGreen:cmap_blue_red2];
            [colormap setBlue:cmap_blue_red2];
            break;
        
        case 6:
            [colormap setRed:cmap_bright];
            [colormap setGreen:cmap_bright];
            [colormap setBlue:cmap_bright];
            break;
            
        case 7:
            [colormap setRed:cmap_bw];
            [colormap setGreen:cmap_bw];
            [colormap setBlue:cmap_bw];
            break;
            
        case 8:
            [colormap setRed:cmap_default];
            [colormap setGreen:cmap_default];
            [colormap setBlue:cmap_default];
            break;
            
        case 9:
            [colormap setRed:cmap_detail];
            [colormap setGreen:cmap_detail];
            [colormap setBlue:cmap_detail];
            break;
        
        case 10:
            [colormap setRed:cmap_extrema];
            [colormap setGreen:cmap_extrema];
            [colormap setBlue:cmap_extrema];
            break;
            
        case 11:
            [colormap setRed:cmap_helix];
            [colormap setGreen:cmap_helix];
            [colormap setBlue:cmap_helix];
            break;
            
        case 12:
            [colormap setRed:cmap_helix2];
            [colormap setGreen:cmap_helix2];
            [colormap setBlue:cmap_helix2];
            break;
            
        case 13:
            [colormap setRed:cmap_hotres];
            [colormap setGreen:cmap_hotres];
            [colormap setBlue:cmap_hotres];
            break;
            
        case 14:
            [colormap setRed:cmap_jaisn2];
            [colormap setGreen:cmap_jaisn2];
            [colormap setBlue:cmap_jaisn2];
            break;
            
        case 15:
            [colormap setRed:cmap_jaisnb];
            [colormap setGreen:cmap_jaisnb];
            [colormap setBlue:cmap_jaisnb];
            break;
            
        case 16:
            [colormap setRed:cmap_jaisnc];
            [colormap setGreen:cmap_jaisnc];
            [colormap setBlue:cmap_jaisnc];
            break;
            
        case 17:
            [colormap setRed:cmap_jaisnd];
            [colormap setGreen:cmap_jaisnd];
            [colormap setBlue:cmap_jaisnd];
            break;
            
        case 18:
            [colormap setRed:cmap_jaison];
            [colormap setGreen:cmap_jaison];
            [colormap setBlue:cmap_jaison];
            break;
            
        case 19:
            [colormap setRed:cmap_jet];
            [colormap setGreen:cmap_jet];
            [colormap setBlue:cmap_jet];
            break;
            
        case 20:
            [colormap setRed:cmap_manga];
            [colormap setGreen:cmap_manga];
            [colormap setBlue:cmap_manga];
            break;
            
        case 21:
            [colormap setRed:cmap_rainbow];
            [colormap setGreen:cmap_rainbow];
            [colormap setBlue:cmap_rainbow];
            break;
            
        case 22:
            [colormap setRed:cmap_roullet];
            [colormap setGreen:cmap_roullet];
            [colormap setBlue:cmap_roullet];
            break;
            
        case 23:
            [colormap setRed:cmap_ssec];
            [colormap setGreen:cmap_ssec];
            [colormap setBlue:cmap_ssec];
            break;
            
        case 24:
            [colormap setRed:cmap_wheel];
            [colormap setGreen:cmap_wheel];
            [colormap setBlue:cmap_wheel];
            break;
            
    }
    
}

-(void)handleScaleFactorChange:(NSNotification *)note {
    
    int tag, prevTag, ngrid;
    int nx, ny;
    tag = [[[note userInfo] objectForKey:@"MenuTag"] intValue];
    prevTag = [[[note userInfo] objectForKey:@"PrevMenuTag"] intValue];
    
    nx = ( ( (int)[[[note userInfo] objectForKey:@"HorizMax"] floatValue] - (int)[[[note userInfo] objectForKey:@"HorizMin"] floatValue] ) / [[[note userInfo] objectForKey:@"SpaceRes"] intValue] ) + 1;
    ny = ( ( (int)[[[note userInfo] objectForKey:@"VertMax"] floatValue] - (int)[[[note userInfo] objectForKey:@"VertMin"] floatValue] ) / [[[note userInfo] objectForKey:@"SpaceRes"] intValue] ) + 1;
    
    switch (prevTag) {
        case 1:
            if ([fieldView isAllocated] == YES) [fieldView releaseTablesRows:0 Cols:(((nx*1) * (ny*1))*3)-1];
            break;
        case 2:
            if ([fieldView isAllocated] == YES) [fieldView releaseTablesRows:0 Cols:(((nx*2) * (ny*2))*3)-1];
            break;
        case 3:
            if ([fieldView isAllocated] == YES) [fieldView releaseTablesRows:0 Cols:(((nx*4) * (ny*4))*3)-1];
            break;
        case 4:
            if ([fieldView isAllocated] == YES) [fieldView releaseTablesRows:0 Cols:(((nx*6) * (ny*6))*3)-1];
            break;
        case 5:
            if ([fieldView isAllocated] == YES) [fieldView releaseTablesRows:0 Cols:(((nx*8) * (ny*8))*3)-1];
            break;
    }    
    
    switch (tag) {
        case 1:
            scaleFactor = 1;
            ngrid = (nx*scaleFactor) * (ny*scaleFactor);
            [fieldView allocTablesRows:0 Cols:(ngrid*3)-1];
            break;
        case 2:
            scaleFactor = 2;
            ngrid = (nx*scaleFactor) * (ny*scaleFactor);
            [fieldView allocTablesRows:0 Cols:(ngrid*3)-1];
            break;
            
        case 3:
            scaleFactor = 4;
            ngrid = (nx*scaleFactor) * (ny*scaleFactor);
            [fieldView allocTablesRows:0 Cols:(ngrid*3)-1];
            break;
            
        case 4:
            scaleFactor = 6;
            ngrid = (nx*scaleFactor) * (ny*scaleFactor);
            [fieldView allocTablesRows:0 Cols:(ngrid*3)-1];
            break;
            
        case 5:
            scaleFactor = 8;
            ngrid = (nx*scaleFactor) * (ny*scaleFactor);
            [fieldView allocTablesRows:0 Cols:(ngrid*3)-1];
            break;
    }
    
}

-(void)dealloc {
    
    [colormap release];
    [fieldView release];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    [super dealloc];
}

@end
