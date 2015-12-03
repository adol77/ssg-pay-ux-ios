//
//  ZoneNet.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "ZoneNet.h"
#import "TSDebugLogManager.h"
#import "DeviceManager.h"
#import "ZoneDataManager.h"
#import "Zone.h"

@interface ZoneNet ()

@property (nonatomic, strong) NSArray *zoneList;

@end

@implementation ZoneNet

static const NSString *zoneApiVersion         = @"/v1";
static const NSString *zoneApiGroup           = @"/zms";

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
    
    NSArray* zoneList = [responseObject valueForKey:@"zone_array"];
    if (zoneList) {
        self.zoneList = zoneList;
        return YES;
    }
    return NO;
}

+ (void)requestZoneListWithAccessToken:(NSString*)token block:(void (^)(ZoneNet *netObject))block {
    TSGLog(TSLogGroupZone, @"requestZoneListWithAccessToken");
    
    ZoneNet *net = [[ZoneNet alloc] initWithAccessToken:token];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", zoneApiVersion, zoneApiGroup, @"/zone.do"] type:TSNetMethodTypeGET];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            ZoneNet* net = (ZoneNet*)netObject;
            TSLog(@"%s, net.zoneList %@", __PRETTY_FUNCTION__, net.zoneList);
            NSMutableArray *zoneList = [NSMutableArray array];
            for(NSDictionary *zoneDic in net.zoneList) {
                NSLog(@"%s, zoneDic %@", __PRETTY_FUNCTION__, zoneDic);
                Zone* zone = [Zone zoneWithDictionary:zoneDic];
                [zoneList addObject:zone];
            }
            
            [[ZoneDataManager sharedInstance] setZones:zoneList];
            
            TSGLog(TSLogGroupZone, @"Request ZoneList success %d", success);
            NSLog(@"Request zoneList result : %d, count is %tu", success, zoneList.count);
            block(net);
        }
        else {
            TSGLog(TSLogGroupZone, @"Request ZoneList success %d", success);
            NSLog(@"Request zoneList result : %d", success);
            block(net);
        }
        
    }];
}


+ (void)requestZoneWithID:(NSNumber *)zoneID accessToken:(NSString*)token block:(void (^)(ZoneNet *netObject))block {
    TSGLog(TSLogGroupZone, @"requestZoneWithID %@", zoneID);
    
    ZoneNet *net = [[ZoneNet alloc] initWithAccessToken:token];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", zoneApiVersion, zoneApiGroup, @"/zone"] URL:[NSString stringWithFormat:@"/%@", zoneID]];

    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            ZoneNet* net = (ZoneNet*)netObject;
            TSLog(@"%s, net.zoneList %@", __PRETTY_FUNCTION__, net.zoneList);
            NSMutableArray *zoneList = [NSMutableArray array];
            for(NSDictionary *zoneDic in net.zoneList) {
                NSLog(@"%s, zoneDic %@", __PRETTY_FUNCTION__, zoneDic);
                Zone* zone = [Zone zoneWithDictionary:zoneDic];
                [zoneList addObject:zone];
            }
            
            [[ZoneDataManager sharedInstance] setZones:zoneList];
            
             TSGLog(TSLogGroupZone, @"Request ZoneListWithZoneID success %d", success);
            NSLog(@"Request zoneList result : %d, count is %tu", success, (int)zoneList.count);
            block(net);
        }
        else {
             TSGLog(TSLogGroupZone, @"Request ZoneListWithZoneID success %d", success);
            NSLog(@"Request zoneList result : %d", success);
            block(net);
        }
        
    }];

}


+ (void)requestZoneListWithMapID:(NSNumber *)mapID accessToken:(NSString*)token block:(void (^)(ZoneNet *netObject))block {
     TSGLog(TSLogGroupZone, @"requestZoneListWithMapID %@", mapID);
    
    ZoneNet *net = [[ZoneNet alloc] initWithAccessToken:token];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", zoneApiVersion, zoneApiGroup, @"/zone"] URL:[NSString stringWithFormat:@"?map_id=%@", mapID]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            ZoneNet* net = (ZoneNet*)netObject;
            TSLog(@"%s, net.zoneList %@", __PRETTY_FUNCTION__, net.zoneList);
            NSMutableArray *zoneList = [NSMutableArray array];
            for(NSDictionary *zoneDic in net.zoneList) {
                NSLog(@"%s, zoneDic %@", __PRETTY_FUNCTION__, zoneDic);
                Zone* zone = [Zone zoneWithDictionary:zoneDic];
                [zoneList addObject:zone];
            }
            
             TSGLog(TSLogGroupZone, @"Request ZoneListWithMapID success %d", success);
            
            NSLog(@"Request zoneList result : %d, count is %tu", success, zoneList.count);
            block(net);
        }
        else {
             TSGLog(TSLogGroupZone, @"Request ZoneListWithMapID success %d", success);
            NSLog(@"Request zoneList result : %d", success);
            block(net);
        }
        
    }];
}

+ (void)requestZoneListWithBranchID:(NSNumber *)branchID accessToken:(NSString*)token block:(void (^)(ZoneNet *netObject))block {
    TSGLog(TSLogGroupZone, @"requestZoneListWithBranchID %@", branchID);
    
    ZoneNet *net = [[ZoneNet alloc] initWithAccessToken:token];
    //zms/closed_branch.do
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", zoneApiVersion, zoneApiGroup, @"/closed_branch.do"] URL:[NSString stringWithFormat:@"?branch_id=%@", branchID]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            ZoneNet* net = (ZoneNet*)netObject;
            TSLog(@"%s, net.zoneList %@", __PRETTY_FUNCTION__, net.zoneList);
            NSMutableArray *zoneList = [NSMutableArray array];
            for(NSDictionary *zoneDic in net.zoneList) {
                NSLog(@"%s, zoneDic %@", __PRETTY_FUNCTION__, zoneDic);
                Zone* zone = [Zone zoneWithDictionary:zoneDic];
                [zoneList addObject:zone];
            }
            
            TSGLog(TSLogGroupZone, @"Request requestZoneListWithBranchID success %d", success);
            
            NSLog(@"Request zoneList result : %d, count is %tu", success, zoneList.count);
            block(net);
        }
        else {
            TSGLog(TSLogGroupZone, @"Request requestZoneListWithBranchID success %d", success);
            NSLog(@"Request zoneList result : %d", success);
            block(net);
        }
        
    }];
}



@end
