//
//  IndicatorView.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/15/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "IndicatorView.h"
#import "ColorUtil.h"

@interface IndicatorView ()

@property (nonatomic, strong) UIView *indicatorBackView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation IndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // indicator back view
        self.indicatorBackView = [[UIView alloc] initWithFrame:frame];
        self.indicatorBackView.backgroundColor = [ColorUtil popupBgColor];
        
        // indicator view
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicatorView.center = self.indicatorBackView.center;
        [self.indicatorBackView addSubview:self.indicatorView];
        
        [self addSubview:self.indicatorBackView];
    }
    
    return self;
}

- (void)startAnimating {
    [self.indicatorView startAnimating];
}

- (void)stopAnimating {
    [self.indicatorView stopAnimating];
}

@end
