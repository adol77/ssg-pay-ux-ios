//
//  ZoneCampaignManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBSKit.h"
#import "SLBSZoneCampaignManager.h"
#import "ZoneCampaignNet.h"
#import "DeviceManager.h"
#import "TSDebugLogManager.h"


@interface SLBSZoneCampaignManager() <SLBSKitZoneCampaignDelegate>{
    BOOL running;
}
@end

@implementation SLBSZoneCampaignManager : NSObject

+ (SLBSZoneCampaignManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static SLBSZoneCampaignManager *sharedSLBSZoneCampaignManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedSLBSZoneCampaignManager = [[SLBSZoneCampaignManager alloc] init];
    });
    return sharedSLBSZoneCampaignManager;
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

/**
 *  Zone Campaign Detection 시작
 */
- (void)startMonitoring
{
    TSGLog(TSLogGroupCampaign, @"startMonitoring");
    if( running ) return;
    running = YES;
    [[SLBSKit sharedInstance] setZoneCampaignDelegate:self];
    [[SLBSKit sharedInstance] startService:SLBSServiceZoneCampaign];

}

/**
 * Zone Campaign Detection 중지
 */
- (void)stopMonitoring
{
    TSGLog(TSLogGroupCampaign, @"stopMonitoring");
    
    if( !running ) return;
    [[SLBSKit sharedInstance] setZoneCampaignDelegate:nil];
    [[SLBSKit sharedInstance] stopService];
    running = NO;
}

/**
 *  Zone Campign 정보 수동 업데이트 지원
 */

- (void)updateZoneCampaignListToServerWithBlock:(void (^)(BOOL))block {
    TSGLog(TSLogGroupCampaign, @"updateZoneCampaignListToServerWithBlock");
    
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    
    [ZoneCampaignNet requestCampaignsWithAccessToken:accessToken block:^(ZoneCampaignNet* zoneNet) {
        TSLog(@"ZoneCampaign requestCampaignsWithAccessToken");
        if(zoneNet.returnCode == 0)
            block(YES);
        else
            block(NO);
    }];
    
}

/**
 *  SLBSKit으로부터 전달받은 SLBSZoneCampaign 정보를 외부(App)로 전달해준다.
 *
 *  @param manager          SLBSKit
 *  @param zoneCampaignInfo Detected Zone과 연계된 Campaign 정보
 */
- (void)slbskit:(SLBSKit *)manager didEventCampaign:(NSArray *)zoneCampaignList
{
    TSGLog(TSLogGroupCampaign, @"didEventCampaign %@", zoneCampaignList);
    
    [self.delegate zoneCampaignManager:self onCampaignPopup:zoneCampaignList];
}
@end