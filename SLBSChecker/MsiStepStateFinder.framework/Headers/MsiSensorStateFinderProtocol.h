//
//  MsiSensorStateFinderProtocol.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsiSensorEvent.h"
#import "MsiSensorStateConfig.h"

@protocol MsiSensorStateFinderProtocol <NSObject>
- (void)processState:(MsiSensorEvent *) event;
- (void)setConfig:(MsiSensorStateConfig *) config;
@end

