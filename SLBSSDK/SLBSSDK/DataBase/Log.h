//
//  Log.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_Log_h
#define SLBSKit_Log_h

#import <Foundation/Foundation.h>

@interface Log : NSObject<NSCoding>

@property NSString* device_id;
@property NSString* app_id;
@property NSNumber* user_id;
@property NSNumber* event_type;
@property NSNumber* log_type;
@property NSString* timestamp;

+(instancetype)logWithData:(NSString*)deviceID appID:(NSString*)appID userID:(NSNumber*)userID eventType:(NSNumber*)eventType logType:(NSNumber*)logType timeStamp:(NSString*)timeStamp;
@end

@interface RouteLog : NSObject<NSCoding>

@property NSString* device_id;
@property NSString* app_id;
@property NSString* location_log;
@property NSNumber* company_id;
@property NSNumber* branch_id;
@property NSNumber* floor_id;
@property double coord_x;
@property double coord_y;
@property NSNumber* zone_id;
@property NSNumber* zone_campaign_id;
@property NSNumber* zone_log_type;
@property NSString* timestamp;

+(instancetype)routeLogWithData:(NSString*)deviceID appID:(NSString*)appID locationLog:(NSString*)locationLog companyID:(NSNumber*)companyID branchID:(NSNumber*)branchID floorID:(NSNumber*)floorID coordX:(double)coordX coordY:(double)coordY zoneID:(NSNumber*)zoneID zoneCampaignID:(NSNumber*)zoneCampaignID zoneLogType:(NSNumber*)zoneLogType timeStamp:(NSString*)timeStamp;
@end

#endif
