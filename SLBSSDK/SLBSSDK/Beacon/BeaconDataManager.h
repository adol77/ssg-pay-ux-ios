//
//  BeaconDataManager.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 25..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"

@interface BeaconDataManager : NSObject

+ (BeaconDataManager*)sharedInstance;

@property (strong) NSArray* beaconList;
@property (strong) NSArray* uuidList;

#pragma Beacon
- (void)setBeacons:(NSArray*)zones;
- (NSArray*)beacons;
- (Beacon*)beaconForID:(NSNumber*)beaconID;
- (Beacon*)beaconForUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor;

#pragma UUID
- (void)setUUIDs:(NSArray*)uuids;
- (NSArray*)UUIDs;

@end