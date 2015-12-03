//
//  PolygonView.h
//  indoornowMapviewSample
//
//  Created by Lee muhyeon on 2015. 8. 20..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Polygon.h"

@interface PolygonView : UIView

@property (strong, nonatomic) Polygon *polygon;
@property (assign, nonatomic) CGFloat scaleFactor;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (readonly) UILabel *textLabel;


+ (instancetype)viewWithPolygon:(Polygon *)polygon
                      plotFrame:(CGRect)plotFrame
                    scaleFactor:(CGFloat)scaleFactor;

@property (readonly) BOOL isSelected;
- (void)setSelected:(BOOL)selected;

@end
