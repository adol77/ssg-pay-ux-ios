//
//  MapPathView.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBSMapViewCommon.h"
#import "SLBSMapViewController.h"

@interface MapPathView : UIView

@property (nonatomic, weak) SLBSMapViewController *dataController;
- (void)showPath:(BOOL)show;

- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms;
- (void)didEndTransforms:(SLBSTransform3Ds *)transforms;
- (void)resetTransforms:(SLBSTransform3Ds *)transforms;

@property (nonatomic, strong) UIImageView *currentPositionView;
- (void)setCurrentPosition:(CGPoint)position;

@end
