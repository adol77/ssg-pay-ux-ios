//
//  SLBSMapDataController.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 16..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "SLBSMapViewController.h"
#import "SLBSMapViewCommon.h"
#import "SLBSMapView.h"
#import "TSDebugLogManager.h"
#import "SLBSPathDirection.h"

const NSString *kSLBSMapViewIconForCurrentPosition          = @"kSLBSMapViewIconForCurrentPosition";
const NSString *kSLBSMapViewIconForCampaignZone             = @"kSLBSMapViewIconForCampaignZone";
const NSString *kSLBSMapViewIconForDeparturePosition        = @"kSLBSMapViewIconForDeparturePosition";
const NSString *kSLBSMapViewIconForPassage                  = @"kSLBSMapViewIconForPassage";
const NSString *kSLBSMapViewIconForDestination              = @"kSLBSMapViewIconForDestination";
const NSString *kSLBSMapViewIconForDirection                = @"kSLBSMapViewIconForDestination";
const NSString *kSLBSMapViewNumberOfDepartureZone           = @"kSLBSMapViewNumberOfDepartureZone";
const NSString *kSLBSMapViewNumberOfDestinationZone         = @"kSLBSMapViewNumberOfDestinationZone";
const NSString *kSLBSMapViewPositionOfDeparture             = @"kSLBSMapViewPositionOfDeparture";
const NSString *kSLBSMapViewPositionsOfPassage              = @"kSLBSMapViewPositionsOfPassage";
const NSString *kSLBSMapViewPositionOfDestination           = @"kSLBSMapViewPositionOfDestination";

@interface SLBSMapViewController () < SLBSMapViewDelegate > {
//    SLBSTransform3Ds transforms_;
}

@property (nonatomic, strong) SLBSMapView *mapView;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSMutableDictionary *resource;

@property (nonatomic, strong) NSArray *zones;
@property (nonatomic, strong) NSArray *paths;
@property (nonatomic, assign) BOOL pathHidden;
@property (nonatomic, strong) NSMutableDictionary *position;

@property (nonatomic, assign) BOOL currentLocationHidden;

@end

@implementation SLBSMapViewController

#pragma mark - initialize
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.pathLineWidth = 12.0f/2;
    self.pathStrokeColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    self.pathDirectionIconInterval = 50.0f/2;
    
    self.selectedStrokeColor = UIColorFromRGBA(0x982424, 1.0f);
    self.selectedStrokeLineWidth = 4.0f;

    self.campaignStrokeColor = UIColorFromRGBA(0x37a07c, 1.0f);
    self.campaignStrokeLineWidth = 2.0f;
    
    self.titleColor = [UIColor whiteColor];
    self.pathDepartureTitleColor = [UIColor yellowColor];
    self.pathDestinationTitleColor = [UIColor yellowColor];
    
    self.minimumFontScale = 0.2f;
    self.maximumFontSize = 38.0f/2.0f;
    self.minimumFontSize = nearbyintl(self.maximumFontSize * self.minimumFontScale);
    
    self.titleFont = [UIFont systemFontOfSize:self.maximumFontSize];
    self.pathDepartureTitleFont = [UIFont boldSystemFontOfSize:self.maximumFontSize];
    self.pathDestinationTitleFont = [UIFont boldSystemFontOfSize:self.maximumFontSize];
}

- (instancetype)initWithFrame:(CGRect)frame resource:(NSDictionary *)resource {
    self = [self init];
    if (self) {
        self.resource = [NSMutableDictionary dictionaryWithDictionary:resource];
        self.frame = frame;
        self.mapView = [[SLBSMapView alloc] initWithFrame:self.frame controller:self];
        self.mapView.delegate = self;
    }
    return self;
}

#pragma mark - Map View
- (UIView *)mapViewControl {
    return (UIView *)self.mapView;
}

- (void)setFrame:(CGRect)frame {
    if(CGRectEqualToRect(self.frame, frame) == YES) {
        return;
    }
    _frame = frame;
    self.mapView.frame = self.frame;
//    [self.mapView layoutSubviews];//맞는지 보고 다른 방법을 생각해 보자.
}

#pragma mark - resource
- (NSDictionary *)resources {
    return [NSDictionary dictionaryWithDictionary:self.resource];
}

- (void)addResourceObject:(NSDictionary *)resource {
    [self.resource addEntriesFromDictionary:resource];
}

#pragma mark - basic data
- (void)shouldLoadMapData:(SLBSMapViewData *)data {
    self.mapID = data.ID;
    self.mapImage = data.image;
    [self setZones:data.zoneList];
    [self.mapView loadMapData];
}

