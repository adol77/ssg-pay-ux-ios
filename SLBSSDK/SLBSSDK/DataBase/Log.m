//
//  Log.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "Log.h"

@implementation Log

+(instancetype)logWithData:(NSString*)deviceID appID:(NSString*)appID userID:(NSNumber*)userID eventType:(NSNumber*)eventType logType:(NSNumber*)logType timeStamp:(NSString*)timeStamp{
    Log* log = [[Log alloc] init];
    
    log.device_id = deviceID;
    log.app_id = appID;
    log.user_id = userID;
    log.event_type = eventType;
    log.log_type = logType;
    log.timestamp = timeStamp;
    
    return log;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

@end

@implementation RouteLog

+(instancetype)routeLogWithData:(NSString*)deviceID appID:(NSString*)appID locationLog:(NSString*)locationLog companyID:(NSNumber*)companyID branchID:(NSNumber*)branchID floorID:(NSNumber*)floorID coordX:(double)coordX coordY:(double)coordY zoneID:(NSNumber*)zoneID zoneCampaignID:(NSNumber*)zoneCampaignID zoneLogType:(NSNumber*)zoneLogType timeStamp:(NSString*)timeStamp{
    
    RouteLog* routeLog = [[RouteLog alloc] init];
    routeLog.device_id = deviceID;
    routeLog.app_id = appID;
    routeLog.location_log = locationLog;
    routeLog.company_id  = companyID;
    routeLog.branch_id = branchID;
    routeLog.floor_id = floorID;
    routeLog.coord_x = coordX;
    routeLog.coord_y = coordY;
    routeLog.zone_id = zoneID;
    routeLog.zone_campaign_id = zoneCampaignID;
    routeLog.zone_log_type = zoneLogType;
    routeLog.timestamp = timeStamp;
    
    return routeLog;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

@end