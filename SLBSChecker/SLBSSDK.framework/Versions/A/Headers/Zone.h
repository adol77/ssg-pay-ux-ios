//
//  Zone.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 25..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/**
 zone_data {
 positioning,
 name, 
 address, 
 icon_url,
 attribute, 
 type, 
 owner_type, 
 owner_group,
 description,
 store: {
    company_id, 
    branch_id,
    floor_id,
 name,
 type,
 active,
 description,
 address,
 image_url,
 opening_hours_start,
 opening_hours_end,
 business_day},
 coords:
 [{x,y}]
 }
 */


@interface Zone : NSObject <NSCoding>

- (instancetype)initWithDictionary:(NSDictionary*)source;
+ (Zone*)zoneWithDictionary:(NSDictionary*)source;
+ (NSArray *)zonesWithSources:(NSArray *)sources;

@property (readonly) NSNumber* zone_id;
@property (readonly) NSNumber* map_id;
@property (readonly) NSNumber* store_id;
@property (readonly) NSNumber* beacon_id;
@property (readonly) NSNumber* positioning;
@property (readonly) double center_x;
@property (readonly) double center_y;
@property (readonly) NSString *name;
@property (readonly) NSString *address;
@property (readonly) NSNumber* type;
@property (readonly) NSNumber* attribute;

@property (readonly) NSArray *coords;
@property (readonly) UIBezierPath* polygonPath;

@property (readonly) NSNumber* owner_type;
@property (readonly) NSString* icon_url;
@property (readonly) NSNumber* zone_level;
@property (readonly) NSString *desc;
@property (readonly) NSNumber* owner_group;

@property (readonly) double title_center_x;
@property (readonly) double title_center_y;
@property (readonly) double title_left_top_x;
@property (readonly) double title_left_top_y;
@property (readonly) double title_right_bottom_x;
@property (readonly) double title_right_bottom_y;
@property (readonly) double title_angle;

//@property (readonly) NSString* store_off_day_desc;
//@property (readonly) NSNumber* store_company_id;
//@property (readonly) NSString* store_off_week;
//@property (readonly) NSNumber* store_company_brand_id;
//@property (readonly) NSNumber* store_off_day_of_week;
//@property (readonly) NSDate* store_opening_hour_end;
//@property (readonly) NSNumber* store_floor_id;
//@property (readonly) NSDate* store_opening_hour_start;
//@property (readonly) NSString* store_address;
//@property (readonly) NSString* store_image_url;
//@property (readonly) NSString* store_decs;
//@property (readonly) NSString* store_name;
//@property (readonly) NSNumber* store_active;
//@property (readonly) NSNumber* store_branch_id;
//@property (readonly) NSString* store_biz_day_of_week;


@property (readonly) NSNumber* store_company_id;
@property (readonly) NSNumber* store_company_brand_id;
@property (readonly) NSNumber* store_root_branch_id;
@property (readonly) NSNumber* store_branch_id;
@property (readonly) NSNumber* store_floor_id;
@property (readonly) NSNumber* store_tenant_corner_id;
@property (readonly) NSNumber* store_type;

@property (readonly) NSNumber* campaign_count;

@property (readonly) NSNumber* tenant_id;
@property (readonly) NSNumber* tenant_brand_id;
@property (readonly) NSNumber* tenant_branch_id;
@property (readonly) NSNumber* tenant_floor_id;
@property (readonly) NSNumber* tenant_type;
@property (readonly) NSString* tenant_phone_num;
@property (readonly) NSString* tenant_image;
@property (readonly) NSNumber* tenant_active;
@property (readonly) NSNumber* tenant_display_map;
@property (readonly) NSNumber* tenant_company_id;
@property (readonly) NSString* tenant_name;
@property (readonly) NSString* tenant_bi;
@property (readonly) NSString* tenant_description;

@property (readonly) NSArray* tenant_biz_off_list;
@property (readonly) NSArray* tenant_biz_time_list;


@end
