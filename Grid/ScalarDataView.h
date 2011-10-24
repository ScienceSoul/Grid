//
//  ScalarDataView.h
//  Grid
//
//  Created by Hakime Seddik on 13/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLUT/glut.h>

#import "memory.h"

@interface ScalarDataView : NSOpenGLView {
    
    int width, height;             // Width and height of the 2D data field  
    GLubyte colorTable[256][3];    // Color lookup table to use with OpenGL
    GLubyte *pixelValues;          // Contains the index to color lookup table
                                   // of the transformed field data to color values
    
}

-(void)setColorTable: (unsigned char)r: (unsigned char)g: (unsigned char)b: (int)i;
-(void)setPixelValues: (GLubyte)val: (int)i;
-(void)setWidth: (int)val;
-(void)setHeight: (int)val;
-(int)width;
-(int)height;
-(void)allocTables: (int)nl: (int)nh;
-(void)releaseTables: (int)nl: (int)nh;
-(BOOL)isAllocated;

-(void)draw2DField;

@end
