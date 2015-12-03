//
//  MapPathFilter.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "MapPathFilter.h"

NSArray* MapPathFilter(NSArray* arr)
{
    if ( arr == nil ) return nil;
    const NSUInteger len = arr.count;
    if ( len < 3 ) return arr;
    
    NSMutableArray* list = [NSMutableArray array];
    [list addObject:arr[0]];
    double oldDir = calcMapPathDir(arr[0], arr[1]);
    
    for ( int i = 0 ; i < len - 1 ; i++ ) {
        MapPathViewData* p = arr[i];
        MapPathViewData* next = arr[i+1];
        double dir = calcMapPathDir(p, next);
        if ( fabs(oldDir - dir) > 0.034 ) {
            [list addObject:p];
            oldDir = dir;
        }
    }
    
    [list addObject:arr[len-1]];
    return [list copy];
}

double calcMapPathDir(MapPathViewData* p1, MapPathViewData* p2)
{
    double dx = p2.x - p1.x;
    double dy = p2.y - p1.y;
    
    if ( dx >= 0. && dy >= 0.) {
        if ( dx >= dy ) return atan2(dy, dx);
        else return M_PI * 0.5 - atan2(dx, dy);
    }
    else if ( dx < 0. && dy >= 0. ) {
        dx = fabs(dx);
        
        if ( dx >= dy ) return M_PI - atan2(dy, dx);
        else return M_PI * 0.5 + atan2(dx, dy);
        
    }
    else if ( dx < 0. && dy < 0. ) {
        dx = fabs(dx);
        dy = fabs(dy);
        
        if ( dx >= dy ) return M_PI + atan2(dy, dx);
        else return M_PI * 1.5 - atan2(dx, dy);
    }
    else {
        dy = fabs(dy);
        if ( dx >= dy ) return M_PI * 2. - atan2(dy, dx);
        else return M_PI * 1.5 + atan2(dx, dy);
    }
}