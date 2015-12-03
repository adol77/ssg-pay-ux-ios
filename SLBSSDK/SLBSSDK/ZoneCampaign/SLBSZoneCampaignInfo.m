//
//  SLBSZoneCampaignInfo.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 21..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "SLBSZoneCampaignInfo.h"
#import "NSString+SafeCreation.h"
#import "NSDate+String.h"

@interface SLBSZoneCampaignInfo()

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSArray *zoneIDs;
@property (nonatomic, strong) NSArray *zones;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *appID;
@property (nonatomic, strong) NSNumber *ownerGroup;
@property (nonatomic, strong) NSNumber *workingCondition;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *marketingType;
@property (nonatomic, strong) NSNumber *loiteringTime;
@property (nonatomic, strong) NSNumber *maxCount;
@property (nonatomic, strong) NSArray *offWeeks;
@property (nonatomic, strong) NSNumber *offDayOfWeeks;
@property (nonatomic, strong) NSNumber *interval;
@property (nonatomic, strong) NSDate *positioningStartTime;
@property (nonatomic, strong) NSDate *positioningEndTime;
@property (nonatomic, strong) NSString *zoneDataFormat;
@property (nonatomic, strong) NSString *appSpecificCampaignData;

@end

/**
 *  Zone Campaign Entity
 *
 *  서버에서 생성된 Zone Campaign 정보를 담고 있는 객체
 *
 */

@implementation SLBSZoneCampaignInfo
//campaign_info : {
const NSString *kZoneCampaignKeyID                      = @"id";
const NSString *kZoneCampaignKeyZoneID                  = @"zone_id";
const NSString *kZoneCampaignKeyZones                   = @"zone_array";
const NSString *kZoneCampaignKeyName                    = @"name";
const NSString *kZoneCampaignKeyAppID                   = @"app_id";
const NSString *kZoneCampaignKeyOwnerGroup              = @"owner_group";
const NSString *kZoneCampaignKeyWorkingCondition        = @"working_condition";
const NSString *kZoneCampaignKeyType                    = @"type";
const NSString *kZoneCampaignKeyMarketingType           = @"marketing_type";
const NSString *kZoneCampaignKeyLoiteringTime           = @"loitering_time";
const NSString *kZoneCampaignKeyMaxCount                = @"max_count_per_customer";
const NSString *kZoneCampaignKeyOffWeeks                = @"off_week";
const NSString *kZoneCampaignKeyOffDayOfWeeks           = @"off_day";
const NSString *kZoneCampaignKeyInterval                = @"interval";
const NSString *kZoneCampaignKeyPositioningStartTime    = @"start_time";
const NSString *kZoneCampaignKeyPositioningEndTime      = @"end_time";
const NSString *kZoneCampaignKeyZoneDataFormat          = @"zone_data_format";
const NSString *kZoneCampaignKeyAppSpecificCampaignData = @"app_specific_data";
NSString *kZoneCampaignPositioningFormat                = @"HH:mm";

//}*/
#pragma mark - initialize
- (instancetype)initWithSource:(NSDictionary *)source
{
    self = [super init];
    if (self) {
        self.ID = [source objectForKey:kZoneCampaignKeyID];
        {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *zones = [source objectForKey:kZoneCampaignKeyZones];
            for (NSDictionary *zone in zones) {
                if ([zone objectForKey:kZoneCampaignKeyZoneID]) {
                    [array addObject:[zone objectForKey:kZoneCampaignKeyZoneID]];
                }
            }
            self.zoneIDs = [NSArray arrayWithArray:array];
        }
        self.zones = [source objectForKey:kZoneCampaignKeyZones];
        self.name = [NSString stringWithUnsafeString:[source objectForKey:kZoneCampaignKeyName]];
        self.appID = [source objectForKey:kZoneCampaignKeyAppID];
        self.ownerGroup = [source objectForKey:kZoneCampaignKeyOwnerGroup];
        self.workingCondition = [source objectForKey:kZoneCampaignKeyWorkingCondition];
        self.type = [source objectForKey:kZoneCampaignKeyType];
        self.marketingType = [source objectForKey:kZoneCampaignKeyMarketingType];
        self.loiteringTime = [source objectForKey:kZoneCampaignKeyLoiteringTime];
        self.maxCount = [source objectForKey:kZoneCampaignKeyMaxCount];
        {
            NSString *offWeeksString = [NSString stringWithUnsafeString:[source objectForKey:kZoneCampaignKeyOffWeeks]];
            self.offWeeks = [offWeeksString componentsSeparatedByString:@"/"];
        }
        self.offDayOfWeeks = [source objectForKey:kZoneCampaignKeyOffDayOfWeeks];
        self.interval = [source objectForKey:kZoneCampaignKeyInterval];
        self.positioningStartTime = [NSDate dateFromUnsafeString:[source objectForKey:kZoneCampaignKeyPositioningStartTime] format:kZoneCampaignPositioningFormat];
        self.positioningEndTime = [NSDate dateFromUnsafeString:[source objectForKey:kZoneCampaignKeyPositioningEndTime] format:kZoneCampaignPositioningFormat];
        self.zoneDataFormat = [NSString stringWithUnsafeString:[source objectForKey:kZoneCampaignKeyZoneDataFormat]];
        self.appSpecificCampaignData = [NSString stringWithUnsafeString:[source objectForKey:kZoneCampaignKeyAppSpecificCampaignData]];
    }
    return self;
}

