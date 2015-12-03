//
//  POIView.h
//  indoormap-sample
//
//  Created by Lee muhyeon on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface POIView : UIView

- (instancetype)initWithCenter:(CGPoint)center;

@property (readonly) BOOL isSelected;
- (void)setSelected:(BOOL)selected;

@end
