//
//  Interpoler.h
//  Grid
//
//  Created by Hakime Seddik on 13/09/11.
//  Copyright © 2011 ScienceSoul. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "dataObject.h"
#import "processedDataObject.h"
#import "RGBColorMap.h"
#import "ScalarDataView.h"

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
    
    int scaleFactor;
    RGBColorMap *colormap;
    ScalarDataView *fieldView;
    
    NSString *headerString;
    NSString *cpuGridString;
    NSString *cpuLoopString;
    NSString *gcdGridString;
    NSString *gcdLoopString;
    NSString *openclGridString;
    NSString *openclLoopString;
    
}

-(BOOL)dataReadVarIn:(const char *)var_in varIn2:(const char *)var_in2 varIn3:(const char *)var_in3 varOut:(const char *)var_out NbVarIn:(int)nb_var_in data:(dataObject *)data;
-(BOOL)prepareData: (dataObject *)data;
-(void)GCDCompute: (dataObject *)data;
-(void)SerialCompute: (dataObject *)data;
-(void)OpenCLCompute: (dataObject *)data;
-(void)Serial_work_functionGrid1:(float ***)grid1 grid2:(int ***)grid2 t:(int)t entry1:(float ***)entry1 entry2:(float *)entry2 entry3:(float *)entry3 N1:(int)N1 N2:(int)N2 N3:(int)N3 N4:(int)N4 data1:(dataObject *)data1 data2:(processedDataObject *)data2;
-(void)GCD_work_functionGrid1:(float ***)grid1 grid2:(int ***)grid2 t:(int)t entry1:(float ***)entry1 entry2:(float *)entry2 entry3:(float *)entry3 N1:(int)N1 N2:(int)N2 N3:(int)N3 N4:(int)N4 data1:(dataObject *)data1 data2:(processedDataObject *)data2;
-(int)exec_kernelgx:(float *)gx gy:(float *)gy triangles:(float *)triangles serializedGriddedData:(float *)serialized_griddedData serializedGridMaskData:(int *)serialized_gridMaskData ngrid:(int)ngrid ni:(int)ni nj:(int)nj filename:(const char *)filename firstTime:(int)firstTime data1:(dataObject *)data1 data2:(processedDataObject *)data2;
-(int)exec_kernel_optgx:(float *)gx gy:(float *)gy X1:(float *)X1 X2:(float *)X2 X3:(float *)X3 Y1:(float *)Y1 Y2:(float *)Y2 Y3:(float *)Y3 Z1:(float *)Z1 Z2:(float *)Z2 Z3: (float *)Z3 aligned:(int)aligned serializedGriddedData:(float *)serialized_griddedData serialized_gridMaskData:(int *)serialized_gridMaskData ngrid:(int)ngrid ni:(int)ni nj: (int)nj filename:(const char *)filename firstTime:(int)firstTime data1:(dataObject *)data1 data2:(processedDataObject *)data2;

-(void)presentDataToUser: (processedDataObject *)processedData;
-(void)colorTableLookUp;
-(void)drawData;
-(void)memoryReleaseData1:(dataObject *)data1 data2:(processedDataObject *)data2;
-(void)isTerminatedThreadData1:(dataObject *)data1 data2:(processedDataObject *)data2;
-(void)manageFailure: (dataObject *)data;

@end
