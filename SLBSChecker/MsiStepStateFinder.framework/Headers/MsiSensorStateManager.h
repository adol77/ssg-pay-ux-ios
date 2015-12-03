//
//  MsiSensorStateManager.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsiSensorStateFinder.h"
#import "MsiSensorEvent.h"

extern NSString *FALL;   /** 낙상 */
extern NSString *STEP;   /** 걸음 */
extern NSString *STEP_PEAK; /** 걸음 (peak) */
extern NSString *SHAKE; /** 흐들림 */

@interface MsiSensorStateManager : NSObject
{
    NSMutableArray *finderList; // Msi Sensor State Finder list
}

@property NSMutableArray *finderList;

-(id)init;
-(void)addFinder:(MsiSensorStateFinder*)finder;
-(void)removeFinder:(MsiSensorStateFinder*)finder;
-(void)findState:(MsiSensorEvent*)event;
-(void)preProcessing:(MsiSensorEvent*)event;
-(void)processing:(MsiSensorEvent*)event;
-(void)postProcessing:(MsiSensorEvent*)event;
@end
