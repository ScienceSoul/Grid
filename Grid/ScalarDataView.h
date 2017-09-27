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

-(void)setColorTableRed:(unsigned char)r green:(unsigned char)g blue:(unsigned char)b index:(int)i;
-(void)setPixelValues:(GLubyte)val index:(int)i;
-(void)setWidth: (int)val;
-(void)setHeight: (int)val;
-(int)width;
-(int)height;
-(void)allocTablesRows:(int)nl Cols:(int)nh;
-(void)releaseTablesRows:(int)nl Cols:(int)nh;
-(BOOL)isAllocated;
-(void)draw2DField;

@end
