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
@protocol SLBSLocationManagerDelegate <NSObject>

- (void)locationManager:(SLBSLocationManager *)manager onLocation:(SLBSCoordination*)location;

@end

@interface SLBSLocationManager : NSObject

@property (weak, nonatomic) id<SLBSLocationManagerDelegate> delegate;

+ (SLBSLocationManager*)sharedInstance;

- (void)startMonitoring;
- (void)stopMonitoring;

@end


#endif
