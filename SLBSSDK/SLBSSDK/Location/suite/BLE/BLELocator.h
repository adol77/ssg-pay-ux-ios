//
//  BLELocator.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSLocator.h"
#import "BLELocationExaminer.h"
#import "BLELocationSource.h"
#import "BLESessionSource.h"

/**
 * 비콘 정보를 위치정보로 변환하고, RSSI 정보를 Weight로 변환하여 LocationCandidate를 만든다.
 */
@interface BLELocator : NSObject<LSLocator, BLELocationSource>


-(void)tick:(long)currentTimeInMillis;
-(NSMutableArray*)buildCandidates:(NSArray*)session;
-(int)findMajorMap:(NSArray*)candidates;
-(void)removeLocation:(NSMutableArray*)candidates NotIn:(int)map;
-(float)calcWeight:(float)rssi;


@property (weak) id<BLELocationSource> beaconLocationSource;
@property (weak) id<BLESessionSource> sessionSource;
@property (weak) id<BLELocationExaminer> listener;

@end
