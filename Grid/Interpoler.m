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

#import "RGBColorMap.h"
#import "ScalarDataView.h"
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
        headerString = [NSString stringWithString:@"Grid(Interpoler): "];
    }
    
    return self;
}

-(void)getInputFile:(NSArray *)arg :(NSTextView *)view{
    
    NSString *string;
    
    if ([arg count]-1 == 7) {
        f1 = fopen([[arg objectAtIndex:3] cStringUsingEncoding:NSASCIIStringEncoding], "r");
    } else {
        f1 = fopen([[arg objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
    }
    if(!f1) {
        NSLog(@"Fata Error: Input file not found\n");
        exit(-1);
    }
    
    if ([arg count]-1 == 7) {
        string = [headerString stringByAppendingFormat:[arg objectAtIndex:3]];
        [view insertText: string];
        [view insertNewlineIgnoringFieldEditor:self];
    } else {
        string = [headerString stringByAppendingFormat:[arg objectAtIndex:2]];
        [view insertText:string];
        [view insertNewlineIgnoringFieldEditor:self];
    }

}

-(void)LoadNETCDFFile:(NSArray *)arg :(NSTextView *)view {
    
    int nc1d;
    int retval;
    size_t length;
    NSString *string;
    
    if ([arg count]-1 == 7) {
        if ((retval = nc_open([[arg objectAtIndex:4] cStringUsingEncoding:NSASCIIStringEncoding], NC_NOWRITE, &ncid2)))
            ERR(retval);
    } else {
        if ((retval = nc_open([[arg objectAtIndex:3] cStringUsingEncoding:NSASCIIStringEncoding], NC_NOWRITE, &ncid2)))
            ERR(retval);
    }
    
    /* Retrieve some informations dimensions size */
    if ((retval = nc_inq_dimid(ncid2, "x", &nc1d) ))
        ERR(retval);
    
    if ((retval = nc_inq_dimlen(ncid2, nc1d, &length) ))
        ERR(retval);
    
    NJ = (int) length;
    
    if ((retval = nc_inq_dimid(ncid2, "y", &nc1d) ))
        ERR(retval);
    
    if ((retval = nc_inq_dimlen(ncid2, nc1d, &length) ))
        ERR(retval);
    
    NI = (int) length;
    
    if ((retval = nc_inq_dimid(ncid2, "time", &nc1d) ))
        ERR(retval);
    
    if ((retval = nc_inq_dimlen(ncid2, nc1d, &length) ))
        ERR(retval);
    
    NZ = (int) length;	
    
    if ([arg count]-1 == 7) {
        string = [headerString stringByAppendingFormat:[arg objectAtIndex:4]];
        [view insertText: string];
        [view insertNewlineIgnoringFieldEditor:self];
    } else {
        string = [headerString stringByAppendingFormat:[arg objectAtIndex:3]];
        [view insertText:string];
        [view insertNewlineIgnoringFieldEditor:self];
    }
    
    NSLog(@"*** SUCCESS loading input NETCDF file!\n");

}

-(BOOL)dataRead:(int)i :(char *)var_in :(char *)var_in2 :(char *)var_in3 :(char *)var_out :(int *)nb_var_in {
    
    int x, y, z;
    int retval;
    int varid, varid2, varid3;
    
    float ***buffer1, ***buffer2, ***buffer3;
    
    fscanf(f1,"%s %d %s %s %s\n", var_out, &nb_var_in[i], var_in, var_in2, var_in3);
    if (var_out[0] == '#') return NO;
    
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
    
    if ((retval = nc_inq_varid(ncid2, "xcoord", &varid)))
        ERR(retval);
    if ((retval = nc_get_var_float(ncid2, varid, &ElmercoordX[0][0][0])))
        ERR(retval);
    
    if ((retval = nc_inq_varid(ncid2, "ycoord", &varid)))
        ERR(retval);
    if ((retval = nc_get_var_float(ncid2, varid, &ElmercoordY[0][0][0])))
        ERR(retval);
    
    if (nb_var_in[i] > 3 || nb_var_in[i] < 1) {
        
        NSLog(@"Error: Maximum supported input variables at once in order to create one single output variable is 3\n");
        NSLog(@"Error: Mimumn input variable to create one single output variable is 1\n");
        exit(-1);
    } else if (nb_var_in[i] > 1 && nb_var_in[i] <= 3) {
        
        switch (nb_var_in[i]) {
                
            case 2:
                
                buffer1 = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
                buffer2 = f3tensor(0, NZ-1, 0, NJ-1, 0, NI-1);
                
                if ((retval = nc_inq_varid(ncid2, var_in, &varid)))
                    ERR(retval);
                if ((retval = nc_get_var_float(ncid2, varid, &buffer1[0][0][0])))
                    ERR(retval);
                
                if ((retval = nc_inq_varid(ncid2, var_in2, &varid2)))
                    ERR(retval);
                if ((retval = nc_get_var_float(ncid2, varid2, &buffer2[0][0][0])))
                    ERR(retval);
                
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

                if ((retval = nc_inq_varid(ncid2, var_in, &varid)))
                    ERR(retval);
                if ((retval = nc_get_var_float(ncid2, varid, &buffer1[0][0][0])))
                    ERR(retval);
                
                if ((retval = nc_inq_varid(ncid2, var_in2, &varid2)))
                    ERR(retval);
                if ((retval = nc_get_var_float(ncid2, varid2, &buffer2[0][0][0])))
                    ERR(retval);
                
                if ((retval = nc_inq_varid(ncid2, var_in3, &varid3)))
                    ERR(retval);
                if ((retval = nc_get_var_float(ncid2, varid3, &buffer3[0][0][0])))
                    ERR(retval);
                
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
    else if (nb_var_in[i] == 1) {
        
        if ((retval = nc_inq_varid(ncid2, var_in, &varid)))
            ERR(retval);
        if ((retval = nc_get_var_float(ncid2, varid, &zs[0][0][0])))
            ERR(retval);
        
    }
    
    if ((retval = nc_inq_varid(ncid2, "mask", &varid)))
        ERR(retval);
    if ((retval = nc_get_var_int(ncid2, varid, &mask[0][0][0])))
        ERR(retval);
    
    if ((retval = nc_inq_varid(ncid2, "elements", &varid)))
        ERR(retval);
    if ((retval = nc_get_var_int(ncid2, varid, &elements[0][0][0])))
        ERR(retval);
    
    return YES;
    
}

-(void)prepareData:(dataObject *)data {
    
    FILE *f2;
    int i, k;
    int ngrid;
    float xyrange[2][2];
    
    NSRange subRange;
    
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    
    if ([arguments count]-1 == 7) { 
        
        NT = [[arguments objectAtIndex:5] intValue];
        
    } else {
        
        NT = [[arguments objectAtIndex:4] intValue];
        
    }
    
    if ([arguments count]-1 == 7) { 
        
        if ([[arguments objectAtIndex:1] isEqualToString:@"Jakobshavn"]) {
            
            // Verify first that we are opening the proper file
            subRange = [[arguments objectAtIndex:2] rangeOfString:@"jis.sif"];
            
            if (subRange.location == NSNotFound) { 
                NSLog(@"Fatal Error: Input file for coordinates not consistent with domain name\n"); 
                exit(-1);
            }
            
            f2 = fopen([[arguments objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
            if(!f2) {
                NSLog(@"Fatal Error: File %@ not found\n", [arguments objectAtIndex:2]);
                exit(-1);
            }
        } 
        else if ([[arguments objectAtIndex:1] isEqualToString:@"Kangerdlussuaq"]) {
            
            subRange = [[arguments objectAtIndex:2] rangeOfString:@"kl.sif"];
            
            if (subRange.location == NSNotFound) { 
                NSLog(@"Fatal Error: Input file for coordinates not consistent with domain name\n"); 
                exit(-1);
            }
            
            f2 = fopen([[arguments objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
            if(!f2) {
                NSLog(@"Fatal Error: File %@ not found\n", [arguments objectAtIndex:2]);
                exit(-1);
            }
        }
        else if ([[arguments objectAtIndex:1] isEqualToString:@"Helheim"]) {
            
            subRange = [[arguments objectAtIndex:2] rangeOfString:@"hh.sif"];
            
            if (subRange.location == NSNotFound) { 
                NSLog(@"Fatal Error: Input file for coordinates not consistent with domain name\n"); 
                exit(-1);
            }
            
            f2 = fopen([[arguments objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
            if(!f2) {
                NSLog(@"Fatal Error: File %@ not found\n", [arguments objectAtIndex:2]);
                exit(-1);
            }
        }
        else if ([[arguments objectAtIndex:1] isEqualToString:@"Petermann"]) {
            
            subRange = [[arguments objectAtIndex:2] rangeOfString:@"pt.sif"];
            
            if (subRange.location == NSNotFound) { 
                NSLog(@"Fatal Error: Input file for coordinates not consistent with domain name\n"); 
                exit(-1);
            }
            
            f2 = fopen([[arguments objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
            if(!f2) {
                NSLog(@"Fatal Error: File %@ not found\n", [arguments objectAtIndex:2]);
                exit(-1);
            }
        }
        else {
            
            NSLog(@"Fatal Error: Unknown domain type.\n");
            exit(-1);
        }
        
        k=0;
        do {
            
            fscanf(f2,"%f %f\n", &xyrange[k][0], &xyrange[k][1]);
            k++;
        }
        while (!feof(f2)); 
        fclose(f2);
        
        NX = ( ( (int) xyrange[0][1] - (int) xyrange[0][0] ) / 1000 ) + 1;
        NY = ( ( (int) xyrange[1][1] - (int) xyrange[1][0] ) / 1000 ) + 1;
        
    } else {
        
        xyrange[0][0] = [data xmin];
        xyrange[0][1] = [data xmax];
        xyrange[1][0] = [data ymin];
        xyrange[1][1] = [data ymax];
        
        // To do: What we do if we forget to give values?
        
        NX = ( ( (int) xyrange[0][1] - (int) xyrange[0][0] ) / 1000 ) + 1;
        NY = ( ( (int) xyrange[1][1] - (int) xyrange[1][0] ) / 1000 ) + 1;
        
    }
    
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
        
        coordX[i] = coordX[i-1] + 1000.0;

    }
    
    for (i=1;i<NY;i++) {
        
        coordY[i] = coordY[i-1] + 1000.0;
        
    }
    
        
    if ([arguments count]-1 == 7) { 
        
        step = [[arguments objectAtIndex:7] intValue];
        incrTime = [[arguments objectAtIndex:6] intValue]-1;
        
    } else {
        
        step = [[arguments objectAtIndex:6] intValue];
        incrTime = [[arguments objectAtIndex:5] intValue]-1;
        
    }
    
    fclose(f2);
    
}

-(void)SerialCompute:(dataObject *)data {
    
    int l;
    int x, y, z;
    BOOL anyDataRead;
    
    char variable_in[100], variable_in2[100], variable_in3[100], variable_out[100];
    int nbVariablesIn[20];
    
    int xx, yy, ii, jj, k;
    int indx, ngrid;
    float ***triangles;
    
    uint64_t beg, end;
    uint64_t gr_end, gr_beg;
    
    //NSAutoreleasePool* myAutoreleasePool = [[NSAutoreleasePool alloc] init];
    
    processedDataObject *processedData = [[processedDataObject alloc] init];
    
    cpuGridString = [NSString stringWithString:@"CPU Grid(sec): "];
    cpuLoopString = [NSString stringWithString:@"CPU Loop(sec): "];
    
    ngrid = NX * NY;
    
    l = -1;
    
    do {
        
        [self isTerminatedThread:data :processedData];
        
        l++;
        anyDataRead = [self dataRead:l :variable_in :variable_in2 :variable_in3 :variable_out :nbVariablesIn];
        if (anyDataRead == NO) continue;
        
        if (nbVariablesIn[l] > 1 && nbVariablesIn[l] <= 3) {
            
            switch (nbVariablesIn[l]) {
                case 2:
                    NSLog(@"Interpolating SeaRise variable %s from Elmer variables %s and %s:.......\n", variable_out, variable_in, variable_in2);
                    break;
                    
                case 3:
                    NSLog(@"Interpolating SeaRise variable %s from Elmer variables %s, %s and %s:.......\n", variable_out, variable_in, variable_in2, variable_in3);
                    break;
            }
        }
        else if (nbVariablesIn[l] == 1) { 
            NSLog(@"Interpolating SeaRise variable %s from Elmer variable %s:.......\n", variable_out, variable_in);
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
            
            [self isTerminatedThread:data :processedData];
            
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
            
            [self Serial_work_function:griddedData :gridMask :z :triangles :coordX :coordY :NI :NJ :NX :NY :data :processedData];
            
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
            
            // Pass how much we scale data for viewing it
            [processedData setScaleFactor:[data scaleFactor]];
            
            // Pass which scaling method we use
            [processedData setScaleMethod:[data scaleMethod]];
            
            // Pass which colormap we use
            [processedData setColormapFromAppMenu:[data colormapFromAppMenu]];
            
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
        
    } while (!feof(f1));
    
    // If we arrive until here, it means we completed the run so re-change the state of 
    // the interface button so that we are ready for next run
    [[data serialButtonState] setState:NSOffState];

    [self memoryRelease:data :processedData];
    
    //[myAutoreleasePool release];
    
}

-(void)GCDCompute:(dataObject *)data{
    
    int l;
    int x, y, z;
    BOOL anyDataRead;
    
    char variable_in[100], variable_in2[100], variable_in3[100], variable_out[100];
    int nbVariablesIn[20];
    
    int xx, yy, ii, jj, k;
    int indx, ngrid;
    float ***triangles;
    
    uint64_t beg, end;
    uint64_t gr_end, gr_beg;
    
    //NSAutoreleasePool* myAutoreleasePool = [[NSAutoreleasePool alloc] init];
    
    processedDataObject *processedData = [[processedDataObject alloc] init];
    
    gcdGridString = [NSString stringWithString:@"GCD Grid(sec): "];
    gcdLoopString = [NSString stringWithString:@"GCD Loop(sec): "];
    
    ngrid = NX * NY;
    
    l = -1;
    
    do {
        
        [self isTerminatedThread:data :processedData];
        
        l++;
        anyDataRead = [self dataRead:l :variable_in :variable_in2 :variable_in3 :variable_out :nbVariablesIn];
        if (anyDataRead == NO) continue;
        
        if (nbVariablesIn[l] > 1 && nbVariablesIn[l] <= 3) {
            
            switch (nbVariablesIn[l]) {
                case 2:
                    NSLog(@"Interpolating SeaRise variable %s from Elmer variables %s and %s:.......\n", variable_out, variable_in, variable_in2);
                    break;
                    
                case 3:
                    NSLog(@"Interpolating SeaRise variable %s from Elmer variables %s, %s and %s:.......\n", variable_out, variable_in, variable_in2, variable_in3);
                    break;
            }
        }
        else if (nbVariablesIn[l] == 1) { 
            NSLog(@"Interpolating SeaRise variable %s from Elmer variable %s:.......\n", variable_out, variable_in);
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
            
            [self isTerminatedThread:data :processedData];
            
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
            
            [self GCD_work_function:griddedData :gridMask :z :triangles :coordX :coordY :NI :NJ :NX :NY :data :processedData];
            
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
            
            // Pass how much we scale data for viewing it
            [processedData setScaleFactor:[data scaleFactor]];
            
            // Pass which scaling method we use
            [processedData setScaleMethod:[data scaleMethod]];
            
            // Pass which colormap we use
            [processedData setColormapFromAppMenu:[data colormapFromAppMenu]];
            
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
        
    } while (!feof(f1));
    
    // If we arrive until here, it means we completed the run so re-change the state of 
    // the interface button so that we are ready for next run
    [[data gcdSButtonState] setState:NSOffState];

    [self memoryRelease:data :processedData];
    
    //[myAutoreleasePool release];

}

-(void)OpenCLCompute:(dataObject *)data {
    
    int i, j, k, l;
    int z;
    int firstTime;
    BOOL anyDataRead;
    
    char variable_in[100], variable_in2[100], variable_in3[100], variable_out[100];
    int nbVariablesIn[20];
    
    int ii, jj, kk;
    int indx, ngrid;
    float *triangles;
    
    uint64_t beg, end;
    uint64_t gr_end, gr_beg;
    
    //NSAutoreleasePool* workThreadPool = [[NSAutoreleasePool alloc] init];
    
    processedDataObject *processedData = [[processedDataObject alloc] init];
    
    openclGridString = [NSString stringWithString:@"OpenCL Grid(sec): "];
    openclLoopString = [NSString stringWithString:@"OpenCL Loop(sec): "];
          
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
    l = -1;
    
    do {
        
        [self isTerminatedThread:data :processedData];
        
        l++;
        anyDataRead = [self dataRead:l :variable_in :variable_in2 :variable_in3 :variable_out :nbVariablesIn];
        if (anyDataRead == NO) continue;
        
        if (nbVariablesIn[l] > 1 && nbVariablesIn[l] <= 3) {
            
            switch (nbVariablesIn[l]) {
                case 2:
                    NSLog(@"Interpolating SeaRise variable %s from Elmer variables %s and %s:.......\n", variable_out, variable_in, variable_in2);
                    break;
                    
                case 3:
                    NSLog(@"Interpolating SeaRise variable %s from Elmer variables %s, %s and %s:.......\n", variable_out, variable_in, variable_in2, variable_in3);
                    break;
            }
        }
        else if (nbVariablesIn[l] == 1) { 
            NSLog(@"Interpolating SeaRise variable %s from Elmer variable %s:.......\n", variable_out, variable_in);
        }
        
        triangles = floatvec(0, (NJ*(NI/3)*12)-1 );
        
        beg = mach_absolute_time();
        
        for (z=0; z<NT; z++) {
            
            [self isTerminatedThread:data :processedData];
            
            for(ii=0; ii<ngrid; ii++) {
                serialized_grid[ii] = 0.0;
                serialized_gridMask[ii] = -1;
            }
            
            for (ii = 0; ii<(NJ*(NI/3)*12); ii++){
                triangles[ii] = 0.0;
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
            
            gr_beg = mach_absolute_time();
            
            [self exec_kernel:serialized_x :serialized_y :triangles :serialized_grid :serialized_gridMask :ngrid :NI :NJ :"interpolate.cl" :firstTime :data :processedData];
            
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
            
            // Pass how much we scale data for viewing it
            [processedData setScaleFactor:[data scaleFactor]];
            
            // Pass which scaling method we use
            [processedData setScaleMethod:[data scaleMethod]];
            
            // Pass which colormap we use
            [processedData setColormapFromAppMenu:[data colormapFromAppMenu]];
            
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
        
    } while (!feof(f1));
    
    
    // If we arrive until here, it means we completed the run so re-change the state of 
    // the interface button so that we are ready for next run
    [[data openclButtonState] setState:NSOffState];
    
    [self memoryRelease:data :processedData];
    
    //[myAutoreleasePool release];
    
}

-(void)Serial_work_function:(float ***)grid1 :(int ***)grid2 :(int)t :(float ***)entry1 :(float *)entry2 :(float *)entry3 :(int)N1 :(int)N2 :(int)N3 :(int)N4 :(dataObject *)data1 :(processedDataObject *)data2 {
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
        
        [self isTerminatedThread:data1 :data2];
        
		for (ii=0;ii<10;ii++) {
			for (jj=0;jj<2;jj++) {
				foundTriangles[ii][jj] = 0;
			}
		}
		
		for (xx=0; xx<N3; xx++) {
            
            [self isTerminatedThread:data1 :data2];
			
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

-(void)GCD_work_function:(float ***)grid1 :(int ***)grid2 :(int)t :(float ***)entry1 :(float *)entry2 :(float *)entry3 :(int)N1 :(int)N2 :(int)N3 :(int)N4 :(dataObject *)data1 :(processedDataObject *)data2 {
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

-(int)exec_kernel:(float *)gx :(float *)gy :(float *)triangles :(float *)serialized_griddedData :(int *)serialized_gridMaskData :(int)ngrid :(int)ni :(int)nj :(const char *)filename :(int)firstTime :(dataObject *)data1 :(processedDataObject *)data2 {
    
    cl_context         context;
	
	cl_command_queue   cmd_queue;
	cl_device_id       devices;
	
	cl_int             err;
	
	size_t src_len;
	int return_value;
	char *program_source;
	
    [self isTerminatedThread:data1 :data2];
    
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
	
    [self isTerminatedThread:data1 :data2];
    
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
	
    [self isTerminatedThread:data1 :data2];
    
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
	
    [self isTerminatedThread:data1 :data2];
    
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
	err |= clSetKernelArg(kernel, 5, sizeof(int), &ni);
	err |= clSetKernelArg(kernel, 6, sizeof(int), &nj);
	
	
#ifdef DEBUG
	mbeg = mach_absolute_time();
#endif
    
    [self isTerminatedThread:data1 :data2];
	
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
	
    [self isTerminatedThread:data1 :data2];
    
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


-(void)presentDataToUser:(processedDataObject *)processedData {
    
    int i, j, ngrid, colorIndex;
    
    float ratio;
    float max, min;
    
    NSString *str1, *str2, *str3;
    
    RGBColorMap *colormap = [[RGBColorMap alloc] init];
    ScalarDataView *fieldView = [[ScalarDataView alloc] init];
        
    // Get red, green and blue components from color table
    if ([processedData colormapFromAppMenu] == 8) {
        
        [colormap setRed:cmap_default];
        [colormap setGreen:cmap_default];
        [colormap setBlue:cmap_default];

    } else if ([processedData colormapFromAppMenu] == 1) {
        
        [colormap setRed:cmap_3gauss];
        [colormap setGreen:cmap_3gauss];
        [colormap setBlue:cmap_3gauss];
    } else if ([processedData colormapFromAppMenu] == 2) {
        
        [colormap setRed:cmap_3saw];
        [colormap setGreen:cmap_3saw];
        [colormap setBlue:cmap_3saw];
    } else if ([processedData colormapFromAppMenu] == 3) {
        
        [colormap setRed:cmap_banded];
        [colormap setGreen:cmap_banded];
        [colormap setBlue:cmap_banded];
    } else if ([processedData colormapFromAppMenu] == 4) {
        
        [colormap setRed:cmap_blue_red1];
        [colormap setGreen:cmap_blue_red1];
        [colormap setBlue:cmap_blue_red1];
    } else if ([processedData colormapFromAppMenu] == 5) {
        
        [colormap setRed:cmap_blue_red2];
        [colormap setGreen:cmap_blue_red2];
        [colormap setBlue:cmap_blue_red2];
    } else if ([processedData colormapFromAppMenu] == 6) {
        
        [colormap setRed:cmap_bright];
        [colormap setGreen:cmap_bright];
        [colormap setBlue:cmap_bright];
    } else if ([processedData colormapFromAppMenu] == 7) {
        
        [colormap setRed:cmap_bw];
        [colormap setGreen:cmap_bw];
        [colormap setBlue:cmap_bw];
    } else if ([processedData colormapFromAppMenu] == 9) {
        
        [colormap setRed:cmap_detail];
        [colormap setGreen:cmap_detail];
        [colormap setBlue:cmap_detail];
    } else if ([processedData colormapFromAppMenu] == 10) {
        
        [colormap setRed:cmap_extrema];
        [colormap setGreen:cmap_extrema];
        [colormap setBlue:cmap_extrema];
    } else if ([processedData colormapFromAppMenu] == 11) {
        
        [colormap setRed:cmap_helix];
        [colormap setGreen:cmap_helix];
        [colormap setBlue:cmap_helix];
    } else if ([processedData colormapFromAppMenu] == 12) {
        
        [colormap setRed:cmap_helix2];
        [colormap setGreen:cmap_helix2];
        [colormap setBlue:cmap_helix2];
    } else if ([processedData colormapFromAppMenu] == 13) {
    
        [colormap setRed:cmap_hotres];
        [colormap setGreen:cmap_hotres];
        [colormap setBlue:cmap_hotres];
    } else if ([processedData colormapFromAppMenu] == 14) {
        
        [colormap setRed:cmap_jaisn2];
        [colormap setGreen:cmap_jaisn2];
        [colormap setBlue:cmap_jaisn2];
    } else if ([processedData colormapFromAppMenu] == 15) {
        
        [colormap setRed:cmap_jaisnb];
        [colormap setGreen:cmap_jaisnb];
        [colormap setBlue:cmap_jaisnb];
    } else if ([processedData colormapFromAppMenu] == 16) {
        
        [colormap setRed:cmap_jaisnc];
        [colormap setGreen:cmap_jaisnc];
        [colormap setBlue:cmap_jaisnc];
    } else if ([processedData colormapFromAppMenu] == 17) {
        
        [colormap setRed:cmap_jaisnd];
        [colormap setGreen:cmap_jaisnd];
        [colormap setBlue:cmap_jaisnd];
    } else if ([processedData colormapFromAppMenu] == 18) {
        
        [colormap setRed:cmap_jaison];
        [colormap setGreen:cmap_jaison];
        [colormap setBlue:cmap_jaison];
    } else if ([processedData colormapFromAppMenu] == 19) {
        
        [colormap setRed:cmap_jet];
        [colormap setGreen:cmap_jet];
        [colormap setBlue:cmap_jet];
    } else if ([processedData colormapFromAppMenu] == 20) {
        
        [colormap setRed:cmap_manga];
        [colormap setGreen:cmap_manga];
        [colormap setBlue:cmap_manga];
    } else if ([processedData colormapFromAppMenu] == 21) {
        
        [colormap setRed:cmap_rainbow];
        [colormap setGreen:cmap_rainbow];
        [colormap setBlue:cmap_rainbow];
    } else if ([processedData colormapFromAppMenu] == 22) {
        
        [colormap setRed:cmap_roullet];
        [colormap setGreen:cmap_roullet];
        [colormap setBlue:cmap_roullet];
    } else if ([processedData colormapFromAppMenu] == 23) {
        
        [colormap setRed:cmap_ssec];
        [colormap setGreen:cmap_ssec];
        [colormap setBlue:cmap_ssec];
    } else if ([processedData colormapFromAppMenu] == 24) {
        
        [colormap setRed:cmap_wheel];
        [colormap setGreen:cmap_wheel];
        [colormap setBlue:cmap_wheel];
    }
    
    // Load the color lookup table
    for (i=0; i<256; i++) {
        
        [fieldView setColorTable:[colormap red:i] :[colormap green:i] :[colormap blue:i] :i];
    
    }
    
    ngrid = (NX*[processedData scaleFactor]) * (NY*[processedData scaleFactor]);
    
    float *scaled_values = floatvec(0, ngrid-1);
    

    if ([processedData scaleFactor] > 1) {
        
        expand_data(scaled_values, serialized_grid, ngrid, NX, NY, [processedData scaleFactor], [processedData scaleMethod]);
        
    } else {
        
        for (i=0; i<ngrid; i++) {
            scaled_values[i] = serialized_grid[i];
        }
    }
    
    max = computemax(scaled_values, ngrid);
    min = computemin(scaled_values, ngrid);
    
    // The pixelValues table contains NX*NY*3 data since we use RGB model
    [fieldView allocTables:0 :(ngrid*3)-1];
    
    // Transform data to an color index and assign it to the pixelValues table for each RGB component
    for (i=0,j=0; i<ngrid; i++,j+=3) {
    
        if (scaled_values[i] < min) {
            
            [fieldView setPixelValues:0 :j];
            [fieldView setPixelValues:0 :j+1];
            [fieldView setPixelValues:0 :j+2];
                        
        } else if (scaled_values[i] > max) {
            
            [fieldView setPixelValues:255 :j];
            [fieldView setPixelValues:255 :j+1];
            [fieldView setPixelValues:255 :j+2];
            
        } else {
            
            ratio = 256.0 * ( (scaled_values[i] - min) / (max - min) );
            colorIndex = (int)ratio;
            [fieldView setPixelValues:(unsigned char)colorIndex :j];
            [fieldView setPixelValues:(unsigned char)colorIndex :j+1];
            [fieldView setPixelValues:(unsigned char)colorIndex :j+2];
            
        }
    
    }
    
    [fieldView setWidth:(NX*[processedData scaleFactor])];
    [fieldView setHeight:(NY*[processedData scaleFactor])];
    
    [fieldView draw2DField];
    
    str1 = [[processedData string1] stringByAppendingFormat:[processedData string2]];
    str2 = [NSString stringWithFormat:@"%1.12g",[processedData timing]];
    str3 = [str1 stringByAppendingFormat:str2];
    
    [[processedData view] insertText:str3];
    [[processedData view] insertNewlineIgnoringFieldEditor:self];
    
    [fieldView releaseTables:0 :(ngrid*3)-1];
    [colormap release];
    [fieldView release];
    
    free_fvector(scaled_values, 0, ngrid-1);
    
}

-(void)memoryRelease:(dataObject *)data1 :(processedDataObject *)data2 {
    
    int retval;
    
    fclose(f1);
    
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

-(void)isTerminatedThread:(dataObject *)data1 :(processedDataObject *)data2 {
    
    if ([[NSThread currentThread] isCancelled]) {
        
        [self memoryRelease:data1 :data2];
        [NSThread exit];
    }
    
}



@end