- (void)setZones:(NSArray *)zones {
    if (self.zones) {
        _zones = nil;
    }
    _zones = zones;
    
    for (SLBSMapViewZoneData *zoneData in self.zones) {
        if ([zoneData.name containsString:@"\\n"] == YES) {
            zoneData.name = [zoneData.name stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
        }
        
        zoneData.currentCenter = CGPointNearbyintForRetina(zoneData.currentCenter);
        zoneData.titleCenter = CGPointNearbyintForRetina(zoneData.titleCenter);
        NSArray *array = [NSArray arrayWithArray:zoneData.polygons];
        NSMutableArray *retinaArray = [NSMutableArray array];
        for (NSValue *position in array) {
            NSValue *retinaPosition = [NSValue valueWithCGPoint:CGPointNearbyintForRetina([position CGPointValue])];
            [retinaArray addObject:retinaPosition];
        }
        zoneData.polygons = [NSArray arrayWithArray:retinaArray];
        zoneData.visibleFrame = CGRectNearbyintForRetina(zoneData.visibleFrame);
    }
}

- (SLBSMapViewZoneData *)zoneDataAtID:(NSNumber *)zoneID {
    NSArray *filteredArray = [self.zones filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"zoneID == %@", zoneID]];
    if ([filteredArray count] > 0) {
        return [filteredArray firstObject];
    }
    return nil;
}

- (NSArray *)poiZoneList {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", [NSNumber numberWithInteger:TSSLBSMapZoneTypePOIImage]];
    NSArray *poiArray = [self.zones filteredArrayUsingPredicate:predicate];
    if ([poiArray count] > 0) {
        return poiArray;
    }
    return nil;
}

- (NSArray *)storeZoneList {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@", [NSNumber numberWithInteger:TSSLBSMapZoneTypePolygon]];
    NSArray *storeArray = [self.zones filteredArrayUsingPredicate:predicate];
    if ([storeArray count] > 0) {
        return storeArray;
    }
    return nil;
}

- (BOOL)mapView:(SLBSMapView *)mapView willSelectedZone:(NSNumber *)zoneID {
    if (self.delegate && [self.delegate respondsToSelector:@selector(controller:willSelectedZone:)] == YES) {
        return [self.delegate controller:self willSelectedZone:zoneID];
    }
    return NO;
}

- (void)setSelectedZoneNumber:(NSNumber *)selectedZoneNumber {
    if ((selectedZoneNumber == nil) || ([_selectedZoneNumber isEqualToNumber:selectedZoneNumber] == YES) ) {
        [self.mapView unselectedZone:self.selectedZoneNumber];
        _selectedZoneNumber = nil;
    } else {
        [self.mapView unselectedZone:self.selectedZoneNumber];
        _selectedZoneNumber = selectedZoneNumber;
        [self.mapView selectedZone:self.selectedZoneNumber];
    }
}

- (void)setPathHidden:(BOOL)pathHidden {
    if (self.pathHidden == pathHidden) {
        return;
    }
    _pathHidden = pathHidden;
    [self.mapView hiddenPath:self.pathHidden];
}

- (void)setPath:(NSArray *)path positions:(NSDictionary *)positions {
    if ([path count] <= 0) {
        [self.mapView showPath:NO];
//        기존함수 제거하면 주석코드로 복원해야한다.
//        self.paths = nil;
        _paths = nil;
        self.position = nil;
    } else {
        path = [SLBSPathDirectionHelper pathDicrectionFilter:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSValue *pathPosition in path) {
            NSValue *rintPath = [NSValue valueWithCGPoint:CGPointNearbyintForRetina([pathPosition CGPointValue])];
            [array addObject:rintPath];
        }
        
//        기존함수 제거하면 주석코드로 복원해야한다.
//        self.paths = nil;
//        self.paths = [NSArray arrayWithArray:array];
        _paths = nil;
        _paths = [NSArray arrayWithArray:array];
        self.position = [NSMutableDictionary dictionaryWithDictionary:positions];
        [self.mapView showPath:YES];
    }
}

- (void)removePath {
    [self setPath:nil positions:nil];
}


- (NSDictionary *)positions {
    return [NSDictionary dictionaryWithDictionary:self.position];
}

- (void)addPositionObject:(NSDictionary *)object {
    [self.position addEntriesFromDictionary:object];
}

- (void)updateCurrentPosition:(CGPoint)position moveCenter:(BOOL)move {
    [self.mapView updateCurrentPosition:CGPointNearbyintForRetina(position) moveCenter:move];
}

- (id)valueForPositionFromKeyString:(const NSString *)key {
    id object = [self.position objectForKey:key];
    if (object && strcmp([object objCType], @encode(CGPoint)) == 0) {
        return [NSValue valueWithCGPoint:CGPointNearbyintForRetina([(NSValue *)object CGPointValue])];
    } else if(object && [object isKindOfClass:[NSNumber class]] == YES) {
        return object;
    }
    return nil;
}

- (NSValue *)departurePosition {
    NSValue *position = [self valueForPositionFromKeyString:kSLBSMapViewPositionOfDeparture];
    if (position == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty departure position value");
    }
    return position;
}

- (NSValue *)destinationPosition {
    NSValue *position = [self valueForPositionFromKeyString:kSLBSMapViewPositionOfDestination];
    if (position == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty destination position value");
    }
    return position;
}

