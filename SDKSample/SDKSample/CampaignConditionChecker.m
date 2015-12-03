//
//  CampaignConditionChecker.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/1/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <SLBSSDK/TSDebugLogManager.h>
#import <SLBSSDK/Zone.h>
#import <SLBSSDK/SLBSZoneCampaignInfo.h>

#import "CampaignConditionChecker.h"

#import "AppDataManager.h"
#import "CampaignArchiver.h"
#import "DateTimeUtil.h"
#import "AppDefine.h"

@interface CampaignConditionChecker()

@property (nonatomic, strong) AppDataManager *appDataManager;

@end

@implementation CampaignConditionChecker

#define INTERVAL_TYPE_1                 1       // 1번
#define INTERVAL_TYPE_1_PER_DAY         2       // 1일 1회(날짜 변경에 따라서?)
#define INTERVAL_TYPE_1_PER_3HOURS      3       // 3시간 1회
#define INTERVAL_TYPE_1_PER_6HOURS      4       // 6시간 1회

#define CAMPAIGN_TYPE_NORMAL        1       // 일반 캠페인 팝업
#define CAMPAIGN_TYPE_WELCOME       2       // Welcome
#define CAMPAIGN_TYPE_PARKING       3       // Parking 캠페인 팝업

- (instancetype)init {
    self = [super init];
    
    self.appDataManager = [AppDataManager sharedInstance];
    
    return self;
}

- (void)addZoneCampaignInfo:(SLBSZoneCampaignInfo*)zoneCampaignInfo {
    TSGLog(TSLogGroupApplication, @">>> addZoneCampaignInfo()");
    
    Campaign *foundCampaign = [self findCampaign:zoneCampaignInfo.ID];
    if (foundCampaign!=nil) {
        // update
        [self updateZoneCampaignInfo:foundCampaign campaignInfo:zoneCampaignInfo];
        return;
    }

    // add
    Campaign *campaign = [[Campaign alloc] init];
    campaign.campaignId = zoneCampaignInfo.ID;
    campaign.loiteringTime = [NSNumber numberWithInt:0];
    campaign.receivedCount = [NSNumber numberWithInt:1];
    campaign.receivedTime = 0;

    [self.appDataManager.campaignArray addObject:campaign];
}

- (void)updateZoneCampaignInfo:(Campaign*)campaign campaignInfo:(SLBSZoneCampaignInfo*)zoneCampaignInfo {
    TSGLog(TSLogGroupApplication, @">>> updateZoneCampaignInfo()");
    
    campaign.loiteringTime = [NSNumber numberWithInt:[campaign.loiteringTime intValue] + 1];
    campaign.receivedCount = [NSNumber numberWithInt:[campaign.receivedCount intValue] + 1];
}

- (Campaign*)updateCampaign:(Campaign*)campaign zoneCampaignInfo:(SLBSZoneCampaignInfo*)zoneCampaign {
    Campaign *foundCampaign = [self findCampaign:zoneCampaign.ID];
    
    foundCampaign.campaignId = zoneCampaign.ID;
    foundCampaign.title = campaign.title;
    foundCampaign.imageUrl = campaign.imageUrl;
    foundCampaign.desc = campaign.desc;
    foundCampaign.type = campaign.type;
    
    foundCampaign.receivedTime = [NSDate date];
    
    Zone *associatedZone = [self getFirstZoneWithStoreType:zoneCampaign.zoneIDs];
    if (associatedZone!=nil) {
        foundCampaign.zoneId = associatedZone.zone_id;
        foundCampaign.zoneType = associatedZone.type;
    }
    
    return foundCampaign;
}

- (Zone*)getFirstZoneWithStoreType:(NSArray*)zoneIdArray {
    for (NSNumber *zoneId in zoneIdArray) {
        Zone *associatedZone = [self findZoneWithZoneId:zoneId];
        if ([associatedZone.type intValue]==ZONE_TYPE_STORE) {
            return associatedZone;
        }
    }
    
    return nil;
}

