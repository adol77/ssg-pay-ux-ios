//
//  SLBSCoordination.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 21..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "SLBSCoordination.h"

@implementation SLBSCoordination

- (instancetype)initWithCoordination:(SLBSCoordination*)coordination X:(double)x Y:(double)y {
    self = [self init];
    self = coordination;
    self.x = x;
    self.y = y;
    
    return coordination;
}
@end
