//
//  MapGraphInfo.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapGraphInfo.h"

@implementation MapGraphEdge

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.edge_id = [aDecoder decodeObjectForKey:@"edge_id"];
        self.edge_weight = [aDecoder decodeObjectForKey:@"edge_weight"];
        self.start_vertex_id = [aDecoder decodeObjectForKey:@"start_vertex_id"];
        self.end_vertex_id = [aDecoder decodeObjectForKey:@"end_vertex_id"];
        self.edge_type = [aDecoder decodeObjectForKey:@"edge_type"];
        self.edge_name = [aDecoder decodeObjectForKey:@"edge_name"];
        self.edge_description = [aDecoder decodeObjectForKey:@"edge_description"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.edge_id forKey:@"edge_id"];
    [aCoder encodeObject:self.edge_weight forKey:@"edge_weight"];
    [aCoder encodeObject:self.start_vertex_id forKey:@"start_vertex_id"];
    [aCoder encodeObject:self.end_vertex_id forKey:@"end_vertex_id"];
    [aCoder encodeObject:self.edge_type forKey:@"edge_type"];
    [aCoder encodeObject:self.edge_name forKey:@"edge_name"];
    [aCoder encodeObject:self.edge_description forKey:@"edge_description"];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.edge_id = [dictionary objectForKey:@"id"];
        self.edge_weight = [dictionary objectForKey:@"weight"];
        self.start_vertex_id = [dictionary objectForKey:@"start_vertex_id"];
        self.end_vertex_id = [dictionary objectForKey:@"end_vertex_id"];
        self.edge_type = [dictionary objectForKey:@"type"];
        self.edge_name = [dictionary objectForKey:@"name"];
        self.edge_description = [dictionary objectForKey:@"description"];
        
    }
    return self;
}

+(instancetype)mapGraphEdgeWithDictionary:(NSDictionary*)dictionary {
    return [[MapGraphEdge alloc] initWithDictionary:dictionary];
}

@end

@implementation MapGraphVertex
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.vertex_id = [aDecoder decodeObjectForKey:@"id"];
        self.map_graph_id = [aDecoder decodeObjectForKey:@"map_graph_id"];
        self.coord_x = [[aDecoder decodeObjectForKey:@"coord_x"] doubleValue];
        self.coord_y = [[aDecoder decodeObjectForKey:@"coord_y"] doubleValue];
        self.vertex_attr = [aDecoder decodeObjectForKey:@"attr"];
        self.vertex_type = [aDecoder decodeObjectForKey:@"type"];
        self.vertex_section = [aDecoder decodeObjectForKey:@"section"];
        self.vertex_name = [aDecoder decodeObjectForKey:@"name"];
        self.vertex_description = [aDecoder decodeObjectForKey:@"description"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.vertex_id forKey:@"id"];
    [aCoder encodeObject:self.map_graph_id forKey:@"map_graph_id"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.coord_x] forKey:@"coord_x"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.coord_y] forKey:@"coord_y"];
    [aCoder encodeObject:self.vertex_attr forKey:@"attr"];
    [aCoder encodeObject:self.vertex_type forKey:@"type"];
    [aCoder encodeObject:self.vertex_section forKey:@"section"];
    [aCoder encodeObject:self.vertex_name forKey:@"name"];
    [aCoder encodeObject:self.vertex_description forKey:@"description"];

}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.vertex_id = [dictionary objectForKey:@"id"];
        self.map_graph_id = [dictionary objectForKey:@"map_graph_id"];
        self.coord_x = [[dictionary objectForKey:@"coord_x"] doubleValue];
        self.coord_y = [[dictionary objectForKey:@"coord_y"] doubleValue];
        self.vertex_attr = [dictionary objectForKey:@"attr"];
        self.vertex_type = [dictionary objectForKey:@"type"];
        self.vertex_section = [dictionary objectForKey:@"section"];
        self.vertex_name = [dictionary objectForKey:@"name"];
        self.vertex_description = [dictionary objectForKey:@"description"];
        
    }
    return self;
}

+(instancetype)mapGraphVertexWithDictionary:(NSDictionary *)dictionary {
    return [[MapGraphVertex alloc] initWithDictionary:dictionary];
}

@end


@implementation MapGraphInfo
@synthesize map_id, vertices, edges;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withMap:(long)mapId {
    self = [super init];
    if(self) {
        self.map_id = [NSNumber numberWithInt:(int)mapId];
       	NSArray* vertexList = [dictionary objectForKey:@"map_graph_vertex_list"];
        NSMutableArray* tempVertexList = [NSMutableArray array];
        for ( NSDictionary* vertexDict in vertexList ) {
            [tempVertexList addObject:[MapGraphVertex mapGraphVertexWithDictionary:vertexDict]];
        }
        self.vertices = [tempVertexList copy];
        
        NSArray* edgeList = [dictionary objectForKey:@"map_graph_edge_list"];
        NSMutableArray* tempEdgeList = [NSMutableArray array];
        for ( NSDictionary* edgeDict in edgeList ) {
            [tempEdgeList addObject:[MapGraphEdge mapGraphEdgeWithDictionary:edgeDict]];
        }
        self.edges = [tempEdgeList copy];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.map_id = [aDecoder decodeObjectForKey:@"map_id"];
        self.vertices = [aDecoder decodeObjectForKey:@"vertices"];
        self.edges = [aDecoder decodeObjectForKey:@"edges"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.map_id forKey:@"map_id"];
    [aCoder encodeObject:self.vertices forKey:@"vertices"];
    [aCoder encodeObject:self.edges forKey:@"edges"];

}


@end
