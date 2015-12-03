//
//  LogNet.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "LogNet.h"
#import "TSDebugLogManager.h"

@implementation LogNet

const NSString *logApiVersion         = @"/v1";
const NSString *logApiGroup           = @"/lms";

- (instancetype)initWithAccessToken:(NSString *)token {
    self = [super init];
    if (self) {
        if ([token length] > 0) {
            [self setHeaderField:@"access_token" value:token];
        }
    }
    return self;
}

/**
 *  위치 관련 로그 Server Upload
 *
 *  @param accessToken    <#accessToken description#>
 *  @param deviceID       <#deviceID description#>
 *  @param appID          <#appID description#>
 *  @param locationLog    <#locationLog description#>
 *  @param companyID      <#companyID description#>
 *  @param branchID       <#branchID description#>
 *  @param floorID        <#floorID description#>
 *  @param coordX         <#coordX description#>
 *  @param coordY         <#coordY description#>
 *  @param zoneID         <#zoneID description#>
 *  @param zoneCampaignID <#zoneCampaignID description#>
 *  @param zoneLogType    <#zoneLogType description#>
 *  @param timeStamp      <#timeStamp description#>
 *  @param block          <#block description#>
 */
+(void)sendRouteLogWithAccessToken:(NSString *)accessToken deviceID:(NSString *)deviceID appID:(NSString *)appID locationLog:(NSString *)locationLog companyID:(NSNumber *)companyID branchID:(NSNumber *)branchID floorID:(NSNumber *)floorID coordX:(double)coordX coordY:(double)coordY zoneID:(NSNumber *)zoneID zoneCampaignID:(NSNumber *)zoneCampaignID zoneLogType:(NSNumber *)zoneLogType timeStamp:(NSString*)timeStamp block:(void (^)(LogNet *))block {
    TSGLog(TSLogGroupNetwork, @"send RouteLog API");
    
    NSDictionary *requestObject = @{ @"device_id" : deviceID,
                                     @"app_id" : appID,
                                     @"slbs_location_log" : locationLog,
                                     @"loc_company_id" : companyID,
                                     @"loc_branch_id" : branchID,
                                     @"loc_floor_id" : floorID,
                                     @"loc_coord_x" : [NSNumber numberWithDouble:coordX],
                                     @"loc_coord_y" : [NSNumber numberWithDouble:coordY],
                                     @"zone_id" : zoneID,
                                     @"zone_campaign_id" : zoneCampaignID,
                                     @"zone_log_type" : zoneLogType,
                                     @"str_timestamp" : timeStamp
                                     };
    
    LogNet *net = [[LogNet alloc] initWithAccessToken:accessToken];
    [net setRequestWithAPI:@"/route" data:requestObject];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            NSLog(@"Send RouteLog result: %d", success);
            TSGLog(TSLogGroupNetwork, @"Send RouteLog result: %d", success);

            block(net);
        }
        else {
            NSLog(@"Send RouteLog result: %d", success);
            TSGLog(TSLogGroupNetwork, @"Send RouteLog result: %d", success);
            
            block(net);
        }
    }];
}

/**
 *  AppTraking, Device 관련 로그 Server Upload
 *
 *  @param accessToken <#accessToken description#>
 *  @param deviceID    <#deviceID description#>
 *  @param appID       <#appID description#>
 *  @param userID      <#userID description#>
 *  @param eventType   <#eventType description#>
 *  @param logType     <#logType description#>
 *  @param timeStamp   <#timeStamp description#>
 *  @param block       <#block description#>
 */
+(void)sendLogWithAccessToken:(NSString *)accessToken deviceID:(NSString *)deviceID appID:(NSString *)appID userID:(NSNumber *)userID eventType:(NSNumber *)eventType logType:(NSNumber *)logType timeStamp:(NSString*)timeStamp block:(void (^)(LogNet *))block {
    TSGLog(TSLogGroupNetwork, @"send Log API");
    
    NSDictionary *requestObject = @{ @"log_type" : logType,
                                     @"device_id" : deviceID,
                                     @"app_id" : appID,
                                     @"user_id" : userID,
                                     @"event_type" : eventType,
                                     @"str_timestamp" : timeStamp
                                     };
    
    LogNet *net = [[LogNet alloc] initWithAccessToken:accessToken];
    [net setRequestWithAPI:@"/log" data:requestObject];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            NSLog(@"Send Log result: %d", success);
            TSGLog(TSLogGroupNetwork, @"Send Log result: %d", success);
            
            block(net);
        }
        else {
            NSLog(@"Send Log result: %d", success);
            TSGLog(TSLogGroupNetwork, @"Send Log result: %d", success);
            
            block(net);
        }
    }];

    
}



@end