+ (SLBSZoneCampaignInfo *)zoneCampaignWithSource:(NSDictionary *)source {
    if (source == nil) {
        return nil;
    }
    return [[SLBSZoneCampaignInfo alloc] initWithSource:source];
}

+ (NSArray *)zoneCampaignsWithSources:(NSArray *)sources {
    if (sources ==  nil || ([sources count] <= 0)) {
        return nil;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *source in sources) {
        SLBSZoneCampaignInfo *entity = [SLBSZoneCampaignInfo zoneCampaignWithSource:source];
        if (entity) {
            [array addObject:entity];
        }
    }
    
    return [NSArray arrayWithArray:array];
}

#pragma mark - setter/getter
- (void)setZoneCampaignID:(NSInteger)IDValue {
    self.ID = [NSNumber numberWithInteger:IDValue];
}

#pragma mark - NSCoding Protocol
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.zoneIDs = [aDecoder decodeObjectForKey:@"zoneIDs"];
        self.zones = [aDecoder decodeObjectForKey:@"zones"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.appID = [aDecoder decodeObjectForKey:@"appID"];
        self.ownerGroup = [aDecoder decodeObjectForKey:@"ownerGroup"];
        self.workingCondition = [aDecoder decodeObjectForKey:@"workingCondition"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.marketingType = [aDecoder decodeObjectForKey:@"marketingType"];
        self.loiteringTime = [aDecoder decodeObjectForKey:@"loiteringTime"];
        self.maxCount = [aDecoder decodeObjectForKey:@"maxCount"];
        self.offWeeks = [aDecoder decodeObjectForKey:@"offWeeks"];
        self.offDayOfWeeks = [aDecoder decodeObjectForKey:@"offDayOfWeeks"];
        self.interval = [aDecoder decodeObjectForKey:@"interval"];
        self.positioningStartTime = [aDecoder decodeObjectForKey:@"positioningStartTime"];
        self.positioningEndTime = [aDecoder decodeObjectForKey:@"positioningEndTime"];
        self.zoneDataFormat = [aDecoder decodeObjectForKey:@"zoneDataFormat"];
        self.appSpecificCampaignData = [aDecoder decodeObjectForKey:@"appSpecificCampaignData"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.zoneIDs forKey:@"zoneIDs"];
    [aCoder encodeObject:self.zones forKey:@"zones"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.appID forKey:@"appID"];
    [aCoder encodeObject:self.ownerGroup forKey:@"ownerGroup"];
    [aCoder encodeObject:self.workingCondition forKey:@"workingCondition"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.marketingType forKey:@"marketingType"];
    [aCoder encodeObject:self.loiteringTime forKey:@"loiteringTime"];
    [aCoder encodeObject:self.maxCount forKey:@"maxCount"];
    [aCoder encodeObject:self.offWeeks forKey:@"offWeeks"];
    [aCoder encodeObject:self.offDayOfWeeks forKey:@"offDayOfWeeks"];
    [aCoder encodeObject:self.interval forKey:@"interval"];
    [aCoder encodeObject:self.positioningStartTime forKey:@"positioningStartTime"];
    [aCoder encodeObject:self.positioningEndTime forKey:@"positioningEndTime"];
    [aCoder encodeObject:self.zoneDataFormat forKey:@"zoneDataFormat"];
    [aCoder encodeObject:self.appSpecificCampaignData forKey:@"appSpecificCampaignData"];
}

#pragma mark - debug

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ : ID(%@), name(%@), appID(%@), ownerGroup(%@)", [super description], self.ID, self.name, self.appID, self.ownerGroup];
}

@end
