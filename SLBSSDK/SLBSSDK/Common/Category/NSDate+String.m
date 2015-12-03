//
//  NSDate+String.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 1..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "NSDate+String.h"

@implementation NSDate (String)

+ (NSDate *)dateFromUnsafeString:(NSString *)string format:(NSString *)format {
    if (([string isKindOfClass:[NSString class]] == YES) && ([string length] > 0)) {
        if (format == nil || ([format length] <= 0)) {
            format = @"yyyy-MM-dd HH:mm:ss";
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        NSDate *date = [formatter dateFromString:string];
        return date;
    }
    return nil;
}


@end
