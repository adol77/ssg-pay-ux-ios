//
//  NSString+SafeCreation.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 1..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SafeCreation)

+ (NSString *)stringWithUnsafeString:(NSString *)string;

@end
