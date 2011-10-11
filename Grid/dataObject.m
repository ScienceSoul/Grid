//
//  dataObject.m
//  Grid
//
//  Created by Hakime Seddik on 15/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import "dataObject.h"

@implementation dataObject

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)setxmin:(NSTextField *)textfield {
    
    xmin = [[textfield stringValue] floatValue];
}

-(void)setxmax:(NSTextField *)textfield {
    
    xmax = [[textfield stringValue] floatValue];
}

-(void)setymin:(NSTextField *)textfield {
    
    ymin = [[textfield stringValue] floatValue];
}

-(void)setymax:(NSTextField *)textfield {
    
    ymax = [[textfield stringValue] floatValue];
}

-(void)setScaleFactor:(int)i {
    
    scaleFactor = i;
}

-(void)setScaleMethod:(int)i {
    
    scaleMethod = i;
}

-(void)setTerminated:(BOOL)flag {
    
    terminated.flag = flag;
}

-(void)setview:(NSTextView *)aview {
    
    view = aview;
}

-(void)setSerialButtonState:(NSButton *)abutton {
    
    serialButtonState = abutton;
}

-(void)setGcdSButtonState:(NSButton *)abutton {
    
    gcdSButtonState = abutton;
}

-(void)setOpenclButtonState:(NSButton *)abutton {
    
    openclButtonState = abutton;
}

-(void)setColormapFromAppMenu:(int)i {
    
    colormapFromAppMenu = i;
}

-(float)xmin {
    
    return xmin;
}

-(float)xmax {
    
    return xmax;
}

-(float)ymin {
    
    return ymin;
}

-(float)ymax {
    
    return ymax;
}

-(int)scaleFactor {
    
    return scaleFactor;
}

-(int)scaleMethod {
    
    return scaleMethod;
}

-(BOOL)terminated {
    
    return terminated.flag;
}

-(NSTextView *)view {
    
    return view;
}

-(NSButton *)serialButtonState {
    
    return serialButtonState;
}

-(NSButton *)gcdSButtonState {
    
    return gcdSButtonState;
}

-(NSButton *)openclButtonState {
    
    return openclButtonState;
}

-(int)colormapFromAppMenu {
    
    return colormapFromAppMenu;
}

@end
