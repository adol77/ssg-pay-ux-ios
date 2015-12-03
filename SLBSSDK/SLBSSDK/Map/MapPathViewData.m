//
//  MapPathViewData.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 24..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "MapPathViewData.h"
#import <UIKit/UIKit.h>

@implementation MapPathViewData
@synthesize mapId, mapName, graphId, vertexId, vertexName, x, y;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if ( self = [super init] ) {
        mapId = [[dictionary objectForKey:@"map_id"] longValue];
        graphId = [[dictionary objectForKey:@"graph_id"] longValue];
        vertexId = [[dictionary objectForKey:@"vertex_id"] longValue];
        mapName = [dictionary objectForKey:@"map_name"];
        vertexName = [dictionary objectForKey:@"vertex_name"];
        x = [[dictionary objectForKey:@"x"] doubleValue];
        y = [[dictionary objectForKey:@"y"] doubleValue];
    }
    return self;
}

-(instancetype)initWithMapId:(long)_mapId mapName:(NSString*)_mapName graphId:(long)_graphId vertexId:(long)_vertexId vertexName:(NSString*)_vertexName x:(double)_x y:(double)_y {
    if ( self = [super init] ) {
        mapId = _mapId;
        mapName = _mapName;
        graphId = _graphId;
        vertexId = _vertexId;
        vertexName = _vertexName;
        x = _x;
        y = _y;
    }
    return self;
}

- (NSValue *)position {
    return [NSValue valueWithCGPoint:CGPointMake(self.x, self.y)];
}

@end
