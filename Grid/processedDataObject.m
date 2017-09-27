//
//  processedDataObject.m
//  Grid
//
//  Created by Hakime Seddik on 15/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#import "processedDataObject.h"

@implementation processedDataObject

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)setString1:(NSString *)str {
    
    string1 =  [NSString stringWithString:str];
}

-(void)setString2:(NSString *)str {
    
    string2 = [NSString stringWithString:str];
}

-(NSString *)string1 {
    
    return string1;
}

-(NSString *)string2 {
    
    return string2;
}

-(void)setview:(NSTextView *)aview {
    
    view = aview;
}

-(NSTextView *)view {
    
    return view;
}

-(void)setTiming:(double)adouble {
    
    timing = adouble;
}

-(double)timing {
    
    return timing;
}

-(void)setScaleMethod:(int)i {
    
    scaleMethod = i;
}

-(int)scaleMethod {
    
    return scaleMethod;
}

@end
