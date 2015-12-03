//
//  LogDataManager.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogDataManager : NSObject

+ (LogDataManager*)sharedInstance;

#pragma Route Log
- (void)setRoutes:(NSArray*)routes;
- (NSArray*)routes;
- (void)removeRoutes;

#pragma Route Log
- (void)setLogs:(NSArray*)logs;
- (NSArray*)logs;
- (void)removeLogs;

@end
