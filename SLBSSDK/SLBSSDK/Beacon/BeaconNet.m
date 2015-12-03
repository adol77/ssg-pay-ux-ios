//
//  BeaconNet.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "BeaconNet.h"
#import "BeaconDataManager.h"
#import "Beacon.h"
#import "TSDebugLogManager.h"
#import "BeaconUUID.h"

@interface BeaconNet ()

@property (nonatomic, strong) NSArray *beaconList;
@property (nonatomic, strong) NSArray *uuidList;


@end


@implementation BeaconNet

const NSString *beaconApiVersion         = @"/v1";
const NSString *beaconApiGroup           = @"/bms";


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
    
    NSArray* beaconList = [responseObject valueForKey:@"beacon_list"];
    if (beaconList) {
        self.beaconList = beaconList;
        return YES;
    }
    
    NSArray* uuidList = [responseObject valueForKey:@"company_uuid_list"];
    if(uuidList) {
        self.uuidList = uuidList;
        return YES;
    }
    
    return NO;
}


+(void)requestBeaconListWithAccessToken:(NSString *)token block:(void (^)(BeaconNet *))block {
    TSGLog(TSLogGroupNetwork, @"requestBeaconListWithAccessToken");
    NSNumber* totalNum = [NSNumber numberWithInt:-1];
    [self requestBeaconListWithCompanyID:totalNum branchID:totalNum floorID:totalNum token:token block:^(BeaconNet* net){
        block(net);
    }];
}

/**
 *  company, branch, floor 값으로 Beacon 정보 가져오는 함수
 *
 *  @param companyID  company id
 *  @param branchID  branch id
 *  @param floorID   floor id
 *  @param token     access token
 *  @param block     block
 */
+(void)requestBeaconListWithCompanyID:(NSNumber *)companyID branchID:(NSNumber *)branchID floorID:(NSNumber *)floorID token:(NSString *)token block:(void (^)(BeaconNet *))block {
    TSGLog(TSLogGroupNetwork, @"requestBeaconListWithCompanyID companyID %@ branchID %@ floorID %@", companyID, branchID, floorID);
    
    BeaconNet *net = [[BeaconNet alloc] initWithAccessToken:token];
    NSString* parameterURL = [NSString stringWithFormat:@"?company_id=%@&branch_id=%@&floor_id=%@&validity=1&page_index=-1&record_count_per_page=-1&order_by=-1", companyID, branchID, floorID];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", beaconApiVersion, beaconApiGroup, @"/beacon.do"] URL:parameterURL];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            BeaconNet* net = (BeaconNet*)netObject;
            //TSLog(@"%s, net.beaconList %@", __PRETTY_FUNCTION__, net.beaconList);
            NSMutableArray *beaconList = [NSMutableArray array];
            for(NSDictionary *beaconDic in net.beaconList) {
                //NSLog(@"%s, beaconDic %@", __PRETTY_FUNCTION__, beaconDic);
                Beacon* beacon = [Beacon beaconWithDictionary:beaconDic];
                [beaconList addObject:beacon];
            }
            
            [[BeaconDataManager sharedInstance] setBeacons:beaconList];
            
            NSLog(@"Request beaconList result : %d, count is %tu", success, beaconList.count);
            TSGLog(TSLogGroupNetwork, @"Request BeaconListWithCompanyID %d", success);
            block(net);
        }
        else {
            NSLog(@"Request beaconList result : %d", success);
            TSGLog(TSLogGroupNetwork, @"Request BeaconList %d", success);

            block(net);
        }
        
    }];
}

+(void)requestBeaconListWithUUID:(NSString *)uuid major:(NSNumber *)major minor:(NSNumber *)minor token:(NSString *)token block:(void (^)(BeaconNet *))block {
    TSGLog(TSLogGroupNetwork, @"requestBeaconListWithUUID UUID %@ major %@ minor %@", uuid, major, minor);

    BeaconNet *net = [[BeaconNet alloc] initWithAccessToken:token];
    NSString* parameterURL = [NSString stringWithFormat:@"?uuid = %@&major =%@&minor=%@", uuid, major, minor];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", beaconApiVersion, beaconApiGroup, @"/beaconsbyuuid.do"] URL:parameterURL];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            BeaconNet* net = (BeaconNet*)netObject;
            TSLog(@"%s, net.beaconList %@", __PRETTY_FUNCTION__, net.beaconList);
            NSMutableArray *beaconList = [NSMutableArray array];
            for(NSDictionary *beaconDic in net.beaconList) {
                NSLog(@"%s, beaconDic %@", __PRETTY_FUNCTION__, beaconDic);
                Beacon* beacon = [Beacon beaconWithDictionary:beaconDic];
                [beaconList addObject:beacon];
            }
            
            [[BeaconDataManager sharedInstance] setBeacons:beaconList];
            
            NSLog(@"Request beacon list result : %d, count is %tu", success, beaconList.count);
            TSGLog(TSLogGroupNetwork, @"Request BeaconListWithUUID %d", success);
            block(net);
        }
        else {
            NSLog(@"Request beacon list result : %d", success);
            TSGLog(TSLogGroupNetwork, @"Request BeaconListWithUUID %d", success);
            block(net);
        }
        
    }];
}


+(void)requestUUIDListWithAccessToken:(NSString *)token block:(void (^)(BeaconNet *))block {
    TSGLog(TSLogGroupNetwork, @"requestUUIDListWithAccessToken");
    NSNumber* totalNum = [NSNumber numberWithInt:-1];
    [self requestUUIDListWithCompanyID:totalNum token:token block:^(BeaconNet* net){
        block(net);
    }];
}



+(void)requestUUIDListWithCompanyID:(NSNumber *)companyID token:(NSString *)token block:(void (^)(BeaconNet *))block {
    TSGLog(TSLogGroupNetwork, @"requestUUIDListWithCompanyID companyID %@ ", companyID);

    BeaconNet *net = [[BeaconNet alloc] initWithAccessToken:token];
    NSString* parameterURL = [NSString stringWithFormat:@"?company_id=%@", companyID];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", beaconApiVersion, beaconApiGroup, @"/company_uuid.do"] URL:parameterURL];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            BeaconNet* net = (BeaconNet*)netObject;
            NSLog(@"%s, net.uuidList %@", __PRETTY_FUNCTION__, net.uuidList);
            NSMutableArray *beaconUUIDList = [NSMutableArray array];
            for(NSDictionary *uuidDic in net.uuidList) {
                NSLog(@"%s, uuidDic %@", __PRETTY_FUNCTION__, uuidDic);
                BeaconUUID* beaconUUID = [BeaconUUID beaconUUIDWithDictionary:uuidDic];
                [beaconUUIDList addObject:beaconUUID];
            }
            
            [[BeaconDataManager sharedInstance] setUUIDs:beaconUUIDList];
            
            NSLog(@"Request UUID List result : %d, count is %tu", success, beaconUUIDList.count);
             TSGLog(TSLogGroupNetwork, @"Request UUIDListByCompanyID %d", success);
            
            block(net);
        }
        else {
            NSLog(@"Request UUID List result : %d", success);
              TSGLog(TSLogGroupNetwork, @"Request UUIDListByCompanyID %d", success);
            block(net);
        }
        
    }];
}


@end
