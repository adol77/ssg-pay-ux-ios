//
//  BleSessionMgr.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "BLESessionMgr.h"
#import "BLEBeaconScan.h"
#import "BLEBeaconInfo.h"
#import "BLEBeaconSession.h"
#import "Beacon.h"
#import "TSDebugLogManager.h"

#define SESSION_TIMEOUT (10*1000)

@implementation BLESessionMgr {
    NSMutableDictionary* sessionMap; // BLEBeaconInfo -> BLEBeaconSession
}

@synthesize listener;

-(instancetype)init
{
    if ( self = [super init] ) {
        sessionMap = [NSMutableDictionary dictionary];
    }
    return self;
}

extern long currentTimeInMillis();

-(void)onSensorData:(id)data
{
    BLEBeaconScan* beacon = (BLEBeaconScan*)data;

    NSLog(@"%s onSensorData %@ %d %d", __PRETTY_FUNCTION__, beacon.beaconInfo.uuid, beacon.beaconInfo.major, beacon.beaconInfo.minor);
    
    [self onSensorData:data On:currentTimeInMillis()];
}

-(void)onSensorData:(id)data On:(long)currentTimeInMillis;
{
    // check if data is a BeaconScan object
    if (![data isKindOfClass:[BLEBeaconScan class]]) return;
    BLEBeaconScan* s = data;
    BLEBeaconInfo* b = s.beaconInfo;
    
    BOOL newBeacon = NO;
    BLEBeaconSession* session = [sessionMap objectForKey:b];
    if ( session == nil ) {
        session = [[BLEBeaconSession alloc] initWith:b On:currentTimeInMillis];
        [sessionMap setObject:session forKey:b];
        newBeacon = YES;
    }
    
    [session updateRssi:s.rssi OnTime:currentTimeInMillis];
    if ( newBeacon && listener != nil ) {
        // to notify about the new beacon's appereance
        [listener onDiscovery:b];
    }
}

-(NSArray*)strongestBeaconScans:(int)size
{
    const int count = MIN((int)[sessionMap count], size);
    if ( count <= 0 ) return nil;
    
    NSArray* sessions = [sessionMap allValues];
    NSArray* sorted = [sessions sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        const BLEBeaconSession* s1 = obj1;
        const BLEBeaconSession* s2 = obj2;
        const float rssi1 = s1.avgRssi;
        const float rssi2 = s2.avgRssi;
        
        if ( rssi1 > rssi2 ) return NSOrderedAscending;
        else if ( rssi1 < rssi2 ) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
    
    return [sorted subarrayWithRange:NSMakeRange(0, count)];
}

-(void)tick {
    [self tick:currentTimeInMillis()];
}
-(void)tick:(long)currentTimeInMillis
{
    for ( id k in sessionMap.allKeys ) {
        const BLEBeaconSession* s = [sessionMap objectForKey:k];
        if ( currentTimeInMillis - s.lastUpdateTime > SESSION_TIMEOUT ) {
            // to notify about the old beacon's lost
            if (listener != nil ) {
                [listener onLost:s.beaconInfo];
            }
            [sessionMap removeObjectForKey:k];
        }
    }
}
@end
