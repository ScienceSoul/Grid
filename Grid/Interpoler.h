//
//  Interpoler.h
//  Grid
//
//  Created by Hakime Seddik on 13/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "dataObject.h"
#import "processedDataObject.h"

@interface Interpoler : NSObject {
    
    FILE *f1;
    int NX, NY, NT;
    int NI, NJ, NZ;
    int ncid2;
    int incrTime, step;
    
    float ***ElmercoordX, ***ElmercoordY, ***zs;
    int ***mask, ***elements;
    
    float ***griddedData;
    int ***gridMask;
    float *serialized_grid;
    int *serialized_gridMask;
    
    float *coordX, *coordY;
    float *serialized_x, *serialized_y;
    
    NSString *headerString;
    NSString *cpuGridString;
    NSString *cpuLoopString;
    NSString *gcdGridString;
    NSString *gcdLoopString;
    NSString *openclGridString;
    NSString *openclLoopString;
    
}

-(void)getInputFile: (NSArray *)arg: (NSTextView *)view;
-(void)LoadNETCDFFile: (NSArray *)arg: (NSTextView *)view;
-(BOOL)dataRead: (int)i: (char*)var_in: (char*)var_in2: (char*)var_in3: (char*)var_out: (int*)nb_var_in;
-(void)prepareData: (dataObject *)data;
-(void)GCDCompute: (dataObject *)data;
-(void)SerialCompute: (dataObject *)data;
-(void)OpenCLCompute: (dataObject *)data;
-(void)Serial_work_function: (float ***)grid1: (int ***)grid2: (int)t: (float ***)entry1: (float *)entry2: (float *)entry3: (int)N1: (int)N2: (int)N3: (int)N4: (dataObject *)data1: (processedDataObject *)data2;
-(void)GCD_work_function: (float ***)grid1: (int ***)grid2: (int)t: (float ***)entry1: (float *)entry2: (float *)entry3: (int)N1: (int)N2: (int)N3: (int)N4: (dataObject *)data1: (processedDataObject *)data2; 
-(int)exec_kernel: (float *)gx: (float *)gy: (float *)triangles: (float *)serialized_griddedData: (int *)serialized_gridMaskData :(int)ngrid: (int)ni: (int)nj: (const char *)filename: (int)firstTime: (dataObject *)data1: (processedDataObject *)data2; 


-(void)presentDataToUser: (processedDataObject *)processedData;
-(void)memoryRelease: (dataObject *)data1: (processedDataObject *)data2;
-(void)isTerminatedThread: (dataObject *)data1: (processedDataObject *)data2;

@end
