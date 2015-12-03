//
//  AppDataManager.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/9/15.
//  Copyright (c) 2015 Regina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDataManager : NSObject

@property (nonatomic, strong) NSArray *companyArray;
@property (nonatomic, strong) NSArray *brandArray;
@property (nonatomic, strong) NSArray *branchArray;
@property (nonatomic, strong) NSArray *floorArray;
@property (nonatomic, strong) NSArray *curDirectionArray;

@property (nonatomic, strong) NSMutableArray *zoneListArray;
@property (nonatomic, strong) NSMutableArray *zoneListSearchArray;

@property (nonatomic, strong) NSMutableArray *campaignArray;

+ (AppDataManager*)sharedInstance;

@end
