//
//  BeaconNet.h
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INNet.h"

/**
 Beacon 관련 Rest API 담당
 */
@interface BeaconNet : INNet
@property (readonly) NSArray *beaconList;


/**
 *  Beacon 정보 전체 가져오는 API
 *
 *  @param token accessToken
 *  @param block block
 */
+ (void)requestBeaconListWithAccessToken:(NSString*)token block:(void (^)(BeaconNet *netObject))block;

/**
 *  company, branch, floor 값으로 Beacon 정보 가져오는 함수
 *
 *  @param companyID  company id
 *  @param branchID  branch id
 *  @param floorID   floor id
 *  @param token     access token
 *  @param block     block
 */
+ (void)requestBeaconListWithCompanyID:(NSNumber*)companyID branchID:(NSNumber*)branchID floorID:(NSNumber*)floorID token:(NSString*)token block:(void (^)(BeaconNet *netObject))block;

/**
 *  특정 UUID, Major, Minor 값으로 Beacon List 가져오는 함수
 *
 *  @param uuid  UUID
 *  @param major beacon major
 *  @param minor beacon minor
 *  @param token access token
 *  @param block block
 */
+ (void)requestBeaconListWithUUID:(NSString*)uuid major:(NSNumber*)major minor:(NSNumber*)minor token:(NSString*)token block:(void (^)(BeaconNet *netObject))block;


/**
 *  UUID 전체 리스트 가져오는 함수
 *
 *  @param token accessToken
 *  @param block block
 */
+ (void)requestUUIDListWithAccessToken:(NSString*)token block:(void (^)(BeaconNet *netObject))block;

/**
 *  company값으로 UUID List 가져오는 함수
 *
 *  @param companyID  company id
 *  @param token     access token
 *  @param block     block
 */
+ (void)requestUUIDListWithCompanyID:(NSNumber*)companyID token:(NSString*)token block:(void (^)(BeaconNet *netObject))block;
@end
