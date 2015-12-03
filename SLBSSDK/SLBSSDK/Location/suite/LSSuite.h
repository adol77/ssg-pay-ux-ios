//
//  SensorSuite.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 25..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSSDK_LSSuite_h
#define SLBSSDK_LSSuite_h
#import <CoreLocation/CoreLocation.h>
#import "SLBSCoordination.h"
#import "SLBSKitDefine.h"

@class LSSuite;
@protocol LSSuiteDelegate <NSObject>

@optional
- (void)sensorSuite:(LSSuite *)manager onLocation:(SLBSCoordination*)location;
//- (void)sensorSuite:(LSSuite *)manager onEvent:(NSNumber*)zoneID type:(SLBSSessionType)zoneState;
- (void)sensorSuite:(LSSuite *)manager onEvent:(NSArray*)campaignList;
@end


@interface LSSuite : NSObject
@property (weak, nonatomic) id<LSSuiteDelegate> delegate;

- (void) startScan;
- (void) stopScan;
- (void) setPMPolicy:(NSInteger)pmPolicy;

@end

#endif
