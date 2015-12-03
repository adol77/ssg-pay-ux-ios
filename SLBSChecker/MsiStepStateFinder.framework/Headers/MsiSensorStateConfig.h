//
//  MsiSensorStateConfig.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const float EXTRA_HIGH;
extern const float VERY_HIGH;
extern const float HIGH;
extern const float HIGHER;
extern const float MEDIUM;
extern const float LOWER;
extern const float LOW;
extern const float VERY_LOW;
extern const float EXTRA_LOW;

extern const float FALL_LOW;
extern const float FALL_MEDIUM;
extern const float FALL_HIGH;

@interface MsiSensorStateConfig : NSObject
{
    float threshold;
}

@property float threshold;

- (id)initWithThreshold:(float)th;

@end
