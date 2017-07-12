//
//  AppController.m
//  Grid
//
//  Created by Hakime Seddik on 13/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import <stdbool.h>
#import <stdio.h>
#import <stdlib.h>

#import "AppController.h"
#import "dataObject.h"

#import "memory.h"

@implementation AppController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        processData = [[Interpoler alloc] init];
        
    }
    
    return self;
}

-(IBAction)scaleWindow:(id)sender {
    
    NSInteger tag, prevTag;
    NSRect rect;
    
    tag = [sender tag];
    
    switch (tag) {
        case 1: // Scale 1x
            rect.size.width = width;
            rect.size.height = height;
            if ([scale2x state] == NSOnState) {
                prevTag = [scale2x tag];
                [scale2x setState:NSOffState];
            }
            if ([scale4x state] == NSOnState) {
                prevTag = [scale4x tag];
                [scale4x setState:NSOffState];
            }
            if ([scale6x state] == NSOnState) {
                prevTag = [scale6x tag];
                [scale6x setState:NSOffState];
            }
            if ([scale8x state] == NSOnState) {
                prevTag = [scale8x tag];
                [scale8x setState:NSOffState];
            }
            [scale1x setState:NSOnState];
            break;
        case 2: // Scale 2x
            rect.size.width = width*2.0;
            rect.size.height = height*2.0;
            if ([scale1x state] == NSOnState) {
                prevTag = [scale1x tag];
                [scale1x setState:NSOffState];
            }
            if ([scale4x state] == NSOnState) {
                prevTag = [scale4x tag];
                [scale4x setState:NSOffState];
            }
            if ([scale6x state] == NSOnState) {
                prevTag = [scale6x tag];
                [scale6x setState:NSOffState];
            }
            if ([scale8x state] == NSOnState) {
                prevTag = [scale8x tag];
                [scale8x setState:NSOffState];
            }
            [scale2x setState:NSOnState];
            break;
        case 3: // Scale 4x
            rect.size.width = width*4.0;
            rect.size.height = height*4.0;
            if ([scale1x state] == NSOnState) {
                prevTag = [scale1x tag];
                [scale1x setState:NSOffState];
            }
            if ([scale2x state] == NSOnState) {
                prevTag = [scale2x tag];
                [scale2x setState:NSOffState];
            }
            if ([scale6x state] == NSOnState) {
                prevTag = [scale6x tag];
                [scale6x setState:NSOffState];
            }
            if ([scale8x state] == NSOnState) {
                prevTag = [scale8x tag];
                [scale8x setState:NSOffState];
            }
            [scale4x setState:NSOnState];
            break;
        case 4: // Scale 6x
            rect.size.width = width*6.0;
            rect.size.height = height*6.0;
            if ([scale1x state] == NSOnState) {
                prevTag = [scale1x tag];
                [scale1x setState:NSOffState];
            }
            if ([scale2x state] == NSOnState) {
                prevTag = [scale2x tag];
                [scale2x setState:NSOffState];
            }
            if ([scale4x state] == NSOnState) {
                prevTag = [scale4x tag];
                [scale4x setState:NSOffState];
            }
            if ([scale8x state] == NSOnState) {
                prevTag = [scale8x tag];
                [scale8x setState:NSOffState];
            }
            [scale6x setState:NSOnState];
            break;
        case 5: //Scale 8x
            rect.size.width = width*8.0;
            rect.size.height = height*8.0;
            if ([scale1x state] == NSOnState) {
                prevTag = [scale1x tag];
                [scale1x setState:NSOffState];
            }
            if ([scale2x state] == NSOnState) {
                prevTag = [scale2x tag];
                [scale2x setState:NSOffState];
            }
            if ([scale4x state] == NSOnState) {
                prevTag = [scale4x tag];
                [scale4x setState:NSOffState];
            }
            if ([scale6x state] == NSOnState) {
                prevTag = [scale6x tag];
                [scale6x setState:NSOffState];
            }
            [scale8x setState:NSOnState];
            break;
            
        default:
            break;
    }
    
    rect.origin.x = [dataViewWindow frame].origin.x;
    rect.origin.y = [dataViewWindow frame].origin.y;
    
    [dataViewWindow setFrame:rect display:YES animate:YES];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", tag], @"MenuTag", [NSString stringWithFormat:@"%d", prevTag], @"PrevMenuTag", [coordFocusVertMin stringValue], @"VertMin" , [coordFocusVertMax stringValue], @"VertMax", [coordFocusHorizMin stringValue], @"HorizMin", [coordFocusHorizMax stringValue], @"HorizMax", [runInfoSpaceRes stringValue], @"SpaceRes",  nil];
    [nc postNotificationName:@"GRIDScaleFactorChanged" object:self userInfo:d];
    
}

