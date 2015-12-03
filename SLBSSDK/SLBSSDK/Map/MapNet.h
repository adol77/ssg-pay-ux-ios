#import <Foundation/Foundation.h>
#import "INNet.h"
#import "SLBSMapData.h"
#import "MapGraphInfo.h"
#import "MapPathViewData.h"

/**
 *  Map 관련 Network 담당 class
 */
@interface MapNet : INNet

@property SLBSMapData* mapInfo;
@property MapGraphInfo* graphInfo;
@property long mapId;
@property (readonly) NSArray* mapPathDataArray;

/**
 *  맵 데이터 조회
 *
 *  @param accessToken access token
 *  @param mapId       조회하고자 하는 Map ID
 *  @param block       block
 */

+(void)getMapData:(NSString*)accessToken mapId:(int)mapId block:(void (^)(SLBSMapData* response))block;

/**
 *  Simple 버젼의 맵 조회
 *
 *  @param accessToken access token
 *  @param mapId       조회하고자 하는 Map ID
 *  @param block       block
 */
+(void)getMap:(NSString*)accessToken mapId:(int)mapId block:(void (^)(SLBSMapData* response))block;

/**
 *  Map Tile 조회
 *
 *  @param accessToken access token
 *  @param mapId       조회하고자 하는 Map ID
 *  @param block       block
 */
+(void)getMapTile:(NSString*)accessToken mapId:(int)mapId block:(void (^)(NSArray* response))block;

/**
 *  Map Grahph 조회
 *
 *  @param accessToken access token
 *  @param graphId       조회하고자 하는 MapGraph ID
 *  @param block       block
 */
+(void)getMapGraph:(NSString*)accessToken graphId:(int)graphId block:(void (^)(MapGraphInfo* response))block;

/**
 *  Graph Data - vertex, edge 조회
 *
 *  @param accessToken access token
 *  @param mapId       조회하고자 하는 Map ID
 *  @param block       block
 */
+(void)getMapGraphData:(NSString*)accessToken mapId:(int)mapId block:(void (^)(MapGraphInfo* response))block;

/**
 *  Graph Data 조회
 *
 *  @param accessToken access token
 *  @param startMapId  path 시작점의 map ID
 *  @param startx      시작점의 x 좌표
 *  @param startY      시작점의 y 좌표
 *  @param endMapId    path 도착점의 map ID
 *  @param endX        도착점의 x 좌표
 *  @param endY        도착점의 y 좌표
 *  @param block       block
 */
+(void)findPath:(NSString*)accessToken startMapId:(long)startMapId startX:(double)startx startY:(double)startY endMapId:(long)endMapId endX:(double)endX endY:(double)endY block:(void (^)(NSArray* response))block;
@end
