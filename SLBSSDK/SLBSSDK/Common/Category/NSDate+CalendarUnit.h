//
//  NSDate+CalendarUnit.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarUnit)

- (NSInteger)weeksOfMonth:(int)month inYear:(int)year;
- (NSInteger)weeksOfDate:(NSDate *)date;

@end
