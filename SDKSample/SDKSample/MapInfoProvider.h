//
//  MapInfoProvider.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/30/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDataManager.h"

#import <SLBSSDK/SLBSFloor.h>
#import <SLBSSDK/Zone.h>

@interface MapInfoProvider : NSObject

@property (nonatomic, strong) AppDataManager *appDataManager;
@property (nonatomic, strong) NSArray *selectedFloorArray;  // 층 선택 화면에서 branch(건물)를 선택할 때마다 refresh되는 floor array
@property (nonatomic, strong) NSNumber *currentBranchId;
@property (nonatomic, strong) NSNumber *currentFloorId;
@property (nonatomic, strong) NSNumber *currentMapId;
@property (nonatomic, strong) NSNumber *currentPositionMapId;
@property (nonatomic, strong) NSNumber *tempSelectedBranchArrayIndex;
@property (nonatomic, strong) NSNumber *tempSelectedFloorArrayIndex;

- (NSNumber*)getDefaultMapId;
//- (void)getDefaultMapId:(void (^)(int mapId))resultBlock;
- (SLBSFloor*)getFloorByMapId:(int)mapId;

- (NSString*)getCompanyNameByCompanyId:(NSNumber*)companyId;

- (int)getBranchArrayIndexByBranchId:(NSNumber*)branchId;
- (int)getCurrentBranchArrayIndex;
- (NSNumber*)getBranchIdByBranchArrayIndex:(int)index;
- (NSString*)getCurrentBranchName;
- (NSString*)getBranchNameByBranchId:(NSNumber*)branchId;

- (int)getFloorArrayIndexByFloorId:(NSNumber*)floorId;
- (int)getCurrentFloorArrayIndex;
- (SLBSFloor*)getCurrentFloor;
- (NSNumber*)getFloorIdByFloorArrayIndex:(int)index;
- (SLBSFloor*)getFloorByFloorId:(NSNumber*)floorId;

- (void)updateCurrentBranchIdByBranchIndex:(int)index;

- (void)refreshCurrentFloorArray:(int)selectedBranchId;

- (Zone*)getZoneByZoneId:(NSNumber*)zoneId;
- (Zone*)getZoneByMapId:(NSNumber*)mapId;

@end
