//
//  BLEControl.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 25..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LSControl.h"

/**
 * BluetoothAdapter의 lescan을 제어하고,
 * Android의 BLE scan record를 BeaconScan 정보로 변환한다.
 */
@interface BLEControl : NSObject<LSControl, CLLocationManagerDelegate>
-(void)startScan;
-(void)stopScan;
-(void)setListener:(id<LSControlListener>)listener;
-(void)setPowerManagePolicy:(LSPowerManagePolicy*)policy;

-(void)startScan:(long)currentTimeInMillis;
-(void)stopScan:(long)currentTimeInMillis;
-(void)setPowerManagePolicy:(LSPowerManagePolicy*)policy On:(long)currentTimeInMillis;
-(void)tick:(long)currentTimeInMillis;

@property (readonly, nonatomic ) BOOL running;
@end
