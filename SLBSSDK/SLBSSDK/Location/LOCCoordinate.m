//
//  LOCCooridnate.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "LOCCoordinate.h"

@implementation LOCCoordinate

@synthesize mapId, X, Y;


-(instancetype)initWithMap:(int) map X:(double)x Y:(double)y {
    if ( self = [super init] ) {
        mapId = map;
        X = x;
        Y = y;
    }
    return self;
}

-(BOOL)equal:(LOCCoordinate*)pos {
    return mapId == pos.mapId && X == pos.X && Y == pos.Y;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"<LOCCoordinate mapId:%d, X:%f, Y:%f>", mapId, X, Y];
}

@end
