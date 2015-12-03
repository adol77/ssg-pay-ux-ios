//
//  BLESessionSource.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#pragma once

@protocol BLESessionSource
-(NSArray*)strongestBeaconScans:(int)size;
@end
