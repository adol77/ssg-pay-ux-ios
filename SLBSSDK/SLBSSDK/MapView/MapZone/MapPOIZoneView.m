//
//  MapPOIZoneView.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 3..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapPOIZoneView.h"

@interface MapPOIZoneView () {
    CGPoint center_;
}

@property (nonatomic, strong) UIImageView *icon;

@end

@implementation MapPOIZoneView

- (instancetype)initWithController:(SLBSMapViewController *)controller zoneID:(NSNumber *)zoneID
{
    self = [super initWithController:controller zoneID:zoneID];
    if (self) {
        center_ = self.zoneData.currentCenter;
        self.icon = [[UIImageView alloc] initWithImage:self.zoneData.icon];
        [self addSubview:self.icon];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.frame = self.icon.frame = CGRectMake(self.icon.frame.origin.x, self.icon.frame.origin.y, self.icon.frame.size.width, self.icon.frame.size.height);
    self.center = center_;
    
}

- (void)setShadow:(BOOL)enabled {
    if (enabled) {
        self.icon.layer.shadowColor = [UIColor blackColor].CGColor;
        self.icon.layer.shadowOffset = CGSizeMake(0, 2);
        self.icon.layer.shadowOpacity = 1;
        self.icon.layer.shadowRadius = 5.0;
    } else {
        self.icon.layer.shadowColor = [UIColor blackColor].CGColor;
        self.icon.layer.shadowOffset = CGSizeMake(0, -3);
        self.icon.layer.shadowOpacity = 0;
        self.icon.layer.shadowRadius = 3.0;
    }
}

- (BOOL)pointInside:(CGPoint)point {
    //Using code from http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 1, NULL, (CGBitmapInfo)kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    [self.icon.image drawAtPoint:CGPointMake(-point.x, -point.y)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGFloat alpha = pixel[0]/255.0f;
    BOOL transparent = alpha < 0.01f;
    
    return !transparent;
}

- (BOOL)contains:(CGPoint)location {
    BOOL isContains = [super contains:location];
    if (isContains) {
        isContains = [self pointInside:[self translateInView:location]];
    }
    return isContains;
}

- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms {
    self.layer.transform = CATransform3DInvert(transforms->rotateZaxis);
}

@end
