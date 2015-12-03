//
//  BeaconInfo.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "BLEBeaconInfo.h"

@implementation BLEBeaconInfo
@synthesize uuid, major, minor;

-(instancetype)initWithUUID:(NSUUID*)_uuid Major:(unsigned short)_major Minor:(unsigned short)_minor
{
    if ( self = [super init] ) {
        uuid = _uuid;
        major = _major;
        minor = _minor;
    }
    return self;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if ( ![other isKindOfClass:[BLEBeaconInfo class]] ) return NO;
    
    const BLEBeaconInfo* otherBeacon = other;
    
    if ( ![uuid isEqual:otherBeacon.uuid ]) return NO;
    if ( major != otherBeacon.major ) return NO;
    if ( minor != otherBeacon.minor ) return NO;
    
    return YES;
}

// Android Studio에서 생성한 값 사용
- (NSUInteger)hash
{
    NSUInteger h = uuid.hash;
    h = 31 * h + major;
    h = 31 * h + minor;
    return h;
}


#pragma mark ------------------------------------
#pragma mark @protocol NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    BLEBeaconInfo* newObj = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:major Minor:minor];
    return newObj;
}

@end
