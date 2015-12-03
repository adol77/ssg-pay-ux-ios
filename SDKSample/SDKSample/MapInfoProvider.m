//
//  MapInfoProvider.m
//  SDKSample
//
//  Created by Jeoungsoo on 9/30/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "MapInfoProvider.h"
#import "NetworkDataRequester.h"

#import <SLBSSDK/SLBSCompany.h>
#import <SLBSSDK/SLBSBranch.h>

#import "AppDefine.h"

@implementation MapInfoProvider


#pragma mark - Map

- (NSNumber*)getDefaultMapId {
    SLBSBranch *defaultBranch = nil;
#ifdef USE_NEW_ADDR_ARCH
    // branch의 0번째를 사용할 수 없음
    for (int i=0; i<self.appDataManager.branchArray.count; i++) {
        SLBSBranch *branch = [self.appDataManager.branchArray objectAtIndex:i];
        if ([branch.branchId intValue]==DEFAULT_BRANCH_ID) {
            defaultBranch = branch;
            break;
        }
    }
#else
    defaultBranch = [self.appDataManager.branchArray objectAtIndex:0];
#endif
    
    for (int i=0; i<self.appDataManager.floorArray.count; i++) {
        SLBSFloor *floor = [self.appDataManager.floorArray objectAtIndex:i];
        if ([floor.floorId intValue]==[defaultBranch.default_floor_id intValue]) {
            self.currentBranchId = floor.branchId;
            self.currentFloorId = floor.floorId;
            self.currentMapId = floor.mapId;
            return self.currentMapId;
        }
    }
    
    return nil;
}

//- (void)getDefaultMapId:(void (^)(int mapId))resultBlock {
//    for (int i=0; i<self.appDataManager.floorArray.count; i++) {
//        Floor *floor = [self.appDataManager.floorArray objectAtIndex:i];
//        if ([floor.name caseInsensitiveCompare:@"1F"]==NSOrderedSame) {
//            if ([floor.branchId intValue]==DEFAULT_BRANCH_ID) {
//                self.currentBranchId = floor.branchId;
//                self.currentFloorId = floor.floorId;
//
//                NetworkDataRequester *requester = [NetworkDataRequester sharedInstance];
//                [requester requestMapId:[floor.floorId intValue] block:^(int mapId){
//                    self.currentMapId = [NSNumber numberWithInt:(int)mapId];
//                    resultBlock(mapId);
//                }];
//            }
//        }
//    }
//}

// map id를 이용하여 해당 floor를 리턴
- (SLBSFloor*)getFloorByMapId:(int)mapId {
    for (SLBSFloor *floor in self.appDataManager.floorArray) {
        if ([floor.mapId intValue]==mapId) {
            return floor;
        }
    }
    
    return nil;
}

#pragma mark - Company

- (NSString*)getCompanyNameByCompanyId:(NSNumber*)companyId {
    for (int i=0; i<self.appDataManager.companyArray.count; i++) {
        SLBSCompany *company = [self.appDataManager.companyArray objectAtIndex:i];
        if ([company.companyId intValue]==[companyId intValue]) {
            return company.name;
        }
    }
    
    return @"";
}

#pragma mark - Branch

// 주어진 branchId를 이용하여 branch array의 index를 리턴한다
- (int)getBranchArrayIndexByBranchId:(NSNumber*)branchId {
    for (int i=0; i<self.appDataManager.branchArray.count; i++) {
        SLBSBranch *branch = [self.appDataManager.branchArray objectAtIndex:i];
        if ([branch.branchId intValue]==[branchId intValue]) {
            return i;
        }
    }
    
    return -1;
}

// 현재 branchId를 이용하여 branch array의 index를 리턴한다
- (int)getCurrentBranchArrayIndex {
    return [self getBranchArrayIndexByBranchId:self.currentBranchId];
}

// 주어진 branch array의 index를 이용해서 branchId를 얻는다
- (NSNumber*)getBranchIdByBranchArrayIndex:(int)index {
    SLBSBranch *branch = [self.appDataManager.branchArray objectAtIndex:index];
    
    return branch.branchId;
}

