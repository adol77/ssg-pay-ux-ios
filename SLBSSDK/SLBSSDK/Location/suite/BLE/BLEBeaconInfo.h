//
//  BLEBeaconInfo.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 비콘을 식별하는 객체.
 * equals 및 hash 모두 uuid, major, minor 에만 의존.
 */
@interface BLEBeaconInfo : NSObject<NSCopying>

-(instancetype)initWithUUID:(NSUUID*)uuid Major:(unsigned short)major Minor:(unsigned short) minor;

@property (readonly, nonatomic) NSUUID* uuid;
@property (readonly, nonatomic) unsigned short major;
@property (readonly, nonatomic) unsigned short minor;
@end
