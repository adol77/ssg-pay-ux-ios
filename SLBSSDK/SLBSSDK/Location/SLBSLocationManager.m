//
//  LocationManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBSKit.h"
#import "SLBSLocationManager.h"
#import "TSDebugLogManager.h"

@interface SLBSLocationManager () <SLBSKitLocationDelegate> {
    BOOL running;
}
@end


@implementation SLBSLocationManager : NSObject

+ (SLBSLocationManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static SLBSLocationManager *sharedSLBSLocationManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedSLBSLocationManager = [[SLBSLocationManager alloc] init];
    });
    return sharedSLBSLocationManager;
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

/**
 *  위치 정보 Detection 시작
 */
- (void)startMonitoring
{
    TSGLog(TSLogGroupLocation, @"startMonitoring");
    
    if( running ) return;
    running = YES;
    
    [[SLBSKit sharedInstance] setLocationDelegate:self];
    [[SLBSKit sharedInstance] startService:SLBSServiceLocation];
}

/**
 * 위치 정보 Detection 중지
 */
- (void)stopMonitoring
{
    TSGLog(TSLogGroupLocation, @"stopMonitoring");
    
    if ( !running ) return;
    [[SLBSKit sharedInstance] setLocationDelegate:nil];
    [[SLBSKit sharedInstance] stopService];
    running = NO;
}


/**
 *  SLBSKit으로부터 전달받은 SLBSCoordination 값을 외부(App)로 전달해준다.
 *
 *  @param manager  SLBSKit
 *  @param location SLBS 좌표계를 따르는 위치 정보
 */
- (void)slbskit:(SLBSKit *)manager onLocation:(SLBSCoordination *)location
{
    TSGLog(TSLogGroupLocation, @"onLocation %@", location);
    //TSLog(@"%s onLocation x: %f y:%f", __PRETTY_FUNCTION__, location.x, location.y);
    
    [self.delegate locationManager:self onLocation:location];
}


@end