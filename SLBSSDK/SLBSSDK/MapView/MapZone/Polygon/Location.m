//
//  Location.m
//  indoornowMapviewSample
//
//  Created by Lee muhyeon on 2015. 8. 20..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "Location.h"

@implementation Location

+ (NSArray *)locationsWithCGPoints:(NSArray *)positions {
    NSMutableArray *array = [NSMutableArray array];
    for (NSValue *position in positions) {
        CGPoint pos = [position CGPointValue];
        Location *location = [Location locationWithCGPoint:pos];
        [array addObject:location];
    }
    return [NSArray arrayWithArray:array];
}

+ (instancetype)locationWithCGPoint:(CGPoint)position {
    return [[Location alloc] initWithX:position.x y:position.y z:0];
}

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

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ {%.2f,%.2f,%.2f}", [super description], self.x, self.y, self.z];
}

@end




