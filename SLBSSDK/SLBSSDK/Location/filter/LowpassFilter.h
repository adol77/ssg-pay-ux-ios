//
//  LowpassFilter.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionFilter.h"

@class SLBSCoordination;


/** 위치의 이동 평균을 구한다. */
@interface LowpassFilter : NSObject<PositionFilter>

-(instancetype)init;

-(instancetype)initWithSize:(int)size;

/**
 *  입력된 좌표중 가장 빈도가 높은 map id를 구한다
 *
 *  @return 빈도가 가장 높은 mapID
 */
-(int)findMajorMapId;

/**
 *  특정 map에서 발견된 좌표의 평균을 구한다.
 *
 *  @param mapId mapId mapID
 *
 *  @return Map에서 발견된 좌표의 평균값
 */
-(SLBSCoordination*)avgPositionInMap:(int)mapId;

/**
 *  최다빈도 map을 구하고 그 map의 좌표평균을 구한다.
 *
 *  @return 좌표 평균값
 */
-(SLBSCoordination*)avgPosition;

/**
 *  입력된 좌표값에 Lowpass Filter 적용
 *
 *  @param pos SLBSCoordination
 *
 *  @return Filter 적용된 SLBSCoordination
 */
-(SLBSCoordination*)filter:(SLBSCoordination*)pos;


@end
