//
//  MovingAverager.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovingAverager : NSObject
{
    double accumDelta;
	double mean;
	double squareMean;
	double lastDeviation;
	double lastDeviationTime;
	NSMutableArray *dataQueue;
}

@property double accumDelta;
@property double mean;
@property double squareMean;
@property double lastDeviation;
@property double lastDeviationTime;
@property NSMutableArray *dataQueue;

-(id)init;
-(id)initWithAccumDelta:(double)acDelta;
-(void)initialize;
-(double)average:(double)time value:(double)value;
-(double)getDeviation;

@end
