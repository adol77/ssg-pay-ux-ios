//
//  PositionSessionManager.h
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLBSCoordination.h"
#import "SLBSKitDefine.h"

@class PositionSessionManager;

/**
 *  Positioning Session Delegate
 *  Positioning Beacon과 Geofence의 Session Type이 변경될 경우 호출되는 Delegate
 */
@protocol PositionSessionManagerDelegate <NSObject>
- (void)sessionManager:(PositionSessionManager *)manager triggerPosZoneState:(NSNumber*)zoneID zoneState:(SLBSSessionType)zoneState;
@end

/**
 *  Positioning Beacon과 Geofence의 Session 관리
 */
@interface PositionSessionManager : NSObject

@property (weak, nonatomic) id<PositionSessionManagerDelegate> delegate;

+ (PositionSessionManager*)sharedInstance;

/**
 *  위치 정보를 바탕으로 Zone Exit 체크
 *
 *  @param coordination SLBS 좌표
 */
- (void) checkPosition:(SLBSCoordination*)coordination;

/**
 *  Session Detection 위한 외부 인터페이스
 *  Exit 처리 위해 현재 위치 정보도 같이 전달해 줘야 함.
 *
 *  @param zoneID       zone ID
 *  @param delegate     delegate
 */
- (void)detectSessionOfPosition:(NSInteger)zoneID delegate:(id<PositionSessionManagerDelegate>)delegate;
@end