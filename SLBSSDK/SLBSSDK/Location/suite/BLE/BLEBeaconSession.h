//
//  BLEBeaconSession.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEBeaconInfo.h"

/**
 * 비콘 정보를 누적시켜 rssi의 이동평균을 구함.
 */
@interface BLEBeaconSession : NSObject

-(instancetype)initWith:(BLEBeaconInfo*)beacon;
-(instancetype)initWith:(BLEBeaconInfo*)beacon On:(long)currentTimeInMillis;

-(float)avgRssi;

-(void)updateRssi:(float)rssi;
-(void)updateRssi:(float)rssi OnTime:(long)currentTimeInMillis;

@property (readonly, nonatomic) BLEBeaconInfo* beaconInfo;
@property (readonly, nonatomic) long lastUpdateTime;

@end
