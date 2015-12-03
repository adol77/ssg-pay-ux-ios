//
//  MapMatchingFilter.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionFilter.h"
#import "MapRoadSource.h"

@class LOCLineSegment;
@class LOCCoordinate;

/**
 *  Coordinate 좌표를 LineSegment 좌표에 projection 시킨 결과물.
 */
struct Projection {
    double distance;
    double x;
    double y;
};


/**
 *  Coordinate 좌표를 IMapRoadSource 가 제공해주는 road 정보에 맞도록 filtering한다.
 */
@interface MapMatchingFilter : NSObject<PositionFilter>

/**
 *  segment의 시점과 종점이 모두 mapId인지 확인 한다.
 *
 *  @param segment segment
 *  @param mapId   mapID
 *
 *  @return segment 여부
 */
+(BOOL)isSegment:(LOCLineSegment*)segment InMap:(int)mapId;

/**
 *  Coordinate의 LineSegment 정사영을 구한다.
 * LineSemgent 의 시점을 P1, 종점을 P2, Coordinate 좌표를 P3라고 할때,
 * 다음 조건을 만족하는 P4를 구한다.
 *  - P1, P2의 기울기와 P3, P4의 기울기의 곱은 -1이다.
 *  - P1, P4의 기울기는 P1, P2의 기울기와 같다.
 *
 *  @param pos     LOCCoordination 좌표값
 *  @param segment LineSegment
 *
 *  @return <#return value description#>
 */
+(struct Projection)calcProjection:(LOCCoordinate*)pos On:(LOCLineSegment*)segment;


/**
 *  정사영이 선분내에 위치하는지 확인한다. 선분 밖에 있는 경우는 비껴 있는 경우.
 *
 *  @param proj    projection
 *  @param segment LOCLineSegment
 *
 *  @return <#return value description#>
 */
+(BOOL)isProjection:(struct Projection)proj On:(LOCLineSegment*)segment;


/**
 *  필터링 함수. 해당 층의 모든 segment에 대해 정사영을 구한다. 그중 거리가 최소인 점을 선택
 *
 *  @param pos LOCCoordinate 좌표값
 *
 *  @return 필터링된 LOCCoordinate 좌표값
 */
-(LOCCoordinate*)filter:(LOCCoordinate*)pos;

@property (weak) id<MapRoadSource> mapRoadSource;

@end
