//
//  RGBColorMap.m
//  Grid
//
//  Created by Hakime Seddik on 21/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import "RGBColorMap.h"

@implementation RGBColorMap

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        red = uns_charvec(0, 255);
        green = uns_charvec(0, 255);
        blue = uns_charvec(0, 255);
    }
    
    return self;
}

-(void)setRed:(int *)data {
    
    int	i;
    
    //NSLog(@"Initializing red component of colormap.\n");
    
    for (i=0; i<256; i++) {
        red[i] = (unsigned char)data[i*3+0];
    }
}


-(void)setGreen:(int *)data {
    
    int	i;
    
    //NSLog(@"Initializing green component of colormap.\n");
    
    for (i=0; i<256; i++) {
        green[i] = (unsigned char)data[i*3+1];
    }
}

-(void)setBlue:(int *)data {
    
    int	i;
    
    //NSLog(@"Initializing green component of colormap.\n");
    
    for (i=0; i<256; i++) {
        blue[i] = (unsigned char)data[i*3+2];
    }
}

-(void)setColormap_name:(char *)name {
    
    colormap_name = name;
}

-(unsigned char)red:(int)i {
    
    return red[i];
}

-(unsigned char)green:(int)i {
    
    return green[i];
}

-(unsigned char)blue:(int)i {
    
    return blue[i];
}

-(char *)colormap_name {
    
    return colormap_name;
}

-(void)setNb_colors:(int)i {
    
    nb_colors = i;
}

-(int)nb_colors {
    
    return nb_colors;
}


-(void)dealloc {
    
    free_uns_cvector(red, 0, 255);
    free_uns_cvector(green, 0, 255);
    free_uns_cvector(blue, 0, 255);
    [super dealloc];
}

@end
