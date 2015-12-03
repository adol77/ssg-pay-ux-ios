//
//  LocationEngine.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_LocationEngine_h
#define SLBSKit_LocationEngine_h
#import "SLBSCoordination.h"
#import "Policy.h"
#import "LSSuite.h"

@class LOCLocationEngine;

@protocol LOCLocationDelegate <NSObject>
- (void)locationEngine:(LOCLocationEngine *)engine onLocation:(SLBSCoordination*)location;
@end

@protocol LOCZoneCampaignDelegate <NSObject>
- (void)locationEngine:(LOCLocationEngine *)engine didEventCampaign:(NSArray*)zoneCampaignInfo;
@end

@interface LOCLocationEngine : NSObject <LSSuiteDelegate>

+ (LOCLocationEngine*)sharedInstance;
@property (weak, nonatomic) id<LOCLocationDelegate> locationDelegate;
@property (weak, nonatomic) id<LOCZoneCampaignDelegate> zoneCampaignDelegate;

- (void)addSensorSuite:(LSSuite*)sensorSuite;
- (void)startScan;
- (void)stopScan;
- (void)setPolicy:(Policy*)policyData;
- (void)setLocationUsageAgreement:(BOOL)locationUsageAgreement;

@end



#endif
