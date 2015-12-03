//
//  Beacon.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//


#ifndef SLBSKit_Beacon_h
#define SLBSKit_Beacon_h

#import <Foundation/Foundation.h>

@interface Beacon : NSObject <NSCoding>

@property (readonly) NSNumber* beacon_id;
@property (readonly) NSString* uuid;
@property (readonly) NSNumber* major;
@property (readonly) NSNumber* minor;
@property (readonly) NSNumber* type;
@property (readonly) NSString* txpower;
@property (readonly) NSString* serial_number;
@property (readonly) NSString* mac_address;
@property (readonly) NSNumber* broadcast_freq;
@property (readonly) NSString* image_url;
@property (readonly) NSNumber *validity;
@property (readonly) NSString *beacon_description;
@property (readonly) NSString *name;

@property (readonly) NSNumber* loc_company_id;
@property (readonly) NSNumber* loc_id;
@property (readonly) NSNumber* loc_floor_id;
@property (readonly) NSString* loc_description;
@property (readonly) NSNumber* loc_validity;
@property (readonly) NSNumber* loc_branch_id;
@property (readonly) double loc_x;
@property (readonly) double loc_y;
@property (readonly) NSNumber* loc_map_id;

@property (readonly) NSNumber* status_id;
@property (readonly) NSNumber* status_humidity;
@property (readonly) NSNumber* status_validity;
@property (readonly) NSNumber* status_battery;
@property (readonly) NSNumber* status_illumination;
@property (readonly) NSNumber* status_temperature;

- (instancetype)initWithDictionary:(NSDictionary*)source;
+ (Beacon*)beaconWithDictionary:(NSDictionary*)source;

@end
#endif