-(IBAction)changeColorMap:(id)sender {
    
    NSInteger tag;
    NSString *tagString;
    
    tag = [sender tag];
    
    switch (tag) {
        case 1:  //3Gausss
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [three_gauss setState:NSOnState];
            break;
        case 2:  //3saw
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [three_saw setState:NSOnState];
            break;
        case 3:  //banded
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [banded setState:NSOnState];
            break;
        case 4:  //blue red 1
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [blue_red1 setState:NSOnState];
            break;
        case 5:  //bluer red 5
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [blue_red2 setState:NSOnState];
            break;
        case 6:  //bright
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [bright setState:NSOnState];
            break;
        case 7:  //bw
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [bw setState:NSOnState];
            break;
        case 8:  //default
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [deflt setState:NSOnState];
            break;
        case 9:  //detail
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [detail setState:NSOnState];
            break;
        case 10:  //extrema
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [extrema setState:NSOnState];
            break;
        case 11:  //helix
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [helix setState:NSOnState];
            break;
        case 12:  //helix 2
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [helix2 setState:NSOnState];
            break;
        case 13:  //hotres
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [hotres setState:NSOnState];
            break;
        case 14:  //jaisn2
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [jaisn2 setState:NSOnState];
            break;
        case 15:  //jaisnb
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [jaisnb setState:NSOnState];
            break;
        case 16:  //jaisnc
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [jaisnc setState:NSOnState];
            break;
        case 17:  //jaisnd
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [jaisnd setState:NSOnState];
            break;
        case 18:  //jason
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [jaison setState:NSOnState];
            break;
        case 19:  //jet
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [jet setState:NSOnState];
            break;
        case 20:  //manga
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [manga setState:NSOnState];
            break;
        case 21:  //rainbow
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [rainbow setState:NSOnState];
            break;
        case 22:  //roullet
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [roullet setState:NSOnState];
            break;
        case 23:  //ssec
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([wheel state] == NSOnState) {
                [wheel setState:NSOffState];
            }
            [ssec setState:NSOnState];
            break;
        case 24:  //wheel
            if ([three_gauss state] == NSOnState) {
                [three_gauss setState:NSOffState];
            }
            if ([three_saw state] == NSOnState) {
                [three_saw setState:NSOffState];
            }
            if ([banded state] == NSOnState) {
                [banded setState:NSOffState];
            }
            if ([blue_red1 state] == NSOnState) {
                [blue_red1 setState:NSOffState];
            }
            if ([blue_red2 state] == NSOnState) {
                [blue_red2 setState:NSOffState];
            }
            if ([bright state] == NSOnState) {
                [bright setState:NSOffState];
            }
            if ([bw state] == NSOnState) {
                [bw setState:NSOffState];
            }
            if ([deflt state] == NSOnState) {
                [deflt setState:NSOffState];
            }
            if ([detail state] == NSOnState) {
                [detail setState:NSOffState];
            }
            if ([extrema state] == NSOnState) {
                [extrema setState:NSOffState];
            }
            if ([helix state] == NSOnState) {
                [helix setState:NSOffState];
            }
            if ([helix2 state] == NSOnState) {
                [helix2 setState:NSOffState];
            }
            if ([hotres state] == NSOnState) {
                [hotres setState:NSOffState];
            }
            if ([jaisn2 state] == NSOnState) {
                [jaisn2 setState:NSOffState];
            }
            if ([jaisnb state] == NSOnState) {
                [jaisnb setState:NSOffState];
            }
            if ([jaisnc state] == NSOnState) {
                [jaisnc setState:NSOffState];
            }
            if ([jaisnd state] == NSOnState) {
                [jaisnd setState:NSOffState];
            }
            if ([jaison state] == NSOnState) {
                [jaison setState:NSOffState];
            }
            if ([jet state] == NSOnState) {
                [jet setState:NSOffState];
            }
            if ([manga state] == NSOnState) {
                [manga setState:NSOffState];
            }
            if ([rainbow state] == NSOnState) {
                [rainbow setState:NSOffState];
            }
            if ([roullet state] == NSOnState) {
                [roullet setState:NSOffState];
            }
            if ([ssec state] == NSOnState) {
                [ssec setState:NSOffState];
            }
            [wheel setState:NSOnState];
            break;
    }
    
    tagString = [NSString stringWithFormat:@"%d", tag];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *d = [NSDictionary dictionaryWithObject:tagString forKey:@"MenuTag"];
    [nc postNotificationName:@"GRIDColorMapChanged" object:self userInfo:d];
    
    if ([dataViewWindow isVisible] && ![workThread isExecuting]) {
        [processData colorTableLookUp];
        [processData drawData];
    }
    
}

