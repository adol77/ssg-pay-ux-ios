//
//  ZoneCampaignDataManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZoneCampaignDataManager.h"
#import "TSDebugLogManager.h"

@interface ZoneCampaignDataManager ()

@property (nonatomic, strong) NSArray *campaigns;

@end

@implementation ZoneCampaignDataManager : NSObject

+ (ZoneCampaignDataManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static ZoneCampaignDataManager *sharedZoneCampaignDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedZoneCampaignDataManager = [[ZoneCampaignDataManager alloc] init];
    });
    return sharedZoneCampaignDataManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.campaigns = [self zoneCampaignsFromStorage];
    }
    return self;
}

/**
 *  Zone Campaign 정보 수동 업데이트
 *
 *  Todo : OS 제약으로 인해 전부 다 가져오긴 하지만, 서버에 등록된 Campaign 갯수에 따라 indexing 하여 가져오는 방법도 고민 필요
 */
- (void)setZoneCampaigns:(NSArray *)zoneCampaigns {
    if (zoneCampaigns && ([zoneCampaigns count] > 0)) {
        self.campaigns = [NSArray arrayWithArray:zoneCampaigns];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zoneCampaigns"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:self.campaigns];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"zoneCampaigns"];
    }
}

- (NSArray *)zoneCampaignsFromStorage {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"zoneCampaigns"];
    if (raw) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:raw];
    }
    return nil;
}

- (NSArray *)zoneCampaigns {
    if ( (self.campaigns == nil) || ([self.campaigns count] <= 0)) {
        self.campaigns = [self zoneCampaignsFromStorage];
    }
    if ( (self.campaigns == nil) || ([self.campaigns count] <= 0)) {
        return nil;
    }
    return [NSArray arrayWithArray:self.campaigns];
}

- (SLBSZoneCampaignInfo *)zoneCampaignWithID:(NSNumber *)campaignID {
    //TSGLog(TSLogGroupCampaign, @"zoneCampaingWithID %@", campaignID);
    
    if ( (self.campaigns == nil) || ([self.campaigns count] <= 0)) {
        return nil;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ID == %@", campaignID];
    NSArray *filteredArray = [self.campaigns filteredArrayUsingPredicate:predicate];
    if (filteredArray && ([filteredArray count] > 0)) {
        return [filteredArray firstObject];
    }
    return nil;
}

- (SLBSZoneCampaignInfo *)zoneCampaignWithName:(NSString *)campaignName {
    //TSGLog(TSLogGroupCampaign, @"zoneCampaignWithName %@", campaignName);
    
    if ( (self.campaigns == nil) || ([self.campaigns count] <= 0)) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", campaignName];
    NSArray *filteredArray = [self.campaigns filteredArrayUsingPredicate:predicate];
    if (filteredArray && ([filteredArray count] > 0)) {
        return [filteredArray firstObject];
    }
    return nil;
}

- (NSArray *)zoneCampaignsWithZoneID:(NSNumber *)zoneID {
    //TSGLog(TSLogGroupCampaign, @"zoneCampaignsWithZoneID %@", zoneID);
    if ( (self.campaigns == nil) || ([self.campaigns count] <= 0)) {
        return nil;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY zones.zone_id == %@)", zoneID];
    NSArray *filteredArray = [self.campaigns filteredArrayUsingPredicate:predicate];
    if (filteredArray && ([filteredArray count] > 0)) {
        return filteredArray;
    }
    return nil;
}

- (NSArray *)zoneCampaignsWithZoneID:(NSNumber *)zoneID sessionType:(SLBSSessionType)sessionType {
    //TSGLog(TSLogGroupCampaign, @"zoneCampaignsWithZoneID %@ sessionType %ld", zoneID, (long)sessionType);
    
    NSLog(@"%s zoneCampaignsWithZoneID %@ %ld", __PRETTY_FUNCTION__, zoneID, (long)sessionType);
    if ( (self.campaigns == nil) || ([self.campaigns count] <= 0)) {
        return nil;
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY zones.zone_id == %@) AND (workingCondition == %@)", zoneID, [NSNumber numberWithInteger:sessionType]];
    NSArray *filteredArray = [self.campaigns filteredArrayUsingPredicate:predicate];
    
     NSLog(@"%s zoneCampaignsWithZoneID filteredArray %ld", __PRETTY_FUNCTION__, (unsigned long)[filteredArray count]);
    if (filteredArray && ([filteredArray count] > 0)) {
        return filteredArray;
    }
    return nil;
}

- (void)detectZoneCampaign:(NSNumber *)zoneID sessionType:(SLBSSessionType)sessionType {
    //TSGLog(TSLogGroupCampaign, @"detectZoneCampaign %@ sessionType %ld", zoneID, (long)sessionType);
    
    NSArray* zoneCampaignList = [self zoneCampaignsWithZoneID:zoneID sessionType:sessionType];
    
    if(zoneCampaignList != nil)
        [self.delegate ZoneCampaignDataManager:self onCampaignPopup:zoneCampaignList];
}


/**
 *  ZoneCampaign 검색
 *
 *  @param zoneID      zoneID
 *  @param sessionType sessionType - Type 값은 SLBSSessionType 참고
 *
 *  @return SLBSZoneCampaignInfo - 현재는 단일 객체로 하였으나, 추후 NSArray로 변경할수도 있음.
 */
//- (SLBSZoneCampaignInfo*)searchZoneCampaign:(NSNumber*)zoneID sessionType:(SLBSSessionType)sessionType
//{
//    SLBSZoneCampaignInfo* zoneCampaignInfo = [[DataManager sharedInstance] searchZoneCampaign:zoneID sessionType:sessionType];
//    
//    return zoneCampaignInfo;
//}
@end