//
//  BleControl.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 25..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "BleControl.h"
#import "BeaconDataManager.h"
#import "BeaconUUID.h"
#import "TSDebugLogManager.h"
#import "SLBSKitDefine.h"
#import "BLEProximity.h"
#import "BLEBeaconScan.h"
#import "BLEBeaconInfo.h"
#import "TSDebugLogManager.h"

#define ON_TIMEOUT (1000)
#define OFF_TIMEOUT (5000)

@interface BLEControl()
@property (nonatomic, strong) CLLocationManager* locationManager;
@end

@implementation BLEControl {
    id<LSControlListener> listener;
    id<BLEProximityListener> proximityListener;
    LSPowerManagePolicy* policy;
    enum { OFF, ON, PERIODIC_ON, PERIODIC_OFF } currentState;
    long periodicTimestamp;
}

@synthesize running;

-(instancetype)init
{
    if ( self = [super init] )
    {
        running = NO;
        policy = [LSPowerManagePolicy defaultPolicy];
        
        periodicTimestamp = 0;
        currentState = OFF;
    }
    return self;
}

-(void)setListener:(id<LSControlListener>)_listener
{
    listener = _listener;
}

-(void)setProximityListener:(id<BLEProximityListener>)_listener
{
    proximityListener = _listener;
}

extern long currentTimeInMillis();

-(void)setPowerManagePolicy:(LSPowerManagePolicy*)_policy
{
    [self setPowerManagePolicy:_policy On:currentTimeInMillis()];
}

-(void)startScan
{
    [self startScan:currentTimeInMillis()];
}

-(void)startLeScan:(long)currentTimeInMillis
{
    TSGLog(TSLogGroupLocation, @"startLeScan");
    NSLog(@"[%08ld] CONTROL::StartLeScan", currentTimeInMillis);
    
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
    }
    
    NSArray* uuidList = [[BeaconDataManager sharedInstance] UUIDs];
        
    for(BeaconUUID* beaconUUID in uuidList) {
//         NSLog(@"Beacon Info uuid %@ company_id %@", beaconUUID.beacon_uuid, beaconUUID.company_id);
        
        NSUUID*  uuid = [[NSUUID alloc] initWithUUIDString:beaconUUID.beacon_uuid];
        CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:beaconUUID.beacon_uuid];
        if (beaconRegion) {
            beaconRegion.notifyEntryStateOnDisplay = YES;
            [self.locationManager startMonitoringForRegion:beaconRegion];
            //[self.locationManager startRangingBeaconsInRegion:beaconRegion];
        }
        NSLog(@"startRanging for Beacon:%@", beaconUUID.beacon_uuid);
    }

}

-(void)stopLeScan:(long)currentTimeInMillis
{
    TSGLog(TSLogGroupLocation, @"stopLeScan");
    NSLog(@"[%08ld] CONTROL::StopLeScan", currentTimeInMillis);
}

-(void)changeState:(int)newState On:(long)currentTimeInMillis
{
    int oldState = currentState;
    currentState = newState;
    
    if (( oldState == OFF || oldState == PERIODIC_OFF) &&
        ( newState == ON ||  newState == PERIODIC_ON )) {
        [self startLeScan:currentTimeInMillis];
    }
    else if (( oldState == ON || oldState == PERIODIC_ON) &&
             ( newState == OFF ||  newState == PERIODIC_OFF )) {
        [self stopLeScan:currentTimeInMillis];
    }
    
    if ( newState == PERIODIC_ON || newState == PERIODIC_OFF ) {
        periodicTimestamp = currentTimeInMillis;
    }
}

-(void)startScan:(long)currentTimeInMillis
{
    //if ( listener == nil ) return;
    if ( running == YES ) return;
    running = YES;

    LSScanMode mode = policy.scanMode;
    if ( mode == FULL_SCAN ) {
        [self changeState:ON On:currentTimeInMillis];
    }
    else if ( mode == PERIODIC_SCAN ) {
        [self changeState:PERIODIC_ON On:currentTimeInMillis];
    }
}

-(void)stopScan
{
    for(CLRegion* region in self.locationManager.monitoredRegions)
        [self.locationManager stopMonitoringForRegion:region];
    
    [self stopScan:currentTimeInMillis()];
}

-(void)stopScan:(long)currentTimeInMillis
{
    if ( running == NO ) return;
    running = NO;
    
    [self changeState:OFF On:currentTimeInMillis];
}

-(void)setPowerManagePolicy:(LSPowerManagePolicy*)_policy On:(long)currentTimeInMillis
{
    TSGLog(TSLogGroupLocation, @"setPowerManagePolicy %@", _policy);
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
    if ( running == NO ) return;
    
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

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
  
    for(CLBeacon* clBeacon in beacons ) {
        //TSGLog(TSLogGroupLocation, @"didRangeBeacons %@", clBeacon);
        
        NSLog(@"%s didRangeBeacons %@ %@ %@ %ld", __PRETTY_FUNCTION__, clBeacon.proximityUUID, clBeacon.major, clBeacon.minor, (long)clBeacon.rssi);
        
        if(clBeacon.rssi == 0)
            continue;
        
        Beacon* beacon = [[BeaconDataManager sharedInstance] beaconForUUID:clBeacon.proximityUUID major:clBeacon.major minor:clBeacon.minor];

       
        BLEBeaconScan* beaconScan = [[BLEBeaconScan alloc] init];        
        BLEBeaconInfo* beaconInfo =[[BLEBeaconInfo alloc] initWithUUID:clBeacon.proximityUUID Major:[clBeacon.major integerValue] Minor:[clBeacon.minor integerValue]];
        [beaconScan setBeaconInfo:beaconInfo];
        [beaconScan setRssi:clBeacon.rssi];
        
        [listener onSensorData:beaconScan];

        
        if ([beacon.type integerValue] == SLBSBeaconProximity) {
            if(proximityListener != nil)
                [proximityListener onProximityData:beacon];
            break;
        };

    }
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if(state == CLRegionStateInside)
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    else if(state == CLRegionStateOutside)
        [self.locationManager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
}

#pragma mark - CLLocationManagerDelegate
/*- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error {
    NSLog(@"[CLLocationManagerDelegate] %@ region(%@) error(%@", NSStringFromSelector(_cmd), region, error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"[CLLocationManagerDelegate] %@ error(%@", NSStringFromSelector(_cmd), error);
}
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"[CLLocationManagerDelegate] %@ region(%@) error(%@", NSStringFromSelector(_cmd), region, error);
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"[CLLocationManagerDelegate] %@ status(%@)", NSStringFromSelector(_cmd), [BLEControl stringForStatus:status]);
}

+ (NSString *)stringForStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            return @"kCLAuthorizationStatusNotDetermined";
            break;
        case kCLAuthorizationStatusRestricted:
            return @"kCLAuthorizationStatusRestricted";
            break;
        case kCLAuthorizationStatusDenied:
            return @"kCLAuthorizationStatusDenied";
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            return @"kCLAuthorizationStatusAuthorizedAlways";
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return @"kCLAuthorizationStatusAuthorizedWhenInUse";
            break;
        default:
            return @"kCLAuthorizationStatusUnknown";
            break;
    }
    return @"kCLAuthorizationStatusUnknown";
}*/

@end
