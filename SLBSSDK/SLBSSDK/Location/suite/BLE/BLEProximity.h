//
//  BLEProximity.h
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#ifndef SLBSSDK_BLEProximity_h
#define SLBSSDK_BLEProximity_h

#import "Beacon.h"

@protocol BLEProximityListener
-(void)onProximityData:(Beacon*)data;
@end

@interface BLEProximity : NSObject
-(void)setListener:(id<BLEProximityListener>)listener;

@end

#endif
