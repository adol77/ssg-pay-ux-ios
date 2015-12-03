//
//  ZoneCampaignNet.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 1..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "INNet.h"
#import "SLBSZoneCampaignInfo.h"
#import "Zone.h"

@interface ZoneCampaignNet : INNet

/**
 *  전달된 campaign 목록
 */
@property (readonly) NSArray *campaigns;
/**
 *  전달된 campaign 데이터
 */
@property (readonly) SLBSZoneCampaignInfo *campaign;

/**
 *  전달된 Zone 데이터
 */
@property (readonly) NSArray *zoneIDs;


/**
 *  전체 ZoneCampaign 데이터 목록 요청 함수
 *
 *  @param token        서버에 접근할 수 있는 AccessToken 값
 *  @param block        RESTful API 결과를 가지고 있는 ZoneCampaignNet 객체
 */
+ (void)requestCampaignsWithAccessToken:(NSString*)token block:(void (^)(ZoneCampaignNet *rapiObject))block;

/**
 *  요청 시 전달된 ID 값을 가진 ZoneCampaign 데이터 요청 함수
 *
 *  @param campaignID   요청할 campaign의 ID 값
 *  @param token        서버에 접근할 수 있는 AccessToken 값
 *  @param block        RESTful API 결과를 가지고 있는 ZoneCampaignNet 객체
 */
+ (void)requestCampaignWithID:(NSNumber *)campaignID accessToken:(NSString*)token block:(void (^)(ZoneCampaignNet *rapiObject))block;

/**
 *  요청 시 전달된 Zone에 등록되어 있는 ZoneCampaign 데이터 목록 요청 함수
 *
 *  @param campaignID   요청할 Zone의 ID 값
 *  @param token        서버에 접근할 수 있는 AccessToken 값
 *  @param block        RESTful API 결과를 가지고 있는 ZoneCampaignNet 객체
 */
+ (void)requestCampaignsWithZoneIDs:(NSArray *)zoneIDs accessToken:(NSString*)token block:(void (^)(ZoneCampaignNet *rapiObject))block;

/**
 *  요청 시 전달된 ID 값의 campaign이 등록되어 있는 Zone 데이터 요청 함수
 *
 *  @param campaignID   요청할 campaign의 ID 값
 *  @param token        서버에 접근할 수 있는 AccessToken 값
 *  @param block        RESTful API 결과를 가지고 있는 ZoneCampaignNet 객체
 */
+ (void)requestZonesWithCampaignID:(NSNumber *)campaignID accessToken:(NSString*)token block:(void (^)(ZoneCampaignNet *rapiObject))block;

@end
