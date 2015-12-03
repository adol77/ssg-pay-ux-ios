#import "MapNet.h"

/**
 Map 관련 Rest API 담당
 */
@implementation MapNet

@synthesize mapInfo;
@synthesize graphInfo;
@synthesize mapPathDataArray;

const NSString *mapApiVersion         = @"/v1";
const NSString *mapApiGroup           = @"/mms";

typedef NS_ENUM(NSInteger, tagMapNetRAPI) {
    tagMapNetRAPIMap,
    tagMapNetRAPIMapData,
    tagMapNetRAPIMapTile,
    tagMapNetRAPIMapGraph,
    tagMapNetRAPIMapGraphData,
    tagMapNetRAPIMapGraphVertex,
    tagMapNetRAPIMapGraphEdge,
    tagMapNetRAPIMapFindPath,
};


- (instancetype)initWithAccessToken:(NSString *)token {
    self = [super init];
    if (self) {
        if ([token length] > 0) {
            [self setHeaderField:@"access_token" value:token];
        }
    }
    return self;
}

-(BOOL)processResponseData:(id)responseObject dataType:(TSNetDataType)type {
    if ( type == TSNetDataDictionary ) {
        NSDictionary *rootObject = responseObject;//[responseObject objectForKey:kReturnRootKey];
        
        assert([rootObject isKindOfClass:[NSDictionary class]]);
        
        switch (self.tag) {
            case tagMapNetRAPIMap:
            case tagMapNetRAPIMapData: {
                SLBSMapData* map = [[SLBSMapData alloc] initWithDictionary:rootObject];
                if (map) {
                    self.mapInfo = map;
                    return YES;
                }
                else
                    return NO;
            } break;
            case tagMapNetRAPIMapGraphData: {
                MapGraphInfo* mapGraphInfo = [[MapGraphInfo alloc] initWithDictionary:rootObject withMap:self.mapId];
                if (mapGraphInfo) {
                    self.graphInfo = mapGraphInfo;
                    return YES;
                }
                else
                    return NO;
            }
            default:
                return NO;
                break;
        }
    } else if ( type == TSNetDataArray ) {
        NSArray *rootObject = responseObject;
        switch (self.tag) {
            case tagMapNetRAPIMapFindPath: {
                NSMutableArray* tmpArray = [NSMutableArray array];
                for ( NSDictionary* d in rootObject ) {
                    MapPathViewData* pd = [[MapPathViewData alloc] initWithDictionary:d];
                    [tmpArray addObject:pd];
                }
                mapPathDataArray = [tmpArray copy];
                return YES;
            }
            default:
                return NO;
                break;
        }
        
    }
    return YES;
}

/** 맵 데이터 조회
 * 맵 데이터 조회
 */
+(void)getMapData:(NSString*)accessToken mapId:(int)mapId block:(void (^)(SLBSMapData* response))block
{
    MapNet *net = [[MapNet alloc] initWithAccessToken:accessToken];
    [net setTag:tagMapNetRAPIMapData];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", mapApiVersion, mapApiGroup, @"/map_data.do"] URL:[NSString stringWithFormat:@"?map_id=%d", mapId]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if ( success ) {
            MapNet* net = (MapNet*)(netObject);
            block(net.mapInfo);
        }
        else {
            block(nil);
        }
    }];
}

/** 맵조회(Simple)
 * 맵조회. 그러나 graph 정보는 오지 않는다.
 */
+(void)getMap:(NSString*)accessToken mapId:(int)mapId block:(void (^)(SLBSMapData* response))block
{
    MapNet *net = [[MapNet alloc] initWithAccessToken:accessToken];
    [net setTag:tagMapNetRAPIMap];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", mapApiVersion, mapApiGroup, @"/map.do"] URL:[NSString stringWithFormat:@"?map_id=%d", mapId]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        block(net.mapInfo);
    }];
}

/** Map Tile 조회
 * Map Tile 조회
 */
+(void)getMapTile:(NSString*)accessToken mapId:(int)mapId block:(void (^)(NSArray* response))block
{
    MapNet *net = [[MapNet alloc] initWithAccessToken:accessToken];
    [net setTag:tagMapNetRAPIMapTile];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", mapApiVersion, mapApiGroup, @"/map_tile.do"] URL:[NSString stringWithFormat:@"?map_id=%d", mapId]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        // TODO
    }];
}

/** Graph조회
 * Graph조회
 */
+(void)getMapGraph:(NSString*)accessToken graphId:(int)graphId block:(void (^)(MapGraphInfo* response))block
{
    MapNet *net = [[MapNet alloc] initWithAccessToken:accessToken];
    [net setTag:tagMapNetRAPIMapGraph];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", mapApiVersion, mapApiGroup, @"/map_graph.do"] URL:[NSString stringWithFormat:@"?graph_id=%d", graphId]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        // TODO
        block(net.graphInfo);
    }];
}

+(void)getMapGraphData:(NSString*)accessToken mapId:(int)mapId block:(void (^)(MapGraphInfo* response))block
{
    MapNet *net = [[MapNet alloc] initWithAccessToken:accessToken];
    net.mapId = mapId;
    [net setTag:tagMapNetRAPIMapGraphData];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", mapApiVersion, mapApiGroup, @"/map_graph_data.do"] URL:[NSString stringWithFormat:@"?map_id=%d", mapId]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        // TODO
        block(net.graphInfo);
    }];
}




+(void)findPath:(NSString*)accessToken startMapId:(long)startMapId startX:(double)startX startY:(double)startY endMapId:(long)endMapId endX:(double)endX endY:(double)endY block:(void (^)(NSArray* response))block
{
    MapNet *net = [[MapNet alloc] initWithAccessToken:accessToken];
    [net setTag:tagMapNetRAPIMapFindPath];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", mapApiVersion, mapApiGroup, @"/path_find_by_coords.do"] URL:[NSString stringWithFormat:@"?start_map_id=%ld&start_x=%f&start_y=%f&end_map_id=%ld&end_x=%f&end_y=%f", startMapId, startX, startY, endMapId, endX, endY]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if ( success ) {
            block(net.mapPathDataArray);
        }
        else {
            block(nil);
        }
    }];
    
}



@end
