//
//  ZoneCampaignDataManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_ZoneCampaignDataManager_h
#define SLBSKit_ZoneCampaignDataManager_h

#import "SLBSKitDefine.h"
#import "SLBSZoneCampaignInfo.h"

/**
 event popup delegate

 
 ZoneCampaign 이벤트 발생시 ZoneCampainManager에게 알려주는 인터페이스
 
 @param zoneCampaingID
 @param zoneCampaignType 캠페인 Type에 따라 App에서 자체 레거시에게 물어볼지 결정을 위해 Type도 같이 전달
*/

@class ZoneCampaignDataManager;
@protocol ZoneCampaignDataManagerDelegate <NSObject>

- (void)ZoneCampaignDataManager:(ZoneCampaignDataManager *)manager onCampaignPopup:(NSArray*)zoneCampaignList;

@end


/**
 ZoneCampaign 관련 데이터 관리 및 Campaign Condition Trigger
 
 서버로 부터 받은 ZoneCampaign Data 관리
 Zone Condition에 맞는 Campaign Trigger 하여 ZoneCampaignManager에게 전달
 */
@interface ZoneCampaignDataManager : NSObject 

+ (ZoneCampaignDataManager*)sharedInstance;
@property (weak, nonatomic) id<ZoneCampaignDataManagerDelegate> delegate;

/**
 *  전달된 ZoneCampaign 목록을 저장소에 저장하는 함수
 *
 *  @param zoneCampaigns      저장할 SLBSZoneCampaignInfo 객체의 목록
 */
- (void)setZoneCampaigns:(NSArray *)zoneCampaigns;

/**
 *  저장된 ZoneCampaign 목록을 얻어주는 함수
 *
 *  @return ZoneCampaign 목록
 */
- (NSArray *)zoneCampaigns;

/**
 *  저장된 ZoneCampaign 목록을 저장소에서 직접 읽어 얻어주는 함수
 *
 *  @return ZoneCampaign 목록
 */
- (NSArray *)zoneCampaignsFromStorage;

/**
 *  저장된 SLBSZoneCampaignInfo 목록 중 전달되는 campaign ID 값을 가진 SLBSZoneCampaignInfo 갹체를 찾아주는 함수
 *
 *  @param campaignID      검색할 SLBSZoneCampaignInfo 갹체의 ID
 *
 *  @return 검색된 SLBSZoneCampaignInfo 객체
 */
- (SLBSZoneCampaignInfo *)zoneCampaignWithID:(NSNumber *)campaignID;

/**
 *  저장된 SLBSZoneCampaignInfo 목록 중 전달되는 campaign 이름 값을 가진 SLBSZoneCampaignInfo 갹체를 찾아주는 함수
 *
 *  @param campaignName      검색할 SLBSZoneCampaignInfo 갹체의 이름
 *
 *  @return 검색된 SLBSZoneCampaignInfo 객체, 다수의 Array로 변경 가능
 */
- (SLBSZoneCampaignInfo *)zoneCampaignWithName:(NSString *)campaignName;//다수가 될 수 있다. 검토 필요

/**
 *  저장된 SLBSZoneCampaignInfo 목록 중 전달되는 zoneID 가 포함된 SLBSZoneCampaignInfo 갹체를 찾아주는 함수
 *
 *  @param zoneID      검색할 SLBSZoneCampaignInfo 가 등록되어 있는 Zone의 ID
 *
 *  @return 검색된 SLBSZoneCampaignInfo의 목록
 */
- (NSArray *)zoneCampaignsWithZoneID:(NSNumber *)zoneID;
/**
 *  저장된 SLBSZoneCampaignInfo 목록 중 전달되는 zoneID가 포함되고 SLBSSessionType이 같은 SLBSZoneCampaignInfo 갹체를 찾아주는 함수
 *
 *  @param zoneID           검색할 SLBSZoneCampaignInfo 가 등록되어 있는 Zone의 ID
 *  @param sessionType      검색할 SLBSZoneCampaignInfo의 session type 값
 *
 *  @return 검색된 SLBSZoneCampaignInfo의 목록
 */
- (NSArray *)zoneCampaignsWithZoneID:(NSNumber *)zoneID sessionType:(SLBSSessionType)sessionType;
//
//- (void)requestZoneCampaignListToServer;
//- (SLBSZoneCampaignInfo*)searchZoneCampaign:(NSNumber*)zoneID sessionType:(SLBSSessionType)sessionType;

- (void)detectZoneCampaign:(NSNumber *)zoneID sessionType:(SLBSSessionType)sessionType;
@end

#endif
