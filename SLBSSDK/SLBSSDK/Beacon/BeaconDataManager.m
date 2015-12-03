//
//  BeaconDataManager.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 25..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "BeaconDataManager.h"
#import "TSDebugLogManager.h"

@implementation BeaconDataManager : NSObject

+ (BeaconDataManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static BeaconDataManager *sharedBeaconDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedBeaconDataManager = [[BeaconDataManager alloc] init];
    });
    return sharedBeaconDataManager;
}

/**
 *  Beacon 데이터 저장
 *
 *  @param beacons beacon 데이터
 */
- (void)setBeacons:(NSArray*)beacons{
    if (beacons) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"beacons"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:beacons];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"beacons"];
        
        self.beaconList = [NSArray arrayWithArray:beacons];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"beacons"];
        
        self.beaconList = nil;
    }
}

/**
 *  Beacon 데이터 가져오기
 *
 *  @return beacon 데이터
 */
- (NSArray*)beacons {
    if(self.beaconList)
        return self.beaconList;
    
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"];
    if (raw) {
        self.beaconList = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return self.beaconList;
    }
    return nil;
}

/**
 *  beacon ID로 BeaconData  검색
 *
 *  @param beaconID beacon ID
 *
 *  @return beacon 정보
 */
- (Beacon*)beaconForID:(NSNumber*)beaconID {
    //TSGLog(TSLogGroupBeacon, @"beaconForID %@", beaconID);
    
    NSArray* beacons = [self beacons];
    NSArray *fetchResults = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beacon_id == %@", beaconID]];
    if ([fetchResults count] <= 0) {
        return nil;
    }
    return [fetchResults objectAtIndex:0];
}

/**
 *  UUID로 beaconData 검색
 *
 *  @param uuid  UUID
 *  @param major beacon major
 *  @param minor beacon minor
 *
 *  @return Beacon 정보
 */
- (Beacon *)beaconForUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor {
    //TSGLog(TSLogGroupBeacon, @"beaconForUUID %@ %@ %@ ", uuid, major, minor);
    
    NSArray* beacons = [self beacons];
    NSArray *fetchResults = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"uuid == %@ and major == %@ and minor == %@", [uuid UUIDString], major, minor]];
    if ([fetchResults count] <= 0) {
        return nil;
    }
    return [fetchResults objectAtIndex:0];
}

/**
 *  Beacon UUID List 데이터 저장
 *
 *  @param uuids beacon uuid 데이터
 */
- (void)setUUIDs:(NSArray*)uuids{
    if (uuids) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UUIDs"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:uuids];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"UUIDs"];
        
        self.uuidList = [NSArray arrayWithArray:uuids];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UUIDs"];
        
        self.uuidList = nil;
    }
}

/**
 *  Beacon UUID List데이터 가져오기
 *
 *  @return uuid 데이터
 */
- (NSArray*)UUIDs {
    if(self.uuidList)
        return self.uuidList;
    
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUIDs"];
    if (raw) {
        self.uuidList = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return self.uuidList;
    }
    return nil;
}

@end