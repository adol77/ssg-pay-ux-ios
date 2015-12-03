//
//  MovingAveragerDataContainer.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovingAveragerDataContainer : NSObject
{
    double time;
    double value;
}

@property double time;
@property double value;

-(id)init;
-(id)initWithTimeAndValue:(double)t v:(double)v;

@end
