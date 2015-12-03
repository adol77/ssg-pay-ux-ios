//
//  SLBSMapViewController.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 16..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBSMapViewData.h"

FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForCurrentPosition;
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForCampaignZone;
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForDeparturePosition;
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForDestination;
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForDirection;
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForPassage;

FOUNDATION_EXTERN const NSString *kSLBSMapViewNumberOfDepartureZone;//unused....
FOUNDATION_EXTERN const NSString *kSLBSMapViewNumberOfDestinationZone;//Object : NSNumber

FOUNDATION_EXTERN const NSString *kSLBSMapViewPositionOfDeparture;//Object : NSValue
FOUNDATION_EXTERN const NSString *kSLBSMapViewPositionsOfPassage;//Object : NSValue or NSValue's array
FOUNDATION_EXTERN const NSString *kSLBSMapViewPositionOfDestination;//Object : NSValue


@class SLBSMapViewController;
@protocol SLBSMapViewControllerDelegate <NSObject>

- (BOOL)controller:(SLBSMapViewController *)controller willSelectedZone:(NSNumber *)zoneID;
- (void)touchedMapViewWithController:(SLBSMapViewController *)controller;

@end

@interface SLBSMapViewController : NSObject

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame resource:(NSDictionary *)resource;

@property (nonatomic, weak) id<SLBSMapViewControllerDelegate> delegate;

@property (nonatomic, readonly) UIView *mapViewControl;
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, readonly) NSDictionary *resources;
- (void)addResourceObject:(NSDictionary *)resource;

- (void)shouldLoadMapData:(SLBSMapViewData *)data;

@property (nonatomic, strong) NSNumber *mapID;
@property (nonatomic, strong) UIImage *mapImage;

- (void)setZones:(NSArray *)zones;
@property (nonatomic, readonly) NSArray *zones;

- (SLBSMapViewZoneData *)zoneDataAtID:(NSNumber *)zoneID;

@property (readonly) NSArray *poiZoneList;
@property (readonly) NSArray *storeZoneList;

//#pragma mark - transform
//@property (readonly) SLBSTransform3Ds *transforms;

#pragma mark - path
- (void)setPath:(NSArray *)path positions:(NSDictionary *)positions;
- (void)removePath;
@property (nonatomic, readonly) NSArray *paths;
@property (nonatomic, readonly) NSDictionary *positions;
- (void)addPositionObject:(NSDictionary *)object;

@property (nonatomic, assign) BOOL pathHidden;

@property (nonatomic, assign) CGFloat pathLineWidth;
@property (nonatomic, strong) UIColor *pathStrokeColor;

#pragma mark - departure/destination in path
@property (nonatomic, readonly) NSValue *departurePosition;
@property (nonatomic, readonly) NSValue *destinationPosition;
@property (nonatomic, readonly) NSArray *passagePositions;
@property (nonatomic, readonly) UIImage *pathDepartureIcon;
@property (nonatomic, readonly) UIImage *pathDestinationIcon;
@property (nonatomic, readonly) UIImage *pathDirectionIcon;
@property (nonatomic, readonly) UIImage *pathPassageIcon;
@property (nonatomic, assign)   CGFloat pathDirectionIconInterval;

@property (nonatomic, readonly) NSNumber *departureZoneNumber;
@property (nonatomic, readonly) NSNumber *destinationZoneNumber;

#pragma mark - user location
@property (nonatomic, readonly) UIImage *currentLocationIcon;
@property (nonatomic, assign) BOOL currentLocationHidden;
- (void)updateCurrentPosition:(CGPoint)position moveCenter:(BOOL)move;

#pragma mark - selected zone display
@property (nonatomic, strong) NSNumber *selectedZoneNumber;
@property (nonatomic, strong) UIColor *selectedStrokeColor;
@property (nonatomic, assign) CGFloat selectedStrokeLineWidth;

#pragma mark - campaing zone display
@property (nonatomic, readonly) UIImage *campaignZoneIcon;
@property (nonatomic, strong) UIColor *campaignStrokeColor;
@property (nonatomic, assign) CGFloat campaignStrokeLineWidth;

#pragma mark - title for zone display
@property (nonatomic, assign) CGFloat minimumFontScale;
@property (nonatomic, assign) CGFloat minimumFontSize;
@property (nonatomic, assign) CGFloat maximumFontSize;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *pathDepartureTitleFont;
@property (nonatomic, strong) UIFont *pathDestinationTitleFont;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *pathDepartureTitleColor;
@property (nonatomic, strong) UIColor *pathDestinationTitleColor;


////////////////////old interface
//#pragma mark - basic data
//- (void)setPaths:(NSArray *)paths DEPRECATED_MSG_ATTRIBUTE("Replaced by setPath:positions: method");
//- (void)setPaths:(NSArray*)paths departurePosition:(NSValue *)departure destinationPosition:(NSValue *)destination DEPRECATED_MSG_ATTRIBUTE("Replaced by setPath:positions: method");

@end


