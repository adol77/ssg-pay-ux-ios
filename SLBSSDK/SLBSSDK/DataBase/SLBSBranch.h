//
//  SLBSBranch.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBSBranch : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)source;
+ (SLBSBranch*)branchWithDictionary:(NSDictionary*)source;

@property (nonatomic, readonly) NSNumber* branchId;
@property (nonatomic, readonly) NSNumber* companyId;
@property (nonatomic, readonly) NSNumber* brandId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSString *desc;
@property (nonatomic, readonly) NSString *imageUrl;
@property (nonatomic, readonly) NSString *iconUrl;
@property (nonatomic, readonly) NSNumber* active;   // 1: 영업중, 2: 공사중
@property (nonatomic, readonly) NSString* brandName;
@property (nonatomic, readonly) NSString* companyName;
@property (nonatomic, readonly) NSNumber* default_floor_id;
@property (nonatomic, readonly) NSNumber* rootbranch_id;
@property (nonatomic, readonly) NSArray* branch_biz_off_list;
@property (nonatomic, readonly) NSArray* branch_biz_time_list;

@end
