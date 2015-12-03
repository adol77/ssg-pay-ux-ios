//
//  ZoneDataManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "ZoneDataManager.h"
#import "ZoneNet.h"
#import "ZoneCoord.h"
#import "Beacon.h"
#import "BeaconDataManager.h"
#import "TSDebugLogManager.h"

//#define TESTCODE

/**
 *  Zone 데이터 관리
 *  1. 클라이언트가 요청시 서버에게 Zone 데이터 요청 및 Caching 담당
 *  2. Zone Search 담당
 */
@implementation ZoneDataManager

+ (ZoneDataManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static ZoneDataManager *sharedZoneDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedZoneDataManager = [[ZoneDataManager alloc] init];
    });
    return sharedZoneDataManager;
}

- (instancetype)init {
    self = [super init];
    [self zones];
    
    return self;
}


#pragma Zone
/**
 *  Zone 데이터 저장
 *
 *  @param zones zone 데이터
 */
- (void)setZones:(NSArray*)zones{
    if (zones) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zones"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:zones];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"zones"];
        
        self.zoneList = [NSArray arrayWithArray:zones];
        
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zones"];
        
        self.zoneList = nil;
    }
}

/**
 *  Zone 데이터 가져오기
 *
 *  @return zone 데이터
 */
- (NSArray*)zones {
    if(self.zoneList)
        return self.zoneList;
    
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"zones"];
    if (raw) {
        self.zoneList = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return self.zoneList;
    }
    return nil;
}

/**
 *  <#Description#>
 *
 *  @param zoneID <#zoneID description#>
 *
 *  @return <#return value description#>
 */
- (Zone*)zoneForID:(NSNumber*)zoneID {
    //TSGLog(TSLogGroupZone, @"zoneForID %@", zoneID);
    
    NSArray* zones = [self zones];
    NSArray *fetchResults = [zones filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"zone_id == %@", zoneID]];
    if ([fetchResults count] <= 0) {
        return nil;
    }
    return [fetchResults objectAtIndex:0];
}


/**
 *  BranchId와 층 정보로 ZoneData 검색
 *
 *  @param branchID branch ID
 *  @param floor    floor ID
 *
 *  @return Zone Data List
 */
- (NSMutableArray *)zonesForBranchID:(NSNumber*)branchID floor:(NSNumber*)floor{
    //TSGLog(TSLogGroupZone, @"zonesForBranchID %@ floor %@", branchID, floor);
    
    NSArray* zones = [self zones];
    
    NSArray *fetchResults = [zones filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"store_branch_id == %@ and store_floor_id == %@", branchID, floor]];
    if ([fetchResults count] <= 0) {
        return nil;
    }
    
    NSMutableArray *searchZones     = [NSMutableArray array];
    for (Zone *searchZone in fetchResults) {
        [searchZones addObject:searchZone];
    }
    
    return searchZones;
}

/**
 *  SLBS 좌표값으로 ZoneData 검색
 *
 *  @param coordination SLBS 좌표값
 *
 *  @return Zone Data List
 */
- (NSMutableArray*)zonesForCoordination:(SLBSCoordination*)coordination{
    //TSGLog(TSLogGroupZone, @"zonesForCoordination %f %f ", coordination.x, coordination.y);
    
    NSArray* zones;
    
    //GeoZone은 전체 데이터 검색
    if([coordination.branchID intValue] == -1 && [coordination.floorID intValue] == -1)
        zones = [self zones];
    else //그외의 존은 BranchID와 FloorID로 검색 후 inpolygon area 검색
        zones = [self zonesForBranchID:coordination.branchID floor:coordination.floorID];
    
    CGPoint point = CGPointMake(coordination.x, coordination.y);
    NSMutableArray *searchZones  = [NSMutableArray array];
    
    for(Zone* zone in zones)
    {
        BOOL containPoint = [self pointInPolygon:zone point:point];
        //TSGLog(TSLogGroupZone, @"%s containPoint %d ", __PRETTY_FUNCTION__, containPoint);
      
        if(containPoint)
        {
            NSLog(@"%s searchZone %@ %@", __PRETTY_FUNCTION__, zone.name, zone.zone_id);
            [searchZones addObject:zone];
            
        }
        
    }
    
    zones = nil;
    
   return searchZones;
}

