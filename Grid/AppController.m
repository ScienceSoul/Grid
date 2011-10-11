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
    
    NSInteger tag;
    NSRect rect;
    
    tag = [sender tag];
    
    switch (tag) {
        case 1: // Scale 1x
            rect.size.width = width;
            rect.size.height = height;
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
            break;
        case 2: // Scale 2x
            rect.size.width = width*2.0;
            rect.size.height = height*2.0;
            if ([scale1x state] == NSOnState) {
                [scale1x setState:NSOffState];
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
            [scale2x setState:NSOnState];
            break;
        case 3: // Scale 4x
            rect.size.width = width*4.0;
            rect.size.height = height*4.0;
            if ([scale1x state] == NSOnState) {
                [scale1x setState:NSOffState];
            }
            if ([scale2x state] == NSOnState) {
                [scale2x setState:NSOffState];
            }
            if ([scale6x state] == NSOnState) {
                [scale6x setState:NSOffState];
            }
            if ([scale8x state] == NSOnState) {
                [scale8x setState:NSOffState];
            }
            [scale4x setState:NSOnState];
            break;
        case 4: // Scale 6x
            rect.size.width = width*6.0;
            rect.size.height = height*6.0;
            if ([scale1x state] == NSOnState) {
                [scale1x setState:NSOffState];
            }
            if ([scale2x state] == NSOnState) {
                [scale2x setState:NSOffState];
            }
            if ([scale4x state] == NSOnState) {
                [scale4x setState:NSOffState];
            }
            if ([scale8x state] == NSOnState) {
                [scale8x setState:NSOffState];
            }
            [scale6x setState:NSOnState];
            break;
        case 5: //Scale 8x
            rect.size.width = width*8.0;
            rect.size.height = height*8.0;
            if ([scale1x state] == NSOnState) {
                [scale1x setState:NSOffState];
            }
            if ([scale2x state] == NSOnState) {
                [scale2x setState:NSOffState];
            }
            if ([scale4x state] == NSOnState) {
                [scale4x setState:NSOffState];
            }
            if ([scale6x state] == NSOnState) {
                [scale6x setState:NSOffState];
            }
            [scale8x setState:NSOnState];
            break;
            
        default:
            break;
    }
    
    rect.origin.x = [myWindow frame].origin.x;
    rect.origin.y = [myWindow frame].origin.y;
    
    [myWindow setFrame:rect display:YES animate:YES];
}

-(IBAction)changeColorMap:(id)sender {
    
    NSInteger tag;
    
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
    
    
}


-(IBAction)loadData:(id)sender
{
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
        
    [processData getInputFile:arguments :consoleView];
    [processData LoadNETCDFFile:arguments :consoleView];
    
}

