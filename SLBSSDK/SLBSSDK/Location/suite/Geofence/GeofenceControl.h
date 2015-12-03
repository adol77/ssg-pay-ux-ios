//
//  GeofenceControl.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "LSPowerManagePolicy.h"
#import "LSControl.h"

@interface GeofenceControl : NSObject<LSControl,CLLocationManagerDelegate>
-(void)startScan;
-(void)stopScan;
-(void)setListener:(id<LSControlListener>)listener;
-(void)setPowerManagePolicy:(LSPowerManagePolicy*)policy;


-(void)startScan:(long)currentTimeInMillis;
-(void)stopScan:(long)currentTimeInMillis;
-(void)setPowerManagePolicy:(LSPowerManagePolicy*)policy On:(long)currentTimeInMillis;
-(void)tick:(long)currentTimeInMillis;

@property (readonly, nonatomic) BOOL running;


@end
