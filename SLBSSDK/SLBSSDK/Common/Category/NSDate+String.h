//
//  NSDate+String.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 1..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (String)

+ (NSDate *)dateFromUnsafeString:(NSString *)string format:(NSString *)format;

@end
