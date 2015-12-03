//
//  BLEBeaconScan.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "BLEBeaconScan.h"

@interface BLEBeaconScan()

@end
@implementation BLEBeaconScan
@synthesize beaconInfo, rssi;

-(instancetype)initWith:(BLEBeaconInfo*)_beacon Rssi:(float)_rssi
{
    if ( self = [super init] ) {
        beaconInfo = _beacon;
        rssi = _rssi;
    }
    return self;
}



@end
