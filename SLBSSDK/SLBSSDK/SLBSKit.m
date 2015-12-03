//
//  SLBSKit.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBSKit.h"
#import "DeviceManager.h"
#import "PolicyManager.h"
#import "LogManager.h"
#import "GeofenceSuite.h"
#import "BLESuite.h"
#import "TSDebugLogManager.h"
#import "ZoneNet.h"
#import "ZoneCampaignNet.h"
#import "BeaconNet.h"
#import "SLBSZoneCampaignInfo.h"
#import "MapDataManager.h"
#import "DeviceNet.h"
#import "BeaconDataManager.h"
#import "MapNet.h"
#import "MapDataManager.h"
//#define TEST_CODE

@interface SLBSKit()
@property (nonatomic)NSMutableArray* startServiceList;
@property (nonatomic)BOOL hasAlreadyServerData;

@property GeofenceSuite* geofenceSuite;
@property BLESuite* bleSuite;
@property NSInteger checkMapGraphCount;
@property NSInteger checkMapDataCount;
@end

@implementation SLBSKit : NSObject 

/**
 *  SLBSKit Insstance 객체
 *  Singleton 객체이며, 생성시 initialize 진행
 *
 *  @return SLBSKit Instance
 */
#pragma mark - Singletons
+ (SLBSKit*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static SLBSKit *sharedSLBSKit = nil;
    dispatch_once(&oncePredicate, ^{
        sharedSLBSKit = [[SLBSKit alloc] init];
    });
    return sharedSLBSKit;
}

- (instancetype)init {
    self = [super init];
    
    self.locationDelegate = nil;
    self.zoneCampaignDelegate = nil;
    self.mapDelegate = nil;
    self.dataDelegate = nil;
    
    self.startServiceList = [[NSMutableArray alloc] init];
    self.hasAlreadyServerData = false;
    self.hasAlreadyAccessToken = false;
    
    [self initialize];
    return self;
}

/**
 *  서비스 초기 셋팅 작업 수행
 *
 *  1. DeviceID, AccessToken 요청
 *  2. Policy 정보 동기화
 *  3. Log/LocationEngine에 policy 반영
 *  4. Zone Data 요청
 *  5. Zone Campaign Data 요청
 */
- (void) initialize
{
    //Todo
    //initData에서 Error 발생시 App에게 전달할 방법 고민
    
    NSLog(@"%s initilize", __PRETTY_FUNCTION__);
    TSGLog(TSLogGroupCommon, @"initialize");
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [[DeviceManager sharedInstance] initData];
    });

}


- (void)startService {
    
    for(NSNumber* category in self.startServiceList) {
        [self startServiceWithCategory:[category integerValue]];
    }
}

/**
 *  서비스 시작 전 체크 함수
 *  서버와의 통신을 위한 AccessToken 준비가 되었는지에 따라 바로 서비스 시작 또는
 *  ServiceList에 추가등의 작업 수행
 *
 * @param serviceCategory - Service 시작의 주체 명시, 명시하지 않으니 같은 Callback이 자주 발생하는 문제 발생
 */
- (void)startService:(SLBSServiceCategory)serviceCategory
{
    if(self.hasAlreadyServerData == false)
    {
        NSNumber* category = [NSNumber numberWithInt:serviceCategory];
        switch (serviceCategory) {
            case SLBSServiceMap:
            case SLBSServiceData:
                if(self.hasAlreadyAccessToken)
                    [self startServiceWithCategory:serviceCategory];
                break;
            case SLBSServiceLocation:
            case SLBSServiceZoneCampaign:
                [self.startServiceList addObject:category];
            default:
                break;
        }
    }
    else
        [self startServiceWithCategory:serviceCategory];
   
}

/**
 *  서비스 시작
 *  App에서 셋팅한 Delegate들 체크하여 각각에 맞게 동작 설정
 *  1. Location/ZoneCampaign - LocationEngine 시작
 *  2. Map - MapDataManager에게 서버 동기화 요청
 *
 * @param serviceCategory - Service 시작의 주체 명시, 명시하지 않으니 같은 Callback이 자주 발생하는 문제 발생
 */
