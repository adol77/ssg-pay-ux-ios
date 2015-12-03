//
//  ProximitySessionManager.h
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 9..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBSCoordination.h"
#import "SLBSKitDefine.h"

@class ProximitySessionManager;

/**
 *  ProximitySession Delegate
 *  Proximity Beacon의 Session Type이 변경될 경우 호출되는 Delegate
 */
@protocol ProximitySessionManagerDelegate <NSObject>
- (void)sessionManager:(ProximitySessionManager *)manager triggerProxZoneState:(NSNumber*)zoneID zoneState:(SLBSSessionType)zoneState;
@end

/**
 *  Proximity Beacon의 Session 관리
 */
@interface ProximitySessionManager : NSObject

@property (weak, nonatomic) id<ProximitySessionManagerDelegate> delegate;

+ (ProximitySessionManager*)sharedInstance;

/**
 *  Session Detection 위한 외부 인터페이스
 *  Exit 처리 위해 현재 위치 정보도 같이 전달해 줘야 함.
 *
 *  @param zoneID       zone ID
 *  @param delegate     delegate
 */
- (void) detectSessionOfProximity:(NSInteger)zoneID delegate:(id<ProximitySessionManagerDelegate>) delegate;
@end