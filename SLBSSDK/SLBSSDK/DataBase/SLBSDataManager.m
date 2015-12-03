//
//  SLBSDataManager.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 13..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "SLBSDataManager.h"
#import "SLBSKit.h"
#import "ZoneNet.h"
#import "DeviceManager.h"
#import "DataManager.h"
#import "DataNet.h"
#import "ZoneDataManager.h"
#import "LOCLocationEngine.h"

@interface SLBSDataManager () <SLBSKitDataDelegate> {
    BOOL running;
}
@end

@implementation SLBSDataManager : NSObject

+ (SLBSDataManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static SLBSDataManager *sharedDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedDataManager = [[SLBSDataManager alloc] init];
    });
    return sharedDataManager;
}


- (void)startMonitoring {
    if ( running ) return;
    running = YES;
    
    [[SLBSKit sharedInstance] setDataDelegate:self];
    [[SLBSKit sharedInstance] startService:SLBSServiceData];
}

- (void)stopMonitoring {
    TSGLog(TSLogGroupLocation, @"stopMonitoring");
    
    if ( !running ) return;
    [[SLBSKit sharedInstance] setDataDelegate:nil];
    [[SLBSKit sharedInstance] stopService];
    running = NO;

}

- (void)requestCompanyListWithBlock:(void (^)(NSArray *companyArray, NSInteger resultCode))block {
    NSArray* companies = [[DataManager sharedInstance] companies];
    
    if(companies.count > 0)
        block(companies, 0);
    else {
        NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
        [DataNet requestCompanyListWithAccessToken:accessToken block:^(DataNet* net) {
            if(net.returnCode == 0)
               [[DataManager sharedInstance] setCompanies:net.companyList];
            
            block(net.companyList, net.returnCode);
        }];
    }
        
}

- (void)requestBrandListWithCompanyId:(NSInteger)companyId block:(void (^)(NSArray *brandArray, NSInteger resultCode))block {
    //NSArray* brands = [[DataManager sharedInstance] brands];
    
    //if(brands.count > 0)
    //    block(brands, 0);
    //else {
        NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
        [DataNet requestBrandListWithCompanyID:[NSNumber numberWithInteger:companyId] accessToken:accessToken block:^(DataNet* net) {
            if(net.returnCode == 0)
                [[DataManager sharedInstance] setBrands:net.brandList];
            
            block(net.brandList, net.returnCode);
        }];
    //}
}

- (void)requestBranchListWithCompanyId:(NSInteger)companyId brandId:(NSInteger)brandId branchId:(NSInteger)branchId block:(void (^)(NSArray *branchArray, NSInteger resultCode))block {
   // NSArray* branches = [[DataManager sharedInstance] branches];
    
   // if(branches.count > 0)
   //     block(branches, 0);
   // else {
        NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
        [DataNet requestBranchListWithCompanyID:[NSNumber numberWithInteger:companyId] brandID:[NSNumber numberWithInteger:brandId] branchID:[NSNumber numberWithInteger:branchId] accessToken:accessToken block:^(DataNet* net) {
            if(net.returnCode == 0)
                [[DataManager sharedInstance] setBranches:net.branchList];
            
            block(net.branchList, net.returnCode);
        }];
    //}
}

- (void)requestFloorListWithCompanyId:(NSInteger)companyId brandId:(NSInteger)brandId branchId:(NSInteger)branchId block:(void (^)(NSArray *floorArray, NSInteger resultCode))block {
    //NSArray* floors = [[DataManager sharedInstance] floors];
    
    //if(floors.count > 0)
    //    block(floors, 0);
    //else {
        NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
        [DataNet requesFloorListWithCompanyID:[NSNumber numberWithInteger:companyId] brandID:[NSNumber numberWithInteger:brandId] branchID:[NSNumber numberWithInteger:branchId] accessToken:accessToken block:^(DataNet* net) {
            if(net.returnCode == 0)
                [[DataManager sharedInstance] setFloors:net.floorList];
            
            block(net.floorList, net.returnCode);
        }];
    //}

}

- (void)requestZoneListWithBranchID:(NSNumber*)branchId block:(void (^)(NSArray *zoneListArray, NSInteger resultCode))block {
    NSArray* zones = [[ZoneDataManager sharedInstance] zonesForBranchID:branchId];
    
    if(zones.count > 0)
        block(zones, 0);
    else {
        
        NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
        [ZoneNet requestZoneListWithBranchID:branchId accessToken:accessToken block:^(ZoneNet* net) {
            if(net.returnCode == 0)
                [[ZoneDataManager sharedInstance] setZones:net.zoneList];
            block(net.zoneList, net.returnCode);
        }];
    }
   
}

- (void)onServiceReady {
    [self.delegate onServiceReady];
}

- (void)setUserAccountName:(NSString*)accountName {
    [[DataManager sharedInstance] setAccountName:accountName];
}

- (void)setLocationAgreement:(BOOL)agree {
    [[DataManager sharedInstance] setLocationLocationUsageAgreement:agree];
    [[LOCLocationEngine sharedInstance] setLocationUsageAgreement:agree];
}
@end
