//
//  NSString+SafeCreation.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 1..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "NSString+SafeCreation.h"

@implementation NSString (SafeCreation)

+ (NSString *)stringWithUnsafeString:(NSString *)string {
    if (([string isKindOfClass:[NSString class]] == YES) && ([string length] > 0)) {
        return [NSString stringWithString:string];
    }
    return @"";
}


@end
