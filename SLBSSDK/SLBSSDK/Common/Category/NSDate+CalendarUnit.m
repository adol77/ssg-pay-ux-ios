//
//  NSDate+CalendarUnit.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "NSDate+CalendarUnit.h"

@implementation NSDate (CalendarUnit)

//http://stackoverflow.com/questions/15243443/how-to-get-the-number-of-weeks-in-a-month
- (NSInteger)weeksOfMonth:(int)month inYear:(int)year {
    NSString *dateString=[NSString stringWithFormat:@"%4d/%d/1",year,month];
    
    NSDateFormatter *dfMMddyyyy=[NSDateFormatter new];
    [dfMMddyyyy setDateFormat:@"yyyy/MM/dd"];
    NSDate *date=[dfMMddyyyy dateFromString:dateString];
    
    NSCalendar *calender = [NSCalendar currentCalendar];
//    NSRange weekRange = [calender rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSRange weekRange = [calender rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date];//컴파일 경고로 임의 수정. 확인 필요
    NSInteger weeksCount=weekRange.length;
    
    return weeksCount;
}

- (NSInteger)weeksOfDate:(NSDate *)date {
    NSCalendar *calender = [NSCalendar currentCalendar];
    //    NSRange weekRange = [calender rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    NSRange weekRange = [calender rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:date];//컴파일 경고로 임의 수정. 확인 필요
    NSInteger weeksCount=weekRange.length;
    
    return weeksCount;
}

@end
