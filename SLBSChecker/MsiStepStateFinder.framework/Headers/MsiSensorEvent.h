//
//  MsiSensorEvent.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsiSensorEventProtocol.h"

extern const NSInteger SENSOR_EVENT_TYPE_UNKNOWN;
extern const NSInteger SENSOR_EVENT_TYPE_ACCELERATION;
extern const NSInteger SENSOR_EVENT_TYPE_LINEAR_ACCELERATION;

@interface MsiSensorEvent : NSObject <MsiSensorEventProtocol>
{
    NSInteger evType;
    
    NSMutableArray *orgValues;
    NSMutableArray *values;
    double timestamp;
}

@property NSMutableArray *orgValues;
@property NSMutableArray *values;
@property double timestamp;
@property NSInteger evType;

-(id)init;
-(MsiSensorEvent*)clone;

@end
