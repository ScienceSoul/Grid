//
//  processedDataObject.h
//  Grid
//
//  Created by Hakime Seddik on 15/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface processedDataObject : NSObject {
    
    NSString *string1;
    NSString *string2;
    NSTextView* view;
    double timing;
    int scaleFactor;
    int scaleMethod;    // 1: Replicate; 2: Bilinear 
    int colormapFromAppMenu; // Based on MenuItem tag, see AppController class
    
}

-(void)setString1: (NSString *)str;
-(void)setString2: (NSString *)str;
-(NSString *)string1;
-(NSString *)string2;
-(void)setview: (NSTextView *)aview;
-(void)setColormapFromAppMenu: (int)i;

-(NSTextView *)view;
-(void)setTiming: (double)adouble;
-(double)timing;
-(void)setScaleFactor: (int)i;
-(int)scaleFactor;
-(void)setScaleMethod: (int)i;
-(int)scaleMethod;
-(int)colormapFromAppMenu;

@end
