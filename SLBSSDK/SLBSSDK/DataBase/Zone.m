//
//  Zone.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 25..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "Zone.h"
#import "ZoneCoord.h"
#import "TenantBizOffInfo.h"
#import "TenantBizTimeInfo.h"
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface Zone()
@property (nonatomic, assign) NSNumber* owner_type;
@property (nonatomic, strong) NSString* icon_url;
@property (nonatomic, assign) NSNumber* attribute;
@property (nonatomic, assign) NSNumber* type;
@property (nonatomic, assign) NSNumber* positioning;
@property (nonatomic, assign) NSNumber* zone_id;
@property (nonatomic, assign) double center_x;
@property (nonatomic, assign) double center_y;
@property (nonatomic, assign) NSNumber* level;
@property (nonatomic, assign) NSNumber* map_id;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSNumber* owner_group;
@property (nonatomic, assign) NSNumber* beacon_id;

@property (nonatomic, assign) double title_center_x;
@property (nonatomic, assign) double title_center_y;
@property (nonatomic, assign) double title_left_top_x;
@property (nonatomic, assign) double title_left_top_y;
@property (nonatomic, assign) double title_right_bottom_x;
@property (nonatomic, assign) double title_right_bottom_y;
@property (nonatomic, assign) double title_angle;

@property (nonatomic, assign) NSNumber* store_company_id;
@property (nonatomic, assign) NSNumber* store_company_brand_id;
@property (nonatomic, assign) NSNumber* store_root_branch_id;
@property (nonatomic, assign) NSNumber* store_branch_id;
@property (nonatomic, assign) NSNumber* store_floor_id;
@property (nonatomic, assign) NSNumber* store_tenant_corner_id;
@property (nonatomic, assign) NSNumber* store_type;

@property (nonatomic, strong) NSArray* coords;
@property (nonatomic, strong) UIBezierPath* polygonPath;

@property (nonatomic, assign) NSNumber* campaign_count;

@property (nonatomic, assign) NSNumber* tenant_id;
@property (nonatomic, assign) NSNumber* tenant_brand_id;
@property (nonatomic, assign) NSNumber* tenant_branch_id;
@property (nonatomic, assign) NSNumber* tenant_floor_id;
@property (nonatomic, assign) NSNumber* tenant_type;
@property (nonatomic, strong) NSString* tenant_phone_num;
@property (nonatomic, strong) NSString* tenant_image;
@property (nonatomic, assign) NSNumber* tenant_active;
@property (nonatomic, assign) NSNumber* tenant_display_map;
@property (nonatomic, assign) NSNumber* tenant_company_id;
@property (nonatomic, strong) NSString* tenant_name;
@property (nonatomic, strong) NSString* tenant_bi;
@property (nonatomic, strong) NSString* tenant_description;
@property (nonatomic, strong) NSArray* tenant_biz_off_list;
@property (nonatomic, strong) NSArray* tenant_biz_time_list;



@end

@implementation Zone

+ (NSArray *)zonesWithSources:(NSArray *)sources {
    if (sources && ([sources count] > 0)) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *source in sources) {
            Zone *entity = [Zone zoneWithDictionary:source];
            if (entity) {
                [array addObject:array];
            }
        }
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

