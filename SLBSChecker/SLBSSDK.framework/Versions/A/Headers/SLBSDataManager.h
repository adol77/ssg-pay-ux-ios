//
//  SLBSDataManager.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 13..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SLBSDataManagerDelegate <NSObject>
- (void)onServiceReady;
@end

@interface SLBSDataManager : NSObject

@property (weak, nonatomic) id<SLBSDataManagerDelegate> delegate;

+ (SLBSDataManager*)sharedInstance;

- (void)startMonitoring;
- (void)stopMonitoring;

- (void)requestCompanyListWithBlock:(void (^)(NSArray *companyArray, NSInteger resultCode))block;
- (void)requestBrandListWithCompanyId:(NSInteger)companyId block:(void (^)(NSArray *brandArray, NSInteger resultCode))block;
- (void)requestBranchListWithCompanyId:(NSInteger)companyId brandId:(NSInteger)brandId branchId:(NSInteger)branchId block:(void (^)(NSArray *branchArray, NSInteger resultCode))block;
- (void)requestFloorListWithCompanyId:(NSInteger)companyId brandId:(NSInteger)brandId branchId:(NSInteger)branchId block:(void (^)(NSArray *branchArray, NSInteger resultCode))block;
- (void)requestZoneListWithBranchID:(NSNumber*)branchId block:(void (^)(NSArray *zoneListArray, NSInteger resultCode))block;

- (void)setUserAccountName:(NSString*)accountName;
- (void)setLocationAgreement:(BOOL)agree ;
@end