- (NSArray *)passagePositions {
    id object = [self.position objectForKey:kSLBSMapViewPositionsOfPassage];
    if (object && [object isKindOfClass:[NSArray class]] == YES) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *values = object;
        for (id value in values) {
            if (value && strcmp([value objCType], @encode(CGPoint)) == 0) {
                [array addObject:[NSValue valueWithCGPoint:CGPointNearbyintForRetina([(NSValue *)value CGPointValue])]];
            }
        }
        return [NSArray arrayWithArray:array];
    } else if (object && strcmp([object objCType], @encode(CGPoint)) == 0) {
        NSValue *value = [NSValue valueWithCGPoint:CGPointNearbyintForRetina([(NSValue *)object CGPointValue])];
        return [NSArray arrayWithObject:value];
    }
    return nil;
}

- (NSNumber *)minimumDistanceZoneNumberWithPosition:(CGPoint)position {
    NSNumber *zoneNumber = nil;
    CGFloat minimumDistance = MAXFLOAT;
    for (SLBSMapViewZoneData *zoneData in self.zones) {
        CGFloat distance = distanceBetweenTwoPoint(zoneData.currentCenter, position);
        if (distance < minimumDistance) {
            minimumDistance = distance;
            zoneNumber = zoneData.zoneID;
        }
    }
    return zoneNumber;
}

- (NSNumber *)departureZoneNumber {
    NSNumber *zoneNumber = nil;//[self valueForPositionFromKeyString:kSLBSMapViewNumberOfDepartureZone];
    if (zoneNumber == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty departure zone number value");
//        if (self.departurePosition ) {
//            CGPoint departure = [self.departurePosition CGPointValue];
//            zoneNumber = [self minimumDistanceZoneNumberWithPosition:departure];
//        }//외부에서 설정해 주는 것으로 다시 변경 됨.
    }
//    return zoneNumber;
    return nil;//출발지는 표시하지 않는다... 로 변경 되었단다.
}

- (NSNumber *)destinationZoneNumber {
    NSNumber *zoneNumber = [self valueForPositionFromKeyString:kSLBSMapViewNumberOfDestinationZone];
    if (zoneNumber == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty destination zone number value");
//        if (self.destinationPosition) {
//            CGPoint destination = [self.destinationPosition CGPointValue];
//            zoneNumber = [self minimumDistanceZoneNumberWithPosition:destination];
//        }//외부에서 설정해 주는 것으로 다시 변경 됨.
    }
    return zoneNumber;
}


- (UIImage *)imageFromKeyString:(const NSString *)key {
    id object = [self.resource objectForKey:key];
    if (object && [NSStringFromClass([object class]) isEqualToString:NSStringFromClass([UIImage class])] == YES) {
        return (UIImage *)object;
    }
    return nil;
}

- (UIImage *)pathDepartureIcon {
    UIImage *image = [self imageFromKeyString:kSLBSMapViewIconForDeparturePosition];
    if (image == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty departure position icon");
    }
    return image;
}

- (UIImage *)pathDestinationIcon {
    UIImage *image = [self imageFromKeyString:kSLBSMapViewIconForDestination];
    if (image == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty destination position icon");
    }
    return image;
}

- (UIImage *)pathPassageIcon {
    UIImage *image = [self imageFromKeyString:kSLBSMapViewIconForPassage];
    if (image == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty destination position icon");
    }
    return image;
}

- (UIImage *)pathDirectionIcon {
    UIImage *image = [self imageFromKeyString:kSLBSMapViewIconForDirection];
    if (image == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty destination position icon");
    }
    return image;
}

- (UIImage *)currentLocationIcon {
    UIImage *image = [self imageFromKeyString:kSLBSMapViewIconForCurrentPosition];
    if (image == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty current position icon");
    }
    return image;
}

- (UIImage *)campaignZoneIcon {
    UIImage *image = [self imageFromKeyString:kSLBSMapViewIconForCampaignZone];
    if (image == nil) {
        TSGLog(TSLogGroupMap, @"MapView ERROR!!! empty campaignzone position icon");
    }
    return image;
}


///////////////////old interface
#pragma mark - path
- (void)setPaths:(NSArray *)paths {
    [self setPaths:paths departurePosition:nil destinationPosition:nil];
}

- (void)setPaths:(NSArray*)paths departurePosition:(NSValue *)departure destinationPosition:(NSValue *)destination {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (departure) {
        [dictionary addEntriesFromDictionary:@{kSLBSMapViewPositionOfDeparture:[NSValue valueWithCGPoint:CGPointNearbyintForRetina([departure CGPointValue])]}];
    }
    if (destination) {
        [dictionary addEntriesFromDictionary:@{kSLBSMapViewPositionOfDestination:[NSValue valueWithCGPoint:CGPointNearbyintForRetina([destination CGPointValue])]}];
    }
    [self setPath:paths positions:dictionary];
}

@end
