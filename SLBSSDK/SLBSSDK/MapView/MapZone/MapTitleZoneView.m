//
//  MapTitleZoneView.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 23..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapTitleZoneView.h"

@interface MapTitleZoneView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) BOOL transformed;

@end

@implementation MapTitleZoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;//[title stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    
    if (nil == self.title) {
        return;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    
    label.text = self.title;
    label.font = self.textFont;
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentCenter;
    if ([[title componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] count] > 1) {
        label.numberOfLines = 0;
    }
//    else {
//        label.numberOfLines = 1;
//        label.adjustsFontSizeToFitWidth = YES;
//        label.minimumScaleFactor = self.minimumFontScale;
//    }
    
//    label.layer.shadowColor = [UIColor blackColor].CGColor;
//    label.layer.shadowOffset = CGSizeMake(0, 1);
//    label.layer.shadowOpacity = 1;
//    label.layer.shadowRadius = 2.0;
//    label.clipsToBounds = NO;
    
    self.textLabel = label;
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.textLabel];
}

- (void)setAngle:(CGFloat)angle {
    if (angle == 0) {
        return;
    }
    _angle = angle;
    self.textLabel.layer.transform = CATransform3DRotate(CATransform3DIdentity, self.angle, 0, 0, 1);
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = nil;
    _textColor = textColor;
    
    self.textLabel.textColor = self.textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = nil;
    _textFont = textFont;
    self.textLabel.font = self.textFont;
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
        self.textLabel.layer.transform = CATransform3DRotate(CATransform3DIdentity, self.angle, 0, 0, 1);
    } else if((angle < (-M_PI_2-self.angle) || (M_PI_2-self.angle) < angle) && self.transformed == NO) {
        self.transformed = YES;
        self.textLabel.layer.transform = CATransform3DRotate(CATransform3DIdentity, (M_PI+self.angle), 0, 0, 1);
        changed = YES;
    }
    
    if (changed) {
        self.textLabel.alpha = 0.0f;
        [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.textLabel.alpha = 1.0f;
        } completion:nil];
//        [UIView beginAnimations:@"rotateText" context:nil];
//        [UIView setAnimationDuration:MAP_ANIMATION_DURATION_MIDDLE];
//        [UIView commitAnimations];
    }
}

- (void)resetTransforms:(SLBSTransform3Ds *)transforms {
    self.transformed = NO;
    self.textLabel.layer.transform = CATransform3DRotate(CATransform3DIdentity, self.angle, 0, 0, 1);
}

@end
