//
//  SLBSMapViewCommon.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 10. 15..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "SLBSMapViewCommon.h"

@implementation SLBSMapViewCommon

@end


CGFloat distanceBetweenTwoPoint(CGPoint point1, CGPoint point2) {
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

//1:x increase 2:y increase 3:x decrease 4:y decrease -1:delta 0
NSInteger directionWithTwoPoint(CGPoint point1, CGPoint point2) {
    CGFloat delta_x = (point2.x - point1.x);
    CGFloat delta_y = (point2.y - point1.y);
    if (fabs(delta_x) >= fabs(delta_y)) {//x 축 변화
        if (delta_x >= 0) {
            return 1;
        } else {
            return 3;
        }
    } else {//y축 변화
        if (delta_y >= 0) {
            return 2;
        } else {
            return 4;
        }
    }
    return -1;
}
