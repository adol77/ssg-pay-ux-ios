//
//  MsiStepFinderPeakDetectorListener.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PeakDetectorListener.h"
#import "MsiStepFinder.h"

@class MsiStepFinder;

@interface MsiStepFinderPeakDetectorListener : PeakDetectorListener
{
    MsiStepFinder *msiStepFinder;
}

@property MsiStepFinder *msiStepFinder;
-(id)init:(MsiStepFinder*)msf;
@end
