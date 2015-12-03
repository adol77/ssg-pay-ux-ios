//
//  MsiStepFinder.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsiSensorStateFinder.h"
#import "LowPassFilter.h"
#import "PeakDetector.h"

@interface MsiStepFinder : MsiSensorStateFinder

{
    LowPassFilter *lowPassFilter;
	PeakDetector *PeakDetector;
    
	BOOL initialized;
	double startTimestamp;
	NSMutableArray *lastPeak; // Double Container
	NSMutableArray *lastPeakTime; // Double Container
	NSMutableArray *lastValley; // Double Container
	NSInteger peakIndex;
    
	NSMutableArray *candidate;
    
	double thresholdMax, thresholdMin;
	double lastStepTime;
}

@property LowPassFilter *lowPassFilter;
@property PeakDetector *peakDetector;

@property BOOL initialized;
@property double startTimestamp;
@property NSMutableArray *lastPeak;
@property NSMutableArray *lastPeakTime;
@property NSMutableArray *lastValley;
@property NSInteger peakIndex;

@property NSMutableArray *candidate;
@property double thresholdMax;
@property double thresholdMin;
@property double lastStepTime;

-(id)init;
-(id)initWithEventNameAndListener:(NSString *)evName listener:(MsiSensorStateListener *)evListener;
-(void)initialize;
-(void)sendStateEvent:(NSString*)status;
-(void)setConfig:(MsiSensorStateConfig*)config;
-(void)setSensorSensitivity:(float)sensitivity;
-(void)finalizeCandidate:(double)fTime;
-(void)restart;
-(void)processCandidate;
-(void)noticeStepCount:(double)stepTime;
-(void)renewThreshold;
-(double)getA:(double)pd;
-(void)processPeak:(NSInteger)peakIndex;

@end
