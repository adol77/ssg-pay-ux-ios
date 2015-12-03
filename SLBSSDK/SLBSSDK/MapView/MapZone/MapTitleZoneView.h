//
//  MapTitleZoneView.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 23..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapZoneView.h"

@interface MapTitleZoneView : MapZoneView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, assign) CGFloat minimumFontScale;
@property (nonatomic, assign) CGFloat angle;

@end
