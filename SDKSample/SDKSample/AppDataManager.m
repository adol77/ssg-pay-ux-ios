//
//  NetworkDataManager.m
//  SDKSample
//
//  Created by Jeoungsoo on 9/9/15.
//  Copyright (c) 2015 Regina. All rights reserved.
//

#import "AppDataManager.h"

@interface AppDataManager()

@end

@implementation AppDataManager

+ (AppDataManager*)sharedInstance {
    static dispatch_once_t oncePredicate;
    static AppDataManager *sharedDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedDataManager = [[AppDataManager alloc] init];
    });
    return sharedDataManager;
}

@end
