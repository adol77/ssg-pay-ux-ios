//
//  MapZoneView.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 3..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBSMapViewCommon.h"
#import "SLBSMapViewController.h"

@interface MapZoneView : UIView

+ (instancetype)zoneViewWithController:(SLBSMapViewController *)controller zoneID:(NSNumber *)zoneID;
- (instancetype)initWithController:(SLBSMapViewController *)controller zoneID:(NSNumber *)zoneID;

@property (nonatomic, weak) SLBSMapViewController *dataController;
@property (nonatomic, weak) SLBSMapViewZoneData *zoneData;

@property (readonly) NSNumber *zoneID;
@property (readonly) NSNumber *sessionType;

- (BOOL)contains:(CGPoint)location;

@property (nonatomic, assign) BOOL selected;

- (void)setShadow:(BOOL)enabled;

- (CGPoint)translateInView:(CGPoint)origin;
- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms;
- (void)didEndTransforms:(SLBSTransform3Ds *)transforms;
- (void)resetTransforms:(SLBSTransform3Ds *)transforms;

@property (nonatomic, assign) BOOL departureZone;
@property (nonatomic, assign) BOOL destinationZone;

@end
