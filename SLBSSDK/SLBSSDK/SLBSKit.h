//
//  SLBSKit.h
//  SLBSKit
//
//  Created by KimHeedong on 2015. 8. 18..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBSKitDefine.h"
#import "SLBSCoordination.h"
#import "SLBSZoneCampaignInfo.h"
#import "SLBSMapData.h"
#import "LOCLocationEngine.h"
#import "MapDataManager.h"
#import "TSDebugLogManager.h"

@class SLBSKit;

/**
 *  Location Delegate
 */
@protocol SLBSKitLocationDelegate <NSObject>
/**
 *  위치 정보 전달
 *
 *  @param manager  SLBSKit
 *  @param location SLBSCoordination
 */
- (void)slbskit:(SLBSKit *)manager onLocation:(SLBSCoordination*)location;
@end

/**
 *  Zone Campaign Delegate
 */
@protocol SLBSKitZoneCampaignDelegate <NSObject>
/**
 *  ZoneCampaign 전달
 *
 *  @param manager          SLBSKit
 *  @param zoneCampaignList ZoneCampaign Array
 */
- (void)slbskit:(SLBSKit *)manager didEventCampaign:(NSArray*)zoneCampaignList;
@end

/**
 *  Map Delegate
 */
@protocol SLBSKitMapDelegate <NSObject>
/**
 *  Map 정보 요청 사전 준비 완료 알림
 */
- (void)onServiceReady;
@end

/**
 *  Data Delegate
 */
@protocol SLBSKitDataDelegate <NSObject>
/**
 *  Data 요청 사전 준비 완료 알림
 */
- (void)onServiceReady;
@end

/**
 *  SLBS Service 전체적인 Flow 관리
 */
@interface SLBSKit : NSObject <LOCLocationDelegate, LOCZoneCampaignDelegate>
@property (weak, nonatomic) id<SLBSKitLocationDelegate    > locationDelegate;
@property (weak, nonatomic) id<SLBSKitZoneCampaignDelegate> zoneCampaignDelegate;
@property (strong, nonatomic) id<SLBSKitMapDelegate> mapDelegate;
@property (weak, nonatomic) id<SLBSKitDataDelegate> dataDelegate;
@property (nonatomic, assign) BOOL hasAlreadyAccessToken;

+ (SLBSKit*)sharedInstance;

/**
 *  서비스 시작
 *
 *  @param serviceCategory SLBSServiceCategory
 */
- (void)startService:(SLBSServiceCategory)serviceCategory;

/**
 *  서비스 중단
 */
- (void)stopService;

/**
 *  서비스 시작 전 서버와 통신 준비 완료 알림
 */
-(void)readyToAccessToken;
@end



