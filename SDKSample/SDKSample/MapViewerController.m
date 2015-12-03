//
//  MapViewerController.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/14/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "MapViewerController.h"
#import <SLBSSDK/SLBSMapViewController.h>

#import <SLBSSDK/SLBSMapManager.h>
#import <SLBSSDK/SLBSLocationManager.h>
#import <SLBSSDK/SLBSDataManager.h>
#import <SLBSSDK/TSDebugLogManager.h>
#import <SLBSSDK/MapPathViewData.h>
#import <SLBSSDK/SLBSBranch.h>

#import "AppDataManager.h"
#import "MapInfoProvider.h"

#import "AppDefine.h"
#import "Util.h"
#import "StorePopupView.h"

@interface MapViewerController () <SLBSMapViewControllerDelegate, SLBSMapManagerDelegate, SLBSPathFindListener, SLBSLocationManagerDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong) AppDataManager *appDataManager;
@property (nonatomic, strong) MapInfoProvider *mapInfoProvider;

@property (nonatomic, strong) SLBSCoordination *curLocation;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) SLBSMapViewController *mapViewCont;

@property (nonatomic, strong) StorePopupView *storePopupView;
@property (nonatomic, strong) UIView *campaignPopupBackView;

@property (nonatomic, strong) NSNumber *mapDirectionZoneId;

@property (nonatomic, assign) BOOL isLocationRunning;
@property (nonatomic, assign) BOOL selectedCurrentPosition;
@property (nonatomic, assign) BOOL currentPositionToCenter;
@property (nonatomic, assign) BOOL isMapLoading;

@property (nonatomic, assign) BOOL isLoadingMapForMovingStore;
@property (nonatomic, strong) Zone *movingZone;

@end

@implementation MapViewerController

- (instancetype)init:(MapInfoProvider*)mapInfoProvider parentView:(UIView*)parentView {
    self = [super init];
    if (self) {
        self.appDataManager = [AppDataManager sharedInstance];
        self.mapInfoProvider = mapInfoProvider;
        self.parentView = parentView;
     
        [self startMonitoring];
    }
    
    return self;
}

- (UIView*)createMapViewWithFrame:(CGRect)frame {
    NSDictionary *resource = @{kSLBSMapViewIconForDeparturePosition:[UIImage imageNamed:@"map_path_start_icon.png"],
                               kSLBSMapViewIconForDestination:[UIImage imageNamed:@"map_path_end_icon.png"],
                               kSLBSMapViewIconForPassage:[UIImage imageNamed:@"map_pass_icon.png"],
                               kSLBSMapViewIconForCurrentPosition:[UIImage imageNamed:@"map_here_icon.png"],
                               kSLBSMapViewIconForCampaignZone:[UIImage imageNamed:@"map_zone_campain_icon.png"],
                               kSLBSMapViewIconForDirection:[UIImage imageNamed:@"map_arrow_icon.png"]};
    
    self.mapViewCont = [[SLBSMapViewController alloc] initWithFrame:frame resource:resource];
    self.mapViewCont.delegate = self;
    
    return self.mapViewCont.mapViewControl;
}

- (void)currentPositionSelected:(BOOL)selected {
    if (selected) {
        self.currentPositionToCenter = YES;
    }
    
    self.selectedCurrentPosition = selected;
}

#pragma mark - SLBSMapViewDelegate

- (BOOL)controller:(SLBSMapViewController *)controller willSelectedZone:(NSNumber *)zoneID {
    if (self.appDataManager.zoneListArray!=nil) {
        for (int i=0; i<self.appDataManager.zoneListArray.count; i++) {
            Zone *zone = [self.appDataManager.zoneListArray objectAtIndex:i];
            if ([zone.zone_id intValue]==[zoneID intValue]) {
                if ([zone.type intValue]==ZONE_TYPE_STORE) {
                    [self showStorePopupWithZone:zone];
                } else if ([zone.type intValue]==ZONE_TYPE_POI) {
                    [self showAlertPopupWithZoneId:zone.zone_id tenantName:zone.name];
                }
                break;
            }
        }
    }
    
    return YES;
}

