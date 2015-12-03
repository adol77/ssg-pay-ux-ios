//
//  MapViewerController.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/14/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLBSSDK/SLBSMapViewData.h>

@protocol MapActionDelegate <NSObject>

- (void)beginPathFindingAction;
- (void)endPathFindingAction:(BOOL)isSuccess;

- (void)beginMapLoadingAction;
- (void)endMapLoadingAction:(SLBSMapViewData*)mapData isSuccess:(BOOL)isSuccess;

- (void)doSelectCurrentPosition:(BOOL)select;

@end

@class MapInfoProvider;
@class SLBSCoordination;
@interface MapViewerController : NSObject

@property (nonatomic, strong) id<MapActionDelegate> mapActionDelegate;

@property (nonatomic, assign) BOOL isMapDirectioning;

- (instancetype)init:(MapInfoProvider*)mapInfoProvider parentView:(UIView*)parentView;
- (UIView*)createMapViewWithFrame:(CGRect)frame;

- (void)startMapManager;
- (void)stopMapManager;

- (void)startMonitoring;
- (void)stopMonitoring;

//- (void)beginMapDirection;
//- (void)endMapDirection;

- (void)onMapManagerReady;
- (BOOL)reloadMap;
- (void)removeMapPath;

- (void)moveToStore:(NSNumber *)zoneId;
- (void)directToStore:(NSNumber*)zoneId;

- (void)currentPositionSelected:(BOOL)selected;

@end
