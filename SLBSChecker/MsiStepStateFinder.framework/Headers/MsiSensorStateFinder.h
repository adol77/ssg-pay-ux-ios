//
//  MsiSensorStateFinder.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MsiSensorStateFinderProtocol.h"
#import "MsiSensorStateListener.h"

@interface MsiSensorStateFinder : NSObject <MsiSensorStateFinderProtocol>
{
    NSString* eventName;
	MsiSensorStateListener *listener; /** 이벤트를 전달받을 리스너 */
}

@property NSString *eventName;
@property MsiSensorStateListener *listener;

- (id)initWithEventNameAndListener:(NSString *)evName listener:(MsiSensorStateListener *)evListener;

@end

