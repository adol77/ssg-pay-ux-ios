//
//  GFDebug.h
//
//  Created by Lee mu hyeon on 2013. 11. 25..
//  Copyright (c) 2013년 nenmustech. All rights reserved.
//

#ifndef GFDEBUG_H
#define GFDEBUG_H

#ifdef GFDEBUG_ENABLE
#warning    GFDEBUG_ENABLE(Mode ON)

#define CJK_LOG_ENABLE 0
static inline NSString* NStringForCJKFromUTF8(NSString *str) {
#if CJK_LOG_ENABLE
#warning    2Byte Unicode Debug Log Enabled
    NSString* strT= [str stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)strT, NULL, transform, YES);
    
    return strT;
#else
    return str;
#endif
}

#define GFMI		NSLog(@"\n>>> Entering Method %s", __PRETTY_FUNCTION__)
#define GFMO		NSLog(@"\n>>> Outtering Method %s", __PRETTY_FUNCTION__)

#if CJK_LOG_ENABLE
#define GFLog(s, ...)	\
NSLog(@"\nMethod:%s {\n\t%@\n}\n", __PRETTY_FUNCTION__, NStringForCJKFromUTF8([NSString stringWithFormat:(s), ##__VA_ARGS__]));
#else
#define GFLog(s, ...)	\
NSLog(@"\nMethod:%s {\n\t%@\n}\n", __PRETTY_FUNCTION__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);
#endif

#else
#define GFMI
#define GFLog( s, ... )
#endif

#define resultstr(success)  success?@"success":@"fail"
#define boolstr(boolValue)  boolValue?@"YES":@"NO"

#endif
