//
//  MapManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SLBSKit.h"
#import "SLBSKitDefine.h"
#import "SLBSMapManager.h"
#import "Zone.h"
#import "ZoneCoord.h"
#import "MapImageCache.h"
#import "MapNet.h"
#import "ZoneCampaignDataManager.h"

@interface __ServiceReadyDelegate : NSObject<SLBSKitMapDelegate>
- (instancetype)initWithBlock:(void (^)(void))block;
- (void)onServiceReady;
@end

@implementation __ServiceReadyDelegate {
    void (^block)(void);
}

- (instancetype)initWithBlock:(void (^)(void))_block
{
    if ( self = [super init] ) {
        block = _block;
    }
    return self;
}

- (void)onServiceReady;
{
    if ( block != nil ) { block(); }
}
@end

@interface SLBSMapManager ()
- (void)buildViewMapData:(SLBSMapData*)mapData withId:(int)mapId block:(void (^)(SLBSMapViewData*))block;
- (SLBSMapViewZoneData*)convertZone:(Zone*)zone;
@end

@implementation SLBSMapManager  {
	BOOL running;
    MapImageCache* imageCache;
}

+ (SLBSMapManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static SLBSMapManager *sharedSLBSMapManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedSLBSMapManager = [[SLBSMapManager alloc] init];
    });
    return sharedSLBSMapManager;
}

- (instancetype)init {
	if ( self = [super init] ) {
        imageCache = [[MapImageCache alloc] init];
	}
    
    return self;
}



- (void)startMonitoring:(void (^)(void))block
{
	if ( running ) return;
	running = YES;
	
    [SLBSKit sharedInstance].mapDelegate = [[__ServiceReadyDelegate alloc] initWithBlock:block];
    [[SLBSKit sharedInstance] startService:SLBSServiceMap];

}


- (void)stopMonitoring
{
	if ( !running ) return;
    [[SLBSKit sharedInstance] stopService];
	running = NO;
}
- (UIImage*)loadMapImage:(NSString*)imageUrl
{
    UIImage* cached = [imageCache imageForKey:imageUrl];
    if ( cached != nil ) return cached;
    
    NSURL  *url = [NSURL URLWithString:imageUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData == nil ) return nil;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachePath = [documentsDirectory stringByAppendingPathComponent:[[NSUUID new] UUIDString]];
    
    if ( ![urlData writeToFile:cachePath atomically:YES] ) {
        return nil;
    }
    
    [imageCache addCache:cachePath forKey:imageUrl];
    UIImage* image = [imageCache imageForKey:imageUrl];
    
    return image;
}

static BOOL isVisibleZone(Zone* zone)
{
    return zone.type.intValue != 1; // basic type이 아니면 보여주는 것으로.. 확정된 것은 아님.
}
static NSString* getZoneName(Zone* zone)
{
    /*
    if ( zone.store_name != nil ) return zone.store_name;
    else if (zone.name != nil) return zone.name;
    else return [[NSString alloc] init];
     */
    return zone.name;
}

- (SLBSMapViewZoneData*)convertZone:(Zone*)zone
{
    if ( !isVisibleZone(zone) ) return nil;
    SLBSMapViewZoneData* ret = [[SLBSMapViewZoneData alloc] init];
    if ( !ret ) return nil;
    
    ret.zoneID = zone.zone_id;
    ret.name = getZoneName(zone);
    
    
    if ( zone.coords != nil ) {
        ret.type = TSSLBSMapZoneTypePolygon;
    }
    else {
        ret.type = TSSLBSMapZoneTypePOIImage;
    }
    
    CGPoint center;
    center.x = (float)zone.center_x;
    center.y = (float)zone.center_y;
//    ret.currentCenter = center;
    ret.currentCenter = CGPointMake(zone.title_center_x, zone.title_center_y);//edit by mhlee 2015.10.23
    
    NSMutableArray* polygons = [NSMutableArray array];
    NSArray* coords = zone.coords;
    
    for(ZoneCoord* c in coords) {
        double x = c.x;
        double y = c.y;
//        int index = c.order;
        
        id p = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [polygons addObject:p];
    }
    
    ret.polygons = polygons;

//#define NEMUS_EXTERNAL 1
#ifdef NEMUS_EXTERNAL
    if(zone.icon_url != nil && zone.icon_url.length > 0) {
        NSString* newUrl = [zone.icon_url stringByReplacingOccurrencesOfString:@"http://192.168.3.145/" withString:@"http://115.71.237.123:7008/"];
         ret.icon = [self loadMapImage:newUrl];
        ret.name = nil;
    }
#else
    if(zone.icon_url != nil && zone.icon_url.length > 0) {
        ret.icon = [self loadMapImage:[NSString stringWithFormat:@"http://%@%@", SERVER_IP, zone.icon_url]];
        ret.name = nil;
    }
#endif
    
    /*if ( ret.icon == nil ) {
        if ( defaultIcon == nil ) {
            defaultIcon = [self loadMapImage:DEFAULT_ICON_URL];
        }
        //ret.icon = defaultIcon;
    }*/
    
    if ( zone.tenant_bi != nil && zone.tenant_bi.length > 0 ) {
        NSString* strBIImage = [NSString stringWithFormat:@"http://%@%@", SERVER_IP, zone.tenant_bi];
        ret.storeBI = [self loadMapImage:strBIImage];
        ret.name = nil;
    }
    else {
        ret.storeBI = nil;
    }
    
    CGRect title_rect;
    title_rect.origin.x = zone.title_left_top_x;
    title_rect.origin.y = zone.title_left_top_y;
    title_rect.size.width = zone.title_right_bottom_x - zone.title_left_top_x;
    title_rect.size.height = zone.title_right_bottom_y - zone.title_left_top_y;
    ret.visibleFrame = title_rect;
    ret.titleCenter = CGPointMake(zone.title_center_x, zone.title_center_y);
    ret.angle = zone.title_angle;
    
//    BOOL containedCampaign = NO;
//    NSArray* campArr = [[ZoneCampaignDataManager sharedInstance] zoneCampaignsWithZoneID:zone.zone_id];
//    if ( campArr != nil && campArr.count > 0) containedCampaign = YES;
    ret.containedCampaign = [zone.campaign_count boolValue];
    
    return ret;
}

