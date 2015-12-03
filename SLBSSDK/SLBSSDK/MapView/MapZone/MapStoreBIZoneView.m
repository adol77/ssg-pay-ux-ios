//
//  MapStoreBIZoneView.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 10. 6..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapStoreBIZoneView.h"

@interface MapStoreBIZoneView ()

@property (nonatomic, strong) UIImageView *storeBIImageView;
@property (nonatomic, assign) BOOL transformed;

@end

@implementation MapStoreBIZoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setBI:(UIImage *)BI {
    if (self.storeBIImageView) {
        [self.storeBIImageView removeFromSuperview];
        self.storeBIImageView = nil;
    }
    _BI = BI;
    self.storeBIImageView = [[UIImageView alloc] initWithImage:self.BI];
    [self addSubview:self.storeBIImageView];
}

- (void)setAngle:(CGFloat)angle {
    if (angle == 0) {
        return;
    }
    _angle = angle;
    self.storeBIImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, self.angle, 0, 0, 1);
}

- (void)fillColor:(UIColor *)color {
    if (color == nil) {
        self.storeBIImageView.image = self.BI;
        return;
    }
    
    UIImage *image = self.BI;
    UIColor *fillColor = color;
    
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *flippedImage = [UIImage imageWithCGImage:img.CGImage
                                                scale:2.0 orientation: UIImageOrientationDownMirrored];
    self.storeBIImageView.image = flippedImage;
}

- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms {
//    self.layer.transform = CATransform3DInvert(transforms.rotateZaxis);
}

- (void)didEndTransforms:(SLBSTransform3Ds *)transforms {
    CGFloat angle = [(NSNumber *)[self.superview.superview.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
//    CGFloat textAngle = [(NSNumber *)[self.textLabel.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
//    NSLog(@"angel : %.2f absangel : %.2f textAngle : %.2f", angle, fabs(angle), textAngle);
    BOOL changed = NO;
    if (((-M_PI_2-self.angle) < angle && angle < (M_PI_2-self.angle)) && self.transformed == YES) {
        self.transformed = NO;
        changed = YES;
        self.storeBIImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, self.angle, 0, 0, 1);
    } else if((angle < (-M_PI_2-self.angle) || (M_PI_2-self.angle) < angle) && self.transformed == NO) {
        self.transformed = YES;
        self.storeBIImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, (M_PI+self.angle), 0, 0, 1);
        changed = YES;
    }
    
    if (changed) {
        self.storeBIImageView.alpha = 0.0f;
        [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.storeBIImageView.alpha = 1.0f;
        } completion:nil];
//        [UIView beginAnimations:@"rotateText" context:nil];
//        [UIView setAnimationDuration:MAP_ANIMATION_DURATION_MIDDLE];
//        self.storeBIImageView.alpha = 1.0f;
//        [UIView commitAnimations];
    }
}

- (void)resetTransforms:(SLBSTransform3Ds *)transforms {
    self.transformed = NO;
    self.storeBIImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, self.angle, 0, 0, 1);
}


@end
