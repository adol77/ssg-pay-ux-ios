//
//  BLESuite.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLESuite.h"
#import "BLEControl.h"
#import "BLESessionMgr.h"
#import "BLELocator.h"
#import "BLESelector.h"
#import "BLEProximity.h"
#import "BeaconDataManager.h"
#import "PositionSessionManager.h"
#import "TSDebugLogManager.h"
#import "KalmanFilter.h"
#import "MapMatchingFilter.h"
#import "BLERoadSource.h"
#import "LOCCoordinate.h"
#import "DeviceManager.h"
#import "LogManager.h"

static int CONTROL_INTERVAL_MS = 1000;
static int SESSION_MGR_INTERVAL_MS = 1000;
static int LOCATOR_INTERVAL_MS = 1000;

NSTimeInterval lastControlTick = 0;
NSTimeInterval lastSessionMgrTick = 0;
NSTimeInterval lastLocatorTick = 0;

NSTimer* tickTimer;

@interface BLESuite()

@end

@implementation BLESuite {
    BLEControl* control;
    BLESessionMgr* sessionMgr;
    BLELocator* locator;
    BLESelector* selector;
    BLEProximity* proximity;
    KalmanFilter* kalman;
    MapMatchingFilter* mapMatching;
    BLERoadSource* roadSource;
}

+ (BLESuite*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static BLESuite *sharedBLESuite= nil;
    dispatch_once(&oncePredicate, ^{
        sharedBLESuite = [[BLESuite alloc] init];
    });
    return sharedBLESuite;
}

- (instancetype)init {
    if ( self = [super init] ) {
        control = [[BLEControl alloc] init];
        sessionMgr = [[BLESessionMgr alloc] init];
        locator = [[BLELocator alloc] init];
        selector = [[BLESelector alloc] init];
        proximity = [[BLEProximity alloc] init];
        kalman = [[KalmanFilter alloc] init];
        mapMatching = [[MapMatchingFilter alloc] init];
        roadSource = [[BLERoadSource alloc] init];
        mapMatching.mapRoadSource = roadSource; // TODO
        //stepCounter = [[StepCounter alloc] init];
        
        [control setListener:sessionMgr];
        [locator setListener:selector];
        [locator setSessionSource:sessionMgr];
        [locator setBeaconLocationSource:locator];
        [selector setListener:self];
        
        [sessionMgr setListener:self];
        [proximity setListener:self];
    }
    return self;
}

- (void)startScan{
    
    TSGLog(TSLogGroupLocation, @"startScan");
    
    if ( control.running ) return;
    
    [control startScan];
    
    tickTimer = [NSTimer scheduledTimerWithTimeInterval:([self getTickGCD]/1000.) target:self selector:@selector(setTick) userInfo:nil repeats:YES];
}

- (void)stopScan {
    TSGLog(TSLogGroupLocation, @"stopScan");
    
    if ( !control.running ) return;
    [control stopScan];

    // TODO: to reset session manager;
    [tickTimer invalidate];
    tickTimer = nil;
}

extern long currentTimeInMillis();

- (void)setTick {
    //NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    [self tick:currentTimeInMillis()];
}

- (void)setPMPolicy:(NSInteger)pmPolicy{

    //[NSException raise:@"BLESuite" format:@"setPMPolicy is NOT implemented YET."];
    
    LSPowerManagePolicy* policy = [LSPowerManagePolicy defaultPolicy];
    // TODO: to translate pmPolicy to policy object;
    [control setPowerManagePolicy:policy];
}



- (void)tick:(long)currentTimeInMillis {
    
    if ( !lastControlTick || currentTimeInMillis - lastControlTick >= CONTROL_INTERVAL_MS ) {
        [control tick:currentTimeInMillis];
        lastControlTick = currentTimeInMillis;
    }
    
    if ( !lastSessionMgrTick||currentTimeInMillis - lastSessionMgrTick >= SESSION_MGR_INTERVAL_MS ) {
        [sessionMgr tick:currentTimeInMillis];
        lastSessionMgrTick = currentTimeInMillis;
    }
    
    if ( !lastLocatorTick||currentTimeInMillis - lastLocatorTick >= LOCATOR_INTERVAL_MS ) {
        [locator tick:currentTimeInMillis];
        lastLocatorTick = currentTimeInMillis;
    }
}