-(void)dataInitialize:(dataObject *)data{
    
    [data setNetCDFFile:[netCDFfile stringValue]];
    [data setVariableName:[variableName stringValue]];
    [data setVariableVar1:[variableVar1 stringValue]];
    [data setVariableVar2:[variableVar2 stringValue]];
    [data setVariableVar3:[variableVar3 stringValue]];
    [data setVariableNB:[[variableNB stringValue] intValue]];
    [data setCoordFocusHorizMin:[[coordFocusHorizMin stringValue] floatValue]];
    [data setCoordFocusHorizMax:[[coordFocusHorizMax stringValue] floatValue]];
    [data setCoordFocusVertMin:[[coordFocusVertMin stringValue] floatValue]];
    [data setCoordFocusVertMax:[[coordFocusVertMax stringValue] floatValue]];
    [data setRunInfoSpaceRes:[[runInfoSpaceRes stringValue] intValue]];
    [data setRunInfoTimeLoop:[[runInfoTimeLoop stringValue] intValue]];
    [data setRunInfoStartPos:[[runInfoStartPos stringValue] intValue]];
    [data setRunInfoIncrement:[[runInfoIncrement stringValue] intValue]];
    
    [data setview:consoleView];
    
    // Scaling method we want to use based on user choice
    if ([scalingMethodCell selectedColumn] == 0) {
        [data setScaleMethod:1];
    } else if ([scalingMethodCell selectedColumn] == 1) {
        [data setScaleMethod:2];
    }
    
    [data setTerminated:NO];
    
}

