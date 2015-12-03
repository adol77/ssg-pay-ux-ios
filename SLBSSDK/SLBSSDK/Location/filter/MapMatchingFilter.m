//
//  MapMatchingFilter.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "MapMatchingFilter.h"
#import "LOCLineSegment.h"
#import "LOCCoordinate.h"


@implementation MapMatchingFilter

@synthesize mapRoadSource;

+(BOOL)isSegment:(LOCLineSegment*)segment InMap:(int)mapId {
    const LOCCoordinate* start = segment.startPoint;
    const LOCCoordinate* end = segment.endPoint;
    if ( start.mapId != mapId ||
        end.mapId != mapId ) {
        return NO;
    }
    
    return YES;
}

+(struct Projection)calcProjection:(LOCCoordinate*)pos On:(LOCLineSegment*)segment {
    const LOCCoordinate* start = segment.startPoint;
    const LOCCoordinate* end = segment.endPoint;
    const double epsilon = 1E-7;
    struct Projection retVal;
    
    if ( fabs(start.X - end.X) < epsilon ) {
        retVal.distance = fabs(pos.X - start.X);
        retVal.x = start.X;
        retVal.y = pos.Y;
        return retVal;
    }
    if ( fabs(start.Y - end.Y) < epsilon ) {
        retVal.distance = fabs(pos.Y - start.Y);
        retVal.x = pos.X;
        retVal.y = start.Y;
        return retVal;
    }
    
    const double x1 = start.X;
    const double x2 = end.X;
    const double x3 = pos.X;
    const double y1 = start.Y;
    const double y2 = end.Y;
    const double y3 = pos.Y;
    
    const double z1 = (y2 - y1)/(x2 - x1);
    const double z2 = -1 / z1;
    const double c1 = y1 - z1 * x1;
    const double c2 = y3 - z2 * x3;
    
    const double x4 = (c2 - c1) / (z1- z2);
    const double y4 = z1 * x4 + c1;
    
    const double dist_x = (x3 - x4);
    const double dist_y = (y3 - y4);
    
    const double distance = sqrt(dist_x * dist_x + dist_y * dist_y);
    
    retVal.distance = distance;
    retVal.x = x4;
    retVal.y = y4;

    return retVal;
    
}

+(BOOL)isProjection:(struct Projection)proj On:(LOCLineSegment*)segment {
    const LOCCoordinate* start = segment.startPoint;
    const LOCCoordinate* end = segment.endPoint;
    const double left = fmin(start.X, end.X);
    const double right = fmax(start.X, end.X);
    const double top = fmin(start.Y, end.Y);
    const double bottom = fmax(start.Y, end.Y);
    const double projX = proj.x;
    const double projY = proj.y;
    
    if ( projX < left - 5 || projX > right + 5 || projY < top - 5 || projY > bottom + 5 ) return NO;
    return YES;
}


-(LOCCoordinate*)filter:(LOCCoordinate*)pos {
    if ( pos == nil ) return nil;
    
    int mapId = pos.mapId;
    NSArray* roads = [mapRoadSource roadsInMap:mapId];
    if ( roads == nil ) return nil;
    
    BOOL notSet = YES;
    struct Projection minDistProj;
    
    for ( LOCLineSegment* s in roads ) {
        if ( ![MapMatchingFilter isSegment:s InMap:mapId] ) continue;
        
        struct Projection proj = [MapMatchingFilter calcProjection:pos On:s];
        
        if ( ![MapMatchingFilter isProjection:proj On:s] ) continue;
        
        if ( notSet || minDistProj.distance > proj.distance ) {
            notSet = NO;
            minDistProj = proj;
        }
    }
    
    if ( notSet ) return nil;
    return [[LOCCoordinate alloc] initWithMap:mapId X:minDistProj.x Y:minDistProj.y];
}

@end
