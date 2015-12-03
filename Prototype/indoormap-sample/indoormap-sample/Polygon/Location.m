//
//  Location.m
//  indoornowMapviewSample
//
//  Created by Lee muhyeon on 2015. 8. 20..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "Location.h"

@implementation Location

- (instancetype)initWithX:(CGFloat)x
                        y:(CGFloat)y
                        z:(CGFloat)z;
{
    if (self = [super init]) {
        _x = x;
        _y = y;
        _z = z;
    }
    
    return self;
}

@end
