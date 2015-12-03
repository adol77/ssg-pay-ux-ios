//
//  LogDataManager.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "LogDataManager.h"

@implementation LogDataManager

+ (LogDataManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static LogDataManager *sharedLogDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedLogDataManager = [[LogDataManager alloc] init];
    });
    return sharedLogDataManager;
}

#pragma Route Log
/**
 *  Route 로그 저장
 *
 *  @param routes route 로그
 */
- (void)setRoutes:(NSArray*)routes {
    if (routes) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"routes"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:routes];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"routes"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"routes"];
    }
}

/**
 *  Route 로그 가져오기
 *
 *  @return RouteLog array
 */
- (NSArray*)routes {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"routes"];
    if (raw) {
        NSArray* ret = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return ret;
    }
    return nil;
}

/**
 *  Routes 로그 삭제
 */
- (void) removeRoutes {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"routes"];
}


#pragma Route Log
/**
 *  AppTraking/Device 로그 저장
 *
 *  @param logs apptraking/device 로그
 */
- (void)setLogs:(NSArray*)logs {
    if (logs) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logs"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:logs];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"logs"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logs"];
    }
}

/**
 *  AppTracking/Device 로그 가져오기
 *
 *  @return Log Array
 */
- (NSArray*)logs {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"logs"];
    if (raw) {
        NSArray* ret = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return ret;
    }
    return nil;
}

/**
 *  AppTracking/Device 로그 삭제
 */
- (void)removeLogs {
     [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"logs"];
}


@end
