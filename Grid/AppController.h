//
//  AppController.h
//  Grid
//
//  Created by Hakime Seddik on 13/09/11.
//  Copyright © 2011 ScienceSoul. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Interpoler.h"
#import "ScalarDataView.h"

@interface AppController : NSObject {
    
    NSThread *workThread;
    NSWindow *dataViewWindow;
    Interpoler *processData;
    ScalarDataView *glView;
    
    float width, height;                  // Width and height of the data view window
    
    IBOutlet NSButton *serialStartStop;
    IBOutlet NSButton *GCDStartStop;
    IBOutlet NSButton *OpenCLStartStop;
    
    IBOutlet NSTextView *consoleView;
    
    IBOutlet NSMenuItem *scale1x;
    IBOutlet NSMenuItem *scale2x;
    IBOutlet NSMenuItem *scale4x;
    IBOutlet NSMenuItem *scale6x;
    IBOutlet NSMenuItem *scale8x;
    
    IBOutlet NSMenuItem *three_gauss;     // Tag: 1 
    IBOutlet NSMenuItem *three_saw;       // Tag: 2
    IBOutlet NSMenuItem *banded;          // Tag: 3
    IBOutlet NSMenuItem *blue_red1;       // Tag: 4
    IBOutlet NSMenuItem *blue_red2;       // Tag: 5
    IBOutlet NSMenuItem *bright;          // Tag: 6
    IBOutlet NSMenuItem *bw;              // Tag: 7
    IBOutlet NSMenuItem *deflt;           // Tag: 8
    IBOutlet NSMenuItem *detail;          // Tag: 9
    IBOutlet NSMenuItem *extrema;         // Tag: 10
    IBOutlet NSMenuItem *helix;           // Tag: 11
    IBOutlet NSMenuItem *helix2;          // Tag: 12
    IBOutlet NSMenuItem *hotres;          // Tag: 13
    IBOutlet NSMenuItem *jaisn2;          // Tag: 14
    IBOutlet NSMenuItem *jaisnb;          // Tag: 15
    IBOutlet NSMenuItem *jaisnc;          // Tag: 16
    IBOutlet NSMenuItem *jaisnd;          // Tag: 17
    IBOutlet NSMenuItem *jaison;          // Tag: 18
    IBOutlet NSMenuItem *jet;             // Tag: 19
    IBOutlet NSMenuItem *manga;           // Tag: 20
    IBOutlet NSMenuItem *rainbow;         // Tag: 21
    IBOutlet NSMenuItem *roullet;         // Tag: 22
    IBOutlet NSMenuItem *ssec;            // Tag: 23
    IBOutlet NSMenuItem *wheel;           // Tag: 24
    
    IBOutlet NSMatrix *scalingMethodCell;
    
    // Sheet window outlets
    int nbVariables;
    IBOutlet NSWindow *interpolationSheet;
    IBOutlet NSTextField *netCDFfile;
    IBOutlet NSTextField *variableName;
    IBOutlet NSTextField *variableNB;
    IBOutlet NSTextField *variableVar1;
    IBOutlet NSTextField *variableVar2;
    IBOutlet NSTextField *variableVar3;
    IBOutlet NSButton *focusCoordinates;
    IBOutlet NSButton *globalGrid;
    IBOutlet NSTextField *coordFocusHorizMin;
    IBOutlet NSTextField *coordFocusHorizMax;
    IBOutlet NSTextField *coordFocusVertMin;
    IBOutlet NSTextField *coordFocusVertMax;
    IBOutlet NSTextField *runInfoSpaceRes;
    IBOutlet NSTextField *runInfoTimeLoop;
    IBOutlet NSTextField *runInfoStartPos;
    IBOutlet NSTextField *runInfoIncrement;
}

-(void)dataInitialize:(dataObject *)data;
-(IBAction)computeSerial:(id)sender;
-(IBAction)computeGCD:(id)sender;
-(IBAction)computeOpenCL:(id)sender;

-(IBAction)scaleWindow:(id)sender;
-(IBAction)changeColorMap:(id)sender;

// Sheet window actions
-(void)setNbVariables:(int)i;
-(int)nbVariables;
-(IBAction)showInterpolationSheet:(id)sender;
-(IBAction)endInterpolationSheet:(id)sender;
-(IBAction)cancelInterpolationSheet:(id)sender;
-(void)beginAlert:(NSString *)message;
-(IBAction)chooseFocusCoordinates:(id)sender;
-(IBAction)chooseGlobalGrid:(id)sender;

@end