+ (Zone*)zoneWithDictionary:(NSDictionary*)source {
    return [[Zone alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.owner_type = [source objectForKey:@"owner_type"];
        self.icon_url = [source objectForKey:@"icon_url"];
        self.level = [source objectForKey:@"zone_level"];
        self.desc = [source objectForKey:@"description"];
        self.owner_group = [source objectForKey:@"owner_group"];
        self.zone_id = [source objectForKey:@"id"];
        self.map_id =[source objectForKey:@"map_id"];
        self.beacon_id =[source objectForKey:@"beacon_id"];
        self.positioning =[source objectForKey:@"positioning"] ;
        self.center_x =[[source objectForKey:@"center_x"] doubleValue];
        self.center_y =[[source objectForKey:@"center_y"] doubleValue];
        self.name =[source objectForKey:@"name"];
        self.address = [source objectForKey:@"address"];
        self.type =[source objectForKey:@"type"];
        self.attribute =[source objectForKey:@"attribute"];
        
        
        self.title_left_top_x =[[source objectForKey:@"title_left_top_x"] doubleValue];
        self.title_left_top_y =[[source objectForKey:@"title_left_top_y"] doubleValue];
        self.title_right_bottom_x =[[source objectForKey:@"title_right_bottom_x"] doubleValue];
        self.title_right_bottom_y =[[source objectForKey:@"title_right_bottom_y"] doubleValue];
        self.title_center_x =[[source objectForKey:@"title_center_x"] doubleValue];
        self.title_center_y =[[source objectForKey:@"title_center_y"] doubleValue];
        self.title_angle =[[source objectForKey:@"title_angle"] doubleValue];
        
        self.store_company_id = [source objectForKey:@"company_id"];
        self.store_company_brand_id = [source objectForKey:@"company_brand_id"];
        self.store_floor_id = [source objectForKey:@"floor_id"];
        self.store_branch_id = [source objectForKey:@"branch_id"];
        self.store_root_branch_id = [source objectForKey:@"root_branch_id"];
        self.store_tenant_corner_id = [source objectForKey:@"tenant_corner_id"];
        self.store_type = [source objectForKey:@"store_type"];
        
        self.campaign_count = [source objectForKey:@"campaign_count"];
        
        NSArray* coords = [source objectForKey:@"coords_array"];
        NSMutableArray* coordsArray = [NSMutableArray array];
        for(NSDictionary* coordDic in coords) {
            ZoneCoord* zoneCoord = [ZoneCoord zoneCoordWithDictionary:coordDic];
            [coordsArray addObject:zoneCoord];
        }
        self.coords = coordsArray;
                
        self.polygonPath = [self createPath:coordsArray];
        
        NSDictionary* tenantDic = [source objectForKey:@"tenant_corner"];
        if (tenantDic != (NSDictionary*) [NSNull null]) {
            self.tenant_id = [tenantDic objectForKey:@"id"];
            self.tenant_brand_id = [tenantDic objectForKey:@"brand_id"];
            self.tenant_branch_id = [tenantDic objectForKey:@"branch_id"];
            self.tenant_company_id = [tenantDic objectForKey:@"company_id"];
            self.tenant_floor_id = [tenantDic objectForKey:@"floor_id"];
            self.tenant_type = [tenantDic objectForKey:@"type"];
            self.tenant_phone_num = [tenantDic objectForKey:@"phone_num"];
            self.tenant_image = [tenantDic objectForKey:@"tenant_image"];
            self.tenant_active = [tenantDic objectForKey:@"active"];
            self.tenant_display_map = [tenantDic objectForKey:@"display_map"];
            self.tenant_bi = [tenantDic objectForKey:@"tenant_bi"];
            self.tenant_description = [tenantDic objectForKey:@"description"];
            self.tenant_name = [tenantDic objectForKey:@"name"];
            
            NSArray* tenantBizOffList = [tenantDic objectForKey:@"biz_off_list"];
            NSMutableArray* bizoffArray = [NSMutableArray array];
            for(NSDictionary* bizOffDic in tenantBizOffList) {
                TenantBizOffInfo* tenantOffInfo = [TenantBizOffInfo tenantBizOffInfoWithDictionary:bizOffDic];
                [bizoffArray addObject:tenantOffInfo];
            }
            self.tenant_biz_off_list = [bizoffArray copy];
            
            NSArray* tenantBizTimeList = [tenantDic objectForKey:@"biz_time_list"];
            NSMutableArray* bizTimeArray = [NSMutableArray array];
            for(NSDictionary* bizTimeDic in tenantBizTimeList) {
                TenantBizTimeInfo* tenantTimeInfo = [TenantBizTimeInfo tenantBizTimeInfoWithDictionary:bizTimeDic];
                [bizTimeArray addObject:tenantTimeInfo];
            }
            self.tenant_biz_time_list = [bizTimeArray copy];
        }
        else {
            self.tenant_id = [NSNumber numberWithInt:-1];
            self.tenant_brand_id = [NSNumber numberWithInt:-1];
            self.tenant_branch_id = [NSNumber numberWithInt:-1];
            self.tenant_company_id = [NSNumber numberWithInt:-1];
            self.tenant_floor_id = [NSNumber numberWithInt:-1];
            self.tenant_type = [NSNumber numberWithInt:-1];
            self.tenant_phone_num = @"";
            self.tenant_image = @"";
            self.tenant_active = [NSNumber numberWithInt:-1];
            self.tenant_display_map = [NSNumber numberWithInt:-1];
            self.tenant_bi = @"";
            self.tenant_description = @"";
            self.tenant_name = @"";
            
            self.tenant_biz_off_list = nil;
            self.tenant_biz_time_list = nil;
        }
       
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        self.owner_type = [aDecoder decodeObjectForKey:@"owner_type"];
        self.icon_url = [aDecoder decodeObjectForKey:@"icon_url"];
        self.level = [aDecoder decodeObjectForKey:@"level"];
        self.desc = [aDecoder decodeObjectForKey:@"description"];
        self.owner_group = [aDecoder decodeObjectForKey:@"owner_group"];
        self.zone_id = [aDecoder decodeObjectForKey:@"id"];
        self.map_id =[aDecoder decodeObjectForKey:@"map_id"];
        self.beacon_id =[aDecoder decodeObjectForKey:@"beacon_id"];
        self.positioning =[aDecoder decodeObjectForKey:@"positioning"] ;
        self.center_x =[[aDecoder decodeObjectForKey:@"center_x"] doubleValue];
        self.center_y =[[aDecoder decodeObjectForKey:@"center_y"] doubleValue];
        self.name =[aDecoder decodeObjectForKey:@"name"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.type =[aDecoder decodeObjectForKey:@"type"];
        self.attribute =[aDecoder decodeObjectForKey:@"attribute"];
        
        self.title_left_top_x =[[aDecoder decodeObjectForKey:@"title_left_top_x"] doubleValue];
        self.title_left_top_y =[[aDecoder decodeObjectForKey:@"title_left_top_y"] doubleValue];
        self.title_right_bottom_x =[[aDecoder decodeObjectForKey:@"title_right_bottom_x"] doubleValue];
        self.title_right_bottom_y =[[aDecoder decodeObjectForKey:@"title_right_bottom_y"] doubleValue];
        self.title_center_x =[[aDecoder decodeObjectForKey:@"title_center_x"] doubleValue];
        self.title_center_y =[[aDecoder decodeObjectForKey:@"title_center_y"] doubleValue];
        self.title_angle =[[aDecoder decodeObjectForKey:@"title_angle"] doubleValue];
        
        self.store_company_id = [aDecoder decodeObjectForKey:@"store_company_id"];
        self.store_company_brand_id = [aDecoder decodeObjectForKey:@"store_company_brand_id"];
        self.store_floor_id = [aDecoder decodeObjectForKey:@"store_floor_id"];
        self.store_branch_id = [aDecoder decodeObjectForKey:@"store_branch_id"];
        self.store_root_branch_id = [aDecoder decodeObjectForKey:@"store_root_branch_id"];
        self.store_tenant_corner_id = [aDecoder decodeObjectForKey:@"store_tenant_corner_id"];
        self.store_type = [aDecoder decodeObjectForKey:@"store_type"];
        
        self.campaign_count = [aDecoder decodeObjectForKey:@"campaign_count"];
        
        self.coords = [aDecoder decodeObjectForKey:@"coords"];
        self.polygonPath = [aDecoder decodeObjectForKey:@"polygon"];

        self.tenant_id = [aDecoder decodeObjectForKey:@"tenant_id"];
        self.tenant_brand_id = [aDecoder decodeObjectForKey:@"tenant_brand_id"];
        self.tenant_branch_id = [aDecoder decodeObjectForKey:@"tenant_branch_id"];
        self.tenant_company_id = [aDecoder decodeObjectForKey:@"tenant_company_id"];
        self.tenant_floor_id = [aDecoder decodeObjectForKey:@"tenant_floor_id"];
        self.tenant_type = [aDecoder decodeObjectForKey:@"tenant_type"];
        self.tenant_phone_num = [aDecoder decodeObjectForKey:@"tenant_phone_num"];
        self.tenant_image = [aDecoder decodeObjectForKey:@"tenant_image"];
        self.tenant_active = [aDecoder decodeObjectForKey:@"tenant_active"];
        self.tenant_display_map = [aDecoder decodeObjectForKey:@"tenant_display_map"];
        self.tenant_bi = [aDecoder decodeObjectForKey:@"tenant_bi"];
        self.tenant_description = [aDecoder decodeObjectForKey:@"tenant_description"];
        self.tenant_name = [aDecoder decodeObjectForKey:@"tenant_name"];
        
        self.tenant_biz_off_list = [aDecoder decodeObjectForKey:@"tenant_biz_off_list"];
        self.tenant_biz_time_list = [aDecoder decodeObjectForKey:@"tenant_biz_time_list"];

    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.owner_type forKey:@"owner_type"];
    [aCoder encodeObject:self.icon_url forKey:@"icon_url"];
    [aCoder encodeObject:self.level forKey:@"level"];
    [aCoder encodeObject:self.description forKey:@"description"];
    [aCoder encodeObject:self.owner_group forKey:@"owner_group"];
    [aCoder encodeObject:self.zone_id forKey:@"id"];
    [aCoder encodeObject:self.map_id forKey:@"map_id"];
    [aCoder encodeObject:self.beacon_id forKey:@"beacon_id"];
    [aCoder encodeObject:self.positioning forKey:@"positioning"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.center_x] forKey:@"center_x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.center_y] forKey:@"center_y"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.attribute forKey:@"attribute"];
    
    [aCoder encodeObject:[NSNumber numberWithDouble:self.title_left_top_x] forKey:@"title_left_top_x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.title_left_top_y] forKey:@"title_left_top_y"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.title_right_bottom_x] forKey:@"title_right_bottom_x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.title_right_bottom_y] forKey:@"title_right_bottom_y"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.title_center_x] forKey:@"title_center_x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.title_center_y] forKey:@"title_center_y"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.title_angle] forKey:@"title_angle"];
    
    [aCoder encodeObject:self.store_id forKey:@"store_id"];
    [aCoder encodeObject:self.store_company_id forKey:@"store_company_id"];
    [aCoder encodeObject:self.store_company_brand_id forKey:@"store_company_brand_id"];
    [aCoder encodeObject:self.store_floor_id forKey:@"store_floor_id"];
    [aCoder encodeObject:self.store_branch_id forKey:@"store_branch_id"];
    [aCoder encodeObject:self.store_root_branch_id forKey:@"store_root_branch_id"];
    [aCoder encodeObject:self.store_tenant_corner_id forKey:@"store_tenant_corner_id"];
    [aCoder encodeObject:self.store_type forKey:@"store_type"];
    
    [aCoder encodeObject:self.campaign_count forKey:@"campaign_count"];
    
    [aCoder encodeObject:self.coords forKey:@"coords"];
    [aCoder encodeObject:self.polygonPath forKey:@"polygon"];
    
    [aCoder encodeObject:self.tenant_id forKey:@"tenant_id"];
    [aCoder encodeObject:self.tenant_brand_id forKey:@"tenant_brand_id"];
    [aCoder encodeObject:self.tenant_branch_id forKey:@"tenant_branch_id"];
    [aCoder encodeObject:self.tenant_company_id forKey:@"tenant_company_id"];
    [aCoder encodeObject:self.tenant_floor_id forKey:@"tenant_floor_id"];
    [aCoder encodeObject:self.tenant_type forKey:@"tenant_type"];
    [aCoder encodeObject:self.tenant_phone_num forKey:@"tenant_phone_num"];
    [aCoder encodeObject:self.tenant_image forKey:@"tenant_image"];
    [aCoder encodeObject:self.tenant_active forKey:@"tenant_active"];
    [aCoder encodeObject:self.tenant_display_map forKey:@"tenant_display_map"];
    [aCoder encodeObject:self.tenant_bi forKey:@"tenant_bi"];
    [aCoder encodeObject:self.tenant_description forKey:@"tenant_description"];
    [aCoder encodeObject:self.tenant_name forKey:@"tenant_name"];
    
    [aCoder encodeObject:self.tenant_biz_off_list forKey:@"tenant_biz_off_list"];
    [aCoder encodeObject:self.tenant_biz_time_list forKey:@"tenant_biz_time_list"];
    
}

- (UIBezierPath*)createPath:(NSArray*)coords{
    NSMutableArray* points = [NSMutableArray array];
    
    for(ZoneCoord* zoneCoord in coords)
    {
       // NSLog(@"%s zoneCoord %f, %f ", __PRETTY_FUNCTION__, zoneCoord.x, zoneCoord.y);
        
        CGPoint zonePoint = CGPointMake(zoneCoord.x, zoneCoord.y);
        [points addObject:[NSValue valueWithCGPoint:zonePoint]];
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    if (points && points.count > 0) {
        CGPoint p =[(NSValue *)[points objectAtIndex:0] CGPointValue];
        CGPathMoveToPoint(path, nil, p.x, p.y);
        for (int i = 1; i < points.count; i++) {
            p = [(NSValue *)[points objectAtIndex:i] CGPointValue];
            CGPathAddLineToPoint(path, nil, p.x, p.y);
        }
    }
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPathWithCGPath:path];
    
    return bezierPath;
}

@end
