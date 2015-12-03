//
//  MapGraphInfo.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapGraphEdge : NSObject<NSCoding>
@property NSNumber* edge_id;
@property NSNumber* edge_weight;
@property NSNumber* start_vertex_id;
@property NSNumber* end_vertex_id;
@property NSNumber* edge_type;
@property NSString* edge_name;
@property NSString* edge_description;

+(instancetype)mapGraphEdgeWithDictionary:(NSDictionary*)dictionary;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end

@interface MapGraphVertex : NSObject<NSCoding>
@property NSNumber* vertex_id;
@property NSNumber* map_graph_id;
@property double coord_x;
@property double coord_y;
@property NSNumber* vertex_attr;
@property NSNumber* vertex_type;
@property NSNumber* vertex_section;
@property NSString* vertex_name;
@property NSString* vertex_description;

+(instancetype)mapGraphVertexWithDictionary:(NSDictionary*)dictionary;
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end

@interface MapGraphInfo : NSObject <NSCoding>
@property NSNumber* map_id;
@property NSArray *vertices;
@property NSArray *edges;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary withMap:(long)mapId;

@end