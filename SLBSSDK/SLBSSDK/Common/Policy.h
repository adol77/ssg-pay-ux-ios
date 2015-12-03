//
//  PolicyData.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 21..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {"sdk_policy":
 {
 "microfence":1,
 "policy_sync_interval":5,
 "map_view_mode":1,
 "reg_date":Wed Sep 16 17:13:05 KST 2015,
 "map_zoom_level_max":5,
 "log_server_transfer":1,
 "geofence":1,
 "id":2,
 "geofence_filter_count":50,
 "position_log_interval":1,
 "validity":1,
 "name":"테스트 SDK 정책 From JUnit",
 "zone_campaign_sync_time":"04:00:00",
 "geofence_filter_time":10,
 "log_wifi":1,
 "log_sync_time":"03:00:00",
 "map_zoom_level_min":1,
 "zone_sync_time":"03:30:00",
 "upd_date":Wed Sep 16 17:13:05 KST 2015,
 "creator_id":-1,
 "geofence_filter_distance":1,
 "zone_list_cache":-1,
 "default_policy":1,
 "position_battery":2,
 "editor_id":-1,
 "map_rotation_x_angle":0.166
 },
 "msg":"SUCCESS"}
 */
@class Policy;
@interface Policy : NSObject <NSCoding>

- (instancetype)initWithDictionary:(NSDictionary*)source;
+ (Policy*)policyWithDictionary:(NSDictionary*)source;

@property (readonly) NSNumber* policy_id;
@property (readonly) NSString* name;
@property (readonly) NSNumber* geofence;
@property (readonly) NSNumber* microfence;
@property (readonly) NSNumber* geofence_filter_time;
@property (readonly) NSNumber* geofence_filter_distance;
@property (readonly) NSNumber* geofence_filter_count;
@property (readonly) NSNumber* position_battery;
@property (readonly) NSNumber* position_log_interval;
@property (readonly) NSNumber* log_server_transfer;
@property (readonly) NSNumber* log_wifi;
@property (readonly) NSDate* log_sync_time;
@property (readonly) NSDate* zone_sync_time;
@property (readonly) NSDate* zone_campaign_sync_time;
@property (readonly) NSNumber* zone_list_cache;
@property (readonly) NSNumber* map_zoom_level_min;
@property (readonly) NSNumber* map_zoom_level_max;
@property (readonly) NSNumber* map_view_mode;
@property (readonly) NSNumber* map_rotation_x_angle;
@property (readonly) NSNumber* default_policy;
@property (readonly) NSNumber* policy_sync_signal;

@end

