//
//  DateTimeUtil.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/1/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "DateTimeUtil.h"

@implementation DateTimeUtil


+ (int)getCurrentWeekOfMonth {
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calender
                                       components:(NSCalendarUnitWeekOfMonth)
                                       fromDate:[NSDate date]];
    return (int)dateComponent.weekOfMonth;
}

+ (int)getCurrentWeekday {
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calender
                                       components:(NSCalendarUnitWeekOfMonth)
                                       fromDate:[NSDate date]];
    return (int)dateComponent.weekday;
}

+ (int)getCurrentDay {
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calender
                                       components:(NSCalendarUnitDay)
                                       fromDate:[NSDate date]];
    return (int)dateComponent.day;
}

+ (int)getDayByDate:(NSDate*)date {
    NSCalendar *calender = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComponent = [calender
                                       components:(NSCalendarUnitDay)
                                       fromDate:date];
    return (int)dateComponent.day;
}


+ (NSTimeInterval)getCurrentDateInterval {
    return [[NSDate date] timeIntervalSince1970];
}

+ (NSDate*)convertTimeInterval:(NSTimeInterval)interval {
    return [[NSDate alloc] initWithTimeIntervalSince1970:interval];
}

+ (NSString*)convertDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    return [dateFormatter stringFromDate:date];
}

@end
