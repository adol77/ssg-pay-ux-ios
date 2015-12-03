//
//  ZoneDataManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_ZoneDataManager_h
#define SLBSKit_ZoneDataManager_h

#import "Zone.h"
#import "SLBSCoordination.h"
#import "Beacon.h"

@class ZoneDataManager;

@protocol ZoneDataManagerDelegate <NSObject>
- (void)zoneDataManager:(ZoneDataManager *)manager onZoneDetection:(NSInteger)zoneID;
@end

@interface ZoneDataManager : NSObject

+ (ZoneDataManager*)sharedInstance;
@property (weak, nonatomic) id<ZoneDataManagerDelegate> delegate;
@property (nonatomic, strong) NSArray* zoneList;

#pragma Zone
- (void)setZones:(NSArray*)zones;
- (NSArray*)zones;
- (Zone*)zoneForID:(NSNumber*)zoneID;
- (NSMutableArray*)zonesForBranchID:(NSNumber*)branchID floor:(NSNumber*)floor;
- (NSMutableArray*)zonesForUUID:(NSUUID*)uuid major:(NSNumber*)major minor:(NSNumber*)minor;
- (NSArray*)zonesForMap:(int)mapId;
- (NSArray*)zonesForBranchID:(NSNumber*)branchId;

- (void)detectZone:(SLBSCoordination*)coordination;
- (void)detectProximityZone:(Beacon*)beacon;

@end
#endif
