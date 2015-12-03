//
//  LogManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LogManager.h"
#import "DeviceManager.h"
#import "SLReachability.h"
#import "LogNet.h"
#import "LogDataManager.h"
#import "Log.h"

@implementation LogManager : NSObject

+ (LogManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static LogManager *sharedLogManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedLogManager = [[LogManager alloc] init];
    });
    return sharedLogManager;
}


-(void)uploadToServer
{
    if([[DeviceManager sharedInstance] deviceID] == nil)
        return;
    
    if(self.uploadServerStatus == YES
       && self.wifiCheckStatus == NO)
    {
        [self sendLogWithBlock:^(BOOL success) {
            if(success)
               [[LogDataManager sharedInstance] removeLogs];
        }];
        
        [self sendRoutLogWithBlock:^(BOOL success) {
            if(success)
               [[LogDataManager sharedInstance] removeRoutes];
        }];
    }
    else if(self.uploadServerStatus == YES
            && self.wifiCheckStatus == YES
            && [self checkNetworkStatus] == ReachableViaWiFi)
    {
        [self sendLogWithBlock:^(BOOL success) {
            if(success)
                [[LogDataManager sharedInstance] removeLogs];
        }];
        
        [self sendRoutLogWithBlock:^(BOOL success) {
            if(success)
                [[LogDataManager sharedInstance] removeRoutes];
        }];
    }
    
}


- (void)saveLogWithDeviceID:(NSString*)deviceID appID:(NSString*)appID eventType:(NSNumber*)eventType logType:(NSNumber*)logType {
    
    NSArray* logs = [[LogDataManager sharedInstance] logs];
    NSMutableArray* mutableLogs = [logs copy];
    
    NSString *timeStamp = [self getDateStringWithFormatter:@"yyyy-MM-dd HH:mm:ss" date:[NSDate date]];
   
    Log* log = [Log logWithData:deviceID appID:appID userID:[NSNumber numberWithInt:0] eventType:eventType logType:logType timeStamp:timeStamp];
    
    [mutableLogs addObject:log];
    
    [[LogDataManager sharedInstance] setLogs:mutableLogs];
}

- (void)saveRouteLogWithDeviceID:(NSString*)deviceID appID:(NSString*)appID locationLog:(NSString*)locationLog companyID:(NSNumber*)companyID branchID:(NSNumber*)branchID floorID:(NSNumber*)floorID coordX:(double)coordX coordY:(double)coordY zoneID:(NSNumber*)zoneID zoneCampaignID:(NSNumber*)zoneCampaignID zoneLogType:(NSNumber*)zoneLogType {
    
    NSArray* routeLogs = [[LogDataManager sharedInstance] routes];
    NSMutableArray* mutableRouteLogs = [routeLogs copy];
    
    NSString *timeStamp = [self getDateStringWithFormatter:@"yyyy-MM-dd HH:mm:ss" date:[NSDate date]];
    
    RouteLog* routeLog = [RouteLog routeLogWithData:deviceID appID:appID locationLog:locationLog companyID:companyID branchID:branchID floorID:floorID coordX:coordX coordY:coordY zoneID:zoneID zoneCampaignID:zoneCampaignID zoneLogType:zoneLogType timeStamp:timeStamp];
    
    [mutableRouteLogs addObject:routeLog];
    
    [[LogDataManager sharedInstance] setRoutes:mutableRouteLogs];
}
     


- (void)setPolicy:(Policy*)policyData
{
    self.wifiCheckStatus = [[policyData log_wifi] boolValue];
    self.uploadServerStatus = [[policyData log_server_transfer] boolValue];
}

/**
 *  위치 관련 로그 Server Upload
 *
 *  @param block block
 */
- (void) sendRoutLogWithBlock:(void (^)(BOOL success))block  {
    NSArray* routeLogs = [[LogDataManager sharedInstance] routes];
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    for(RouteLog* routeLog in routeLogs) {
        [LogNet sendRouteLogWithAccessToken:accessToken deviceID:routeLog.device_id appID:routeLog.app_id locationLog:routeLog.location_log companyID:routeLog.company_id branchID:routeLog.branch_id floorID:routeLog.floor_id coordX:routeLog.coord_x coordY:routeLog.coord_y zoneID:routeLog.zone_id zoneCampaignID:routeLog.zone_campaign_id zoneLogType:routeLog.zone_log_type timeStamp:routeLog.timestamp block:^(LogNet* net) {
            if(net.returnCode == 0) {
                NSLog(@"SendRouteLog Success");
                block(YES);
            }
            else {
                NSLog(@"SendRouteLog Fail");
                block(NO);
            }
        }];
    }
}

/**
 *  AppTraker/Device 로그 Server upload
 *
 *  @param block block
 */
- (void) sendLogWithBlock:(void (^)(BOOL success))block {
    NSArray* logs = [[LogDataManager sharedInstance] logs];
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    for(Log* log in logs) {
        [LogNet sendLogWithAccessToken:accessToken deviceID:log.device_id appID:log.app_id userID:log.user_id eventType:log.event_type logType:log.log_type timeStamp:log.timestamp block:^(LogNet* net) {
            if(net.returnCode == 0) {
                NSLog(@"SendLog Success");
                block(YES);
            }
            else {
                NSLog(@"SendLog Fail");
                block(NO);
            }
        }];
    }
}

/**
 *  Network 상태 체크
 *
 *  @return NetworkStatus - NetworkStatus 참고
 */
- (NetworkStatus)checkNetworkStatus{
    SLReachability *reachability = [SLReachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
   
    [reachability stopNotifier];
    
    return status;
}

- (NSString*)getDateStringWithFormatter:(NSString*)format date:(NSDate*)date {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    return [dateFormat stringFromDate:date];
}

@end