//
//  MapInfo.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "SLBSMapData.h"

@implementation SLBSMapTileData
@synthesize name,url,index,start_x,start_y,end_x,end_y;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
	if ( self = [super init] ) {
		self.name = [dictionary objectForKey:@"name"];
		self.url = [dictionary objectForKey:@"url"];
	        self.index = [[dictionary objectForKey:@"index"] intValue];
		self.start_x = [[dictionary objectForKey:@"start_x"] intValue];
		self.start_y = [[dictionary objectForKey:@"start_y"] intValue];
		self.end_x = [[dictionary objectForKey:@"end_x"] intValue];
		self.end_y = [[dictionary objectForKey:@"end_y"] intValue];
	}
	return self;
}

+(instancetype)mapTileWithDictionary:(NSDictionary*)dictionary {
	return [[SLBSMapTileData alloc] initWithDictionary:dictionary];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:self.name forKey:@"name"];
	[aCoder encodeObject:self.url forKey:@"url"];
	[aCoder encodeInt:self.index forKey:@"index"];
	[aCoder encodeInt:self.start_x forKey:@"start_x"];
	[aCoder encodeInt:self.start_y forKey:@"start_y"];
	[aCoder encodeInt:self.end_x forKey:@"end_x"];
    [aCoder encodeInt:self.end_y forKey:@"end_y"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.index = [aDecoder decodeIntForKey:@"index"];
        self.start_x = [aDecoder decodeIntForKey:@"start_x"];
        self.start_y = [aDecoder decodeIntForKey:@"start_y"];
        self.end_x = [aDecoder decodeIntForKey:@"end_x"];
        self.end_y = [aDecoder decodeIntForKey:@"end_y"];
    }
    return self;
}

@end

@implementation SLBSMapData
@synthesize map_id, scale, angle, width_pixel, height_pixel, gps_lat, gps_lng, type, map_tile_list;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary
{
	if ( self = [super init] ) {
        self.map_id = [[dictionary objectForKey:@"map_id"] intValue];
		self.scale = [[dictionary objectForKey:@"scale"] doubleValue];
		self.angle = [[dictionary objectForKey:@"angle"] doubleValue];
		self.width_pixel = [[dictionary objectForKey:@"width_pixel"] intValue];
		self.height_pixel = [[dictionary objectForKey:@"height_pixel"] intValue];
		self.gps_lat = [[dictionary objectForKey:@"gps_lat"] doubleValue];
		self.gps_lng = [[dictionary objectForKey:@"gps_lng"] doubleValue];
		self.type = [[dictionary objectForKey:@"type"] intValue];
		NSArray* tileList = [dictionary objectForKey:@"map_tile_list"];
		NSMutableArray* tiles = [NSMutableArray array];
		for ( NSDictionary* tileDict in tileList ) {
			[tiles addObject:[SLBSMapTileData mapTileWithDictionary:tileDict]];
		}
		self.map_tile_list = [tiles copy];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:self.map_id forKey:@"map_id"];
	[aCoder encodeDouble:self.scale forKey:@"scale"];
	[aCoder encodeDouble:self.angle forKey:@"angle"];
	[aCoder encodeInt:self.width_pixel forKey:@"width_pixel"];
	[aCoder encodeInt:self.height_pixel forKey:@"height_pixel"];
	[aCoder encodeDouble:self.gps_lat forKey:@"gps_lat"];
	[aCoder encodeDouble:self.gps_lng forKey:@"gps_lng"];
	[aCoder encodeInt:self.type forKey:@"type"];
	[aCoder encodeObject:self.map_tile_list forKey:@"map_tile_list"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        self.map_id = [aDecoder decodeDoubleForKey:@"map_id"];
        self.scale = [aDecoder decodeDoubleForKey:@"scale"];
        self.angle = [aDecoder decodeDoubleForKey:@"angle"];
        self.width_pixel = [aDecoder decodeIntForKey:@"width_pixel"];
        self.height_pixel = [aDecoder decodeIntForKey:@"height_pixel"];
        self.gps_lat = [aDecoder decodeDoubleForKey:@"gps_lat"];
        self.gps_lng = [aDecoder decodeDoubleForKey:@"gps_lng"];
        self.type = [aDecoder decodeIntForKey:@"type"];
        self.map_tile_list  = [aDecoder decodeObjectForKey:@"map_tile_list "];
    }
	return self; 
}

@end
