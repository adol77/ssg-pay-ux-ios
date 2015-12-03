//
//  MapDataManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapDataManager.h"
#import "MapNet.h"
#import "SLBSMapData.h"
#import "ZoneDataManager.h"
#import "ZoneNet.h"
#import "DeviceManager.h"

@interface MapDataManager()
- (void)saveMapInfoTable;
- (void)clearMapInfoTable;
- (void)loadMapInfoTable;
- (void)addMapInfoToLocal:(SLBSMapData*)map mapId:(int)mapId;
@end

@implementation MapDataManager {
	NSMutableDictionary* mapTable;
}

+ (MapDataManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static MapDataManager *sharedMapDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedMapDataManager = [[MapDataManager alloc] init];
    });
    return sharedMapDataManager;
}

#pragma Local DB

- (instancetype)init
{
	if ( self = [super init] ) {
		[self loadMapInfoTable];
	}
	return self;
}

- (void)saveMapInfoTable
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSData* raw = [NSKeyedArchiver archivedDataWithRootObject:mapTable];
	[defaults setObject:raw forKey:@"maps"];
}

- (void)clearMapInfoTable
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:@"maps"];
	mapTable = [NSMutableDictionary dictionary];
}

-(void)loadMapInfoTable
{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSData* raw = [defaults objectForKey:@"maps"];
    if ( raw ) {
        @try {
            mapTable = (NSMutableDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:raw];
        }
        @catch(NSException* e) {
            [self clearMapInfoTable];
        }
    }
    else {
        // if we don't have any saved table, just create one.
        mapTable = [NSMutableDictionary dictionary];
    }
}

- (void)addMapInfoToLocal:(SLBSMapData*)map mapId:(int)mapId
{
    NSNumber* key = [NSNumber numberWithInt:mapId];
	[mapTable setObject:map forKey:key];
	[self saveMapInfoTable];
}

// 로컬 cache에서 지도 정보를 가져옴.
- (SLBSMapData*)mapInfoFromLocal:(int)mapId
{
    NSNumber* key = [NSNumber numberWithInt:mapId];
	SLBSMapData* obj = (SLBSMapData*)[mapTable objectForKey:key];
    return obj;
}


#pragma Network
// 서버에서 지도 정보를 가져옴.
- (void)fetchMapInfo:(int)mapId token:(NSString*)accessToken block:(void(^)(SLBSMapData*))block
{
	[MapNet getMapData:@"asdf" mapId:mapId block:^(SLBSMapData* response) {
			if ( response != nil ) {
                response.map_id = mapId;
				[self addMapInfoToLocal:response mapId:mapId];
                block(response);
			}
		}];
}



// 로컬 cache에서 지도 정보를 확인해 보고 없으면 서버에서 가져옴. 응답은 delegate로.
- (void)loadMapInfo:(int)mapId token:(NSString*)accessToken block:(void(^)(SLBSMapData*))block
{
    SLBSMapData* mapData = [self mapInfoFromLocal:mapId];
	if ( mapData == nil ) {
        [self fetchMapInfo:mapId token:accessToken block:block];
        return;
	}

    if (mapData == nil ) {
        block(nil);
        return;
    }
    
    block(mapData);
}

- (NSArray*)mapGetZoneList:(int)mapId
{
    return [[ZoneDataManager sharedInstance] zonesForMap:mapId];
}

- (void)mapGetZoneList:(int)mapId block:(void (^)(NSArray*))block
{
    ZoneDataManager* zdm = [ZoneDataManager sharedInstance];
    NSArray* zoneListFromCache = [zdm zonesForMap:mapId];
    if ( zoneListFromCache ) {
        block(zoneListFromCache);
        return;
    }
    else {
        NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
        
        [ZoneNet requestZoneListWithMapID:[NSNumber numberWithInt:mapId] accessToken:accessToken block:^(ZoneNet *netObj) {
            NSArray* zoneList = netObj.zoneList;
            block(zoneList);
        }];
    }
}

#pragma MapGraphInfo
- (void)setMapGraphInfos:(NSArray*)mapGraphInfos{
    if (mapGraphInfos) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"map_graph_infos"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:mapGraphInfos];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"map_graph_infos"];
        
        self.mapGraphInfoList = [NSArray arrayWithArray:mapGraphInfos];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"map_graph_infos"];
        
        self.mapGraphInfoList = nil;
    }
}

- (NSArray*)mapGraphInfos {
    if(self.mapGraphInfoList)
        return self.mapGraphInfoList;
    
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"map_graph_infos"];
    if (raw) {
        //return [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        self.mapGraphInfoList = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return self.mapGraphInfoList;
    }
    return nil;
}

#pragma MapData
- (void)setMapDatas:(NSArray*)mapDatas{
    if (mapDatas) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"maps"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:mapDatas];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"maps"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"maps"];
    }
}

- (NSArray*)mapDatas {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"maps"];
    if (raw) {
        NSArray* ret = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return ret;
    }
    return nil;
}
@end
