//
//  MapDataManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#pragma once
#import "SLBSMapData.h"

@interface MapDataManager : NSObject
@property (nonatomic, strong) NSArray* mapGraphInfoList;

+ (MapDataManager*)sharedInstance;

// 서버에서 지도 정보를 가져옴.
- (void)fetchMapInfo:(int)mapId token:(NSString*)accessToken block:(void(^)(SLBSMapData*))block;

// 로컬 cache에서 지도 정보를 가져옴.
- (SLBSMapData*)mapInfoFromLocal:(int)mapId;

// 로컬 cache에서 지도 정보를 확인해 보고 없으면 서버에서 가져옴. 응답은 delegate로.
- (void)loadMapInfo:(int)mapId token:(NSString*)accessToken block:(void(^)(SLBSMapData*))block;

- (NSArray*)mapGetZoneList:(int)mapId;
- (void)mapGetZoneList:(int)mapId block:(void (^)(NSArray*))block;

#pragma MapGraphInfo
- (void)setMapGraphInfos:(NSArray*)mapGraphInfos;
- (NSArray*)mapGraphInfos;

#pragma MapData
- (void)setMapDatas:(NSArray*)mapDatas;
- (NSArray*)mapDatas;


@end

