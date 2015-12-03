//
//  Beacon.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon.h"

@interface Beacon()
@property (nonatomic, assign) NSNumber* beacon_id;
@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, assign) NSNumber* major;
@property (nonatomic, assign) NSNumber* minor;
@property (nonatomic, assign) NSNumber* type;
@property (nonatomic, strong) NSString* txpower;
@property (nonatomic, assign) NSString* serial_number;
@property (nonatomic, assign) NSString* mac_address;
@property (nonatomic, assign) NSNumber* broadcast_freq;
@property (nonatomic, strong) NSString* image_url;
@property (nonatomic, assign) NSNumber *validity;
@property (nonatomic, strong) NSString *beacon_description;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, assign) NSNumber* loc_company_id;
@property (nonatomic, assign) NSNumber* loc_id;
@property (nonatomic, assign) NSNumber* loc_floor_id;
@property (nonatomic, strong) NSString* loc_description;
@property (nonatomic, assign) NSNumber* loc_validity;
@property (nonatomic, assign) NSNumber* loc_branch_id;
@property (nonatomic, assign) double loc_x;
@property (nonatomic, assign) double loc_y;
@property (nonatomic, assign) NSNumber* loc_map_id;

@property (nonatomic, assign) NSNumber* status_humidity;
@property (nonatomic, assign) NSNumber* status_validity;
@property (nonatomic, assign) NSNumber* status_battery;
@property (nonatomic, assign) NSNumber* status_illumination;
@property (nonatomic, assign) NSNumber* status_temperature;

@end


@implementation Beacon

+ (Beacon*)beaconWithDictionary:(NSDictionary*)source {
    return [[Beacon alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.beacon_id = [source objectForKey:@"id"];
        self.uuid = [source objectForKey:@"uuid"];
        self.major = [source objectForKey:@"major"];
        self.minor = [source objectForKey:@"minor"];
        self.type = [source objectForKey:@"type"];
        self.serial_number = [source objectForKey:@"serial_number"];
        self.mac_address = [source objectForKey:@"mac_address"];
        self.broadcast_freq = [source objectForKey:@"broadcast_freq"];
        self.image_url = [source objectForKey:@"image_url"];
        self.validity = [source objectForKey:@"validity"];
        self.beacon_description = [source objectForKey:@"description"];
        self.name = [source objectForKey:@"name"];

        NSDictionary* locDic = [source objectForKey:@"beacon_loc"];
        self.loc_company_id = [locDic objectForKey:@"company_id"];
        self.loc_id = [locDic objectForKey:@"id"];
        self.loc_floor_id = [locDic objectForKey:@"floor_id"];
        self.loc_description = [locDic objectForKey:@"description"];
        self.loc_validity = [locDic objectForKey:@"validity"];
        self.loc_branch_id = [locDic objectForKey:@"branch_id"];
        self.loc_x = [[locDic objectForKey:@"coord_x"] doubleValue];
        self.loc_y = [[locDic objectForKey:@"coord_y"] doubleValue];
        self.loc_map_id = [locDic objectForKey:@"map_id"];
        
        NSDictionary* statusDic = [source objectForKey:@"beacon_status"];
        self.status_humidity = [statusDic objectForKey:@"humidity"];
        self.status_validity = [statusDic objectForKey:@"validity"];
        self.status_battery = [statusDic objectForKey:@"battery"];
        self.status_illumination = [statusDic objectForKey:@"illumination"];
        self.status_temperature = [statusDic objectForKey:@"temperature"];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.beacon_id = [aDecoder decodeObjectForKey:@"id"];
        self.uuid = [aDecoder decodeObjectForKey:@"uuid"];
        self.major = [aDecoder decodeObjectForKey:@"major"];
        self.minor = [aDecoder decodeObjectForKey:@"minor"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.serial_number = [aDecoder decodeObjectForKey:@"serial_number"];
        self.mac_address = [aDecoder decodeObjectForKey:@"mac_address"];
        self.broadcast_freq = [aDecoder decodeObjectForKey:@"broadcast_freq"];
        self.image_url = [aDecoder decodeObjectForKey:@"image_url"];
        self.validity = [aDecoder decodeObjectForKey:@"validity"];
        self.beacon_description = [aDecoder decodeObjectForKey:@"description"];
        self.name = [aDecoder decodeObjectForKey:@"name"];

        self.loc_company_id = [aDecoder decodeObjectForKey:@"loc_company_id"];
        self.loc_id = [aDecoder decodeObjectForKey:@"loc_id"];
        self.loc_floor_id = [aDecoder decodeObjectForKey:@"loc_floor_id"];
        self.loc_description = [aDecoder decodeObjectForKey:@"loc_description"];
        self.loc_validity = [aDecoder decodeObjectForKey:@"loc_validity"];
        self.loc_branch_id = [aDecoder decodeObjectForKey:@"loc_branch_id"];
        self.loc_x = [[aDecoder decodeObjectForKey:@"loc_x"] doubleValue];
        self.loc_y = [[aDecoder decodeObjectForKey:@"loc_y"] doubleValue];
        self.loc_map_id = [aDecoder decodeObjectForKey:@"loc_map_id"];
        
        self.status_humidity = [aDecoder decodeObjectForKey:@"status_humidity"];
        self.status_validity = [aDecoder decodeObjectForKey:@"status_validity"];
        self.status_battery = [aDecoder decodeObjectForKey:@"status_battery"];
        self.status_illumination = [aDecoder decodeObjectForKey:@"status_illumination"];
        self.status_temperature = [aDecoder decodeObjectForKey:@"status_temperature"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.beacon_id forKey:@"id"];
    [aCoder encodeObject:self.uuid forKey:@"uuid"];
    [aCoder encodeObject:self.major forKey:@"major"];
    [aCoder encodeObject:self.minor forKey:@"minor"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.serial_number forKey:@"serial_number"];
    [aCoder encodeObject:self.mac_address forKey:@"mac_address"];
    [aCoder encodeObject:self.broadcast_freq forKey:@"broadcast_freq"];
    [aCoder encodeObject:self.image_url forKey:@"image_url"];
    [aCoder encodeObject:self.validity forKey:@"validity"];
    [aCoder encodeObject:self.beacon_description forKey:@"description"];
    [aCoder encodeObject:self.name forKey:@"name"];
    
    [aCoder encodeObject:self.loc_company_id forKey:@"loc_company_id"];
    [aCoder encodeObject:self.loc_id forKey:@"loc_id"];
    [aCoder encodeObject:self.loc_floor_id forKey:@"loc_floor_id"];
    [aCoder encodeObject:self.loc_description forKey:@"loc_description"];
    [aCoder encodeObject:self.loc_validity forKey:@"loc_validity"];
    [aCoder encodeObject:self.loc_branch_id forKey:@"loc_branch_id"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.loc_x] forKey:@"loc_x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.loc_y] forKey:@"loc_y"];
    [aCoder encodeObject:self.loc_map_id forKey:@"loc_map_id"];
    
    [aCoder encodeObject:self.status_humidity forKey:@"status_humidity"];
    [aCoder encodeObject:self.status_validity forKey:@"status_validity"];
    [aCoder encodeObject:self.status_battery forKey:@"status_battery"];
    [aCoder encodeObject:self.status_illumination forKey:@"status_illumination"];
    [aCoder encodeObject:self.status_temperature forKey:@"status_temperature"];
}

@end