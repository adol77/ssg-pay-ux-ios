//
//  PeakDetectorListenerProtocol.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PeakDetectorListenerProtocol <NSObject>
-(void)onPeakDetected:(double)time value:(double)value;
-(void)onValleyDetected:(double)time value:(double)value;
@end
