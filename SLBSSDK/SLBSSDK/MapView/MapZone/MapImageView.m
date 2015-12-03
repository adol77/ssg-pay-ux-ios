//
//  MapImageView.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapImageView.h"
#import "SLBSMapViewController.h"

@interface MapImageView ()

@property (nonatomic, weak) SLBSMapViewController *dataController;

@end

@implementation MapImageView

- (instancetype)initWithController:(SLBSMapViewController *)controller {
    self = [super init];
    if (self) {
        self.dataController = controller;
        self.frame = CGRectZero;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.dataController.mapImage];
        self.frame = imageView.frame;
        [self addSubview:imageView];
    }
    return self;
}

- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms {
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DConcat(CATransform3DConcat(CATransform3DConcat(transforms->scale, transforms->rotateZaxis), transforms->rotateXaxis), transforms->translation);
    self.layer.transform = transform;
}

- (CGSize)mapSize {
    return self.dataController.mapImage.size;
}

@end
