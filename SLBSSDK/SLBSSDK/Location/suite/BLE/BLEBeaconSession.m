//
//  BLEBeaconSession.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#include <sys/time.h>
#import "BLEBeaconSession.h"
#import "TSDebugLogManager.h"
#define LPF_SIZE (3)

@implementation BLEBeaconSession {
    float rssi[LPF_SIZE];
    int rssiIndex;
    int count;
    float avgRssi;
}
@synthesize beaconInfo, lastUpdateTime;

extern long currentTimeInMillis();

-(instancetype)initWith:(BLEBeaconInfo*)beacon
{
    return [self initWith:beacon On:currentTimeInMillis()];
}

-(instancetype)initWith:(BLEBeaconInfo*)beacon On:(long)currentTimeInMillis;
{
    if ( self = [super init])
    {
        beaconInfo = beacon;
        memset(rssi, 0, sizeof(rssi));
        rssiIndex = 0;
        count = 0;
        lastUpdateTime = currentTimeInMillis;
    }
    return self;
}

-(float)avgRssi
{
    return avgRssi;
}

long currentTimeInMillis()
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    
    return (tv.tv_sec)*1000 + ( tv.tv_usec) / 1000;
}

-(void)updateRssi:(float)_rssi
{
    long current = currentTimeInMillis();
    [self updateRssi:_rssi OnTime:current];
}


-(void)updateRssi:(float)_rssi OnTime:(long)currentTimeInMillis
{
    lastUpdateTime = currentTimeInMillis;
    rssi[rssiIndex++] = _rssi;
    rssiIndex %= LPF_SIZE;
    if ( count < LPF_SIZE ) count++;
    
    float sum = 0.f;
    for ( int i = 0 ; i < LPF_SIZE ; i++ ) {
        sum += rssi[i];
    }
    avgRssi = sum / count;
}

@end
