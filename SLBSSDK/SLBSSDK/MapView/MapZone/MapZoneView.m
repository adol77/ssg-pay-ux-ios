//
//  MapZoneView.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 3..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapZoneView.h"

@interface MapZoneView ()

@end

@implementation MapZoneView

+ (instancetype)zoneViewWithController:(SLBSMapViewController *)controller zoneID:(NSNumber *)zoneID {
    return [[self alloc] initWithController:controller zoneID:zoneID];
}

- (instancetype)initWithController:(SLBSMapViewController *)controller zoneID:(NSNumber *)zoneID {
    self = [super init];
    if (self) {
        self.dataController = controller;
        self.zoneData = [self.dataController zoneDataAtID:zoneID];
    }
    return self;
}

- (NSNumber *)zoneID {
    return [self.zoneData.zoneID copy];
}

- (NSNumber *)sessionType {
    return [NSNumber numberWithInteger:self.zoneData.type];
}

- (void)setShadow:(BOOL)enabled {
    if (enabled) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 5.0;
    } else {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -3);
        self.layer.shadowOpacity = 0;
        self.layer.shadowRadius = 3.0;
    }
}

- (CGPoint)translateInView:(CGPoint)origin {
    return CGPointMake((origin.x - self.frame.origin.x), (origin.y - self.frame.origin.y));
}

- (BOOL)contains:(CGPoint)location {
    BOOL isContains = CGRectContainsPoint(self.frame, location);
    return isContains;
}

- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms {
    
}

- (void)didEndTransforms:(SLBSTransform3Ds *)transforms {
    
}

- (void)resetTransforms:(SLBSTransform3Ds *)transforms {
    
}

@end
