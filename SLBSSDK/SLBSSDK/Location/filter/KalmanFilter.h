//
//  KalmanFilter.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PositionFilter.h"
#import "SLBSCoordination.h"

/** 전달 받은 지도상의 좌표를 kalman filter를 이용하여 보정한다. */
@interface KalmanFilter : NSObject<PositionFilter>

-(SLBSCoordination*)filter:(SLBSCoordination*)pos;
-(SLBSCoordination*)filter:(SLBSCoordination*)pos withVar:(double)var;

@end