- (void)touchedMapViewWithController:(SLBSMapViewController *)controller {
    
}


#pragma mark - Store popup

- (void)showStorePopupWithZone:(Zone*)zone {
    if ([self.storePopupView superview]!=nil) {
        [self.storePopupView removeFromSuperview];
    }
    
    SLBSFloor *floor = [self.mapInfoProvider getFloorByMapId:[zone.map_id intValue]];
    
    self.storePopupView = [[StorePopupView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                           zone:zone floor:floor];
    [self.storePopupView.storeDirectButton addTarget:self
                                              action:@selector(storePopupMapDirectionClicked:)
                                    forControlEvents:UIControlEventTouchUpInside];
    [self.storePopupView.storeCloseButton addTarget:self
                                             action:@selector(storePopupCloseButtonClicked)
                                   forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.storePopupView];
}

- (void)storePopupMapDirectionClicked:(id)sender {
    UIButton *storeDirectionButton = (UIButton*)sender;
    NSNumber *zoneId = [NSNumber numberWithInt:(int)storeDirectionButton.tag];
    Zone *zone = [self.mapInfoProvider getZoneByZoneId:zoneId];

    // zone.name을 임시로 사용. 원래는 tenant_name이 맞음
    [self showAlertPopupWithZoneId:zoneId tenantName:zone.name];
//    [self showAlertPopupWithZoneId:zoneId tenantName:zone.tenant_name];
}

- (void)storePopupCloseButtonClicked {
    [self.storePopupView removeFromSuperview];
}

- (void)showAlertPopupWithZoneId:(NSNumber*)zoneId tenantName:(NSString*)tenantName {
    self.mapDirectionZoneId = zoneId;
    
    NSString *displayTenantName = tenantName;
    if (displayTenantName==nil || displayTenantName.length <= 0) {
        displayTenantName = @"매장";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@(으)로 길안내를 시작 하시겠습니까?", displayTenantName];
    [self showTwoButtonAlertPopupWithTitle:title];
}

#define ALERT_OK_BUTTON_TYPE    1
#define ALERT_TWO_BUTTON_TYPE   2

- (void)showTwoButtonAlertPopupWithTitle:(NSString*)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"확인", nil];
    alertView.tag = ALERT_TWO_BUTTON_TYPE;
    [alertView show];
}

- (void)showAlertPopupWithTitle:(NSString*)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil, nil];
    alertView.tag = ALERT_OK_BUTTON_TYPE;
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"확인"]) {
        if (alertView.tag==ALERT_TWO_BUTTON_TYPE) {
            [self.mapActionDelegate doSelectCurrentPosition:YES];
            [self directToStore:self.mapDirectionZoneId];
            [self.storePopupView removeFromSuperview];
        } else {
            self.currentPositionToCenter = NO;
            self.selectedCurrentPosition = NO;
            self.isMapLoading = NO;
            
            [self.mapActionDelegate endMapLoadingAction:nil isSuccess:NO];
            [self.mapActionDelegate doSelectCurrentPosition:NO];
        }
    } else if ([title isEqualToString:@"취소"]) {
        
    }
}

#pragma mark - Selector

- (void)moveToStore:(NSNumber *)zoneId {
    Zone *zone = [self.mapInfoProvider getZoneByZoneId:zoneId];
    
    if ([self.mapInfoProvider.currentMapId intValue]==[zone.map_id intValue]) {
        self.mapViewCont.selectedZoneNumber = zone.zone_id;
        [self showStorePopupWithZone:zone];
    } else {
        self.movingZone = zone;
        self.isLoadingMapForMovingStore = YES;
        
        [self.mapActionDelegate beginMapLoadingAction];
        
        // @ SSG
        SLBSFloor *floor = [self.mapInfoProvider getCurrentFloor];
        if ([floor.companyId intValue] == SHINSEGAE_INC)
            self.mapViewCont.titleColor = [UIColor blackColor];
        //
        
        [[SLBSMapManager sharedInstance] loadMapData:[zone.map_id intValue] delegate:self];
    }
}

