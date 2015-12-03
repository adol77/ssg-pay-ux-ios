//
//  BLEProximity.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEProximity.h"

@implementation BLEProximity {
    id<BLEProximityListener> listener;
}

-(instancetype)init
{
    self = [super init];
    return self;
}

-(void)setListener:(id<BLEProximityListener>)_listener
{
    listener = _listener;
}

@end