- (NSString*)getCurrentBranchName {
    return [self getBranchNameByBranchId:self.currentBranchId];
}

- (NSString*)getBranchNameByBranchId:(NSNumber*)branchId {
    for (int i=0; i<self.appDataManager.branchArray.count; i++) {
        SLBSBranch *branch = [self.appDataManager.branchArray objectAtIndex:i];
        if ([branch.branchId intValue]==[branchId intValue]) {
            return branch.name;
        }
    }
    
    return @"";
}

#pragma mark - Floor

// 주어진 floorId를 이용하여 floor array의 index를 리턴한다
- (int)getFloorArrayIndexByFloorId:(NSNumber*)floorId {
    for (int i=0; i<self.selectedFloorArray.count; i++) {
        SLBSFloor *floor = [self.selectedFloorArray objectAtIndex:i];
        if ([floor.floorId intValue]==[floorId intValue]) {
            return i;
        }
    }
    
    return -1;
}

// 현재 floorId를 이용하여 floor array의 index를 리턴한다
- (int)getCurrentFloorArrayIndex {
    return [self getFloorArrayIndexByFloorId:self.currentFloorId];
}

// 주어진 floor array의 index를 이용해서 floorId를 얻는다
- (NSNumber*)getFloorIdByFloorArrayIndex:(int)index {
    SLBSFloor *floor = [self.selectedFloorArray objectAtIndex:index];
    
    return floor.floorId;
}

- (SLBSFloor*)getCurrentFloor {
    return [self getFloorByFloorId:self.currentFloorId];
}

- (SLBSFloor*)getFloorByFloorId:(NSNumber*)floorId {
    for (int i=0; i<self.appDataManager.floorArray.count; i++) {
        SLBSFloor *floor = [self.appDataManager.floorArray objectAtIndex:i];
        if ([floor.floorId intValue]==[floorId intValue]) {
            return floor;
        }
    }
    
    return nil;
}

#pragma mark - Update

- (void)updateCurrentBranchIdByBranchIndex:(int)index {
    self.currentBranchId = [self getBranchIdByBranchArrayIndex:index];
}

- (void)updateCurrentFloor:(NSNumber*)floorId {
}

- (void)refreshCurrentFloorArray:(int)selectedBranchId {
    NSMutableArray *floorArray = [NSMutableArray array];
    for (int i=0; i<self.appDataManager.floorArray.count; i++) {
        SLBSFloor *floor = [self.appDataManager.floorArray objectAtIndex:i];
        if ([floor.branchId intValue]==selectedBranchId) {
            [floorArray addObject:floor];
        }
    }
    
//    self.selectedFloorArray = floorArray;
    
    NSArray *sortedArray = [floorArray sortedArrayUsingComparator:^(id obj1, id obj2) {
        SLBSFloor *floor1 = (SLBSFloor*)obj1;
        SLBSFloor *floor2 = (SLBSFloor*)obj2;
        
        if ([floor1.orderIndex intValue] > [floor2.orderIndex intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([floor1.orderIndex intValue] < [floor2.orderIndex intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    self.selectedFloorArray = sortedArray;
}

#pragma mark - Zone

- (Zone*)getZoneByZoneId:(NSNumber*)zoneId {
    for (int i=0; i<self.appDataManager.zoneListArray.count; i++) {
        Zone *zone = [self.appDataManager.zoneListArray objectAtIndex:i];
        if ([zone.zone_id intValue]==[zoneId intValue]) {
            return zone;
        }
    }
    
    return nil;
}

- (Zone*)getZoneByMapId:(NSNumber*)mapId {
    for (int i=0; i<self.appDataManager.zoneListArray.count; i++) {
        Zone *zone = [self.appDataManager.zoneListArray objectAtIndex:i];
        if ([zone.map_id intValue]==[mapId intValue]) {
            return zone;
        }
    }
    
    return nil;
}

@end
