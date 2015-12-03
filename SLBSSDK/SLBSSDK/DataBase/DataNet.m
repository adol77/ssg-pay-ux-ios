//
//  DataNet.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 13..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "DataNet.h"
#import "TSDebugLogManager.h"
#import "SLBSCompany.h"
#import "SLBSBrand.h"
#import "SLBSBranch.h"
#import "SLBSFloor.h"

/**
 *  Company/Branch/Brand/Floor API 통신 담당
 */
@interface DataNet ()

@property (nonatomic, strong) NSArray* companyList;
@property (nonatomic, strong) NSArray* branchList;
@property (nonatomic, strong) NSArray* brandList;
@property (nonatomic, strong) NSArray* floorList;

typedef NS_ENUM(NSInteger, tagDataNetRAPI) {
    tagDataNetRAPICompany,
    tagDataNetRAPIBrand,
    tagDataNetRAPIBranch,
    tagDataNetRAPIFloor,

};

@end

@implementation DataNet

static const NSString *apiVersion         = @"/v1";
static const NSString *apiGroup           = @"/cbms";

- (instancetype)initWithAccessToken:(NSString *)token {
    self = [super init];
    if (self) {
        if ([token length] > 0) {
            [self setHeaderField:@"access_token" value:token];
        }
    }
    return self;
}

-(BOOL)processResponseData:(id)responseObject dataType:(TSNetDataType)type {
    if ( type != TSNetDataDictionary ) return NO;
    
    switch (self.tag) {
        case tagDataNetRAPICompany: {
            NSArray* companyList = [responseObject valueForKey:@"company_list"];
            NSMutableArray* tmpCompanyList = [NSMutableArray array];
            
            for(NSDictionary* companyDic in companyList) {
                SLBSCompany* company = [[SLBSCompany alloc] initWithDictionary:companyDic];
                [tmpCompanyList addObject:company];
            }
            
            self.companyList = [tmpCompanyList copy];
            return YES;
        }
        case tagDataNetRAPIBrand:{
            NSArray* brandList = [responseObject valueForKey:@"brand_list"];
            NSMutableArray* tempBrandList = [NSMutableArray array];
            
            for(NSDictionary* brandDic in brandList) {
                SLBSBrand* brand = [[SLBSBrand alloc] initWithDictionary:brandDic];
                [tempBrandList addObject:brand];
            }
            
            self.brandList = [tempBrandList copy];
            return YES;
        }
        case tagDataNetRAPIBranch:{
            NSArray* branchList = [responseObject valueForKey:@"branch_list"];
            NSMutableArray* tempBranchList = [NSMutableArray array];
            
            for(NSDictionary* branchDic in branchList) {
                SLBSBranch* branch = [[SLBSBranch alloc] initWithDictionary:branchDic];
                [tempBranchList addObject:branch];
            }
            
            self.branchList = [tempBranchList copy];
            return YES;
        }
        case tagDataNetRAPIFloor: {
            NSArray* floorList = [responseObject valueForKey:@"floor_list"];
            NSMutableArray* tempFloorList = [NSMutableArray array];
            
            for(NSDictionary* floorDic in floorList) {
                SLBSFloor* floor = [[SLBSFloor alloc] initWithDictionary:floorDic];
                [tempFloorList addObject:floor];
            }
            
            self.floorList = [tempFloorList copy];
            return YES;
        }
        default:
            return NO;
            break;
    }

    return NO;
}

/**
 *  전체 Company List 요청
 *
 *  @param token AccessToken
 *  @param block block
 */
+ (void)requestCompanyListWithAccessToken:(NSString*)token block:(void (^)(DataNet *netObject))block {
    TSGLog(TSLogGroupNetwork, @"requestCompanyListWithAccessToken");
    
    DataNet *net = [[DataNet alloc] initWithAccessToken:token];
    [net setTag:tagDataNetRAPICompany];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", apiVersion, apiGroup, @"/company.do"] URL:[NSString stringWithFormat:@"?company_id=%@", [NSNumber numberWithInt:-1]]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            DataNet* net = (DataNet*)netObject;
            TSLog(@"%s, companyList %@", __PRETTY_FUNCTION__, net.companyList);
            TSGLog(TSLogGroupNetwork, @"Request requestCompanyListWithAccessToken success %d", success);
            
            NSLog(@"Request companyList result : %d, count is %tu", success, net.companyList.count);
            block(net);
        }
        else {
            TSGLog(TSLogGroupNetwork, @"Request requestCompanyListWithAccessToken success %d", success);
            NSLog(@"Request companyList result : %d", success);
            block(net);
        }
        
    }];
}