-(IBAction)computeSerial:(id)sender {
    
    if ([[netCDFfile stringValue] length] == 0 || [[variableName stringValue] length] == 0 || [[variableNB stringValue] intValue] <= 0 || [[variableVar1 stringValue] length] == 0 || [[runInfoTimeLoop stringValue] intValue] <= 0 || [[runInfoStartPos stringValue] intValue] <= 0 || [[runInfoIncrement stringValue] intValue] <= 0) {
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Interpolation parameters must be first provided before starting a run."];
        [alert beginSheetModalForWindow:[consoleView window] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
        
        [serialStartStop setState:NSOffState];
        
        return;
    }
    
    dataObject *data = [[dataObject alloc] init];
    
    if ([serialStartStop state] == 1) {
    
        [self dataInitialize:data];
        [data setSerialButtonState:serialStartStop];
        
        if (![processData prepareData:data]) {
            
            NSAlert *alert = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[data message]];
            [alert beginSheetModalForWindow:[consoleView window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
            
            [OpenCLStartStop setState:NSOffState];
            return;
            
        }
        
        //[NSThread detachNewThreadSelector:@selector(SerialCompute:)
        //                         toTarget:processData
        //                       withObject:data];
        workThread = [[NSThread alloc] initWithTarget:processData selector:@selector(SerialCompute:) object:data];
        [workThread start];
        
    } else if ([serialStartStop state] == 0) {
        
        [data setTerminated:YES];
        [workThread cancel];
        [workThread release];
        workThread = nil;
        
    }
    
}

-(IBAction)computeGCD:(id)sender
{
    if ([[netCDFfile stringValue] length] == 0 || [[variableName stringValue] length] == 0 || [[variableNB stringValue] intValue] <= 0 || [[variableVar1 stringValue] length] == 0 || [[runInfoTimeLoop stringValue] intValue] <= 0 || [[runInfoStartPos stringValue] intValue] <= 0 || [[runInfoIncrement stringValue] intValue] <= 0) {
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Interpolation parameters must be first provided before starting a run."];
        [alert beginSheetModalForWindow:[consoleView window] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
        
        [GCDStartStop setState:NSOffState];
        
        return;
    }
    
    dataObject *data = [[dataObject alloc] init];
    
    if ([GCDStartStop state] == 1) {
    
        [self dataInitialize:data];
        [data setGcdSButtonState:GCDStartStop];
        
        if (![processData prepareData:data]) {
            
            NSAlert *alert = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[data message]];
            [alert beginSheetModalForWindow:[consoleView window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
            
            [OpenCLStartStop setState:NSOffState];
            return;
            
        }
        
        //[NSThread detachNewThreadSelector:@selector(GCDCompute:)
        //                         toTarget:processData
        //                       withObject:data];
        workThread = [[NSThread alloc] initWithTarget:processData selector:@selector(GCDCompute:) object:data];
        [workThread start];
        
    } else if ([GCDStartStop state] == 0) {
        
        [data setTerminated:YES];
        [workThread cancel];
        [workThread release];
        workThread = nil;
        
    }
}

-(IBAction)computeOpenCL:(id)sender {
    
    if ([[netCDFfile stringValue] length] == 0 || [[variableName stringValue] length] == 0 || [[variableNB stringValue] intValue] <= 0 || [[variableVar1 stringValue] length] == 0 || [[runInfoTimeLoop stringValue] intValue] <= 0 || [[runInfoStartPos stringValue] intValue] <= 0 || [[runInfoIncrement stringValue] intValue] <= 0) {
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Interpolation parameters must be first provided before starting a run."];
        [alert beginSheetModalForWindow:[consoleView window] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
        
        [OpenCLStartStop setState:NSOffState];
        
        return;
    }
    
    dataObject *data = [[dataObject alloc] init];
    
    if ([OpenCLStartStop state] == 1) {
        
        [self dataInitialize:data];
        [data setOpenclButtonState:OpenCLStartStop];
        
        if (![processData prepareData:data]) {
         
            NSAlert *alert = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:[data message]];
            [alert beginSheetModalForWindow:[consoleView window] modalDelegate:self didEndSelector:nil contextInfo:NULL];
            
            [OpenCLStartStop setState:NSOffState];
            return;
            
        }
        
        //[NSThread detachNewThreadSelector:@selector(OpenCLCompute:)
        //                        toTarget:processData
        //                        withObject:data];
        workThread = [[NSThread alloc] initWithTarget:processData selector:@selector(OpenCLCompute:) object:data];
        [workThread start];
        
    } else if ([OpenCLStartStop state] == 0) {
        
        [data setTerminated:YES];
        [workThread cancel];
        [workThread release];
        workThread = nil;
        
    }
    
}

-(void)awakeFromNib 
{
    // Set some initial values for the sheet window
    [variableNB setStringValue:@"1"];
    [variableVar2 setStringValue:@"optional"];
    [variableVar3 setStringValue:@"optional"];
    
    [runInfoSpaceRes setStringValue:@">0"];
    [runInfoTimeLoop setStringValue:@">0"];
    [runInfoStartPos setStringValue:@">0"];
    [runInfoIncrement setStringValue:@">0"];
    
    // By default we use the replicate method for data scaling
    [scalingMethodCell setState:NSOnState atRow:0 column:0];
    
    // By default we use original data
    [scale1x setState:NSOnState];
    
    // We use the default color map
    [deflt setState:NSOnState];

}

#pragma mark Sheet window actions

-(void)setNbVariables:(int)i {
    
    nbVariables = i;
}

-(int)nbVariables {
    
    return nbVariables;
}

-(IBAction)showInterpolationSheet:(id)sender {
    
    [NSApp beginSheet:interpolationSheet modalForWindow:[consoleView window] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
}

-(IBAction)endInterpolationSheet:(id)sender {
    
    int nx, ny;
    float **xyrange;
    NSString *message;
    
    if ([[netCDFfile stringValue] length] == 0) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"A netCDF file containing the data to interpolate must be provided."];
        [self beginAlert:message];
        
        return;        
    }
    
    if ([[variableName stringValue] length] == 0) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"A name to reference the resulting interpolated variable must be provided. Variable:Name:"];
        [self beginAlert:message];
        
        return;
        
    }
    
    if ([[variableNB stringValue] intValue] <= 0 || [[variableNB stringValue] intValue] > 3) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"The number of variables to use for the interpolation must be between 1 and 3. Variable:NB:"];
        [self beginAlert:message];
        
        return;
    }
    
    if ([[variableVar1 stringValue] length] == 0) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"A name for the variable used for the interpolation must be provided. This variable must be present in the netCDF file used as input. Variable:Var.1:"];
        [self beginAlert:message];
        
        return;
    }
    
    if ([[variableNB stringValue] intValue] == 2 && ([[variableVar2 stringValue] length] == 0 || [[variableVar2 stringValue] isEqualToString:@"optional"]) ) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"Number of variable for interpolation is two but second input variable is missing. Variable:Var.2:"];
        [self beginAlert:message];
        
        return;

    }
    
    if ([[variableNB stringValue] intValue] == 3 && ([[variableVar2 stringValue] length] == 0 || [[variableVar2 stringValue] isEqualToString:@"optional"] || [[variableVar3 stringValue] length] == 0 || [[variableVar3 stringValue] isEqualToString:@"optional"]) ) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"Number of variable for interpolation is two but second and/or third input variables are missing. Variable:Var.2:Var.3:"];
        [self beginAlert:message];
        
        return;
        
    }

    if ([[runInfoSpaceRes stringValue] intValue] <= 0) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"Space resolution must be higher or equal to 1. Run info:Space Res:"];
        [self beginAlert:message];
        
        return;
    }
    
    if ([[runInfoTimeLoop stringValue] intValue] <= 0) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"Time iterations must be higher or equal to 1. Run info:Time loop:"];
        [self beginAlert:message];
        
        return;
    }
    
    if ([[runInfoStartPos stringValue] intValue] <= 0) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"The number indicating where to start the interpolation from the imput data should be higher or equal to 1. Run info:Start pos:"];
        [self beginAlert:message];
        
        return;
    }
    
    if ([[runInfoIncrement stringValue] intValue] <= 0) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"Increment size for the interpolation should be higher or equal to 1. Run info:Increment:"];
        [self beginAlert:message];
        
        return;
    }
    
    if ([focusCoordinates state] == NSOnState || [globalGrid state] == NSOnState) {
            
        if ([[coordFocusHorizMin stringValue] floatValue] == 0.0 || [[coordFocusHorizMax stringValue] floatValue] == 0.0 || [[coordFocusVertMin stringValue] floatValue] == 0.0 || [[coordFocusVertMax stringValue] floatValue] == 0.0) {
            
            [NSApp endSheet:interpolationSheet];
            [interpolationSheet orderOut:sender];
            
            if ([focusCoordinates state] == NSOnState) {
                message = [NSString stringWithString:@"One or several focus coordinates are not provided or are not real values."];
            } else if ([globalGrid state] == NSOnState) {
                message = [NSString stringWithString:@"One or several domain bounds coordinates are not provided or are not real values."];
            }
                
            [self beginAlert:message];
            
            return;
            
        }
        
    } else if ([focusCoordinates state] == NSOffState && [globalGrid state] == NSOffState) {
        
        [NSApp endSheet:interpolationSheet];
        [interpolationSheet orderOut:sender];
        
        message = [NSString stringWithString:@"A method by which the interpolation will be carried out should be provided. Either choose to focus on a specific part of the input domain or choose to interpolate all of it towards the structured grid."];
        [self beginAlert:message];
        
        return;
        
    }
    
    xyrange = floatmatrix(0, 1, 0, 1);
    
    xyrange[0][0] = [[coordFocusHorizMin stringValue] floatValue];
    xyrange[0][1] = [[coordFocusHorizMax stringValue] floatValue];
    xyrange[1][0] = [[coordFocusVertMin stringValue] floatValue];
    xyrange[1][1] = [[coordFocusVertMax stringValue] floatValue];
    
    nx = ( ( (int) xyrange[0][1] - (int) xyrange[0][0] ) / [[runInfoSpaceRes stringValue] intValue] );
    ny = ( ( (int) xyrange[1][1] - (int) xyrange[1][0] ) / [[runInfoSpaceRes stringValue] intValue] );
    
    free_fmatrix(xyrange, 0, 1, 0, 1);
    
    //Close previsously allocated window if any
    if ([dataViewWindow isVisible]) {
        [dataViewWindow close];
    }
    
    NSRect windowRect = NSMakeRect(500.0f, 500.0f, (float)nx, (float)ny);
    dataViewWindow = [[NSWindow alloc] initWithContentRect:windowRect styleMask:( NSTitledWindowMask | NSMiniaturizableWindowMask ) backing:NSBackingStoreBuffered defer:NO];
    [dataViewWindow setReleasedWhenClosed:YES];

    
    width = [[dataViewWindow contentView] bounds].size.width;
    height = [[dataViewWindow contentView] bounds].size.height;
    NSLog(@"Size: %f %f\n", width, height);
    
    glView = [[ScalarDataView alloc] initWithFrame:[[dataViewWindow contentView] bounds]];
    [dataViewWindow setContentView:glView];
    [dataViewWindow setTitle:@"Grid View"];
    [dataViewWindow makeKeyAndOrderFront:nil];

    NSLog(@"Vew frame: %f %f\n", [glView frame].size.width, [glView frame].size.height);
    
    //State-off for any scale chosen previously with a previous window
    if ([scale2x state] == NSOnState) {
        [scale2x setState:NSOffState];
    }
    if ([scale4x state] == NSOnState) {
        [scale4x setState:NSOffState];
    }
    if ([scale6x state] == NSOnState) {
        [scale6x setState:NSOffState];
    }
    if ([scale8x state] == NSOnState) {
        [scale8x setState:NSOffState];
    }
    
    [scale1x setState:NSOnState];
    // To do's need to notify the return to scale 1x.......
    
    
    [NSApp endSheet:interpolationSheet];
    [interpolationSheet orderOut:sender];
}

-(IBAction)cancelInterpolationSheet:(id)sender {
    
    [NSApp endSheet:interpolationSheet];
    [interpolationSheet orderOut:sender];
}

-(void)beginAlert:(NSString *)message {
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"Error!" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:message];
    
    [alert beginSheetModalForWindow:[consoleView window] modalDelegate:self didEndSelector:@selector(alertEnded:code:context:) contextInfo:NULL];

}

-(void)alertEnded:(NSAlert *)alert code:(int)choice context:(void *)v {
    
    if (choice == NSAlertDefaultReturn) {
        
        [[alert window] close];
        
        [NSApp beginSheet:interpolationSheet modalForWindow:[consoleView window] modalDelegate:nil didEndSelector:NULL contextInfo:NULL];
        
    }
}

-(IBAction)chooseFocusCoordinates:(id)sender {
    
    if ([globalGrid state] == NSOnState) {
        [globalGrid setState:NSOffState];
    }
}

-(IBAction)chooseGlobalGrid:(id)sender {
    
    if ([focusCoordinates state] == NSOnState) {
        [focusCoordinates setState:NSOffState];
    }
}

@end
