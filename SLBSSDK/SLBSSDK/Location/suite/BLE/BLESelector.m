//
//  BLESelector.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "BLESelector.h"
#import "LSLocationCandidate.h"
#import "SLBSCoordination.h"

#define KNN_SIZE (3)

@implementation BLESelector {
}

@synthesize listener;

-(void)findLocation:(NSArray*)candidateList
{
    if ( listener == nil ) return;
    
    const int count = MIN((int)candidateList.count, KNN_SIZE);
    if ( count < KNN_SIZE ) return;
    
    // $\sum w_i$ 를 구한다.
    float sumWeight = 0.f;
    for ( int i = 0 ; i < count ; i++ ) {
        LSLocationCandidate* c = candidateList[i];
        sumWeight += [c weight];
    }
    
    if ( sumWeight == 0.f ) return;
    
    LSLocationCandidate* fc = candidateList[0];
    NSNumber* floorID = fc.position.floorID;
    NSNumber* mapID = fc.position.mapID;
    
    // $\sum w_i x_i$를 구해보자
    float x = 0.f;
    float y = 0.f;
    for ( int i = 0 ; i < count ; i++ ) {
        LSLocationCandidate* c = candidateList[i];
        x += c.position.x * c.weight / sumWeight;
        y += c.position.y * c.weight / sumWeight;
    }
    
    SLBSCoordination* newPos = [[SLBSCoordination alloc] init];
    newPos = fc.position;
    newPos.x = x;
    newPos.y = y;
    newPos.floorID = floorID;
    newPos.mapID = mapID;
    
    [listener onLocationSelected:newPos];
}

@end