- (Zone*)findZoneWithZoneId:(NSNumber*)zoneId {
    AppDataManager *appDataManager = [AppDataManager sharedInstance];
    for (Zone *zone in appDataManager.zoneListArray) {
        if ([zone.zone_id intValue]==[zoneId intValue]) {
            return zone;
        }
    }
    
    return nil;
}

- (void)updateDownloadedImagePath:(NSString*)imagePath campaignId:(NSNumber*)campaignId {
    Campaign *foundCampaign = [self findCampaign:campaignId];
    foundCampaign.imageFilePath = imagePath;
}

- (Campaign*)findCampaign:(NSNumber*)campaignId {
    for (Campaign *campaign in self.appDataManager.campaignArray) {
        if ([campaign.campaignId intValue]==[campaignId intValue]) {
            return campaign;
        }
    }
    
    return nil;
}

- (BOOL)checkIfCampaignConditionIsAllowed:(SLBSZoneCampaignInfo*)zoneCampaignInfo {
    Campaign *receivedCampaign = [self findCampaign:zoneCampaignInfo.ID];
    
    if ([self allowMaxCount:receivedCampaign maxCount:zoneCampaignInfo.maxCount]==NO) {
        return NO;
    }

    if ([self allowOffWeekAndDay:zoneCampaignInfo.offWeeks offDay:zoneCampaignInfo.offDayOfWeeks]==NO) {
        return NO;
    }
    
    if ([self allowLoiteringTime:receivedCampaign loiteringTime:(NSNumber*)zoneCampaignInfo.loiteringTime]==NO) {
        return NO;
    }

    if ([self allowInterval:receivedCampaign interval:zoneCampaignInfo.interval]==NO) {
        return NO;
    }
    
    return YES;
}

- (BOOL)allowMaxCount:(Campaign*)receivedCampaign maxCount:(NSNumber*)maxCount {
    if ([receivedCampaign.receivedCount intValue] <= [maxCount intValue]) {
        TSGLog(TSLogGroupApplication,
               @"allowMaxCount() YES maxCount=%d, receivedCampaign.receivedCount=%d",
               [maxCount intValue], [receivedCampaign.receivedCount intValue]);
        return YES;
    }
    
    TSGLog(TSLogGroupApplication,
           @"allowMaxCount() NO maxCount=%d, receivedCampaign.receivedCount=%d",
           [maxCount intValue], [receivedCampaign.receivedCount intValue]);
    return NO;
}

- (BOOL)allowOffWeekAndDay:(NSArray*)offWeek offDay:(NSNumber*)offDay {
    int curWeekOfMonth = [DateTimeUtil getCurrentWeekOfMonth];
    
    for (NSString *offWeekStr in offWeek) {
        if ([offWeekStr intValue]==curWeekOfMonth) {
            int curWeekday = [DateTimeUtil getCurrentWeekday];
            if (curWeekday==[offDay intValue]) {
                TSGLog(TSLogGroupApplication,
                       @"allowOffWeekAndDay() NO curWeekday=%d, offDay=%d",
                       curWeekday, [offDay intValue]);
                return NO;
            }
        }
    }

    TSGLog(TSLogGroupApplication, @"allowOffWeekAndDay() NO");
    return YES;
}

- (BOOL)allowLoiteringTime:(Campaign*)receivedCampaign loiteringTime:(NSNumber*)loiteringTime {
    if ([receivedCampaign.loiteringTime intValue] % [loiteringTime intValue]==0) {
        TSGLog(TSLogGroupApplication,
               @"allowLoiteringTime() YES receivedCampaign.loiteringTime=%d, loiteringTime=%d",
               [receivedCampaign.loiteringTime intValue], [loiteringTime intValue]);
        return YES;
    }
    
    return NO;
}

