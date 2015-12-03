//
//  LogManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_LogManager_h
#define SLBSKit_LogManager_h

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SLBSKitDefine.h"
#import "Policy.h"

/**
 * Log 저장 및 서버 전송 담당
 */
@interface LogManager : NSObject

+ (LogManager*)sharedInstance;

/**
 *  Wifi 상태 체크  Property
 *  Policy 정책 중 Wifi가 켜져 있는 상태에서의 Log upload 값과 상관 관계 있음
 */
@property (nonatomic) BOOL wifiCheckStatus;
/**
 *  Server에 Log Upload 여부 체크 property
 *  Policy 정책 중 Server Upload 값과 상관관계 있음
 */
@property (nonatomic) BOOL uploadServerStatus;

/**
 *  AppTracker, DeviceID 로그 저장
 *
 *  @param deviceID  device id
 *  @param appID     app id
 *  @param eventType event type
 *  @param logType   log type
 */
- (void)saveLogWithDeviceID:(NSString*)deviceID appID:(NSString*)appID eventType:(NSNumber*)eventType logType:(NSNumber*)logType;

/**
 *  Location 관련 로그 저장
 *
 *  @param deviceID       device id
 *  @param appID          app id
 *  @param locationLog    SLBS 좌표계의 String 값
 *  @param companyID      company id
 *  @param branchID       branch id
 *  @param floorID        florr id
 *  @param coordX         x
 *  @param coordY         y
 *  @param zoneID         zone id
 *  @param zoneCampaignID zone campagin id
 *  @param zoneLogType    zone log type - beacon/geofence
 */

- (void)saveRouteLogWithDeviceID:(NSString*)deviceID appID:(NSString*)appID locationLog:(NSString*)locationLog companyID:(NSNumber*)companyID branchID:(NSNumber*)branchID floorID:(NSNumber*)floorID coordX:(double)coordX coordY:(double)coordY zoneID:(NSNumber*)zoneID zoneCampaignID:(NSNumber*)zoneCampaignID zoneLogType:(NSNumber*)zoneLogType;

/**
 *  App Foreground 진입시 Log Server 전송
 * wifi/server upload 상태값 체크하여 조건 맞을때만 server upload 하도록 구현
 */
- (void)uploadToServer;

/**
 *  로그 관련 polity 셋팅
 *
 *  @param policyData policy Data
 */
- (void)setPolicy:(Policy*)policyData;

@end

#endif
