//
//  MapImageView.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBSMapViewCommon.h"
#import "SLBSMapViewController.h"

@interface MapImageView : UIView

- (instancetype)initWithController:(SLBSMapViewController *)controller;

@property (readonly) CGSize mapSize;

- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms;

@end
