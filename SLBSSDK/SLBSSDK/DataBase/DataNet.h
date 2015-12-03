//
//  DataNet.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 13..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INNet.h"

@interface DataNet : INNet
@property (readonly) NSArray* companyList;
@property (readonly) NSArray* branchList;
@property (readonly) NSArray* brandList;
@property (readonly) NSArray* floorList;

+ (void)requestCompanyListWithAccessToken:(NSString*)token block:(void (^)(DataNet *netObject))block;
+ (void)requestBrandListWithCompanyID:(NSNumber*)companyID accessToken:(NSString*)token block:(void (^)(DataNet *netObject))block;
+ (void)requestBranchListWithCompanyID:(NSNumber*)companyID brandID:(NSNumber*)brandID branchID:(NSNumber*)branchID accessToken:(NSString*)token block:(void (^)(DataNet *netObject))block;
+ (void)requesFloorListWithCompanyID:(NSNumber*)companyID brandID:(NSNumber*)brandID branchID:(NSNumber*)branchID accessToken:(NSString*)token block:(void (^)(DataNet *netObject))block;
@end
