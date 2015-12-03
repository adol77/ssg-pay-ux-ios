//
//  LSPowerManagePolicy.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "LSPowerManagePolicy.h"

@implementation LSPowerManagePolicy
@synthesize scanMode;

-(instancetype)init:(LSScanMode)mode
{
    if ( self = [super init] ) {
        scanMode = mode;
    }
    return self;
}

+(instancetype)periodicPolicy
{
    return [[self alloc] init:PERIODIC_SCAN];
}

+(instancetype)fullPolicy
{
    return [[self alloc] init:FULL_SCAN];
}

+(instancetype)defaultPolicy
{
    return self.fullPolicy;
}



@end
