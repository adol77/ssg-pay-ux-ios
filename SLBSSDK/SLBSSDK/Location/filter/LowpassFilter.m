//
//  LowpassFilter.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "LowpassFilter.h"
//#import "LOCCoordinate.h"
#import "SLBSCoordination.h"

#define DEFAULT_WINDOW_SIZE (10)

@implementation LowpassFilter {
    int _size;
    NSMutableArray* _queue;
    NSMutableDictionary* _countMap;
}

-(instancetype)init {
    return [self initWithSize:DEFAULT_WINDOW_SIZE];
}

-(instancetype)initWithSize:(int)size {
    if ( size <= 0 ) return nil;
    if ( self = [super init] ) {
        _size = size;
        _queue = [[NSMutableArray alloc] initWithCapacity:size];
        _countMap = [NSMutableDictionary dictionary];
    }
    return self;
}

-(int)findMajorMapId {
    return [self maxCountMap];
}

-(SLBSCoordination*)avgPositionInMap:(int)mapId {
    int count = 0;
    double sumX = 0.;
    double sumY = 0.;
    
    SLBSCoordination* curPos;
    
    for ( SLBSCoordination* pos in _queue ) {
        if ( [pos.floorID intValue] != mapId ) continue;
        
        count++;
        sumX += pos.x;
        sumY += pos.y;
        
        curPos = pos;
    }
    
    if ( count == 0 ) return nil;
    
    SLBSCoordination* retVal = [[SLBSCoordination alloc] initWithCoordination:curPos X:(sumX/count) Y:(sumY/count)];
    return retVal;
}

-(SLBSCoordination*)avgPosition {
    if ( _queue.count == 0 ) return nil;
    
    int majorMapId = [self findMajorMapId];
    SLBSCoordination* retVal = [self avgPositionInMap:majorMapId];
    return retVal;
}

-(void)incCountMap:(NSInteger)key {
    int val = [[_countMap objectForKey:@(key)] intValue];
    
    val++;
    
    NSNumber* newNumber = [NSNumber numberWithInt:val];
    
    [_countMap setObject:newNumber forKey:@(key)];
}

-(void)decCountMap:(int)key {
    int val = [[_countMap objectForKey:@(key)] intValue];
    if (val == 0 ) return;
    
    val--;
    
    if ( val == 0 ) {
        [_countMap removeObjectForKey:@(key)];
    }
    else {
        [_countMap setObject:[NSNumber numberWithInt:val] forKey:@(key)];
    }
}

-(int)maxCountMap {
    __block int maxMap = 0;
    __block int maxCount = 0;
    
    [_countMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        int count = [obj intValue];
        if ( maxCount < count ) {
            maxMap = [key intValue];
            maxCount = count;
        }
    }];
    return maxMap;
}


-(void)push:(SLBSCoordination*)pos {
    [_queue addObject:pos];
    [self incCountMap:[pos.floorID intValue]];
    
    if ( _queue.count > _size ) {
        [self decCountMap:[pos.floorID intValue]];
        [_queue removeObjectAtIndex:0];
    }
}

-(SLBSCoordination*)filter:(SLBSCoordination*)pos {
    [self push: pos];

    SLBSCoordination* retVal = [self avgPosition];
    return retVal;
}

@end
