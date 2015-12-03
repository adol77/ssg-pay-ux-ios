//
//  BLESessionMgr.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSControl.h"
#import "BLESessionSource.h"

@class BLEBeaconInfo;

@protocol BLESessionMgrListener
-(void)onDiscovery:(BLEBeaconInfo*)beacon;
-(void)onLost:(BLEBeaconInfo*)beacon;
@end

@interface BLESessionMgr : NSObject<BLESessionSource, LSControlListener>

-(void)onSensorData:(id)data;

-(void)onSensorData:(id)data On:(long)currentTimeInMillis;

-(NSArray*)strongestBeaconScans:(int)size;

-(void)tick:(long)currentTimeInMillis;

@property id<BLESessionMgrListener> listener;

@end