- (BOOL)allowInterval:(Campaign*)receivedCampaign interval:(NSNumber*)interval {
    if (receivedCampaign==nil) {
        TSGLog(TSLogGroupApplication, @"allowInterval() YES receivedCampaign is nil");
        return YES;
    } else {
        switch ([interval intValue]) {
            case INTERVAL_TYPE_1:
                if ([receivedCampaign.receivedCount intValue] < 1) {
                    TSGLog(TSLogGroupApplication,
                           @"allowInterval() YES INTERVAL_TYPE_1 receivedCampaign.receivedCount=%d",
                           [receivedCampaign.receivedCount intValue]);
                    return YES;
                }
                
                break;
            case INTERVAL_TYPE_1_PER_DAY: {
                if (receivedCampaign.receivedTime <= 0) {
                    TSGLog(TSLogGroupApplication, @"allowInterval() YES receivedCampaign.receivedTime =%ld",
                           (long)receivedCampaign.receivedTime);
                    return YES;
                } else {
                    int curDay = [DateTimeUtil getCurrentDay];
                    int recvDay = [DateTimeUtil getDayByDate:receivedCampaign.receivedTime];
                    if (curDay!=recvDay) {
                        TSGLog(TSLogGroupApplication, @"allowInterval() YES curDay=%d, recvDay=%d",
                               curDay, recvDay);
                        return YES;
                    } else {
                        TSGLog(TSLogGroupApplication, @"allowInterval() NO curDay=%d, recvDay=%d",
                               curDay, recvDay);
                    }
                }
            }
                break;
            case INTERVAL_TYPE_1_PER_3HOURS: {
                if (receivedCampaign.receivedTime <= 0) {
                    TSGLog(TSLogGroupApplication, @"allowInterval() YES receivedCampaign.receivedTime =%ld",
                           (long)receivedCampaign.receivedTime);
                    return YES;
                } else {
                    NSDate *curDate = [NSDate date];
                    NSDate *after3Hour = [receivedCampaign.receivedTime dateByAddingTimeInterval:((60 * 60) * 3)];
                    if ([after3Hour compare:curDate]==NSOrderedAscending) {
                        TSGLog(TSLogGroupApplication, @"allowInterval() YES 3 hour passed after received time");
                        return YES;
                    } else {
                        TSGLog(TSLogGroupApplication, @"allowInterval() NO 3 hour NOT passed after received time");
                    }
                }
            }
                break;
            case INTERVAL_TYPE_1_PER_6HOURS: {
                if (receivedCampaign.receivedTime <= 0) {
                    TSGLog(TSLogGroupApplication, @"allowInterval() YES receivedCampaign.receivedTime =%ld",
                           (long)receivedCampaign.receivedTime);
                    return YES;
                } else {
                    NSDate *curDate = [NSDate date];
                    NSDate *after3Hour = [receivedCampaign.receivedTime dateByAddingTimeInterval:((60 * 60) * 6)];
                    if ([after3Hour compare:curDate]==NSOrderedDescending) {
                        TSGLog(TSLogGroupApplication, @"allowInterval() YES 6 hour passed after received time");
                        return YES;
                    } else {
                        TSGLog(TSLogGroupApplication, @"allowInterval() NO 6 hour NOT passed after received time");
                    }
                }
            }
                break;
                
            default:
                break;
        }
    }
    
    return NO;
}

// @SSG
- (void)removeZoneCampaign:(NSNumber*)campaignId {
    Campaign *foundCampaign = [self findCampaign:campaignId];
    [self.appDataManager.campaignArray removeObject:foundCampaign];
}

- (void)addZoneCampaign:(Campaign*)campaign {
    [self.appDataManager.campaignArray addObject:campaign];
}

-(BOOL)isParking {
    AppDataManager *appDataManager = [AppDataManager sharedInstance];
    for (Zone *zone in appDataManager.zoneListArray) {
        if ([zone.type intValue] == CAMPAIGN_TYPE_PARKING) {
            return TRUE;
        }
    }
    return FALSE;
}

//

@end
