//
//  GeofenceControl.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeofenceControl.h"
#import "SLBSCoordination.h"
#import "SLBSKitDefine.h"
#import "TSDebugLogManager.h"

#define ON_TIMEOUT (1*1000)
#define OFF_TIMEOUT (5*1000)
#define LOCATION_UPDATE_TIMING          150
#define LOCATION_UPDATE_DISTANCE        30
#define LOCATION_UPDATE_EXPIRATION      600
#define LOCATION_UPDATE_MIN_ACCURACY    200

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

extern long currentTimeInMillis();

@interface GeofenceControl()
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation    * lastValidLocation;
@end

@implementation GeofenceControl{
    BOOL _running;
    id<LSControlListener> listener;
    LSPowerManagePolicy* policy;
    enum { OFF, ON, PERIODIC_ON, PERIODIC_OFF } currentState;
    long periodicTimestamp;
}

-(instancetype) init
{
    if ( self = [super init] ) {
        _running = NO;
        policy = [LSPowerManagePolicy defaultPolicy];
        
        periodicTimestamp = 0;
        currentState = OFF;
    }
    return self;
}

/**
 *  시스템에게 위치 정보 탐색 시작 요청
 *  CLLocationManager 설정
 *
 *  @param currentTimeInMillis  주기 조절을 위한 시간
 */
-(void)startGeofenceScan:(long)currentTimeInMillis
{
    TSGLog(TSLogGroupLocation, @"startGeofenceScan");
    
    NSLog(@"[%08ld] CONTROL::startGeofenceScan", currentTimeInMillis);
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 100;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    //일단은 false, perfomance 체크 후에 true로 갈지 결정 필요
    //T사 결과 배터리 너무 많이 먹음 ㅠㅠ
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    
#ifdef __IPHONE_9_0
    if(IS_OS_9_OR_LATER)
        self.locationManager.allowsBackgroundLocationUpdates = YES;
#endif
    //권한 확인
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if ( status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted ) {
       NSLog(@"not allow to use location Services");
        return;
    }else if ( status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusAuthorizedWhenInUse ){
        if(IS_OS_8_OR_LATER)
            [self.locationManager requestAlwaysAuthorization];
    }

    [self.locationManager startUpdatingLocation];
    [self.locationManager startMonitoringSignificantLocationChanges];
}

/**
 *  시스템에게 위치 정보 탐색 중지 요청
 *
 *  @param currentTimeInMillis 주기 조절을 위한 시간 현재는 사용하지 않음
 */
-(void)stopGeofenceScan:(long)currentTimeInMillis
{
    TSGLog(TSLogGroupLocation, @"stopGeofenceScan");
    
    NSLog(@"[%08ld] CONTROL::stopGeofenceScan", currentTimeInMillis);
    [self.locationManager stopUpdatingLocation];
    [self.locationManager stopMonitoringSignificantLocationChanges];
    
    self.locationManager = nil;
    self.locationManager.delegate = nil;
    
}

/**
 *  주기 조절을 위한 state 관리
 *
 *  @param newState            스캔 주기 상태
 *  @param currentTimeInMillis 현재 시간
 */
-(void)changeState:(int)newState On:(long)currentTimeInMillis
{
    int oldState = currentState;
    currentState = newState;
    
    if (( oldState == OFF || oldState == PERIODIC_OFF) &&
        ( newState == ON ||  newState == PERIODIC_ON )) {
        [self startGeofenceScan:currentTimeInMillis];
    }
    else if (( oldState == ON || oldState == PERIODIC_ON) &&
             ( newState == OFF ||  newState == PERIODIC_OFF )) {
        [self stopGeofenceScan:currentTimeInMillis];
    }
    
    if ( newState == PERIODIC_ON || newState == PERIODIC_OFF ) {
        periodicTimestamp = currentTimeInMillis;
    }
}

/**
 *  LocationEngine에서 호출하는 시작 함수
 */
-(void)startScan
{
    [self startScan:currentTimeInMillis()];
}

/**
 *  현재 시간과 함께 period 주기 확인하여, changeState 호출
 *
 *  @param currentTimeInMillis 현재 시간
 */
-(void)startScan:(long)currentTimeInMillis
{
    if ( _running ) return;
    _running = YES;
    
    LSScanMode mode = policy.scanMode;
    if ( mode == FULL_SCAN ) {
        [self changeState:ON On:currentTimeInMillis];
    }
    else if ( mode == PERIODIC_SCAN ) {
        [self changeState:PERIODIC_ON On:currentTimeInMillis];
    }
}

