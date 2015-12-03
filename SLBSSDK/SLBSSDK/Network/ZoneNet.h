//
//  ZoneNet.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INNet.h"

/**
 *  Zone 서버와의 통신 담당
 */
@interface ZoneNet : INNet
@property (readonly) NSArray *zoneList;

/**
 *  Zone List 전체 요청 API
 *
 *  @param token accessToken
 *  @param block block
 */
+ (void)requestZoneListWithAccessToken:(NSString*)token block:(void (^)(ZoneNet *netObject))block;


/**
 *  ZoneID로 존 정보 요청하는 API
 *
 *  @param zoneID      zone ID
 *  @param token accessToken
 *  @param block        block
 */
+ (void)requestZoneWithID:(NSNumber *)zoneID accessToken:(NSString*)token block:(void (^)(ZoneNet *netObject))block;

/**
 *   MapID로 존 정보 요청하는 API
 *
 *  @param zoneID      zone ID
 *  @param token accessToken
 *  @param block        block
 */
+ (void)requestZoneListWithMapID:(NSNumber *)zoneID accessToken:(NSString*)token block:(void (^)(ZoneNet *netObject))block;

/**
 *  BranchID로 존 정보 요청하는 API
 *
 *  @param branchID branchID
 *  @param token    accessToken
 *  @param block    block
 */
+ (void)requestZoneListWithBranchID:(NSNumber *)branchID accessToken:(NSString*)token block:(void (^)(ZoneNet *netObject))block;

@end

