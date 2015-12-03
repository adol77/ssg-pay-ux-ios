//
//  SLBSLogEntity+description.m
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 21..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import "SLBSLogEntity+description.h"
#import <SLBSSDK/TSDebugLogManager.h>

@implementation SLBSLogEntity (description)

- (NSString *)descriptionForLog {
    return [NSString stringWithFormat:@"{\n\tGROUP  : %@\t\tDate: %@\n\tmethod : %@\n\tmessage: %@\n}\n", [TSLogEntity stringFromGroup:[self.group integerValue]], [self.date simpleString:@"yyyy-MM-dd HH:mm:ss"], self.selectorName, self.message];
}

@end
