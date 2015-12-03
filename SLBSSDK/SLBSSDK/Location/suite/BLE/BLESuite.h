//
//  BLESuite.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_BLESuite_h
#define SLBSKit_BLESuite_h

#import "BLESessionMgr.h"
#import "LSSuite.h"
#import "BLEProximity.h"
#import "ZoneDataManager.h"
#import "ZoneCampaignDataManager.h"
#import "BLELocationExaminer.h"
#import "ProximitySessionManager.h"
#import "PositionSessionManager.h"

/**
 * BLEControl, BLESessionManager를 연결하고 BLELocator와 BLESelector를 연결한다.
 * 비콘 관련 이벤트를 LSSuiteListener에게 전달하고, 일정 시간간격마다 BLELocator에게 위치 계산을 지시한다.
 */
@interface BLESuite : LSSuite <BLESessionMgrListener, BLELocationExaminerListener, BLEProximityListener, ZoneDataManagerDelegate, ProximitySessionManagerDelegate, PositionSessionManagerDelegate, ZoneCampaignDataManagerDelegate>
+ (BLESuite*) sharedInstance;
-(void)tick:(long)currentTimeInMillis;
@end

#endif
