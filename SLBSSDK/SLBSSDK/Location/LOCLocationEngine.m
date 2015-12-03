//
//  LOCLocationEngine.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LOCLocationEngine.h"
#import "ZoneCampaignDataManager.h"
#import "LSDummySuite.h"
#import "TSDebugLogManager.h"
#import "LogManager.h"
#import "DeviceManager.h"
#import "BLESuite.h"
#import "GeofenceSuite.h"
#import "DataManager.h"

@interface LOCLocationEngine()
@property bool runnning;
@property bool bleON;
@property bool geofenceON;
@property (nonatomic, strong) NSMutableArray* suites;
@property NSDate* logSaveCheckDate;
@end


@implementation LOCLocationEngine : NSObject

//#define DUMMY_TESTCODE 1

#ifdef DUMMY_TESTCODE
LSDummySuite* LSdummySuite;
#endif

+ (LOCLocationEngine*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static LOCLocationEngine *sharedLocationEngine = nil;
    dispatch_once(&oncePredicate, ^{
        sharedLocationEngine = [[LOCLocationEngine alloc] init];
    });
    return sharedLocationEngine;
}

/**
 *  SensorSuite 추가
 *  현재 지원 Sensor는 BLE와 GPS
 *
 *  @param sensorSuite SensorSuite
 */
- (void)addSensorSuite:(LSSuite*)sensorSuite {
    TSGLog(TSLogGroupLocation, @"addSensorSuite %@",  sensorSuite);
    
    if(_suites == nil)
        _suites = [[NSMutableArray alloc] init];
    
    [_suites addObject:sensorSuite];
}

/**
 *  위치 서비스 시작
 */
- (void)startScan
{
    TSGLog(TSLogGroupLocation, @"startScan");
    BOOL locationUsageAgreement = [[DataManager sharedInstance] locationUsageAgreement];
    
    if(locationUsageAgreement == NO)//위치 정보 동의하지 않은 경우 시작하지 않음
        return;
    else {
        if([_suites count] == 0) return; //동의 후 바로 StartScan 호출하여도 SensorSuite 추가된 내용이 없으면 StartScan을 하지 않는다.
    }
    
    if( self.runnning ) return;
    self.runnning = YES;
    
    NSLog(@"startScan");
#ifdef DUMMY_TESTCODE
    NSLog(@"%s Dummy StartScan", __PRETTY_FUNCTION__);
    LSdummySuite = [[LSDummySuite alloc] init];
    
    [LSdummySuite setDelegate:self];
    [LSdummySuite startScan];
#else
     NSLog(@"%s StartScan", __PRETTY_FUNCTION__);
    
    for(LSSuite* suite in _suites)
    {
        if(([suite isKindOfClass:[BLESuite class]] && self.bleON) ||
           ([suite isKindOfClass:[GeofenceSuite class]] && self.geofenceON) ) {
            [suite setDelegate:self];
            [suite startScan];
        }
    }
#endif
}

/**
 *  위치 서비스 중단
 */
- (void)stopScan
{
    TSGLog(TSLogGroupLocation, @"stopScan");
    
    if( !self.runnning ) return;
#ifdef DUMMY_TESTCODE
    [LSdummySuite stopScan];
#else
    NSLog(@"%s StopSacn", __PRETTY_FUNCTION__);
    for(LSSuite* suite in _suites)
        [suite stopScan];
#endif
    
    self.runnning = NO;
}

- (void)stopScan:(LSSuite*)suite {
    
}
/**
 *  Policy 설정
 *
 *  @param policyData Policy 데이터
 */
- (void)setPolicy:(Policy*)policyData
{
    //TSGLog(TSLogGroupLocation, @"setPolicy %@", policyData);
    
    NSLog(@"%s setPolicy", __PRETTY_FUNCTION__);
    self.bleON = [policyData microfence];
    self.geofenceON = [policyData geofence];
    
    for(LSSuite* suite in _suites) {
        [suite setPMPolicy:(NSInteger)policyData.position_battery];
        
        
        if(self.runnning) { //위치 서비스 실행 중인 경우
            if(([suite isKindOfClass:[BLESuite class]] && !self.bleON) || //BLESuite 실행 중이나, ble policy가 off 인 경우
               ([suite isKindOfClass:[GeofenceSuite class]] && !self.geofenceON)) { //GeofenceSuite 실행 중이나 geofence policy가 off 인 경우
                [suite stopScan];
            }
        }
        else { //위치 서비스 실행 중이 아닌 경우
            if(([suite isKindOfClass:[BLESuite class]] && self.bleON) || //BLESuite가 SensorSuite으로 등록 되어 있고, ble policy가 on 인 경우
               ([suite isKindOfClass:[GeofenceSuite class]] && self.geofenceON)) { //GeofenceSuite가 SensorSuite으로 등록되어 있고 geofence policy가 on 인 경우
                [suite startScan];
            }
        }
        
    }
    
    
}

