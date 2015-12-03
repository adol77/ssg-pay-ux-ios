//
//  LogNet.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INNet.h"

@interface LogNet : INNet

+(void)sendRouteLogWithAccessToken:(NSString*)accessToken deviceID:(NSString*)deviceID appID:(NSString*)appID locationLog:(NSString*)locationLog companyID:(NSNumber*)companyID branchID:(NSNumber*)branchID floorID:(NSNumber*)floorID coordX:(double)coordX coordY:(double)coordY zoneID:(NSNumber*)zoneID zoneCampaignID:(NSNumber*)zoneCampaignID zoneLogType:(NSNumber*)zoneLogType timeStamp:(NSString*)timeStamp block:(void (^)(LogNet *netObject))block;

+(void)sendLogWithAccessToken:(NSString*)accessToken deviceID:(NSString*)deviceID appID:(NSString*)appID userID:(NSNumber*)userID eventType:(NSNumber*)eventType logType:(NSNumber*)logType timeStamp:(NSString*)timeStamp block:(void (^)(LogNet *netObject))block;
@end
