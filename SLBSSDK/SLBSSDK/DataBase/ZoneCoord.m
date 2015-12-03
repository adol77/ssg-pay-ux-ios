//
//  ZoneCoord.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "ZoneCoord.h"

@interface ZoneCoord ()
@property (nonatomic, assign) double x;
@property (nonatomic, assign) double y;
@property (nonatomic, assign) NSNumber* zone_id;
@property (nonatomic, assign) NSNumber* order;
@property (nonatomic, assign) NSNumber* coord_id;
@end
@implementation ZoneCoord

+ (ZoneCoord*)zoneCoordWithDictionary:(NSDictionary*)source {
    return [[ZoneCoord alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.x = [[source objectForKey:@"coord_x"] doubleValue];
        self.y = [[source objectForKey:@"coord_y"] doubleValue];
        self.zone_id = [source objectForKey:@"zone_id"];
        self.order = [source objectForKey:@"coord_order"];
        self.coord_id = [source objectForKey:@"id"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.x = [[aDecoder decodeObjectForKey:@"coord_x"] doubleValue];
        self.y = [[aDecoder decodeObjectForKey:@"coord_y"] doubleValue];
        self.zone_id = [aDecoder decodeObjectForKey:@"zone_id"];
        self.order = [aDecoder decodeObjectForKey:@"coord_order"];
        self.coord_id = [aDecoder decodeObjectForKey:@"coord_id"];
    }
    
    return self;

}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithDouble:self.x] forKey:@"coord_x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.y] forKey:@"coord_y"];
    [aCoder encodeObject:self.zone_id forKey:@"zone_id"];
    [aCoder encodeObject:self.order forKey:@"coord_order"];
    [aCoder encodeObject:self.coord_id forKey:@"coord_id"];

}
@end
