//
//  GeofenceSuite.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeofenceSuite.h"
#import "GeofenceControl.h"
#import "TSDebugLogManager.h"
#import "DeviceManager.h"
#import "LogManager.h"

@interface GeofenceSuite ()
@end

@implementation GeofenceSuite {
    GeofenceControl* control;
}

-(instancetype)init
{
    if ( self = [super init] ) {
        control = [[GeofenceControl alloc] init];
        control.listener = self;
    }
    return self;
}

- (void) startScan;
{
    TSGLog(TSLogGroupLocation, @"startScan");
    
    if ( control.running ) return;
    [control startScan];
}

- (void)stopScan
{
    TSGLog(TSLogGroupLocation, @"stopScan");
    
    if ( !control.running ) return;
    [control stopScan];
}

- (void)setPMPolicy:(NSInteger)pmPolicy
{
    //[NSException raise:@"GeofenceSuite" format:@"setPMPolicy is NOT implemented YET."];
    
}

/**
 *  Geofence Control로 부터 위치 정보를 전달받음
 *
 *  @param coordination SLBS 좌표계
 */
-(void)onSensorData:(SLBSCoordination *)coordination
{
    TSGLog(TSLogGroupLocation, @"onSensorData %@", coordination);
    
    if ( ![coordination isKindOfClass:[SLBSCoordination class]] ) return;
    
    [self.delegate sensorSuite:self onLocation:coordination];
    [[PositionSessionManager sharedInstance] checkPosition:coordination];
    
}

/**
 *  Zone Detection 결과
 *
 *  @param manager ZoneDataManager
 *  @param zoneID  zone ID
 */
- (void)zoneDataManager:(ZoneDataManager *)manager onZoneDetection:(NSInteger)zoneID {
    TSGLog(TSLogGroupLocation, @"onZoneDetection %ld", (long)zoneID);
    
    [[PositionSessionManager sharedInstance] detectSessionOfPosition:zoneID delegate:self];
}

/**
 *  Session Trigger
 *
 *  @param manager   SessionManager
 *  @param zoneID    zone ID
 *  @param zoneState Zone State
 */
- (void)sessionManager:(PositionSessionManager *)manager triggerPosZoneState:(NSNumber *)zoneID zoneState:(SLBSSessionType)zoneState {
    TSGLog(TSLogGroupLocation, @"triggerPosZoneState %ld %ld",  (long)zoneID, (long)zoneState);
    
    [[ZoneCampaignDataManager sharedInstance] setDelegate:self];
    [[ZoneCampaignDataManager sharedInstance] zoneCampaignsWithZoneID:zoneID sessionType:zoneState];
    
    [self sendZoneLogWithZoneID:zoneID zoneState:zoneState];
}

/**
 *  Zone Campaign Detection
 *
 *  @param manager          zone campaign data manager
 *  @param zoneCampaignList Zone Campaign List
 */
- (void)ZoneCampaignDataManager:(ZoneCampaignDataManager *)manager onCampaignPopup:(NSArray *)zoneCampaignList {
    TSGLog(TSLogGroupLocation, @"onCampaignPopup %@",  zoneCampaignList);
    [self.delegate sensorSuite:self onEvent:zoneCampaignList];
}

- (void)sendZoneLogWithZoneID:(NSNumber*)zoneID zoneState:(SLBSSessionType)zoneState{
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    NSString* appID = [[DeviceManager sharedInstance] appID];
    Zone* zone = [[ZoneDataManager sharedInstance] zoneForID:zoneID];
    NSString* locationLog = [NSString stringWithFormat:@"%@_%@_%@_%f_%f", zone.store_company_id, zone.store_branch_id, zone.store_floor_id, -1.0f, -1.0f];
    
    [[LogManager sharedInstance] saveRouteLogWithDeviceID:deviceID appID:appID locationLog:locationLog companyID:zone.store_company_id branchID:zone.store_branch_id floorID:zone.store_floor_id coordX:-1.0f coordY:-1.0f zoneID:zone.zone_id zoneCampaignID:[NSNumber numberWithInt:-1] zoneLogType:[NSNumber numberWithInteger:zoneState]];
}

@end