-(IBAction)computeSerial:(id)sender {
    
    dataObject *data = [[dataObject alloc] init];
    
    if ([serialStartStop state] == 1) {
    
        [data setxmin:xRangeMin];
        [data setxmax:xRangeMax];
        [data setymin:yRangeMin];
        [data setymax:yRangeMax];
        [data setview:consoleView];
        
        //Scale factor to be used based on user selection
        if ([scale1x state] == NSOnState) {
            
            [data setScaleFactor:1];
            
        } else if ([scale2x state] == NSOnState) {
            
            [data setScaleFactor:2];
            
        } else if ([scale4x state] == NSOnState) {
            
            [data setScaleFactor:4];
            
        } else if ([scale6x state] == NSOnState) {
            
            [data setScaleFactor:6];
            
        } else if ([scale8x state] == NSOnState) {
            
            [data setScaleFactor:8];
            
        } else {
            
            [data setScaleFactor:1];
            
        }
        
        // Scale method we want to use based on user choice
        if ([scalingMethodCell selectedColumn] == 0) {
            [data setScaleMethod:1];
        } else if ([scalingMethodCell selectedColumn] == 1) {
            [data setScaleMethod:2];
        }
        
        // Color map we want to use based on user choice
        if ([three_gauss state] == NSOnState) {
            [data setColormapFromAppMenu:1];
        } else if ([three_saw state] == NSOnState) {
            [data setColormapFromAppMenu:2];
        } else if ([banded state] == NSOnState) {
            [data setColormapFromAppMenu:3];
        } else if ([blue_red1 state] == NSOnState) {
            [data setColormapFromAppMenu:4];
        } else if ([blue_red2 state] == NSOnState) {
            [data setColormapFromAppMenu:5];
        } else if ([bright state] == NSOnState) {
            [data setColormapFromAppMenu:6];
        } else if ([bw state] == NSOnState) {
            [data setColormapFromAppMenu:7];
        } else if ([deflt state] == NSOnState) {
            [data setColormapFromAppMenu:8];
        } else if ([detail state] == NSOnState) {
            [data setColormapFromAppMenu:9];
        } else if ([extrema state] == NSOnState) {
            [data setColormapFromAppMenu:10];
        } else if ([helix state] == NSOnState) {
            [data setColormapFromAppMenu:11];
        } else if ([helix2 state] == NSOnState) {
            [data setColormapFromAppMenu:12];
        } else if ([hotres state] == NSOnState) {
            [data setColormapFromAppMenu:13];
        } else if ([jaisn2 state] == NSOnState) {
            [data setColormapFromAppMenu:14];
        } else if ([jaisnb state] == NSOnState) {
            [data setColormapFromAppMenu:15];
        } else if ([jaisnc state] == NSOnState) {
            [data setColormapFromAppMenu:16];
        } else if ([jaisnd state] == NSOnState) {
            [data setColormapFromAppMenu:17];
        } else if ([jaison state] == NSOnState) {
            [data setColormapFromAppMenu:18];
        } else if ([jet state] == NSOnState) {
            [data setColormapFromAppMenu:19];
        } else if ([manga state] == NSOnState) {
            [data setColormapFromAppMenu:20];
        } else if ([rainbow state] == NSOnState) {
            [data setColormapFromAppMenu:21];
        } else if ([roullet state] == NSOnState) {
            [data setColormapFromAppMenu:22];
        } else if ([ssec state] == NSOnState) {
            [data setColormapFromAppMenu:23];
        } else if ([wheel state] == NSOnState) {
            [data setColormapFromAppMenu:24];
        }
        
        [data setTerminated:NO];
        [data setSerialButtonState:serialStartStop];
        [processData prepareData:data];
        
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
    dataObject *data = [[dataObject alloc] init];
    
    if ([GCDStartStop state] == 1) {
    
        [data setxmin:xRangeMin];
        [data setxmax:xRangeMax];
        [data setymin:yRangeMin];
        [data setymax:yRangeMax];
        [data setview:consoleView];
        
        //Scale factor to be used based on user selection
        if ([scale1x state] == NSOnState) {
            
            [data setScaleFactor:1];
            
        } else if ([scale2x state] == NSOnState) {
            
            [data setScaleFactor:2];
            
        } else if ([scale4x state] == NSOnState) {
            
            [data setScaleFactor:4];
            
        } else if ([scale6x state] == NSOnState) {
            
            [data setScaleFactor:6];
            
        } else if ([scale8x state] == NSOnState) {
            
            [data setScaleFactor:8];
            
        } else {
            
            [data setScaleFactor:1];
            
        }
        
        // Scale method we want to use based on user choice
        if ([scalingMethodCell selectedColumn] == 0) {
            [data setScaleMethod:1];
        } else if ([scalingMethodCell selectedColumn] == 1) {
            [data setScaleMethod:2];
        }
        
        // Color map we want to use based on user choice
        if ([three_gauss state] == NSOnState) {
            [data setColormapFromAppMenu:1];
        } else if ([three_saw state] == NSOnState) {
            [data setColormapFromAppMenu:2];
        } else if ([banded state] == NSOnState) {
            [data setColormapFromAppMenu:3];
        } else if ([blue_red1 state] == NSOnState) {
            [data setColormapFromAppMenu:4];
        } else if ([blue_red2 state] == NSOnState) {
            [data setColormapFromAppMenu:5];
        } else if ([bright state] == NSOnState) {
            [data setColormapFromAppMenu:6];
        } else if ([bw state] == NSOnState) {
            [data setColormapFromAppMenu:7];
        } else if ([deflt state] == NSOnState) {
            [data setColormapFromAppMenu:8];
        } else if ([detail state] == NSOnState) {
            [data setColormapFromAppMenu:9];
        } else if ([extrema state] == NSOnState) {
            [data setColormapFromAppMenu:10];
        } else if ([helix state] == NSOnState) {
            [data setColormapFromAppMenu:11];
        } else if ([helix2 state] == NSOnState) {
            [data setColormapFromAppMenu:12];
        } else if ([hotres state] == NSOnState) {
            [data setColormapFromAppMenu:13];
        } else if ([jaisn2 state] == NSOnState) {
            [data setColormapFromAppMenu:14];
        } else if ([jaisnb state] == NSOnState) {
            [data setColormapFromAppMenu:15];
        } else if ([jaisnc state] == NSOnState) {
            [data setColormapFromAppMenu:16];
        } else if ([jaisnd state] == NSOnState) {
            [data setColormapFromAppMenu:17];
        } else if ([jaison state] == NSOnState) {
            [data setColormapFromAppMenu:18];
        } else if ([jet state] == NSOnState) {
            [data setColormapFromAppMenu:19];
        } else if ([manga state] == NSOnState) {
            [data setColormapFromAppMenu:20];
        } else if ([rainbow state] == NSOnState) {
            [data setColormapFromAppMenu:21];
        } else if ([roullet state] == NSOnState) {
            [data setColormapFromAppMenu:22];
        } else if ([ssec state] == NSOnState) {
            [data setColormapFromAppMenu:23];
        } else if ([wheel state] == NSOnState) {
            [data setColormapFromAppMenu:24];
        }
        
        [data setTerminated:NO];
        [data setGcdSButtonState:GCDStartStop];
        [processData prepareData:data];
        
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
    
    dataObject *data = [[dataObject alloc] init];
    
    if ([OpenCLStartStop state] == 1) {
        
        [data setxmin:xRangeMin];
        [data setxmax:xRangeMax];
        [data setymin:yRangeMin];
        [data setymax:yRangeMax];
        [data setview:consoleView];
        
        //Scale factor to be used based on user selection
        if ([scale1x state] == NSOnState) {
            
            [data setScaleFactor:1];
            
        } else if ([scale2x state] == NSOnState) {
            
            [data setScaleFactor:2];
            
        } else if ([scale4x state] == NSOnState) {
            
            [data setScaleFactor:4];
            
        } else if ([scale6x state] == NSOnState) {
            
            [data setScaleFactor:6];
            
        } else if ([scale8x state] == NSOnState) {
            
            [data setScaleFactor:8];
            
        } else {
            
            [data setScaleFactor:1];
            
        }
        
        // Scale method we want to use based on user choice
        if ([scalingMethodCell selectedColumn] == 0) {
            [data setScaleMethod:1];
        } else if ([scalingMethodCell selectedColumn] == 1) {
            [data setScaleMethod:2];
        }
        
        // Color map we want to use based on user choice
        if ([three_gauss state] == NSOnState) {
            [data setColormapFromAppMenu:1];
        } else if ([three_saw state] == NSOnState) {
            [data setColormapFromAppMenu:2];
        } else if ([banded state] == NSOnState) {
            [data setColormapFromAppMenu:3];
        } else if ([blue_red1 state] == NSOnState) {
            [data setColormapFromAppMenu:4];
        } else if ([blue_red2 state] == NSOnState) {
            [data setColormapFromAppMenu:5];
        } else if ([bright state] == NSOnState) {
            [data setColormapFromAppMenu:6];
        } else if ([bw state] == NSOnState) {
            [data setColormapFromAppMenu:7];
        } else if ([deflt state] == NSOnState) {
            [data setColormapFromAppMenu:8];
        } else if ([detail state] == NSOnState) {
            [data setColormapFromAppMenu:9];
        } else if ([extrema state] == NSOnState) {
            [data setColormapFromAppMenu:10];
        } else if ([helix state] == NSOnState) {
            [data setColormapFromAppMenu:11];
        } else if ([helix2 state] == NSOnState) {
            [data setColormapFromAppMenu:12];
        } else if ([hotres state] == NSOnState) {
            [data setColormapFromAppMenu:13];
        } else if ([jaisn2 state] == NSOnState) {
            [data setColormapFromAppMenu:14];
        } else if ([jaisnb state] == NSOnState) {
            [data setColormapFromAppMenu:15];
        } else if ([jaisnc state] == NSOnState) {
            [data setColormapFromAppMenu:16];
        } else if ([jaisnd state] == NSOnState) {
            [data setColormapFromAppMenu:17];
        } else if ([jaison state] == NSOnState) {
            [data setColormapFromAppMenu:18];
        } else if ([jet state] == NSOnState) {
            [data setColormapFromAppMenu:19];
        } else if ([manga state] == NSOnState) {
            [data setColormapFromAppMenu:20];
        } else if ([rainbow state] == NSOnState) {
            [data setColormapFromAppMenu:21];
        } else if ([roullet state] == NSOnState) {
            [data setColormapFromAppMenu:22];
        } else if ([ssec state] == NSOnState) {
            [data setColormapFromAppMenu:23];
        } else if ([wheel state] == NSOnState) {
            [data setColormapFromAppMenu:24];
        }
        
        [data setTerminated:NO];
        [data setOpenclButtonState:OpenCLStartStop];
        [processData prepareData:data];
        
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
    int n, k;
    int nx, ny;
    NSRange subRange;
    float **xyrange;
    FILE *f1;
    NSString *string;
    
    // Check if we have enough arguments upon awaking from Nib.
    NSArray *arguments = [[NSProcessInfo processInfo] arguments];
    
    xyrange = floatmatrix(0, 1, 0, 1);
    
    n = (int)[arguments count];
    
    if ((n-1) < 6) {
        NSLog(@"Fatal error: Number of arguments should be at least 7.\n");
        exit(-1);
    }
    
    if ([arguments count]-1 == 7) {
        
        NSLog(@"Got the the domain range input file\n");
        
        if ([[arguments objectAtIndex:1] isEqualToString:@"Jakobshavn"]) {
            
            // Verify first that we are opening the proper file
            subRange = [[arguments objectAtIndex:2] rangeOfString:@"jis.sif"];
            
            if (subRange.location == NSNotFound) { 
                NSLog(@"Fatal Error: Input file for coordinates not consistent with domain name\n"); 
                exit(-1);
            }
            
            f1 = fopen([[arguments objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
            if(!f1) {
                NSLog(@"Fatal Error: File %@ not found\n", [arguments objectAtIndex:2]);
                exit(-1);
            }
        } 
        else if ([[arguments objectAtIndex:1] isEqualToString:@"Kangerdlussuaq"]) {
            
            subRange = [[arguments objectAtIndex:2] rangeOfString:@"kl.sif"];
            
            if (subRange.location == NSNotFound) { 
                NSLog(@"Fatal Error: Input file for coordinates not consistent with domain name\n"); 
                exit(-1);
            }
            
            f1 = fopen([[arguments objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
            if(!f1) {
                NSLog(@"Fatal Error: File %@ not found\n", [arguments objectAtIndex:2]);
                exit(-1);
            }
        }
        else if ([[arguments objectAtIndex:1] isEqualToString:@"Helheim"]) {
            
            subRange = [[arguments objectAtIndex:2] rangeOfString:@"hh.sif"];
            
            if (subRange.location == NSNotFound) { 
                NSLog(@"Fatal Error: Input file for coordinates not consistent with domain name\n"); 
                exit(-1);
            }
            
            f1 = fopen([[arguments objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
            if(!f1) {
                NSLog(@"Fatal Error: File %@ not found\n", [arguments objectAtIndex:2]);
                exit(-1);
            }
        }
        else if ([[arguments objectAtIndex:1] isEqualToString:@"Petermann"]) {
            
            subRange = [[arguments objectAtIndex:2] rangeOfString:@"pt.sif"];
            
            if (subRange.location == NSNotFound) { 
                NSLog(@"Fatal Error: Input file for coordinates not consistent with domain name\n"); 
                exit(-1);
            }
            
            f1 = fopen([[arguments objectAtIndex:2] cStringUsingEncoding:NSASCIIStringEncoding], "r");
            if(!f1) {
                NSLog(@"Fatal Error: File %@ not found\n", [arguments objectAtIndex:2]);
                exit(-1);
            }
        }
        else {
            
            NSLog(@"Fatal Error: Unknown domain type.\n");
            exit(-1);
        }
        
        k=0;
        do {
            
            fscanf(f1,"%f %f\n", &xyrange[k][0], &xyrange[k][1]);
            k++;
        }
        while (!feof(f1)); 
        fclose(f1);
        
        nx = ( ( (int) xyrange[0][1] - (int) xyrange[0][0] ) / 1000 ) + 1;
        ny = ( ( (int) xyrange[1][1] - (int) xyrange[1][0] ) / 1000 ) + 1;
        
        string = [NSString stringWithFormat: @"%f", xyrange[0][0]];
        [xRangeMin setStringValue:string];
        
        string = [NSString stringWithFormat: @"%f", xyrange[0][1]];
        [xRangeMax setStringValue:string];
        
        string = [NSString stringWithFormat: @"%f", xyrange[1][0]];
        [yRangeMin setStringValue:string];
        
        string = [NSString stringWithFormat: @"%f", xyrange[1][1]];
        [yRangeMax setStringValue:string];
        
        NSRect windowRect = NSMakeRect(500.0f, 500.0f, (float)nx, (float)ny);
        myWindow = [[NSWindow alloc] initWithContentRect:windowRect styleMask:( NSResizableWindowMask | NSClosableWindowMask | NSTitledWindowMask ) backing:NSBackingStoreBuffered defer:NO];
        
        width = [[myWindow contentView] bounds].size.width;
        height = [[myWindow contentView] bounds].size.height;
        NSLog(@"Size: %f %f\n", width, height);
        
        glView = [[ScalarDataView alloc] initWithFrame:[[myWindow contentView] bounds]];
        [myWindow setContentView:glView];
        [myWindow setTitle:@"Grid View"];
        [myWindow makeKeyAndOrderFront:nil];
        
        NSLog(@"Vew frame: %f %f\n", [glView frame].size.width, [glView frame].size.height);
        
        [scale1x setState:NSOnState];
    
    } else {
        
        [xRangeMin setStringValue:@"0.0"];
        [xRangeMax setStringValue:@"0.0"];
        [yRangeMin setStringValue:@"0.0"];
        [yRangeMax setStringValue:@"0.0"];
    
    }
    
    // By default we use the replicate method for data scaling
    [scalingMethodCell setState:NSOnState atRow:0 column:0];
    
    // We use the default color map
    [deflt setState:NSOnState];
    
    free_fmatrix(xyrange, 0, 1, 0, 1);

}

-(void)checkTerminate:(NSTimer *)theTimer {
    
    NSLog(@"Timer fired********\n");
    
}


@end
