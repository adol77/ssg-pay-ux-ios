//
//  IPositionFilter.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSSDK_IPositionFilter_h
#define SLBSSDK_IPositionFilter_h

@class LOCCoordinate;

/** 이전 좌표를 좀더 안정적으로 보정해 주는 필터 */
@protocol PositionFilter

/** 이 함수는 호출될 때마다 입력된 위치를 통계적으로 누적하여 안정적인 위치를 반환한다. */
-(LOCCoordinate*)filter:(LOCCoordinate*)pos;

@end

#endif
