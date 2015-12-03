//
//  BLERoadSource.m
//  SLBSSDK
//
//  Created by Kim Heedong on 2015. 9. 25..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "BLERoadSource.h"
#import "MapDataManager.h"
#import "MapGraphInfo.h"
#import "LOCCoordinate.h"
#import "LOCLineSegment.h"

@implementation BLERoadSource {
    long mapId;
    NSMutableArray* segments;
}

-(instancetype)init
{
    if ( self = [super init] ) {
        mapId = -1;
    }
    return self;
}

-(BOOL)update:(long)_mapId
{
    NSArray* graphs = [[MapDataManager sharedInstance] mapGraphInfos];
    MapGraphInfo* graph = nil;
    for( MapGraphInfo* g in graphs) {
        if ( [g.map_id longValue]== _mapId ) {
            graph = g;
            break;
        }
    }
    if ( graph == nil ) return NO;
    
    NSMutableDictionary* vertexMap = [NSMutableDictionary dictionary];
    for ( MapGraphVertex* v in graph.vertices ) {
        LOCCoordinate* c = [[LOCCoordinate alloc] initWithMap:(int)_mapId X:v.coord_x Y:v.coord_y];
        [vertexMap setObject:c forKey:v.vertex_id];
    }
    
    segments = [NSMutableArray array];
    for ( MapGraphEdge* e in graph.edges ) {
        LOCCoordinate* cs = [vertexMap objectForKey:e.start_vertex_id];
        LOCCoordinate* ce = [vertexMap objectForKey:e.end_vertex_id];
        if ( cs == nil || ce == nil ) continue;
        
        [segments addObject:[[LOCLineSegment alloc] initWithStart:cs End:ce]];
    }
    
    return YES;
}

-(int)count:(long)_mapId
{
    if ( mapId != _mapId ) {
        if ( ![self update:_mapId] ) return 0;
    }
    return (int)[segments count];
}

-(NSArray*)roadsInMap:(int)_mapId
{
    if ( mapId != _mapId ) {
        if ( ![self update:_mapId] ) return 0;
    }
    return segments;
}

@end