- (BOOL)pointInPolygon:(Zone*)zone point:(CGPoint)point {
    //NSMutableArray* points = [[NSMutableArray alloc] init];
    
  /*  NSLog(@"%s zone %f, %f ", __PRETTY_FUNCTION__, zone.center_x, zone.center_y);
    for(ZoneCoord* zoneCoord in zone.coords)
    {
        NSLog(@"%s zoneCoord %f, %f ", __PRETTY_FUNCTION__, zoneCoord.x, zoneCoord.y);
        
        CGPoint zonePoint = CGPointMake(zoneCoord.x, zoneCoord.y);
        [points addObject:[NSValue valueWithCGPoint:zonePoint]];
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    if (points && points.count > 0) {
        CGPoint p =[(NSValue *)[points objectAtIndex:0] CGPointValue];
        CGPathMoveToPoint(path, nil, p.x, p.y);
        for (int i = 1; i < points.count; i++) {
            p = [(NSValue *)[points objectAtIndex:i] CGPointValue];
            CGPathAddLineToPoint(path, nil, p.x, p.y);
        }
    }*/
    
    BOOL containPoint = CGPathContainsPoint([zone.polygonPath CGPath], NULL, point, YES);
   // NSLog(@"%s containPoint %d ", __PRETTY_FUNCTION__, containPoint);
    return containPoint;
}

/**
 *  Beacon 정보로 Zone 리스트 조회
 *
 *  @param uuid  beacon uuid
 *  @param major beacon major
 *  @param minor beacon minor
 *
 *  @return Zone List
 */
-(NSMutableArray *)zonesForUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor{
    //TSGLog(TSLogGroupZone, @"zonesForUUID %@ major %@ minor %@ ", uuid, major, minor);
    
    NSArray* zones = [self zones];
    
    Beacon* beacon = [[BeaconDataManager sharedInstance] beaconForUUID:uuid major:major minor:minor];
    
    if(beacon == nil)
        return nil;
    
    NSArray *fetchResults = [zones filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"beacon_id == %@", beacon.beacon_id]];
    if ([fetchResults count] <= 0) {
        return nil;
    }
    
    return (NSMutableArray*)fetchResults;
}


/**
 *  Map 정보로 Zone 리스트 조회
 *
 *  @param mapId  mapId
 *
 *  @return Zone List
 */
- (NSArray*)zonesForMap:(int)mapId
{
    //TSGLog(TSLogGroupZone, @"zonesForMap %d ", mapId);
    
    NSArray* zones = [self zones];
    
    NSArray *fetchResults = [zones filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"map_id == %d", mapId]];
    if ([fetchResults count] <= 0) {
        return nil;
    }
    return fetchResults;
    
}

- (NSArray*)zonesForBranchID:(NSNumber*)branchId
{
    //TSGLog(TSLogGroupZone, @"zonesForBranchID %@ ", branchId);
    
    NSArray* zones = [self zones];
    
    NSArray *zoneResults = [zones filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"store_branch_id == %@", branchId]];
    if ([zoneResults count] <= 0) {
        return nil;
    }
    
    NSNumber* rootBranchID;
    for(Zone* searhZone in zoneResults) {
        if([searhZone.store_root_branch_id isEqualToNumber:[NSNumber numberWithInt:-1]] == NO){
            rootBranchID = searhZone.store_root_branch_id;
            break;
        }
    }

    NSArray* fetchResults = [zones filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"store_root_branch_id == %@", rootBranchID]];
    
    if([fetchResults count] <= 0)
        return nil;
    
    return fetchResults;
}

/**
 *  SLBS좌표값이 포함된 Zone Detection
 *
 *  @param coordination SLBS 좌표
 */
- (void)detectZone:(SLBSCoordination *)coordination{
    //TSGLog(TSLogGroupZone, @"detectZone %@ ", coordination);
    
#ifdef TESTCODE
    [self.delegate zoneDataManager:self onZoneDetection:20];
#else
    NSMutableArray* zoneList = [[ZoneDataManager sharedInstance] zonesForCoordination:coordination];
    
    for(Zone* zoneInfo in zoneList)
    {
        
        //TSGLog(TSLogGroupZone, @"%s detectZone %d", __PRETTY_FUNCTION__, (int)zoneInfo.zone_id);
        [self.delegate zoneDataManager:self onZoneDetection:[zoneInfo.zone_id integerValue]];
    }
#endif
}

/**
 *  Proximity Zone Detection
 *
 *  @param beacon Beacon 정보
 */
- (void)detectProximityZone:(Beacon *)beacon {
    //TSGLog(TSLogGroupZone, @"detectProximityZone %@ ", beacon);
    
    NSMutableArray* zoneList = [self zonesForUUID:[[NSUUID alloc] initWithUUIDString:beacon.uuid] major:beacon.major minor:beacon.minor];
    
    for(Zone* zoneInfo in zoneList) {
        NSLog(@"%s detectProximityZone %d", __PRETTY_FUNCTION__, (int)zoneInfo.zone_id);

        [self.delegate zoneDataManager:self onZoneDetection:[zoneInfo.zone_id integerValue]];
    }
}



@end