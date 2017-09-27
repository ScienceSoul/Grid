//
//  ScalarDataView.m
//  Grid
//
//  Created by Hakime Seddik on 13/09/11.
//  Copyright © 2011 ScienceSoul. All rights reserved.
//

#import "ScalarDataView.h"

@implementation ScalarDataView

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here;
    }
    return self;
}

-(void)prepareOpenGL {
    NSOpenGLContext *glContext = [self openGLContext];
    [glContext makeCurrentContext];
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
}

-(void)reshape {
    
    glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

-(void)drawRect:(NSRect)r {
    glFlush();
}

-(void)draw2DField {
    
    NSRect r;
    r = [self frame];
    
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
    glWindowPos2i(0, 0);
    glColorTable(GL_COLOR_TABLE, GL_RGB, 256, GL_RGB, GL_UNSIGNED_BYTE, colorTable);
    glEnable(GL_COLOR_TABLE);
    
    // Draw the pixels
    glDrawPixels([self width], [self height], GL_RGB, GL_UNSIGNED_BYTE, pixelValues);

    [self drawRect:r];
    
    glDisable(GL_COLOR_TABLE);
}

-(void)setColorTableRed:(unsigned char)r green:(unsigned char)g blue:(unsigned char)b index:(int)i {
    
        colorTable[i][0] = r;
        colorTable[i][1] = g;
        colorTable[i][2] = b;
}

-(void)setPixelValues:(GLubyte)val index:(int)i {
    
    pixelValues[i] = val;
}

-(void)setWidth:(int)val {
    
    width = val;
}

-(void)setHeight:(int)val {
    
    height = val;
}

-(int)width {
    
    return width;
}

-(int)height {
    
    return height;
}

-(void)allocTablesRows:(int)nl Cols:(int)nh {
    
    pixelValues = GLubytevec(nl, nh);
}

-(void)releaseTablesRows:(int)nl Cols:(int)nh {
    
    free_GLubytevector(pixelValues, nl, nh);
}


-(BOOL)isAllocated {
    
    if (pixelValues == NULL) {
        return NO;
    } else {
        return YES;
    }
}

@end