- (void)startServiceWithCategory:(SLBSServiceCategory)serviceCategory
{
    NSLog(@"startService");
    TSGLog(TSLogGroupCommon, @"startService %ld", (long)serviceCategory);

    //Todo Policy 정책에 따라 Geofencesuite/BLESuite add 여부 판단코드 추가
    switch (serviceCategory) {
        case SLBSServiceLocation:
            if(self.locationDelegate != nil) {
                if(self.geofenceSuite == nil)
                {
                    self.geofenceSuite = [[GeofenceSuite alloc] init];
                    [[LOCLocationEngine sharedInstance] addSensorSuite:self.geofenceSuite];
                }
                if(self.bleSuite == nil) {
                    self.bleSuite = [BLESuite sharedInstance];
                     [[LOCLocationEngine sharedInstance] addSensorSuite:self.bleSuite];
                }
 
                [[LOCLocationEngine sharedInstance] setLocationDelegate:self];
                [[LOCLocationEngine sharedInstance] startScan];
            }
            break;
        case SLBSServiceZoneCampaign:
            if(self.zoneCampaignDelegate != nil){
                if(self.geofenceSuite == nil)
                {
                    self.geofenceSuite = [[GeofenceSuite alloc] init];
                    [[LOCLocationEngine sharedInstance] addSensorSuite:self.geofenceSuite];
                }
                if(self.bleSuite == nil) {
                    self.bleSuite = [BLESuite sharedInstance];
                    [[LOCLocationEngine sharedInstance] addSensorSuite:self.bleSuite];
                }
                
                [[LOCLocationEngine sharedInstance] setZoneCampaignDelegate:self];
                [[LOCLocationEngine sharedInstance] setLocationDelegate:self];
                [[LOCLocationEngine sharedInstance] startScan];
                
            }
            break;
        case SLBSServiceMap:
            if(self.mapDelegate != nil) {
                [self.mapDelegate onServiceReady];
                self.mapDelegate = nil;
            }
            break;
        case SLBSServiceData:
            if(self.dataDelegate != nil) {
                [self.dataDelegate onServiceReady];
            }
        default:
            break;
    }
    
#ifdef TEST_CODE
    [self testDelegate:serviceCategory];
#endif
}

/**
 *  서비스 중지
 *  1. Location,ZoneCampaign - LocationEngine 중지
 *  2. Map - 단발성 요청이라 특별한 작업 수행하는 것 없음
 */
- (void)stopService{
    TSGLog(TSLogGroupCommon, @"stopService");

    if(self.locationDelegate == nil && self.zoneCampaignDelegate == nil)
        [[LOCLocationEngine sharedInstance] stopScan];
}

/**
 *  LocationEngineLocationDelegate protocol
 *  LocationEngine으로부터 전달 받은 데이터를 SLBSLocationManager에게 전달
 *
 *  @param engine   LOCLocationEngine
 *  @param location SLBSCoordination
 */
- (void)locationEngine:(LOCLocationEngine *)engine onLocation:(SLBSCoordination *)location
{
    NSLog(@"%s onLocation x: %f y:%f", __PRETTY_FUNCTION__, location.x, location.y);
    TSGLog(TSLogGroupLocation, @"onLocation x: %f y:%f", location.x, location.y);

    if(self.locationDelegate)
        [self.locationDelegate slbskit:self onLocation:location];
}

/**
 *  LocationEngineZoneCampaignDelegate protocol
 *  LocationEngine으로부터 전달받은 Campaign 정보를 SLBSZoneCampaignManager에게 전달
 *
 *  @param engine           LOCLocationEngine
 *  @param zoneCampaignList ZoneCampaign List
 */
- (void)locationEngine:(LOCLocationEngine *)engine didEventCampaign:(NSArray *)zoneCampaignList
{
    for(SLBSZoneCampaignInfo * zoneCampaignInfo in zoneCampaignList) {
        NSLog(@"%s didEventCampaign name: %@", __PRETTY_FUNCTION__, zoneCampaignInfo.name);
        TSGLog(TSLogGroupCampaign, @"didEventCampaign name: %@", zoneCampaignInfo.name);
    }
    
    if(self.zoneCampaignDelegate)
        [self.zoneCampaignDelegate slbskit:self didEventCampaign:zoneCampaignList];
}

