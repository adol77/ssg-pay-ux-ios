//
//  MapStoreBIZoneView.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 10. 6..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapZoneView.h"

@interface MapStoreBIZoneView : MapZoneView

@property (nonatomic, strong) UIImage *BI;
- (void)fillColor:(UIColor *)color;
@property (nonatomic, assign) CGFloat angle;

@end
