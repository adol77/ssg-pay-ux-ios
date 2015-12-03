//
//  LSControl.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#pragma once

#import "LSPowerManagePolicy.h"

@protocol LSControlListener
-(void)onSensorData:(id)data;
@end


@protocol LSControl
-(void)startScan;
-(void)stopScan;
-(void)setListener:(id<LSControlListener>)listener;
-(void)setPowerManagePolicy:(LSPowerManagePolicy*)policy;
@end