/**
 *  특정 Company의 Brand List 요청
 *
 *  @param companyID company ID
 *  @param token     AccessToken
 *  @param block     block
 */
+ (void)requestBrandListWithCompanyID:(NSNumber*)companyID accessToken:(NSString*)token block:(void (^)(DataNet *netObject))block {
    TSGLog(TSLogGroupNetwork, @"requestBrandListWithCompanyID %@", companyID);
    
    DataNet *net = [[DataNet alloc] initWithAccessToken:token];
    [net setTag:tagDataNetRAPIBrand];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", apiVersion, apiGroup, @"/brand.do"] URL:[NSString stringWithFormat:@"?company_id=%@&brand_id=-1", companyID]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            DataNet* net = (DataNet*)netObject;
            TSLog(@"%s, brandList %@", __PRETTY_FUNCTION__, net.brandList);
            TSGLog(TSLogGroupNetwork, @"Request requestBrandListWithCompanyID success %d", success);
            
            NSLog(@"Request brandList result : %d, count is %tu", success, net.brandList.count);
            block(net);
        }
        else {
            TSGLog(TSLogGroupNetwork, @"Request requestBrandListWithCompanyID success %d", success);
            NSLog(@"Request brandList result : %d", success);
            block(net);
        }
        
    }];
}

/**
 *  특정 CompanyID, brandID, branchID의 branch List 요청
 *
 *  @param companyID company ID
 *  @param brandID   brandh ID
 *  @param branchID  branch ID
 *  @param token     AccessToken
 *  @param block     block
 */
+ (void)requestBranchListWithCompanyID:(NSNumber*)companyID brandID:(NSNumber*)brandID branchID:(NSNumber*)branchID accessToken:(NSString*)token block:(void (^)(DataNet *netObject))block {
    TSGLog(TSLogGroupNetwork, @"requestBranchListWithCompanyID %@ %@ %@", companyID, branchID, branchID);
    
    DataNet *net = [[DataNet alloc] initWithAccessToken:token];
    [net setTag:tagDataNetRAPIBranch];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", apiVersion, apiGroup, @"/branch.do"] URL:[NSString stringWithFormat:@"?company_id=%@&brand_id=%@&branch_id=%@", companyID, brandID, branchID]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            DataNet* net = (DataNet*)netObject;
            TSLog(@"%s, branchList %@", __PRETTY_FUNCTION__, net.branchList);
            TSGLog(TSLogGroupNetwork, @"Request requestBranchListWithCompanyID success %d", success);
            
            NSLog(@"Request branchList result : %d, count is %tu", success, net.branchList.count);
            block(net);
        }
        else {
            TSGLog(TSLogGroupNetwork, @"Request requestBranchListWithCompanyID success %d", success);
            NSLog(@"Request branchList result : %d", success);
            block(net);
        }
        
    }];

}

/**
 *  특정 CompanyID, brandID, branchID의 Floor List 요청
 *
 *  @param companyID company ID
 *  @param brandID   brandh ID
 *  @param branchID  branch ID
 *  @param token     AccessToken
 *  @param block     block
 */
+ (void)requesFloorListWithCompanyID:(NSNumber*)companyID brandID:(NSNumber*)brandID branchID:(NSNumber*)branchID accessToken:(NSString*)token block:(void (^)(DataNet *netObject))block {
    TSGLog(TSLogGroupNetwork, @"requesFloorListWithCompanyID %@ %@ %@", companyID, branchID, branchID);
    
    DataNet *net = [[DataNet alloc] initWithAccessToken:token];
    [net setTag:tagDataNetRAPIFloor];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", apiVersion, apiGroup, @"/floor.do"] URL:[NSString stringWithFormat:@"?company_id=%@&brand_id=%@&branch_id=%@&floor_id=-1", companyID, brandID, branchID]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            DataNet* net = (DataNet*)netObject;
            TSLog(@"%s, floorList %@", __PRETTY_FUNCTION__, net.floorList);
            TSGLog(TSLogGroupNetwork, @"Request requesFloorListWithCompanyID success %d", success);
            
            NSLog(@"Request floorList result : %d, count is %tu", success, net.floorList.count);
            block(net);
        }
        else {
            TSGLog(TSLogGroupNetwork, @"Request requesFloorListWithCompanyID success %d", success);
            NSLog(@"Request floorList result : %d", success);
            block(net);
        }
        
    }];
}

@end
