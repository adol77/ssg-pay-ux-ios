//
//  ApplicationManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationManager : NSObject

+ (ApplicationManager*)sharedInstance;
+ (NSString*)version;
+ (void)applicationDidFinishLaunching;
+ (void)applicationDidEnterBackground;
+ (void)applicationWillEnterForeground;
+ (void)applicationWillTerminate;
+ (UIApplicationState)applicationStatus;
-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