/**
 *  Proximity Beacon 정보 받음
 *  Proximity Zone Detection 시작
 *
 *  @param beacon beacon 정보
 */
- (void)onProximityData:(Beacon*)beacon {
    //TSGLog(TSLogGroupLocation, @"onProximityData %@",  beacon);
     NSLog(@"%s onProximityData %@ %@ %@", __PRETTY_FUNCTION__, beacon.uuid, beacon.major, beacon.minor);
   
    SLBSCoordination* coordination = [self convertFromBeacon:beacon];
    
    [[ZoneDataManager sharedInstance] setDelegate:self];
    [[ZoneDataManager sharedInstance] detectProximityZone:beacon];
    [[PositionSessionManager sharedInstance] checkPosition:coordination];
    
    //Todo
    //LogManager에게 Proximity Location 저장 루틴 추가
}

/**
 *  Positioning Beacon 정보 받음
 *
 *  @param coordinate SLBSCoordination 정보
 */
- (void)onLocationSelected:(SLBSCoordination *)coordinate {
    //TSGLog(TSLogGroupLocation, @"onLocationSelected %@",  coordinate);
    
    // filter를 적용하자
    SLBSCoordination* newPos = nil;
    newPos = [kalman filter:coordinate];
    
    TSGLog(TSLogGroupLocation, @"kalman oldPos:%f, %f newPos: %f, %f",
     coordinate.x, coordinate.y, newPos.x, newPos.y);
    
    LOCCoordinate* oldPos = [[LOCCoordinate alloc] initWithMap:[newPos.mapID intValue] X:newPos.x Y:newPos.y];

    LOCCoordinate* matchedPos = [mapMatching filter:oldPos];
    TSGLog(TSLogGroupLocation, @"mapMatching oldPos:%f, %f newPos: %f, %f",
          oldPos.X, oldPos.Y, matchedPos.X, matchedPos.Y);
    
    if ( matchedPos != nil ) {
        newPos.x = matchedPos.X;
        newPos.y = matchedPos.Y;
    }
    else {
        TSGLog(TSLogGroupLocation, @"map matching failed");
    }
    
    SLBSCoordination* finalPos = newPos;
    
    [self.delegate sensorSuite:self onLocation:finalPos];
    
    [[PositionSessionManager sharedInstance] checkPosition:finalPos];
    [[ZoneDataManager sharedInstance] setDelegate:self];
    [[ZoneDataManager sharedInstance] detectZone:finalPos];
}

/**
 *  Zone Detection 결과
 *
 *  @param manager ZoneDataManager
 *  @param zoneID  zone ID
 */
- (void)zoneDataManager:(ZoneDataManager *)manager onZoneDetection:(NSInteger)zoneID {
    //TSGLog(TSLogGroupLocation, @"onZoneDetection %ld",  (long)zoneID);
    [[PositionSessionManager sharedInstance] detectSessionOfPosition:zoneID delegate:self];
}

/**
 *  Session Trigger
 *
 *  @param manager   SessionManager
 *  @param zoneID    zone ID
 *  @param zoneState Zone State
 */
- (void)sessionManager:(ProximitySessionManager *)manager triggerProxZoneState:(NSNumber *)zoneID zoneState:(SLBSSessionType)zoneState {
    TSGLog(TSLogGroupZone, @"triggerProxZoneState %@ %ld",  zoneID, (long)zoneState);
    NSLog(@"triggerProxZoneState %@ %ld", zoneID, (long)zoneState);
    
    [[ZoneCampaignDataManager sharedInstance] setDelegate:self];
     [[ZoneCampaignDataManager sharedInstance] detectZoneCampaign:zoneID sessionType:zoneState];
    
    [self sendZoneLogWithZoneID:zoneID zoneState:zoneState];
}

