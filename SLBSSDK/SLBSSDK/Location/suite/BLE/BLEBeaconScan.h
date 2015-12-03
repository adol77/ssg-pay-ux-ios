//
//  BLEBeaconScan.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLEBeaconInfo;

/**
 * 실제로 관측된 scan 정보
 */
@interface BLEBeaconScan : NSObject

-(instancetype)initWith:(BLEBeaconInfo*)beacon Rssi:(float)rssi;

@property (nonatomic, strong) BLEBeaconInfo* beaconInfo;
@property (nonatomic, assign) float rssi;
@end