- (void)directToStore:(NSNumber*)zoneId {
    self.isMapDirectioning = YES;
    self.mapDirectionZoneId = zoneId;
    
    Zone *zone = [self.mapInfoProvider getZoneByZoneId:zoneId];
    [self doFindPath:zone];
}

#pragma mark - MapManager

- (void)startMapManager {
    [[SLBSMapManager sharedInstance] startMonitoring:^(void){
        [self onMapManagerReady];
    }];
}

- (void)stopMapManager {
    [[SLBSMapManager sharedInstance] stopMonitoring];
}

- (void)onMapManagerReady {
    [self setDefaultMapView];
}

- (void)setDefaultMapView {
    [self.mapActionDelegate beginMapLoadingAction];
    
    if (self.mapInfoProvider.currentMapId!=nil) {
        // @ SSG
        SLBSFloor *floor = [self.mapInfoProvider getCurrentFloor];
        if ([floor.companyId intValue] == SHINSEGAE_INC)
            self.mapViewCont.titleColor = [UIColor blackColor];
        //
        [[SLBSMapManager sharedInstance] loadMapData:[self.mapInfoProvider.currentMapId intValue] delegate:self];
    } else {
        NSNumber *mapId = [self.mapInfoProvider getDefaultMapId];
        if ([mapId intValue]==-1) {
            [self.mapActionDelegate endMapLoadingAction:nil isSuccess:NO];
            return;
        } else {
            // @ SSG
            SLBSFloor *floor = [self.mapInfoProvider getCurrentFloor];
            if ([floor.companyId intValue] == SHINSEGAE_INC)
                self.mapViewCont.titleColor = [UIColor blackColor];
            //
            [[SLBSMapManager sharedInstance] loadMapData:[mapId intValue] delegate:self];
        }
    }
}

- (void)doFindPath:(Zone*)zone {
    if (self.curLocation) {
        [self.mapViewCont removePath];
        [self.mapActionDelegate beginPathFindingAction];
        [[SLBSMapManager sharedInstance] findPath:[self.curLocation.mapID intValue]
                                           startX:self.curLocation.x
                                           startY:self.curLocation.y
                                         endMapId:[zone.map_id intValue]
                                             endX:zone.center_x
                                             endY:zone.center_y
                                         delegate:self];
    } else {
        [Util showAlertPopupWithTitle:@"현재 위치가 수신되지 않았습니다"];
    }
}

- (BOOL)reloadMap {
    SLBSFloor *floor = [self.mapInfoProvider getCurrentFloor];
    if ([floor.mapId intValue]==-1) {
        return NO;
    }
    
    self.mapInfoProvider.currentMapId = floor.mapId;
    

    if ([floor.companyId intValue] == SHINSEGAE_INC)
        self.mapViewCont.titleColor = [UIColor blackColor];
    
    [self.mapActionDelegate beginMapLoadingAction];
    [[SLBSMapManager sharedInstance] loadMapData:[self.mapInfoProvider.currentMapId intValue] delegate:self];
    
    return YES;
}

- (void)removeMapPath {
    self.isMapDirectioning = NO;
    
    [self.mapViewCont removePath];
    self.appDataManager.curDirectionArray = nil;
}

#pragma mark - Location and MapManager Start / Stop

- (void)startMonitoring {
    [[SLBSLocationManager sharedInstance] setDelegate:self];
    [[SLBSLocationManager sharedInstance] startMonitoring];
    
    self.isLocationRunning = YES;
    TSGLog(TSLogGroupApplication, @"Location Monitoring Started!!!");
}

