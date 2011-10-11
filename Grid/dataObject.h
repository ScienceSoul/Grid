//
//  dataObject.h
//  Grid
//
//  Created by Hakime Seddik on 15/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataObject : NSObject {
    
    float xmin;
    float xmax;
    float ymin;
    float ymax;
    int scaleFactor;
    int scaleMethod;         // 1: Replication; 2: Bilinear
    int colormapFromAppMenu; // Based on MenuItem tag, see AppController class
    
    struct {
        
        char padding0[64];
        volatile BOOL flag;
        char padding1[64];
        
    } terminated;
    
    NSTextView *view;
    NSButton *serialButtonState;
    NSButton *gcdSButtonState;
    NSButton *openclButtonState;
    
}

-(void)setxmin: (NSTextField *)textfield;
-(void)setxmax: (NSTextField *)textfield;
-(void)setymin: (NSTextField *)textfield;
-(void)setymax:(NSTextField *)textfield;
-(void)setScaleFactor: (int)i;
-(void)setScaleMethod: (int)i;
-(void)setTerminated: (BOOL)flag;
-(void)setview: (NSTextView *)aview;
-(void)setSerialButtonState: (NSButton *)abutton;
-(void)setGcdSButtonState: (NSButton *)abutton;
-(void)setOpenclButtonState: (NSButton *)abutton;
-(void)setColormapFromAppMenu: (int)i;

-(float)xmin;
-(float)xmax;
-(float)ymin;
-(float)ymax;
-(int)scaleFactor;
-(int)scaleMethod;
-(BOOL)terminated;
-(NSTextView *)view;
-(NSButton *)serialButtonState;
-(NSButton *)gcdSButtonState;
-(NSButton *)openclButtonState;
-(int)colormapFromAppMenu;

@end
