//
//  SLBSMapView.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 3..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBSMapViewData.h"
#import "SLBSMapViewController.h"

@class SLBSMapView;
@protocol SLBSMapViewDelegate <NSObject>

- (BOOL)mapView:(SLBSMapView *)mapView willSelectedZone:(NSNumber *)zoneID;

@end

@interface SLBSMapView : UIView

- (instancetype)initWithFrame:(CGRect)frame controller:(SLBSMapViewController *)controller;
@property (nonatomic, assign) id<SLBSMapViewDelegate> delegate;

- (void)loadMapData;
- (void)selectedZone:(NSNumber *)zoneNumber;
- (void)unselectedZone:(NSNumber *)zoneNumber;
- (void)hiddenPath:(BOOL)hidden;
- (void)showPath:(BOOL)show;
- (void)updateCurrentPosition:(CGPoint)position moveCenter:(BOOL)move;
- (void)hiddenCurrentPosition:(BOOL)hidden;

@end
