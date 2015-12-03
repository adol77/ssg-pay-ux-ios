//
//  SLBSMapData.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBSMapTileData : NSObject<NSCoding>
@property NSString* name;
@property NSString* url;
@property int index;
@property int start_x;
@property int start_y;
@property int end_x;
@property int end_y;

+(instancetype)mapTileWithDictionary:(NSDictionary*)dictionary;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end

@interface SLBSMapData : NSObject <NSCoding>

@property int map_id;
@property double scale;
@property double angle;
@property int width_pixel;
@property int height_pixel;
@property double gps_lat;
@property double gps_lng;
@property int type;
@property NSArray* map_tile_list;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