/**
 *  SensorSuite 통해 전달된 위치 정보
 *  전달된 SLBSCoordination 값으로 Zone Detection 시작
 *
 *  @param manager  SensorSuite
 *  @param coordination SLBS 좌표
 */
- (void)sensorSuite:(LSSuite *)manager onLocation:(SLBSCoordination *)coordination{
    //TSGLog(TSLogGroupLocation, @"onLocation %@",  coordination);
    
    [self.locationDelegate locationEngine:self onLocation:coordination];
    
    [self sendLocationLogWithCoordination:coordination];
}

/**
 *  SensorSuite 통해 전달된 Campaign 정보
 *  App에게 ZoneCampaign 정보 전달
 *
 *  @param manager      SensorSuite
 *  @param campaignList ZoneCampaign List
 */
- (void)sensorSuite:(LSSuite *)manager onEvent:(NSArray*)campaignList{
    for(SLBSZoneCampaignInfo* zoneCampaignInfo in campaignList) {
        //TSGLog(TSLogGroupLocation, @"onEvent %@",  zoneCampaignInfo.name);
        
        NSLog(@"%s onCampaignPopup %@", __PRETTY_FUNCTION__, zoneCampaignInfo.ID );
        for(NSNumber* zoneID in zoneCampaignInfo.zoneIDs) {
            Zone* zone = [[ZoneDataManager sharedInstance] zoneForID:zoneID];
            [self sendZoneCampaignLogWithZoneCmapaignID:zoneCampaignInfo.ID zone:zone];
        }
    }
    
    [self.zoneCampaignDelegate locationEngine:self didEventCampaign:campaignList];
    
}

/**
 *  LocationLog 저장
 *
 *  @param coordination 저장될 위치의 SLBS 좌표값
 */
- (void)sendLocationLogWithCoordination:(SLBSCoordination *)coordination {
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    NSString* appID = [[DeviceManager sharedInstance] appID];
    NSString* locationLog = [NSString stringWithFormat:@"%@_%@_%@_%f_%f", coordination.companyID, coordination.branchID, coordination.floorID, coordination.x, coordination.y];
    [[LogManager sharedInstance] saveRouteLogWithDeviceID:deviceID appID:appID locationLog:locationLog companyID:coordination.companyID branchID:coordination.branchID floorID:coordination.floorID coordX:coordination.x coordY:coordination.y zoneID:[NSNumber numberWithInt:-1] zoneCampaignID:[NSNumber numberWithInt:-1] zoneLogType:[NSNumber numberWithInt:-1]];
}

/**
 *  ZoneCampaign Log 저장
 *
 *  @param zoneCampaignID ZoneCampaign ID
 *  @param zone           ZoneCampaign 발생한 Zone 정보
 */
- (void)sendZoneCampaignLogWithZoneCmapaignID:(NSNumber*)zoneCampaignID zone:(Zone*)zone{
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    NSString* appID = [[DeviceManager sharedInstance] appID];
    NSString* locationLog = [NSString stringWithFormat:@"%@_%@_%@_%f_%f", zone.store_company_id, zone.store_branch_id, zone.store_floor_id, -1.0f, -1.0f];
    
    [[LogManager sharedInstance] saveRouteLogWithDeviceID:deviceID appID:appID locationLog:locationLog companyID:zone.store_company_id branchID:zone.store_branch_id floorID:zone.store_floor_id coordX:-1.0f coordY:-1.0f zoneID:zone.zone_id zoneCampaignID:zoneCampaignID zoneLogType:[NSNumber numberWithInt:-1]];
}

/**
 *  사용자 위치정보동의 값에 따라 위치서비스 시작/중단
 *
 *  @param locationUsageAgreement 위치정보동의 설정값
 */
- (void)setLocationUsageAgreement:(BOOL)locationUsageAgreement {
    if (locationUsageAgreement) {
        [self startScan];
    } else {
        [self stopScan];
    }
}

@end