- (void)stopMonitoring {
    self.isLocationRunning = NO;
    
    [[SLBSLocationManager sharedInstance] setDelegate:nil];
    [[SLBSLocationManager sharedInstance] stopMonitoring];
    
    [self stopMapManager];
    
    TSGLog(TSLogGroupApplication, @"Location Monitoring Stopped!!!");
}

#pragma mark - Location Listener

- (void)locationManager:(SLBSLocationManager *)manager onLocation:(SLBSCoordination*)location {
    if([location.type integerValue] == SLBSCoordGPS) return;
    
    self.curLocation = location;
    
    TSGLog(TSLogGroupApplication, @"Current MapId=%d BranchId=%d, FloorId=%d",
           [location.mapID intValue], [location.branchID intValue], [location.floorID intValue]);
//    NSLog(@"### Current MapId=%d BranchId=%d, FloorId=%d",
//           [location.mapID intValue], [location.branchID intValue], [location.floorID intValue]);
    
    if ([location.mapID intValue]!=[self.mapInfoProvider.currentMapId intValue]) {
        // 현재 위치와 다른 맵을 보고 있는 경우
        if (self.selectedCurrentPosition==YES) {
            TSGLog(TSLogGroupApplication, @"Reload Map!!!");
//            NSLog(@"### Reload Map!!!");
            
            self.isMapLoading = YES;
            self.mapInfoProvider.currentMapId = location.mapID;
            self.mapInfoProvider.currentBranchId = location.branchID;
            self.mapInfoProvider.currentFloorId = location.floorID;
            
            // @ SSG
            SLBSFloor *floor = [self.mapInfoProvider getCurrentFloor];
            if ([floor.companyId intValue] == SHINSEGAE_INC)
                self.mapViewCont.titleColor = [UIColor blackColor];
            //
            
            [[SLBSMapManager sharedInstance] loadMapData:[location.mapID intValue] delegate:self];
        } else {
            TSGLog(TSLogGroupApplication, @"update current position! not same map");
//            NSLog(@"### update current position! not same map");
            if (self.isMapLoading==NO) {
                // 현재 위치가 아닌 맵을 보고 있는데, 현재 위치 아이콘이 표시되는 문제 때문에 막음
//                [self.mapViewCont updateCurrentPosition:CGPointMake(location.x, location.y) moveCenter:NO];
            }
        }
    } else {
        // 현재 위치와 같은 맵을 보고 있는 경우
        TSGLog(TSLogGroupApplication, @"update current position! same map");
//        NSLog(@"### update current position! same map");
        if (self.isMapLoading==NO) {
            if ([self.mapInfoProvider.currentMapId intValue]==[location.mapID intValue]) {
                if (self.currentPositionToCenter==YES) {
                    [self.mapViewCont updateCurrentPosition:CGPointMake(location.x, location.y) moveCenter:YES];
                    self.currentPositionToCenter = NO;
                } else {
                    [self.mapViewCont updateCurrentPosition:CGPointMake(location.x, location.y) moveCenter:NO];
                }
            }
        }
    }
}

#pragma mark - MapManager Listener

- (void)mapManager:(SLBSMapManager *)manager onMapReady:(SLBSMapViewData*)mapData {
    NSLog(@"onMapReady()");

    if (mapData.image == nil || [mapData.zoneList count] <= 0) {
        NSString *title = @"현재 층 지도를 표시할 수 없습니다. 잠시 후 다시 시도해 주세요.";
        [self showAlertPopupWithTitle:title];
        
        return;
    }
    
    // @ SSG
    SLBSFloor *floor = [self.mapInfoProvider getCurrentFloor];
    if ([floor.companyId intValue] == SHINSEGAE_INC)
        self.mapViewCont.titleColor = [UIColor blackColor];
    //
    
    [self.mapViewCont shouldLoadMapData:mapData];
    [self.mapActionDelegate endMapLoadingAction:mapData isSuccess:YES];
    
    self.isMapLoading = NO;

    if (self.isLoadingMapForMovingStore) {
        Zone *zone = self.movingZone;
        self.mapViewCont.selectedZoneNumber = zone.zone_id;
        [self showStorePopupWithZone:zone];
        self.isLoadingMapForMovingStore = NO;
    }
    
    // 길안내 중일때 map이 로딩되면(층을 변경하기)
    if (self.isMapDirectioning==YES) {
        [self setMapViewPath];
    }
    
}

