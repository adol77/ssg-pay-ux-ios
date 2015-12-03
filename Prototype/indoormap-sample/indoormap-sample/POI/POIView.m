//
//  POIView.m
//  indoormap-sample
//
//  Created by Lee muhyeon on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "POIView.h"

@interface POIView () {
    CGPoint center_;
}

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, assign) BOOL selected;

@end

@implementation POIView

- (instancetype)initWithCenter:(CGPoint)center
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        center_ = center;
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi.png"]];
        [self addSubview:self.icon];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.frame = self.icon.frame = CGRectMake(self.icon.frame.origin.x, self.icon.frame.origin.y, self.icon.frame.size.width/2, self.icon.frame.size.height/2);
    self.center = center_;
    
    self.icon.layer.shadowColor = [UIColor blackColor].CGColor;
    self.icon.layer.shadowOffset = CGSizeMake(0, 2);
    self.icon.layer.shadowOpacity = 1;
    self.icon.layer.shadowRadius = 5.0;
    self.icon.clipsToBounds = NO;
}

- (BOOL)isSelected {
    return _selected;
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    
    _selected = selected;
    if (self.selected) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 0.5;
        animation.repeatCount = HUGE_VAL;
        animation.autoreverses = YES;
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:1.5];
        [self.icon.layer addAnimation:animation forKey:@"scale-layer"];
    } else {
        [self.icon.layer removeAllAnimations];
    }
}


@end
