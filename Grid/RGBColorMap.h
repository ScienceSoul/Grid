//
//  RGBColorMap.h
//  Grid
//
//  Created by Hakime Seddik on 21/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "memory.h"

@interface RGBColorMap : NSObject {
    
    unsigned char *red;
    unsigned char *green;
    unsigned char *blue;
    char *colormap_name;
    int nb_colors;
}

-(void)setRed: (int *)data;
-(void)setGreen: (int *)data;
-(void)setBlue: (int *)data;
-(void)setColormap_name: (char *)name;

-(unsigned char)red: (int)i;
-(unsigned char)green: (int)i;
-(unsigned char)blue: (int)i;
-(char *)colormap_name;
-(void)setNb_colors: (int)i;
-(int)nb_colors;

@end
