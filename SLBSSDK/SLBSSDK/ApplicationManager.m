//
//  ApplicationManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationManager.h"
#import "SLBSKit.h"
#import "LogManager.h"
#import "PolicyManager.h"
#import "DeviceManager.h"
#import "BeaconNet.h"
#import "ZoneNet.h"
#import "ZoneCampaignNet.h"

#define DATA_UPDATE_DATE          @"Data"

#define ONE_DAY                     60*60*24

UIApplicationState g_appStatus;

typedef void (^completionResultBlock_t)(UIBackgroundFetchResult successed);

@interface ApplicationManager() {
    __strong completionResultBlock_t fetchNewDataWithCompletionBlock;
}
@end

/**
 *  Application Background/ForeGround 상태 전달받고, Background Fetch 처리하는 class
 */
@implementation ApplicationManager

+ (NSString*)version {
    return @"0.10";
}

+ (ApplicationManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static ApplicationManager *sharedApplicationManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedApplicationManager = [[ApplicationManager alloc] init];
    });
    return sharedApplicationManager;
}

+ (void)applicationDidFinishLaunching {
    g_appStatus = UIApplicationStateActive;
}


+ (void)applicationDidEnterBackground {
    //Todo: Background 동작은 별도의 api가 필요한가?
    //iOS7/8 에서는 별도 처리 없다고 보긴 했는데, 그래도 확인 필요
    [[SLBSKit sharedInstance] startService:SLBSServiceLocation];
}

+ (void)applicationWillEnterForeground {
    g_appStatus = UIApplicationStateActive;
    
    [[SLBSKit sharedInstance] startService:SLBSServiceLocation];
    [[LogManager sharedInstance] uploadToServer];
}

+ (void)applicationWillTerminate {
    
}

+ (UIApplicationState)applicationStatus {
    return g_appStatus;
}


-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    TSGLog(TSLogGroupCommon, @"Background Fetch Start");
    
    fetchNewDataWithCompletionBlock = completionHandler;
    
   //Server와 데이터 동기화 작업
   //background fetch가 하루에 여러번 작업될 가능성이 있어 최소 작업 단위를 하루로 설정 , 변경 가능성 있음
   // 모두 다운로드 받아야 하기 때문에 UUID 부터 시작해서 순차적으로 호출
   [self checkAndUpdatePolicy];
    

}

- (void)checkAndUpdatePolicy {
    NSLog(@"checkAndUpdatePolicy");
    
    NSDate* updateDate = [[NSUserDefaults standardUserDefaults] objectForKey:DATA_UPDATE_DATE];
    NSInteger dayDiff;
    
    if(updateDate != nil)
        dayDiff = (int)[updateDate timeIntervalSinceNow];
    
    if(dayDiff > ONE_DAY || updateDate != nil)
    {
        [[PolicyManager sharedInstance] requestPolicyToServerWithBlock:^(BOOL succeess, Policy *policyData) {
            if(succeess)
            {
                TSGLog(TSLogGroupCommon, @"UpdatePolicy");
                [[LogManager sharedInstance] setPolicy:policyData];
                [[LOCLocationEngine sharedInstance] setPolicy:policyData];
                
            }
            [self checkAndUpdateUUIDList];
            
        }];
    }
    
}


- (void)checkAndUpdateUUIDList {
    NSLog(@"checkAndUpdateUUIDList");
    
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    
    [BeaconNet requestUUIDListWithAccessToken:accessToken block:^(BeaconNet* net){
        if(net.returnCode == 0) {
            NSLog(@"%s requestUUIDListWithAccessToken success", __PRETTY_FUNCTION__);
            TSGLog(TSLogGroupCommon, @"Update UUID");
        }
        [self checkAndUpdateBeaconList];
    }];
}

- (void)checkAndUpdateBeaconList {
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    
    [BeaconNet requestBeaconListWithAccessToken:accessToken block:^(BeaconNet* net){
        if(net.returnCode == 0) {
            NSLog(@"%s requestZoneListWithBlock success", __PRETTY_FUNCTION__);
            TSGLog(TSLogGroupCommon, @"Update BeaconList");
        }
        [self checkAndUpdateZoneList];
    }];
   
}


- (void)checkAndUpdateZoneList {
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    
    [ZoneNet requestZoneListWithAccessToken:accessToken block:^(ZoneNet* net){
        if(net.returnCode == 0) {
            NSLog(@"%s requestZoneListWithBlock success", __PRETTY_FUNCTION__);
            TSGLog(TSLogGroupCommon, @"Update ZoneList");
        }
        [self checkAndUpdateZoneCampaignList];
    }];
}


- (void)checkAndUpdateZoneCampaignList {
    
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    
    [ZoneCampaignNet requestCampaignsWithAccessToken:accessToken block:^(ZoneCampaignNet* zoneCampaignNet){
        if(zoneCampaignNet.returnCode == 0) {
            NSLog(@"%s requestCampaignsWithAccessToken success", __PRETTY_FUNCTION__);
            TSGLog(TSLogGroupCommon, @"Update ZoneCampaign");
            
            //완료 후 Update Date 저장
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:DATA_UPDATE_DATE];
            
            NSDate* now = [NSDate date];
            [[NSUserDefaults standardUserDefaults] setObject:now forKey:DATA_UPDATE_DATE];
            
            TSGLog(TSLogGroupCommon, @"Background Fetch Success");
            fetchNewDataWithCompletionBlock(UIBackgroundFetchResultNewData);
        }
        else {
            TSGLog(TSLogGroupCommon, @"Background Fetch Fail");
            fetchNewDataWithCompletionBlock(UIBackgroundFetchResultFailed);
        }
        
    }];
    
    
}


- (void)checkAndUpdateMapList {
   //Map 전체 가져오는 기능 확인 필요
   //Map은 데이터가 많아서 조금 고민.
   //일단 fetch시 현재 위치에서 기준으로 몇개 가져오고, foreground시 없으면 그때 다시 요청하는것도 고려.
}
@end