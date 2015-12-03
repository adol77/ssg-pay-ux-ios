//
//  LowPassFilter.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

@interface LowPassFilter : NSObject
{
    double rc;
	double lastTime;
	double lastFilteredValue;
}

@property double rc;
@property double lastTime;
@property double lastFilteredValue;

-(id)init;
-(id)initWithCutOffFreq:(double)cutOffFreq;
-(void)initialize;
-(double)filter:(double)time value:(double)value;

@end
