//
//  ZoneCampaignNet.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 1..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "ZoneCampaignNet.h"
//#define GFDEBUG_ENABLE
#import "GFDebug.h"

#import "SLBSZoneCampaignInfo.h"
#import "Zone.h"
#import "TSDebugLogManager.h"

const NSString *kApiVersion         = @"/v1";
const NSString *kApiGroup           = @"/zcms";
const NSString *kReturnRootKey      = @"ret_data";
const NSString *kCampaignKey        = @"campaign_info";
const NSString *kCampaignListKey    = @"campaign_array";
const NSString *kZoneListKey        = @"zone_array";

typedef NS_ENUM(NSInteger, tagZoneCampaignNetRAPI) {
    tagZoneCampaignNetRAPIAllCampaigns,
    tagZoneCampaignNetRAPICampaignWithID,
    tagZoneCampaignNetRAPICampaignsWithZoneID,
    tagZoneCampaignNetRAPIZoensWithCampaignID,
};


@interface ZoneCampaignNet ()

@property (nonatomic, strong) NSArray *campaigns;
@property (nonatomic, strong) NSArray *zoneIDs;

@end

/**
 *  Zone Campaign RESTful API
 *
 *  클라이언트가 요청시 서버에게 Zone Campaign 데이터 요청 및 Caching 담당
 *
 */

@implementation ZoneCampaignNet

- (instancetype)initWithAccessToken:(NSString *)token {
    self = [super init];
    if (self) {
        if ([token length] > 0) {
            [self setHeaderField:@"access_token" value:token];
        }
    }
    return self;
}

- (BOOL)processResponseData:(id)responseObject dataType:(TSNetDataType)type {
    if ( type != TSNetDataDictionary ) return NO;
    
    NSDictionary *rootObject = responseObject;//[responseObject objectForKey:kReturnRootKey];
    switch (self.tag) {
        case tagZoneCampaignNetRAPIAllCampaigns:
        case tagZoneCampaignNetRAPICampaignsWithZoneID: {
            NSArray *sources = [rootObject objectForKey:kCampaignListKey];
            if (sources == nil) {
                TSELog(@"invalid zone campaigns data at %@", (self.tag==tagZoneCampaignNetRAPIAllCampaigns)?@"requestCampaignsWithAccessToken":@"requestCampaignsWithZoneID");
                return NO;
            }
            self.campaigns = [SLBSZoneCampaignInfo zoneCampaignsWithSources:sources];
        } break;
        case tagZoneCampaignNetRAPICampaignWithID: {
            NSArray *sources = [rootObject objectForKey:kCampaignListKey];
            if (sources == nil) {
                return NO;
            }
            if ([sources count] > 1) {
                TSWLog(@"duplicated zone campaign object received at requestCampaignWithID");
            }
            self.campaigns = [SLBSZoneCampaignInfo zoneCampaignsWithSources:sources];
        } break;
//        case tagZoneCampaignNetRAPICampaignsWithZoneID: {
//            
//        } break;
        case tagZoneCampaignNetRAPIZoensWithCampaignID: {
            NSArray *sources = [rootObject objectForKey:kCampaignListKey];
            if (sources == nil) {
                return NO;
            }
            if ([sources count] > 1) {
                TSWLog(@"duplicated zone campaign object received at requestCampaignWithID");
            }
            NSArray *campaigns = [SLBSZoneCampaignInfo zoneCampaignsWithSources:sources];
            self.zoneIDs = [NSArray arrayWithArray:((SLBSZoneCampaignInfo*)[campaigns firstObject]).zoneIDs];
//            NSArray *zones = ((SLBSZoneCampaignInfo*)[campaigns firstObject]).zoneIDs;
//            NSMutableArray *array = [NSMutableArray array];
//            for (NSDictionary *zone in zones) {
//                NSNumber *zoneID = [zone objectForKey:@"zone_id"];
//                if (zoneID) {
//                    [array addObject:zoneID];
//                }
//            }
//            self.zoneIDs = [NSArray arrayWithArray:array];
        } break;
        default:
            return NO;
            break;
    }
    return YES;
}

- (SLBSZoneCampaignInfo *)campaign {
    if (self.campaigns && ([self.campaigns count] > 0)) {
        return [self.campaigns firstObject];
    }
    return nil;
}

+ (void)requestCampaignsWithAccessToken:(NSString*)token block:(void (^)(ZoneCampaignNet *rapiObject))block {
    TSGLog(TSLogGroupCampaign, @"requestCampaignWithAccessToken");
    ZoneCampaignNet *net = [[ZoneCampaignNet alloc] initWithAccessToken:token];
    [net setTag:tagZoneCampaignNetRAPIAllCampaigns];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", kApiVersion, kApiGroup, @"/campaign.do"] type:TSNetMethodTypeGET];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if (block) {
             TSGLog(TSLogGroupCampaign, @"Request requestCampaignsWithAccessToken success %ld", (long)net.returnCode);
            block(net);
        }
    }];
}

+ (void)requestCampaignWithID:(NSNumber *)campaignID accessToken:(NSString*)token block:(void (^)(ZoneCampaignNet *rapiObject))block {
    TSGLog(TSLogGroupCampaign, @"requestCampaignWithID %@", campaignID);
    
    ZoneCampaignNet *net = [[ZoneCampaignNet alloc] initWithAccessToken:token];
    [net setTag:tagZoneCampaignNetRAPICampaignWithID];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", kApiVersion, kApiGroup, @"/campaign"] URL:[NSString stringWithFormat:@"/%@.do", campaignID]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if (block) {
            TSGLog(TSLogGroupCampaign, @"Request requestCampaignWithID success %ld", (long)net.returnCode);
            block(net);
        }
    }];
}

+ (void)requestCampaignsWithZoneIDs:(NSArray *)zoneIDs accessToken:(NSString*)token block:(void (^)(ZoneCampaignNet *rapiObject))block {
    TSGLog(TSLogGroupCampaign, @"requestCampaignsWithZoneIDs %@", zoneIDs);
    ZoneCampaignNet *net = [[ZoneCampaignNet alloc] initWithAccessToken:token];
    [net setTag:tagZoneCampaignNetRAPICampaignsWithZoneID];
    NSString *zoneIDSParam = [NSString stringWithFormat:@"zone_id=%@", [zoneIDs componentsJoinedByString:@","]];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", kApiVersion, kApiGroup, @"/campaign.do?"] URL:zoneIDSParam];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if (block) {
            TSGLog(TSLogGroupCampaign, @"Request requestCampaignsWithZoneIDs success %ld", (long)net.returnCode);
            block(net);
        }
    }];
}

+ (void)requestZonesWithCampaignID:(NSNumber *)campaignID accessToken:(NSString*)token block:(void (^)(ZoneCampaignNet *rapiObject))block {
    TSGLog(TSLogGroupCampaign, @"requestZonesWithCampaignID %@", campaignID);
    
    ZoneCampaignNet *net = [[ZoneCampaignNet alloc] initWithAccessToken:token];
    [net setTag:tagZoneCampaignNetRAPIZoensWithCampaignID];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", kApiVersion, kApiGroup, @"/campaign"] URL:[NSString stringWithFormat:@"/%@.do", campaignID]];
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if (block) {
            TSGLog(TSLogGroupCampaign, @"Request requestZonesWithCampaignID success %ld", (long)net.returnCode);
            
            block(net);
        }
    }];
}

@end