- (void)mapManager:(SLBSMapManager *)manager onMapInfo:(SLBSMapData *)mapInfo {
    
}

#pragma mark - MapManager path finding listener

- (void)onPathFindSuccess:(NSArray*)mapPathViewDataArray {
    self.appDataManager.curDirectionArray = mapPathViewDataArray;
    [self setMapViewPath];
    [self.mapActionDelegate endPathFindingAction:YES];
    if (self.isMapDirectioning==YES) {
        [self.mapActionDelegate doSelectCurrentPosition:YES];
    }
}

- (void)onPathFindFail {
    [self.mapActionDelegate endPathFindingAction:NO];
}

- (void)setMapViewPath {
    // convert map path data array for mapview
    MapPathViewData* firstP = nil;
    MapPathViewData* lastP = nil;
    
    NSMutableArray* pathPos = [NSMutableArray array];
    int cnt = (int)self.appDataManager.curDirectionArray.count;
    for ( int i = 0 ; i < cnt ; i++ ) {
        MapPathViewData* p = [self.appDataManager.curDirectionArray objectAtIndex:i];
        if ( p.mapId != [self.mapInfoProvider.currentMapId intValue] ) continue;
        
        if (firstP == nil) {
            firstP = p;
        }
        [pathPos addObject:[NSValue valueWithCGPoint:CGPointMake(p.x, p.y)]];
        lastP = p;
    }
    
    if (firstP==nil && lastP==nil) {
        // 경로가 없는 지도를 선택한 경우
        [self.mapViewCont removePath];
        return;
    } else {
        NSValue* startPos = [NSValue valueWithCGPoint:CGPointMake(firstP.x, firstP.y)];
        NSValue* endPos = [NSValue valueWithCGPoint:CGPointMake(lastP.x, lastP.y)];

        NSDictionary *positions = nil;
        
        MapPathViewData *theFirstData = [self.appDataManager.curDirectionArray objectAtIndex:0];
        MapPathViewData *theLastData = [self.appDataManager.curDirectionArray objectAtIndex:cnt-1];
        
        if (firstP.vertexId == theFirstData.vertexId) {
            if (lastP.vertexId == theLastData.vertexId) {
                // 출발과 도착이 있는 경우,
                if (self.mapDirectionZoneId!=nil) {
                    positions = @{kSLBSMapViewNumberOfDestinationZone:self.mapDirectionZoneId,
                                  kSLBSMapViewPositionOfDeparture:startPos,
                                  kSLBSMapViewPositionOfDestination:endPos};
                }
            } else {
                // 출발과 경유가 있는 경우,
                positions = @{kSLBSMapViewPositionOfDeparture:startPos,
                              kSLBSMapViewPositionsOfPassage:endPos};
            }
            
        } else {
            if (firstP.vertexId != theFirstData.vertexId && lastP.vertexId != theLastData.vertexId) {
                // 경유와 경유가 있는 경우,
                positions = @{kSLBSMapViewPositionsOfPassage:@[startPos,endPos]};
            } else if (lastP.vertexId == theLastData.vertexId) {
                // 경유와 도착이 있는 경우,
                if (self.mapDirectionZoneId!=nil) {
                    positions = @{kSLBSMapViewNumberOfDestinationZone:self.mapDirectionZoneId,
                                  kSLBSMapViewPositionsOfPassage:startPos,
                                  kSLBSMapViewPositionOfDestination:endPos};
                }
            }
            
        }
        
        [self.mapViewCont setPath:[pathPos copy] positions:positions];
    }
}

@end
