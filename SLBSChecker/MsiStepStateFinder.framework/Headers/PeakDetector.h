//
//  PeakDetector.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeakDetectorListener.h"
#import "MovingAverager.h"

@interface PeakDetector : NSObject
{
    PeakDetectorListener *listener;
	MovingAverager *movingAverager;
    
	BOOL findingPeak;
	double maxTime, max, mVatMax, sDatMax;
	double minTime, min, mVatMin, sDatMin;
	double peakTime, peak;
	double valleyTime, valley;
}

@property PeakDetectorListener *listener;
@property MovingAverager *movingAverager;

@property BOOL findingPeak;

@property double maxTime;
@property double max;
@property double mVatMax;
@property double sDatMax;

@property double minTime;
@property double min;
@property double mVatMin;
@property double sDatMin;
@property double peakTime;
@property double peak;

@property double valleyTime;
@property double valley;

-(id)initWithListener:(PeakDetectorListener*)pdListener;
-(void)initialize;
-(void)process:(double)time value:(double)value;
-(void)setMax:(double)time value:(double)value mv:(double)mv sd:(double)sd;
-(void)setMin:(double)time value:(double)value mv:(double) mv sd:(double)sd;
-(void)setPeak:(double)time value:(double)value;
-(void)setValley:(double)time value:(double)value;
-(void)debugLog:(double)value;
@end
