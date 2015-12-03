//
//  ApplicationManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  App의 Background/Foreground 상태값 관리
 */
@interface ApplicationManager : NSObject

+ (ApplicationManager*)sharedInstance;
+ (NSString*)version;
+ (void)applicationDidFinishLaunching;
+ (void)applicationDidEnterBackground;
+ (void)applicationWillEnterForeground;
+ (void)applicationWillTerminate;
+ (UIApplicationState)applicationStatus;

/**
 *  Background Fetch시 실제 작업 수행
 *  Policy, Zone,ZomeCampaign, Beacon, UUID  update
 *
 *  @param completionHandler <#completionHandler description#>
 */
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
