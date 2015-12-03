//
//  LSDummySuite.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//


#import "LSDummySuite.h"
#import "TSDebugLogManager.h"
#import "PositionSessionManager.h"

@interface LSDummySuite()
@property BOOL running;
@property NSTimer* timer;
@end

/**
 *  1차 검증용 DummySuite
 */
@implementation LSDummySuite

double x = 3300.;
double y = 700.;
int dirIncr = 1;
int floorID = 12;
int companyID = 1;
int branchID = 7;
int mapID = 1;


- (instancetype)init {
    self = [super init];
    
    _running = false;
    _timer = [[NSTimer alloc] init];
    
    return self;
}

- (void)startScan {
      NSLog(@"%s startScan", __PRETTY_FUNCTION__);
    
    if(_running) return;
    
  
    _running = true;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(report:) userInfo:nil repeats:YES];
}

- (void)stopScan {
    if(!_running) return;
    _running = false;
    [_timer invalidate];
}

- (void)report:(NSTimer*)timer{
    NSLog(@"%s report", __PRETTY_FUNCTION__);
    
    if (dirIncr == 6 && floorID == 12) {
        branchID = 7;
        floorID = 11;
        mapID = 2;
        x = 2500; y = 700;
    }
    if (dirIncr == 12 && floorID == 11) {
        branchID = 7;
        floorID = 12;
        mapID = 1;
        x = 600; y = 900;
    }
    
    [self updateLocation];
    SLBSCoordination* coordination = [[SLBSCoordination alloc] init];
    [coordination setCompanyID:[NSNumber numberWithInt:companyID]];
    [coordination setBranchID:[NSNumber numberWithInt:branchID]];
    [coordination setFloorID:[NSNumber numberWithInt:floorID]];
    [coordination setMapID:[NSNumber numberWithInt:mapID]];
    [coordination setX:x];
    [coordination setY:y];
    
    [self.delegate sensorSuite:self onLocation:coordination];
    
    [[PositionSessionManager sharedInstance] checkPosition:coordination];
    [[ZoneDataManager sharedInstance] setDelegate:self];
    [[ZoneDataManager sharedInstance] detectZone:coordination];

}

- (void)updateLocation {
    /*switch (dirIncr) {
        case 1: x += 20; if (x >= 680)  dirIncr = 2; break;
        case 2: y -= 20; if (y <= 400) dirIncr = 3; break;
        case 3: x += 20; if (x >= 1280)  dirIncr = 4; break;
        case 4: y += 20; if (y >= 620)   dirIncr = 5; break;
        case 5: x -= 20; if (x <= 1200)  dirIncr = 6; break;
        case 6: x += 20; if (x >= 900)   dirIncr = 7; break; // 2층
        case 7: y += 20; if (y >= 320)   dirIncr = 8; break;
        case 8: x += 20; if (x >= 1800)  dirIncr = 9; break; //
        case 9: x -= 20; if (x <= 900)  dirIncr = 10; break;
        case 10: y -= 20; if (y <= 270)  dirIncr = 11; break;
        case 11: x -= 20; if (x <= 830)  dirIncr = 12; break;
        case 12: x += 20; if (x >= 1280)  dirIncr = 13; break; // 1층
        case 13: y -= 20; if (y <= 400)  dirIncr = 14; break;
        case 14: x -= 20; if (x <= 680)  dirIncr = 15; break;
        case 15: y += 20; if (y >= 730)  dirIncr = 16; break;
        case 16: x -= 20; if (x <= 0)  dirIncr = 1; break;
        default: return;
    }*/
    
    switch (dirIncr) {
        case 1: y+= 20; if (y >= 900) dirIncr = 6; break;
        case 6: x+= 20; if (x >= 3200) dirIncr = 10; break; // 지하1층 시작
        case 10: x-= 20; if (x <= 2500) dirIncr = 12; break;
        case 12: y-= 20; if (y <= 300) dirIncr = 1; break; // 1층 시작
            
    }
}

- (void)zoneDataManager:(ZoneDataManager *)manager onZoneDetection:(NSInteger)zoneID {
    NSLog(@"%s onZoneDetection %ld", __PRETTY_FUNCTION__, (long)zoneID);
    [[PositionSessionManager sharedInstance] detectSessionOfPosition:zoneID delegate:self];
}

- (void)sessionManager:(ProximitySessionManager *)manager triggerProxZoneState:(NSNumber *)zoneID zoneState:(SLBSSessionType)zoneState {
    NSLog(@"%s triggerZoneState %@ %ld", __PRETTY_FUNCTION__, zoneID, (long)zoneState);
    [[ZoneCampaignDataManager sharedInstance] setDelegate:self];
    [[ZoneCampaignDataManager sharedInstance] detectZoneCampaign:zoneID sessionType:zoneState];

}

- (void)sessionManager:(PositionSessionManager *)manager triggerPosZoneState:(NSNumber *)zoneID zoneState:(SLBSSessionType)zoneState {
    NSLog(@"%s triggerZoneState %@ %ld", __PRETTY_FUNCTION__, zoneID, (long)zoneState);
    [[ZoneCampaignDataManager sharedInstance] setDelegate:self];
    [[ZoneCampaignDataManager sharedInstance] detectZoneCampaign:zoneID sessionType:zoneState];
    
}
- (void)ZoneCampaignDataManager:(ZoneCampaignDataManager *)manager onCampaignPopup:(NSArray *)zoneCampaignList {
    for(SLBSZoneCampaignInfo* zoneCampaignInfo in zoneCampaignList) {
         NSLog(@"%s onCampaignPopup %@", __PRETTY_FUNCTION__, zoneCampaignInfo.ID );
    }
    [self.delegate sensorSuite:self onEvent:zoneCampaignList];
}

@end
