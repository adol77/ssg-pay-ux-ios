//
//  BLELocationSource.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//
#pragma once


@class SLBSCoordination;
@class BLEBeaconInfo;

@protocol BLELocationSource
-(SLBSCoordination*)findBeaconLocation:(BLEBeaconInfo*)beacon;
@end
