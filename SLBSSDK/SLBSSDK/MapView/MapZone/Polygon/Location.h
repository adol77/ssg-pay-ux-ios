//
//  Location.h
//  indoornowMapviewSample
//
//  Created by Lee muhyeon on 2015. 8. 20..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Location : NSObject

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat z;

+ (NSArray *)locationsWithCGPoints:(NSArray *)positions;
+ (instancetype)locationWithCGPoint:(CGPoint)position;
- (instancetype)initWithX:(CGFloat)x
                        y:(CGFloat)y
                        z:(CGFloat)z;

@end
