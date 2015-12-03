//
//  INNet.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "TSNet.h"
#define DEVICE_OS 2 //ios
#define INVALID_NO -99999999

@interface INNet : TSNet {
    CFAbsoluteTime startTime;
}

@property (nonatomic, assign, readonly) NSInteger returnCode;
@property (nonatomic, strong, readonly) NSString *returnMessage;

+ (NSString*)stringForInvalidURL:(NSString*)url;

@end