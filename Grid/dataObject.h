//
//  dataObject.h
//  Grid
//
//  Created by Hakime Seddik on 15/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface dataObject : NSObject {
    
    // The following contains the data retrived from
    // the window sheet where the interpolation parameters 
    // are entered. See AppController class.
    
    NSString *netCDFFile;
    NSString *variableName;
    NSString *variableVar1;
    NSString *variableVar2;
    NSString *variableVar3;
    int variableNB;
    float coordFocusHorizMin;
    float coordFocusHorizMax;
    float coordFocusVertMin;
    float coordFocusVertMax;
    int runInfoSpaceRes;
    int runInfoTimeLoop;
    int runInfoStartPos;
    int runInfoIncrement;
    
    int scaleMethod;         // 1: Replication; 2: Bilinear
    
    NSString *message;
    
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

-(void)setNetCDFFile: (NSString *)string;
-(void)setVariableName: (NSString *)string;
-(void)setVariableVar1: (NSString *)string;
-(void)setVariableVar2: (NSString *)string;
-(void)setVariableVar3: (NSString *)string;
-(void)setVariableNB: (int)i;
-(void)setCoordFocusHorizMin: (float)value;
-(void)setCoordFocusHorizMax: (float)value;
-(void)setCoordFocusVertMin: (float)value;
-(void)setCoordFocusVertMax: (float)value;
-(void)setRunInfoSpaceRes: (int)i;
-(void)setRunInfoTimeLoop: (int)i;
-(void)setRunInfoStartPos: (int)i;
-(void)setRunInfoIncrement: (int)i;
-(void)setMessage:(NSString *)string;

-(void)setScaleMethod: (int)i;
-(void)setTerminated: (BOOL)flag;
-(void)setview: (NSTextView *)aview;
-(void)setSerialButtonState: (NSButton *)abutton;
-(void)setGcdSButtonState: (NSButton *)abutton;
-(void)setOpenclButtonState: (NSButton *)abutton;

-(NSString *)netCDFFile;
-(NSString *)variableName;
-(NSString *)variableVar1;
-(NSString *)variableVar2;
-(NSString *)variableVar3;
-(int)variableNB;
-(float)coordFocusHorizMin;
-(float)coordFocusHorizMax;
-(float)coordFocusVertMin;
-(float)coordFocusVertMax;
-(int)runInfoSpaceRes;
-(int)runInfoTimeLoop;
-(int)runInfoStartPos;
-(int)runInfoIncrement;
-(NSString *)message;

-(int)scaleMethod;
-(BOOL)terminated;
-(NSTextView *)view;
-(NSButton *)serialButtonState;
-(NSButton *)gcdSButtonState;
-(NSButton *)openclButtonState;

@end
