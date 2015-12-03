//
//  DateTimeUtil.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/1/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateTimeUtil : NSObject

+ (int)getCurrentWeekOfMonth;
+ (int)getCurrentWeekday;
+ (int)getCurrentDay;
+ (int)getDayByDate:(NSDate*)date;
+ (NSTimeInterval)getCurrentDateInterval;
+ (NSDate*)convertTimeInterval:(NSTimeInterval)interval;
+ (NSString*)convertDate:(NSDate*)date;

@end