- (void)sessionManager:(PositionSessionManager *)manager triggerPosZoneState:(NSNumber *)zoneID zoneState:(SLBSSessionType)zoneState {
    TSGLog(TSLogGroupZone, @"triggerPosZoneState %@ %ld",  zoneID, (long)zoneState);
    NSLog(@"triggerPosZoneState %@ %ld",  zoneID, (long)zoneState);
    
    [[ZoneCampaignDataManager sharedInstance] setDelegate:self];
    [[ZoneCampaignDataManager sharedInstance] detectZoneCampaign:zoneID sessionType:zoneState];
    
    [self sendZoneLogWithZoneID:zoneID zoneState:zoneState];
}

/**
 *  Zone Campaign Detection
 *
 *  @param manager          zone campaign data manager
 *  @param zoneCampaignList Zone Campaign List
 */
- (void)ZoneCampaignDataManager:(ZoneCampaignDataManager *)manager onCampaignPopup:(NSArray *)zoneCampaignList {
    TSGLog(TSLogGroupCampaign, @"onCampaignPopup %@",  zoneCampaignList);
    
    [self.delegate sensorSuite:self onEvent:zoneCampaignList];
}

- (SLBSCoordination*)convertFromBeacon:(Beacon*)beacon{
    SLBSCoordination* coordination = [[SLBSCoordination alloc] init];

    Beacon* searchBeacon = [[BeaconDataManager sharedInstance] beaconForUUID:[[NSUUID alloc] initWithUUIDString:beacon.uuid] major:beacon.major minor:beacon.minor];
    coordination.companyID = searchBeacon.loc_company_id;
    coordination.branchID = searchBeacon.loc_branch_id;
    coordination.floorID = searchBeacon.loc_floor_id;
    coordination.mapID = searchBeacon.loc_map_id;
    coordination.type = SLBSCoordBeacon;
    coordination.x = searchBeacon.loc_x;
    coordination.y = searchBeacon.loc_y;
    
    
    return coordination;
}

/**
 *  BeaconSessionManager에서 새로운 Session 발견시 알려주는 callback
 *  Positioning 에서 사용하는 Session 객체로 Zone SessionType 과는 무관함.
 *  현재 BLESuite 에서는 사용할 부분이 없음
 *
 *  @param beacon BLEBeaconInfo 객체
 */
-(void)onDiscovery:(BLEBeaconInfo*)beacon
{
    NSLog(@"%s onDiscovery ", __PRETTY_FUNCTION__);
}

/**
 *  BeaconSessionManager에서 Session 만료시 알려주는 callback
 *  현재 BLESuite 에서는 사용할 부분이 없음
 *  Positioning 에서 사용하는 Session 객체로 Zone SessionType 과는 무관함.
 *
 *  @param beacon BLEBeaconInfo 객체
 */
-(void)onLost:(BLEBeaconInfo*)beacon
{
    NSLog(@"%s onLost ", __PRETTY_FUNCTION__);
}


- (int) gcd:(int)a b:(int)b {
    while(b!=0) {
        int tmp = a % b;
        a = b;
        b = tmp;
    }
    return a;
}

- (int)getTickGCD {
    return [self gcd:[self gcd:CONTROL_INTERVAL_MS b:SESSION_MGR_INTERVAL_MS] b:LOCATOR_INTERVAL_MS];
}

- (void)sendZoneLogWithZoneID:(NSNumber*)zoneID zoneState:(SLBSSessionType)zoneState{
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    NSString* appID = [[DeviceManager sharedInstance] appID];
    Zone* zone = [[ZoneDataManager sharedInstance] zoneForID:zoneID];
    NSString* locationLog = [NSString stringWithFormat:@"%@_%@_%@_%f_%f", zone.store_company_id, zone.store_branch_id, zone.store_floor_id, -1.0f, -1.0f];
    
//    [[LogManager sharedInstance] saveRouteLogWithDeviceID:deviceID appID:appID locationLog:locationLog companyID:zone.store_company_id branchID:zone.store_branch_id floorID:zone.store_floor_id coordX:-1.0f coordY:-1.0f zoneID:zone.zone_id zoneCampaignID:[NSNumber numberWithInt:-1] zoneLogType:[NSNumber numberWithInteger:zoneState]];
}
@end