-(void)buildViewMapData:(SLBSMapData*)mapData withId:(int)mapId block:(void (^)(SLBSMapViewData*))block
{
    if ( mapData == nil || mapData.map_tile_list == nil || mapData.map_tile_list.count == 0) {
        block(nil);
        return;
    }
    
    [[MapDataManager sharedInstance] mapGetZoneList:mapId block:^(NSArray* zoneList){
        NSUInteger zoneCount = zoneList.count;
        
        NSMutableArray* viewZoneList = [NSMutableArray arrayWithCapacity:zoneCount];
        for ( int i = 0 ; i < zoneCount ; i++ ) {
            
            SLBSMapViewZoneData* viewZoneData = [self convertZone:zoneList[i]];
            if ( viewZoneData == nil ) continue;
            
            [viewZoneList addObject:viewZoneData];
            if ( viewZoneData.type != TSSLBSMapZoneTypePOIImage && viewZoneData.icon != nil ) {
                SLBSMapViewZoneData* iconZoneData = [viewZoneData copy];
                iconZoneData.type = TSSLBSMapZoneTypePOIImage;
                [viewZoneList addObject:iconZoneData];
            }
        }
        
        SLBSMapTileData* tile = mapData.map_tile_list[0];
        
        
        SLBSMapViewData* vd = [[SLBSMapViewData alloc] init];
        vd.ID = [NSNumber numberWithInt:mapId];
        
#ifdef NEMUS_EXTERNAL
        NSString* newUrl = [tile.url stringByReplacingOccurrencesOfString:@"http://192.168.3.145/" withString:@"http://115.71.237.123:7008/"];
        
        vd.image = [self loadMapImage:newUrl];
#else
        vd.image = [self loadMapImage:[NSString stringWithFormat:@"http://%@%@", SERVER_IP, tile.url]];
#endif
        vd.zoneList = [viewZoneList copy];
        
        block(vd);
    }];
}


- (void)loadMapData:(long)mapId delegate:(id<SLBSMapManagerDelegate>)delegate
{
    if ( delegate == nil ) return;
    
    [[MapDataManager sharedInstance] loadMapInfo:(int)mapId token:@"asdf" block:^(SLBSMapData* mapInfo) {
        [delegate mapManager:self onMapInfo:mapInfo];
        
        [self buildViewMapData:mapInfo withId:(int)mapId block:^(SLBSMapViewData* mapData){
            if ( mapData ) {
                [delegate mapManager:self onMapReady:mapData];
            }
            else {
                [delegate mapManager:self onMapReady:nil];
            }
        }];
    }];
}



- (void)findPath:(long)startMapId startX:(double)startX startY:(double)startY endMapId:(long)endMapId endX:(double)endX endY:(double)endY delegate:(id<SLBSPathFindListener>)delegate
{
    if ( delegate == nil ) return;
    
    [MapNet findPath:@"asdf" startMapId:startMapId startX:startX startY:startY endMapId:endMapId endX:endX endY:endY
        block:^(NSArray *response) {
            if ( response != nil ) {
                [delegate onPathFindSuccess:response];
            }
            else {
                [delegate onPathFindFail];
            }
        }];
}

- (void)getZoneList:(int)mapId block:(void (^)(NSArray*))block
{
    if ( block == nil ) return;
    if ( mapId <= 0 ) [NSException raise:@"IllegalArgument" format:@"invalid mapId"];
    
    [[MapDataManager sharedInstance] mapGetZoneList:mapId block:^(NSArray* zoneList){
        block(zoneList);
    }];
}


@end
