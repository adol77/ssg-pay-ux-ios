//
//  LOCLineSegment.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "LOCLineSegment.h"

@implementation LOCLineSegment

@synthesize startPoint, endPoint;

-(instancetype)initWithStart:(LOCCoordinate*)start End:(LOCCoordinate*)end {
    if ( self = [super init] ) {
        startPoint = start;
        endPoint = end;
    }
    return self;
}


@end
