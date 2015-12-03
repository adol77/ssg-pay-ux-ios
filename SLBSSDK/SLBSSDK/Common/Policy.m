//
//  PolicyData.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 21..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "Policy.h"

@interface Policy()
@property (nonatomic, assign) NSNumber* policy_id;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) NSNumber* geofence;
@property (nonatomic, assign) NSNumber* microfence;
@property (nonatomic, assign) NSNumber* geofence_filter_time;
@property (nonatomic, assign) NSNumber* geofence_filter_distance;
@property (nonatomic, assign) NSNumber* geofence_filter_count;
@property (nonatomic, assign) NSNumber* position_battery;
@property (nonatomic, assign) NSNumber* position_log_interval;
@property (nonatomic, assign) NSNumber* log_server_transfer;
@property (nonatomic, assign) NSNumber* log_wifi;
@property (nonatomic, assign) NSDate* log_sync_time;
@property (nonatomic, assign) NSDate* zone_sync_time;
@property (nonatomic, assign) NSDate* zone_campaign_sync_time;
@property (nonatomic, assign) NSNumber* zone_list_cache;
@property (nonatomic, assign) NSNumber* map_zoom_level_min;
@property (nonatomic, assign) NSNumber* map_zoom_level_max;
@property (nonatomic, assign) NSNumber* map_view_mode;
@property (nonatomic, assign) NSNumber* map_rotation_x_angle;
@property (nonatomic, assign) NSNumber* default_policy;
@property (nonatomic, assign) NSNumber* policy_sync_signal;
@end

@implementation Policy

+ (Policy*)policyWithDictionary:(NSDictionary*)source {
    return [[Policy alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.policy_id = [source objectForKey:@"id"];
        self.name = [source objectForKey:@"name"];
        self.geofence = [source objectForKey:@"geofence"];
        self.microfence = [source objectForKey:@"microfence"];
        self.geofence_filter_time = [source objectForKey:@"geofence_filter_time"];
        self.geofence_filter_distance = [source objectForKey:@"geofence_filter_distance"];
        self.geofence_filter_count = [source objectForKey:@"geofence_filter_count"];
        self.position_battery = [source objectForKey:@"position_battery"];
        self.position_log_interval = [source objectForKey:@"position_log_interval"];
        self.log_server_transfer = [source objectForKey:@"log_server_transfer"];
        self.log_wifi = [source objectForKey:@"log_wifi"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"HH:mm:ss"];
        
        NSString *logSyncTime = [NSString stringWithString:[source objectForKey:@"log_sync_time"]];
        self.log_sync_time = [dateFormat dateFromString:logSyncTime];
        
        NSString *zoneSyncTime = [NSString stringWithString:[source objectForKey:@"zone_sync_time"]];
        self.zone_sync_time = [dateFormat dateFromString:zoneSyncTime];
        
        NSString *zoneCampaignSyncTime = [NSString stringWithString:[source objectForKey:@"zone_campaign_sync_time"]];
        self.zone_campaign_sync_time = [dateFormat dateFromString:zoneCampaignSyncTime];
        
        self.zone_list_cache = [source objectForKey:@"zone_list_cache"];
        self.map_zoom_level_min = [source objectForKey:@"map_zoom_level_min"];
        self.map_zoom_level_max = [source objectForKey:@"map_zoom_level_max"];
        self.map_view_mode = [source objectForKey:@"map_view_mode"];
        self.map_rotation_x_angle = [source objectForKey:@"map_rotation_x_angle"];

    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.policy_id = [aDecoder decodeObjectForKey:@"policy_id"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.geofence = [aDecoder decodeObjectForKey:@"geofence"];
        self.microfence = [aDecoder decodeObjectForKey:@"microfence"];
        self.geofence_filter_time = [aDecoder decodeObjectForKey:@"geofence_filter_time"];
        self.geofence_filter_distance = [aDecoder decodeObjectForKey:@"geofence_filter_distance"];
        self.geofence_filter_count =[aDecoder decodeObjectForKey:@"geofence_filter_count"];
        self.position_battery =[aDecoder decodeObjectForKey:@"position_battery"];
        self.position_log_interval =[aDecoder decodeObjectForKey:@"position_log_interval"] ;
        self.log_server_transfer =[aDecoder decodeObjectForKey:@"log_server_transfer"];
        self.log_wifi =[aDecoder decodeObjectForKey:@"log_wifi"] ;
        self.log_sync_time = [aDecoder decodeObjectForKey:@"log_sync_time"];
        self.zone_sync_time = [aDecoder decodeObjectForKey:@"zone_sync_time"];
        self.zone_campaign_sync_time = [aDecoder decodeObjectForKey:@"zone_campaign_sync_time"];
        self.zone_list_cache = [aDecoder decodeObjectForKey:@"zone_list_cache"];
        self.map_zoom_level_min = [aDecoder decodeObjectForKey:@"map_zoom_level_min"];
        self.map_zoom_level_max = [aDecoder decodeObjectForKey:@"map_zoom_level_max"];
        self.map_view_mode =[aDecoder decodeObjectForKey:@"map_view_mode"];
        self.map_rotation_x_angle =[aDecoder decodeObjectForKey:@"map_rotation_x_angle"];
        self.policy_sync_signal =[aDecoder decodeObjectForKey:@"policy_sync_interval"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.policy_id forKey:@"policy_id"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.geofence forKey:@"geofence"];
    [aCoder encodeObject:self.microfence forKey:@"microfence"];
    [aCoder encodeObject:self.geofence_filter_time forKey:@"geofence_filter_time"];
    [aCoder encodeObject:self.geofence_filter_distance forKey:@"geofence_filter_distance"];
    [aCoder encodeObject:self.geofence_filter_count forKey:@"geofence_filter_count"];
    [aCoder encodeObject:self.position_battery forKey:@"position_battery"];
    [aCoder encodeObject:self.position_log_interval forKey:@"position_log_interval"];
    [aCoder encodeObject:self.log_server_transfer forKey:@"log_server_transfer"];
    [aCoder encodeObject:self.log_wifi forKey:@"log_wifi"];
    [aCoder encodeObject:self.log_sync_time forKey:@"log_sync_time"];
    [aCoder encodeObject:self.zone_sync_time forKey:@"zone_sync_time"];
    [aCoder encodeObject:self.zone_campaign_sync_time forKey:@"zone_campaign_sync_time"];
    [aCoder encodeObject:self.zone_list_cache forKey:@"zone_list_cache"];
    [aCoder encodeObject:self.map_zoom_level_min forKey:@"map_zoom_level_min"];
    [aCoder encodeObject:self.map_zoom_level_max forKey:@"map_zoom_level_max"];
    [aCoder encodeObject:self.map_view_mode forKey:@"map_view_mode"];
    [aCoder encodeObject:self.map_rotation_x_angle forKey:@"map_rotation_x_angle"];
    [aCoder encodeObject:self.policy_sync_signal forKey:@"policy_sync_interval"];
}
@end
