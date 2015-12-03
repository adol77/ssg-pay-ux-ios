//
//  MapManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#pragma once
#import "SLBSMapData.h"
#import "SLBSMapViewData.h"

@class SLBSMapManager;
@protocol SLBSMapManagerDelegate <NSObject>

- (void)mapManager:(SLBSMapManager *)manager onMapInfo:(SLBSMapData*)mapInfo;
- (void)mapManager:(SLBSMapManager *)manager onMapReady:(SLBSMapViewData*)mapData;

@end

@protocol SLBSPathFindListener
- (void)onPathFindSuccess:(NSArray*)mapPathViewDataArray;
- (void)onPathFindFail;
@end

@interface SLBSMapManager : NSObject

+ (SLBSMapManager*)sharedInstance;

- (void)startMonitoring:(void (^)(void))block;
- (void)stopMonitoring;

- (void)loadMapData:(long)mapId delegate:(id<SLBSMapManagerDelegate>)delegate;
- (void)findPath:(long)startMapId startX:(double)startX startY:(double)startY endMapId:(long)endMapId endX:(double)endX endY:(double)endY delegate:(id<SLBSPathFindListener>)delegate;

- (void)getZoneList:(int)mapId block:(void (^)(NSArray*))block;

@end
