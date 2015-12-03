//
//  PolicyManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PolicyManager.h"
#import "DeviceNet.h"
#import "DeviceManager.h"
#import "Policy.h"
#import "TSDebugLogManager.h"

#define TEST_CODE

@implementation PolicyManager : NSObject

+ (PolicyManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static PolicyManager *sharedPolicyManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedPolicyManager = [[PolicyManager alloc] init];
    });
    return sharedPolicyManager;
}

/**
 *  서버에 Policy 데이터 요청
 *  결과값으로 받은 데이터 저장하고, Policy 정책 사용시에는 PolicyData 인터페이스 전체 접근하도록 한다.
 *
 *  @param block data 요청 성공/실패 여부와 성공시 policydata 전달
 */
- (void)requestPolicyToServerWithBlock:(void (^)(BOOL succeess, Policy* policyData ))block {
    TSGLog(TSLogGroupCommon, @"requestPolicyToServerWithBlock");
    
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    [DeviceNet requestPolicyWithAccessToken:accessToken deviceID:deviceID block:^(DeviceNet* net) {
        if(net.policyInfo) {
            Policy* policy = [Policy policyWithDictionary:net.policyInfo];
            [self setPolicy:policy];
            block(YES, policy);
        }
        else
            block(NO, nil);
    }];
}

/**
 *  Polisy 데이터 저장
 *
 *  @param policy 서버로부터 전달받은 Policy 데이터
 */
- (void)setPolicy:(Policy*)policy {
    if(policy) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"policy"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:policy];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"policy"];
    }
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"policy"];
}

/**
 *  내부 저장된 policy 정보 가져오기
 *
 *  @return Policy Data
 */
- (Policy*)policy {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"policy"];
    if (raw) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:raw];
    }
    return nil;
    
}

@end