//
//  LocationManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_LocationManager_h
#define SLBSKit_LocationManager_h

#import "SLBSCoordination.h"


@class SLBSLocationManager;

/**
 *  위치 정보 발생시 외부(앱)에게 알려주는 인터페이스
 */
@protocol SLBSLocationManagerDelegate <NSObject>

- (void)locationManager:(SLBSLocationManager *)manager onLocation:(SLBSCoordination*)location;

@end

/**
 *  SLBSLocationManager
 *
 *  위치 정보의 외부 인터페이스
 */
@interface SLBSLocationManager : NSObject

@property (weak, nonatomic) id<SLBSLocationManagerDelegate> delegate;

+ (SLBSLocationManager*)sharedInstance;

- (void)startMonitoring;
- (void)stopMonitoring;

@end


#endif