/**
 *  LocationEngine에서 호출하는 중지 함수
 */
-(void)stopScan
{
    [self stopScan:currentTimeInMillis()];
}

-(void)stopScan:(long)currentTimeInMillis
{
    if ( !_running ) return;
    _running = NO;
    [self changeState:OFF On:currentTimeInMillis];
    
}

-(void)setListener:(id<LSControlListener>)_listener
{
    listener = _listener;
}

-(void)setPowerManagePolicy:(LSPowerManagePolicy*)_policy
{
    TSGLog(TSLogGroupLocation, @"setPowerManagePolicy %@", _policy);
    [self setPowerManagePolicy:_policy On:currentTimeInMillis()];
}

-(void)setPowerManagePolicy:(LSPowerManagePolicy*)_policy On:(long)currentTimeInMillis
{
    LSScanMode newMode = _policy.scanMode;
    
    policy = _policy;
    
    switch(currentState) {
        case ON:
            if ( newMode == PERIODIC_SCAN ) {
                [self changeState:PERIODIC_ON On:currentTimeInMillis];
            }
            break;
        case PERIODIC_ON:
        case PERIODIC_OFF:
            if ( newMode == FULL_SCAN ) {
                [self changeState:ON On:currentTimeInMillis];
            }
            break;
        default:
            break;
    }
}

-(void)tick:(long)currentTimeInMillis
{
    if ( _running == NO ) return;
    
    const LSScanMode mode = policy.scanMode;
    if ( mode == FULL_SCAN ) return;
    
    if ( currentState == PERIODIC_ON ) {
        if ( currentTimeInMillis - periodicTimestamp >= ON_TIMEOUT ) {
            [self changeState:PERIODIC_OFF On:currentTimeInMillis];
        }
    }
    else if ( currentState == PERIODIC_OFF ) {
        if ( currentTimeInMillis - periodicTimestamp >= OFF_TIMEOUT ) {
            [self changeState:PERIODIC_ON On:currentTimeInMillis];
        }
    }
}

/**
 *  시스템에서 올려주는 위치 정보 콜백
 *
 *  @param manager   CLLocationManager
 *  @param locations 위치 정보
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    TSGLog(TSLogGroupLocation, @"didUpdateLocations %@", [locations lastObject]);
   //onLocation은 Policy 정책에 따라 올려주는 주기는 달라질 수 있음
   //iOS는 System주기와 Policy 주기 맞출 수 있는지 확인 필요
    CLLocation* location = [locations lastObject];
    BOOL validity = [self checkValidForLocation:location];
    
    TSGLog(TSLogGroupLocation, @"checkValidForLocation %d", validity);
    if (validity) {
        SLBSCoordination* coordination = [self convertToCLLocation:location];
        [listener onSensorData:coordination];

    }else{
        NSLog(@"Invalid Position");
    }

}

/**
 *  CLLocation -> SLBSCoordination 변환 함수
 *
 *  @param location CLLocation
 *
 *  @return SLBSCoordination
 */
- (SLBSCoordination*)convertToCLLocation:(CLLocation*)location{
    SLBSCoordination* coordination = [[SLBSCoordination alloc] init];
    coordination.type = [NSNumber numberWithInteger:SLBSCoordGPS];
    coordination.x = location.coordinate.latitude;
    coordination.y = location.coordinate.longitude;
    return coordination;
}

/**
 *  Invalid Location Check
 *  이전 위치의 거리와 시간을 바탕으로 Invalid Position Filtering
 *
 *  @param newLocation 현재 위치
 *
 *  @return Valid 유무
 */
- (BOOL)checkValidForLocation:(CLLocation *)newLocation{
    //Todo: 실제 동작보고 Tuning 필요
    if (newLocation == nil) { return false; }
    
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > LOCATION_UPDATE_EXPIRATION) { return false; }
    
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > LOCATION_UPDATE_MIN_ACCURACY) { return false; }
    
    if (_lastValidLocation == nil){ self.lastValidLocation = newLocation; return true; }
    
    CLLocationDistance distance = [newLocation distanceFromLocation:_lastValidLocation];
    NSTimeInterval  timeInterval = [newLocation.timestamp timeIntervalSinceDate:_lastValidLocation.timestamp];
    
    // test the measurement to see if it is more accurate than the previous measurement
    if (_lastValidLocation.horizontalAccuracy > newLocation.horizontalAccuracy || distance > LOCATION_UPDATE_DISTANCE || timeInterval > LOCATION_UPDATE_TIMING) {
        self.lastValidLocation = newLocation;
        return true;
    }
    return false;
}
@end
