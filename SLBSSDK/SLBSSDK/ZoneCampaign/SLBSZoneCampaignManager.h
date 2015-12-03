//
//  ZoneCampaignManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_ZoneCampaignManager_h
#define SLBSKit_ZoneCampaignManager_h

#import "SLBSZoneCampaignInfo.h"

@class SLBSZoneCampaignManager;
@protocol SLBSZoneCampaignManagerDelegate <NSObject>
/**
 *  ZoneCampaign 이벤트 발생시 외부(앱)에게 알려주는 인터페이스
 *
 *  @param manager          SLBSZoneCampaignManager
 *  @param zoneCampaignInfo ZoneCampaign 정보
 */
- (void)zoneCampaignManager:(SLBSZoneCampaignManager *)manager onCampaignPopup:(NSArray*)zoneCampaignList;

@end

/**
 * ZoneCampaign 관련 App간의 인터페이스 담당
 *
 * delegate 등록 및 event popup callback 처리
 */
@interface SLBSZoneCampaignManager : NSObject

@property (weak, nonatomic) id<SLBSZoneCampaignManagerDelegate> delegate;

+ (SLBSZoneCampaignManager*)sharedInstance;

- (void) startMonitoring;
- (void) stopMonitoring;

- (void)updateZoneCampaignListToServerWithBlock:(void (^)(BOOL succeess))block;

@end

#endif
