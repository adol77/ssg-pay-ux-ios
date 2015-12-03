//
//  MsiSensorStateListenerProtocol.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsiSensorStateEvent.h"

@protocol MsiSensorStateListenerProtocol <NSObject>
- (void)onSensorStateChanged:(MsiSensorStateEvent*)event;
@end
