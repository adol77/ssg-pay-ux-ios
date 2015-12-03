//
//  SLBSZoneCampaign.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_SLBSZoneCampaign_h
#define SLBSKit_SLBSZoneCampaign_h

/// Database의 ZoneCampaign class로 대체 또는 상속받아 추가 정보 처리

#import <Foundation/Foundation.h>

@class SLBSZoneCampaignInfo;
@interface SLBSZoneCampaignInfo : NSObject < NSCoding >

@property (readonly) NSNumber *ID;
@property (readonly) NSArray *zoneIDs;
@property (readonly) NSArray *zones;
@property (readonly) NSString *name;
@property (readonly) NSNumber *appID;
@property (readonly) NSNumber *ownerGroup;
@property (readonly) NSNumber *workingCondition;
@property (readonly) NSNumber *type;
@property (readonly) NSNumber *marketingType;
@property (readonly) NSNumber *loiteringTime;
@property (readonly) NSNumber *maxCount;
@property (readonly) NSArray *offWeeks;
@property (readonly) NSNumber *offDayOfWeeks;
@property (readonly) NSNumber *interval;
@property (readonly) NSDate *positioningStartTime;
@property (readonly) NSDate *positioningEndTime;
@property (readonly) NSString *zoneDataFormat;
@property (readonly) NSString *appSpecificCampaignData;


/**
 *  서버에서 전달된 ZoneCampaign response 데이터로부터 SLBSZoneCampaignInfo 객체를 생성하여 전달하는 함수
 *
 *  @param source       서버에서 전달된 response 데이터
 *
 *  @return 생성된 SLBSZoneCampaignInfo의 객체
 */
+ (SLBSZoneCampaignInfo *)zoneCampaignWithSource:(NSDictionary *)source;

/**
 *  서버에서 전달된 ZoneCampaign response 데이터의 목록으로부터 SLBSZoneCampaignInfo 객체의 목록을 생성하여 전달하는 함수
 *
 *  @param sources       서버에서 전달된 response 데이터 목록
 *
 *  @return 생성된 SLBSZoneCampaignInfo의 객체 목록
 */
+ (NSArray *)zoneCampaignsWithSources:(NSArray *)sources;

- (void)setZoneCampaignID:(NSInteger)ID;

@end


#endif
