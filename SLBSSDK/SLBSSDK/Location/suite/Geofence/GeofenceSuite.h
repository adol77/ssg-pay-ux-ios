//
//  GeofenceSuite.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_GeofenceSuite_h
#define SLBSKit_GeofenceSuite_h

#import "LSSuite.h"
#import "LSControl.h"
#import "ZoneDataManager.h"
#import "PositionSessionManager.h"
#import "ZoneCampaignDataManager.h"

@class GeofenceSuite;

@protocol GeofenceSuiteDelegate <LSSuiteDelegate>

@optional
- (void)geofenceSuite:(GeofenceSuite *)manager onLocation:(CLLocation*)location;
@end

/**
 * GPS 관련 정보를 Control로부터 전달 받는다
 * GPS 정보로 LocatonEninge 에게 위치 정보를 전달하며,
 * PositionSessionManager를 통해 Zone Detection 처리하고,
 * ZoneCampaignManager를 통해 Campaign Search도 함께 처리한다.
 */
@interface GeofenceSuite : LSSuite<LSControlListener, ZoneDataManagerDelegate, PositionSessionManagerDelegate, ZoneCampaignDataManagerDelegate>
-(void)onSensorData:(id)data;

@end

#endif
