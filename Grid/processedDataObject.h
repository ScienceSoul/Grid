//
//  processedDataObject.h
//  Grid
//
//  Created by Hakime Seddik on 15/09/11.
//  Copyright © 2011 ScienceSoul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface processedDataObject : NSObject {
    
    NSString *string1;
    NSString *string2;
    NSTextView* view;
    double timing;
    int scaleMethod;    // 1: Replicate; 2: Bilinear 
}

-(void)setString1: (NSString *)str;
-(void)setString2: (NSString *)str;
-(NSString *)string1;
-(NSString *)string2;
-(void)setview: (NSTextView *)aview;

-(NSTextView *)view;
-(void)setTiming: (double)adouble;
-(double)timing;
-(void)setScaleMethod: (int)i;
-(int)scaleMethod;

@end
