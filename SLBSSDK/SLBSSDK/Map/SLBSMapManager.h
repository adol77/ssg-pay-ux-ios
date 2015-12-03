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

/**
 *  맵 정보 준비 알림과 정보 전달시 외부(앱)에게 알려주는 인터페이스
 */
@protocol SLBSMapManagerDelegate <NSObject>

- (void)mapManager:(SLBSMapManager *)manager onMapInfo:(SLBSMapData*)mapInfo;
- (void)mapManager:(SLBSMapManager *)manager onMapReady:(SLBSMapViewData*)mapData;

@end

/**
 *  MapManager path finding listener
 */
@protocol SLBSPathFindListener
- (void)onPathFindSuccess:(NSArray*)mapPathViewDataArray;
- (void)onPathFindFail;
@end

/**
 *  SLBSMapManager
 *
 *  맵 정보의 외부 인터페이스
 */
@interface SLBSMapManager : NSObject

+ (SLBSMapManager*)sharedInstance;

/**
 *  맵 정보 요청 시작
 *
 *  @param block block
 */
- (void)startMonitoring:(void (^)(void))block;

/**
 * 맵 정보 요청 중지
 */
- (void)stopMonitoring;

/**
 *  특정 mapid로 data 요청
 *
 *  @param mapId    map id
 *  @param delegate delegate - 완료시 onMapInfo로 알려줌
 */
- (void)loadMapData:(long)mapId delegate:(id<SLBSMapManagerDelegate>)delegate;

/**
 *  길찾기 함수 
 *
 *  @param startMapId 시작 map ID
 *  @param startX     시작 x 좌표
 *  @param startY     시작 y 좌표
 *  @param endMapId   끝 map ID
 *  @param endX       끝 x 좌표
 *  @param endY       끝 y 좌표
 *  @param delegate   path delegate - 성공시 onPathFindSuccess로 실패시 onPathFindFail로 결과 알림
 */
- (void)findPath:(long)startMapId startX:(double)startX startY:(double)startY endMapId:(long)endMapId endX:(double)endX endY:(double)endY delegate:(id<SLBSPathFindListener>)delegate;

- (void)getZoneList:(int)mapId block:(void (^)(NSArray*))block;

@end
