//
//  MsiSensorStateEvent.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsiSensorStateEvent : NSObject
{
    NSString *eventState;   /** 이벤트의 종류를 나타낸다. */
	double timestamp;         /**이벤트가 발생한 시각을 나타낸다. 단위는 millisecond 이다. */
	NSString *eventName;    /** 이벤트의 이름을 나타낸다. */
}

@property NSString *eventState;
@property double timestamp;
@property NSString *eventName;

- (id)initWithEventNameAndEventState:(NSString*)evName evState:(NSString*)evState;
- (NSString *)getXml;
@end

