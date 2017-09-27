//
//  dataObject.m
//  Grid
//
//  Created by Hakime Seddik on 15/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import "dataObject.h"

@implementation dataObject

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)setNetCDFFile:(NSString *)string {
    
    netCDFFile = [NSString stringWithString:string];
}

-(void)setVariableName:(NSString *)string {
    
    variableName = [NSString stringWithString:string];
}

-(void)setVariableVar1:(NSString *)string {
    
    variableVar1 = [NSString stringWithString:string];
}

-(void)setVariableVar2:(NSString *)string {
    
    variableVar2 = [NSString stringWithString:string];
}

-(void)setVariableVar3:(NSString *)string {
    
    variableVar3 = [NSString stringWithString:string];
}

-(void)setVariableNB:(int)i {
    
    variableNB = i;
}

-(void)setCoordFocusHorizMin:(float)value {
    
    coordFocusHorizMin = value;
}

-(void)setCoordFocusHorizMax:(float)value {
    
    coordFocusHorizMax = value;
}

-(void)setCoordFocusVertMin:(float)value {
    
    coordFocusVertMin = value;
}

-(void)setCoordFocusVertMax:(float)value {
    
    coordFocusVertMax = value;
}

-(void)setRunInfoSpaceRes:(int)i {
    
    runInfoSpaceRes = i;
}

-(void)setRunInfoTimeLoop:(int)i {
    
    runInfoTimeLoop = i;
}

-(void)setRunInfoStartPos:(int)i {
    
    runInfoStartPos = i;
}

-(void)setRunInfoIncrement:(int)i {
    
    runInfoIncrement = i;
}

-(void)setMessage:(NSString *)string {
    
    message = [NSString stringWithString:string];
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

-(NSString *)netCDFFile {
    
    return netCDFFile;
}

-(NSString *)variableName {
    
    return variableName;
}

-(NSString *)variableVar1 {
    
    return variableVar1;
}

-(NSString *)variableVar2 {
    
    return variableVar2;
}

-(NSString *)variableVar3 {
    
    return variableVar3;
}

-(int)variableNB {
    
    return variableNB;
}

-(float)coordFocusHorizMin {
    
    return coordFocusHorizMin;
}

-(float)coordFocusHorizMax {
    
    return coordFocusHorizMax;
}

-(float)coordFocusVertMin {
    
    return coordFocusVertMin;
}

-(float)coordFocusVertMax {
    
    return coordFocusVertMax;
}

-(int)runInfoSpaceRes {
    
    return runInfoSpaceRes;
}

-(int)runInfoTimeLoop {
    
    return runInfoTimeLoop;
}

-(int)runInfoStartPos {
    
    return runInfoStartPos;
}

-(int)runInfoIncrement {
    
    return runInfoIncrement;
}

-(NSString *)message {
    
    return message;
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

@end