- (void)testDelegate:(SLBSServiceCategory)serviceCategory
{
    switch (serviceCategory) {
        case SLBSServiceLocation:
            if(self.locationDelegate) {
                SLBSCoordination* location = [[SLBSCoordination alloc] init];
                [location setFloorID:[NSNumber numberWithInt:1000]];
                [location setX:1000];
                [location setY:1000];
                
                [self.locationDelegate slbskit:self onLocation:location];
            }
            break;
        case SLBSServiceZoneCampaign:
            if(self.zoneCampaignDelegate) {
                SLBSZoneCampaignInfo* zoneCampaign = [[SLBSZoneCampaignInfo alloc] init];
                [zoneCampaign setZoneCampaignID:(NSInteger)2000];
                
                NSMutableArray* zoneCampaingList = [[NSMutableArray alloc] init];
                [zoneCampaingList addObject:zoneCampaign];
                
                [self.zoneCampaignDelegate slbskit:self didEventCampaign:zoneCampaingList];
            }
            break;
        case SLBSServiceMap:
            break;
        default:
            break;
    }
}

-(void)loadMapInfo:(int)mapId block:(void(^)(SLBSMapData*))block
{
    [[MapDataManager sharedInstance] loadMapInfo:mapId token:@"asdf" block:block];
}

-(void)readyToAccessToken {
    dispatch_async(dispatch_get_main_queue(), ^{
    
    TSGLog(TSLogGroupCommon, @"syncWithServer");
        
        NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
        
        [[PolicyManager sharedInstance] requestPolicyToServerWithBlock:^(BOOL successed, Policy* policyData) {
            if(successed)
            {
                NSLog(@"%s requestPolicyToServerWithBlock success", __PRETTY_FUNCTION__);
                [[LogManager sharedInstance] setPolicy:policyData];
                [[LOCLocationEngine sharedInstance] setPolicy:policyData];
                [BeaconNet requestUUIDListWithAccessToken:accessToken block:^(BeaconNet* net){
                    if(net.returnCode == 0) {
                        NSLog(@"requestUUIDListWithAccessToken success");
                        [BeaconNet requestBeaconListWithAccessToken:accessToken block:^(BeaconNet* net){
                            if(net.returnCode == 0){
                                NSLog(@"%s requestBeaconListWithAccessToken success", __PRETTY_FUNCTION__);
                                //[ZoneNet requestZoneListWithAccessToken:accessToken block:^(ZoneNet* net){
                                //    if(net.returnCode == 0) {
                                //        NSLog(@"%s requestZoneListWithBlock success", __PRETTY_FUNCTION__);
                                        
                                        [ZoneCampaignNet requestCampaignsWithAccessToken:accessToken block:^(ZoneCampaignNet* zoneCampaignNet){
                                            if(zoneCampaignNet.returnCode == 0) {
                                                NSLog(@"%s requestCampaignsWithAccessToken success", __PRETTY_FUNCTION__);
                                                
                                                [[ZoneCampaignDataManager sharedInstance] setZoneCampaigns:zoneCampaignNet.campaigns];
                                                self.hasAlreadyServerData = true;
                                                [self startService];
                                                
                                                //Todo, geMapData에서 Full Data 전달해주면 삭제해야 함
                                                [self requestMapData];
                                            }
                                            
                                        }];
                                  //  }
                               // }];
                            }
                        }];
                    }
                    else
                        NSLog(@"%s requestUUIDListWithAccessToken fail", __PRETTY_FUNCTION__);
                    
                }];
            }
        }];
        

    });

}

- (void)requestMapData {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray* beaconMapList = [[[BeaconDataManager sharedInstance] beacons] valueForKeyPath:@"@distinctUnionOfObjects.loc_map_id"];
        NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
        
        NSMutableArray* mapGraphInfos = [NSMutableArray array];
        NSMutableArray* mapDatas = [NSMutableArray array];
        
        self.checkMapDataCount = [beaconMapList count];
        self.checkMapGraphCount = [beaconMapList count];
        
        for (NSNumber *beaconMapId in beaconMapList)
        {
            [MapNet getMapGraphData:accessToken mapId:[beaconMapId intValue] block:^(MapGraphInfo* graphInfo) {
                if(graphInfo) {
                   [mapGraphInfos addObject:graphInfo];
                    
                    self.checkMapGraphCount--;
                    
                    if(self.checkMapGraphCount == 0)
                       [[MapDataManager sharedInstance] setMapGraphInfos:mapGraphInfos];
                }
            }];
            
            [MapNet getMapData:accessToken mapId:[beaconMapId intValue] block:^(SLBSMapData* mapData){
                if(mapData) {
                     [mapDatas addObject:mapData];
                    
                    self.checkMapDataCount--;
                    
                    if(self.checkMapDataCount == 0)
                        [[MapDataManager sharedInstance] setMapDatas:mapDatas];
                }
            }];
            
        }
    });
}


@end