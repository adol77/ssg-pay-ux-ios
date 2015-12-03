//
//  LSDummySuite.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSuite.h"
#import "ZoneDataManager.h"
#import "ZoneCampaignDataManager.h"
#import "ProximitySessionManager.h"
#import "PositionSessionManager.h"

@interface LSDummySuite : LSSuite <ZoneDataManagerDelegate, ProximitySessionManagerDelegate, PositionSessionManagerDelegate, ZoneCampaignDataManagerDelegate>

@end
