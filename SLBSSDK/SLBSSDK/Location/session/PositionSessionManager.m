//
//  PositionSessionManager.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#include <sys/time.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "PositionSessionManager.h"
#import "ZoneDataManager.h"
#import "ZoneCoord.h"
#import "TSDebugLogManager.h"

/**
 *  Dwell 체크 시간 1분으로 설정
 */
const double POS_DWELL_DURATION = 60.0f;
/**
 *  Exit 체크 시간은 15초로 설정
 *  Beacon 신호를 못 받는 경우를 대비한 Timer
 */
const double POS_EXIT_DURATION = 15.0f;

const NSString *posSessionFloorID            = @"floorID";
const NSString *posSessionZoneID             = @"zoneID";
const NSString *posSessionType               = @"type";
const NSString *posSessionDelegate           = @"delegate";
const NSString *posSessionTimestamp           = @"timestamp";

/**
 *  Position(BLE positioning, Geofence) Session 관리 클래스
 *  Enter,Dwell, Exit 처리
 */
@interface PositionSessionManager()
@property NSMutableArray* positionSessionList;
@property NSNumber* currentFloorID;
@end

@implementation PositionSessionManager

+ (PositionSessionManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static PositionSessionManager *sharedPositionSessionManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedPositionSessionManager = [[PositionSessionManager alloc] init];
    });
    return sharedPositionSessionManager;
}

- (instancetype)init {
    self = [super init];
    
    _positionSessionList = [[NSMutableArray alloc] init];
    return self;
}


- (void)detectSessionOfPosition:(NSInteger)zoneID delegate:(id<PositionSessionManagerDelegate>)delegate {
    dispatch_async(dispatch_get_main_queue(), ^{
        //TSGLog(TSLogGroupLocation, @"detectSessionOfPosition zoneID %ld", (long)zoneID);
        NSLog(@"%s detectSessionOfPosition %ld", __PRETTY_FUNCTION__, (long)zoneID);
        NSMutableDictionary* zoneSessionDic = [self getPositionSession:zoneID];
        
        if(zoneSessionDic == nil) {
            Zone* zone = [[ZoneDataManager sharedInstance] zoneForID:[NSNumber numberWithInteger:zoneID]];
            [self addPositionSession:zone delegate:delegate];
            [delegate sessionManager:self triggerPosZoneState:[NSNumber numberWithInteger:zoneID] zoneState:SLBSSessionEnter];
        }
        else {
            NSInteger index = [_positionSessionList indexOfObject:zoneSessionDic];
            [zoneSessionDic setObject:[NSDate date] forKey:posSessionTimestamp];
            [_positionSessionList replaceObjectAtIndex:index withObject:zoneSessionDic];
        }
    });
}

/**
 *  PositionSession Dictionary 추가
 *  Zone Detection 완료되었기 때문에 Enter로 추가
 *
 *  @param zone     Dictionary에 추가될 Zone
 *  @param delegate Geofence와 혼용하여 사용할거라, 각 Suite별 Delegate 처리를 위해 각 PositionSession별 Delegate 관리
 */
- (void)addPositionSession:(Zone*)zone delegate:(id<PositionSessionManagerDelegate>)delegate{
    // NSLog(@"%s addPositionSession %@", __PRETTY_FUNCTION__, zone.zone_id);
    //TSGLog(TSLogGroupLocation, @"addPositionSession zoneID %@", zone.zone_id);
    
    NSNumber* zoneID = zone.zone_id;
    NSNumber* floorID = zone.store_floor_id;
    
    NSMutableDictionary* sessionDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:zoneID, posSessionZoneID,
                                floorID, posSessionFloorID,
                                [NSDate date], posSessionTimestamp,
                                [NSNumber numberWithInteger:SLBSSessionEnter], posSessionType,
                                delegate, posSessionDelegate, nil];
    
    [NSTimer scheduledTimerWithTimeInterval:POS_DWELL_DURATION target:self selector:@selector(checkDwell:) userInfo:sessionDic repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:POS_EXIT_DURATION target:self selector:@selector(checkExit:) userInfo:sessionDic repeats:YES];
    
    [_positionSessionList addObject:sessionDic];
}

/**
 *  Position Session Dictionary 삭제
 *  Session Type Exit 시 사용
 *
 *  @param zoneID Zone ID
 */
- (void)removePositionSession:(NSInteger)zoneID {
   // NSLog(@"%s removePositionSession", __PRETTY_FUNCTION__);
    
    NSMutableDictionary* sessionDic = [self getPositionSession:zoneID];
    
    if(sessionDic !=nil) {
        //TSGLog(TSLogGroupLocation, @"removePositionSession zoneID %ld", (long)zoneID);
        [_positionSessionList removeObject:sessionDic];
    }
}

/**
 *  Position Session Dictionary Update
 *  대부분 SessionType Dwell 저장시 사용
 *
 *  @param zoneID      Zone ID
 *  @param type        SessionType
 */
- (void)updatePositionSession:(NSInteger)zoneID session:(NSInteger)type {
   // NSLog(@"%s updatePositionSession %ld %ld", __PRETTY_FUNCTION__, (long)zoneID, (long)type);
    NSMutableDictionary* sessionDic = [self getPositionSession:zoneID];
    NSNumber* beforeType = [sessionDic objectForKey:posSessionType];
    
    //TSGLog(TSLogGroupLocation, @"updatePositionSession zoneID %ld beforetype %@ aftertype %ld", (long)zoneID, beforeType, (long)type);
    
    // NSLog(@"%s updatePositionSession %@", __PRETTY_FUNCTION__, sessionDic);
    NSInteger index = [_positionSessionList indexOfObject:sessionDic];
    
     // NSLog(@"%s updatePositionSession %ld", __PRETTY_FUNCTION__, (long)index);
    [sessionDic setObject:[NSNumber numberWithInteger:type] forKey:posSessionType];
    
    [_positionSessionList replaceObjectAtIndex:index withObject:sessionDic];
}

/**
 *  Position Session Query
 *
 *  @param zoneID Zone ID
 *
 *  @return Position Session Dictionary
 */
- (NSMutableDictionary*)getPositionSession:(NSInteger)zoneID {
    //TSGLog(TSLogGroupLocation, @"getPositionSession zoneID %ld", (long)zoneID);
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"zoneID == %ld", zoneID];
    NSArray * fetchResults = [_positionSessionList filteredArrayUsingPredicate:predicate];
    
    if([fetchResults count] == 0)
        return nil;
    
    return [fetchResults objectAtIndex:0];
}

/**
 *  Dwell Timer 동작시 호출되는 함수
 *  1분에 한번씩 호출되며 Enter/Dwell 상태 체크하여 Dwell 유지되어 있는 Position의 경우 Dwell 상태 전달
 *
 *  @param timer 각 SessionDictionary에 등록된 Dwell Timer
 */
- (void)checkDwell:(NSTimer*)timer {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* sessionDic = (NSDictionary*)[timer userInfo];
        
        NSLog(@"%s checkDwell %@", __PRETTY_FUNCTION__, [sessionDic objectForKey:posSessionZoneID]);
        
        BOOL timerState = [timer isValid];
        NSLog(@"Dwell Timer Validity is: %@, %@, %@", timer, [sessionDic objectForKey:posSessionZoneID],  timerState?@"YES":@"NO");
        
        if([self getPositionSession:[[sessionDic objectForKey:posSessionZoneID] integerValue]] == nil){
            [timer invalidate];
            [timer fire];
            [self resetTimer:timer];
            return;
        }
        
        
        
        NSInteger type = [[sessionDic objectForKey:posSessionType] integerValue];
        if(type == SLBSSessionEnter) {
            [self updatePositionSession:[[sessionDic objectForKey:posSessionZoneID] integerValue] session:SLBSSessionDwell];
            id<PositionSessionManagerDelegate> delegate = [sessionDic objectForKey:posSessionDelegate];
            [delegate sessionManager:self triggerPosZoneState:[sessionDic objectForKey:posSessionZoneID] zoneState:SLBSSessionDwell];
            [timer invalidate];
            [timer fire];
            [self resetTimer:timer];
            
        }
        else if(type == SLBSSessionDwell) {
            id<PositionSessionManagerDelegate> delegate = [sessionDic objectForKey:posSessionDelegate];
            [delegate sessionManager:self triggerPosZoneState:[sessionDic objectForKey:posSessionZoneID] zoneState:SLBSSessionDwell];
            [timer invalidate];
            [timer fire];
            [self resetTimer:timer];
        }
    });

}

/**
 *  Exit Timer 동작시 호출되는 함수
 *  15초에 한번씩 호출되며 Enter/Dwell 상태 체크하여 Exit Timer 동작할 동안 비콘 신호를 받지 못한 경우 Exit 상태 전달
 *
 *  @param timer 각 SessionDictionary에 등록된 Exit Timer
 */
- (void)checkExit:(NSTimer*)timer {

    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary* sessionDic = (NSDictionary*)[timer userInfo];
        
        NSLog(@"%s checkExit %@", __PRETTY_FUNCTION__, [sessionDic objectForKey:posSessionZoneID]);
        
        BOOL timerState = [timer isValid];
        NSLog(@"Exit Timer Validity is: %@, %@, %@", timer, [sessionDic objectForKey:posSessionZoneID],  timerState?@"YES":@"NO");
        
        NSDate *sessionDate = [sessionDic objectForKey:posSessionTimestamp];
        
        NSTimeInterval timeInterval = [sessionDate timeIntervalSinceNow];
        
        if(-timeInterval < POS_EXIT_DURATION)
            return;
        
        NSInteger type = [[sessionDic objectForKey:posSessionType] integerValue];
        if(type == SLBSSessionEnter || type == SLBSSessionDwell) {
            id<PositionSessionManagerDelegate> delegate = [sessionDic objectForKey:posSessionDelegate];
            [delegate sessionManager:self triggerPosZoneState:[sessionDic objectForKey:posSessionZoneID] zoneState:SLBSSessionExit];
            [self removePositionSession:[[sessionDic objectForKey:posSessionZoneID] integerValue]];
            
            [timer invalidate];
            [timer fire];
            [self resetTimer:timer];
        }
    });
}


- (void) checkPosition:(SLBSCoordination*)coordination {
     NSLog(@"%s checkPosition", __PRETTY_FUNCTION__);
    
    if([_positionSessionList count] == 0 ) return;
    
    //층이 변경된 경우 이전 Zone들을 Exit 처리
    //Geofence인 경우 floorID가 없음.
    //그래서 Floor 비교 루틴은 Beacon인 경우만 처리해야함.
    if(coordination.floorID != nil &&
       self.currentFloorID != nil &&
       ![coordination.floorID isEqualToNumber:self.currentFloorID] &&
       [coordination.type integerValue] == SLBSCoordBeacon) {
        for(int i = 0; i < [_positionSessionList count]; i++) {
            NSDictionary* sessionDic = [_positionSessionList objectAtIndex:i];
            NSInteger zoneID = [[sessionDic objectForKey:posSessionZoneID] integerValue];
            NSNumber* floorID = [sessionDic objectForKey:posSessionFloorID];
            
            //Zone의 층과 현재 층 비교하여 다른 경우만 Exit 처리
            if(![coordination.floorID isEqualToNumber:floorID]) {
                id<PositionSessionManagerDelegate> delegate = [sessionDic objectForKey:posSessionDelegate];
                [delegate sessionManager:self triggerPosZoneState:[NSNumber numberWithInteger:zoneID] zoneState:SLBSSessionExit];
                [self removePositionSession:zoneID];
            }
        }
    }
    else {
        for(int i = 0; i < [_positionSessionList count]; i++) {
            NSDictionary* sessionDic = [_positionSessionList objectAtIndex:i];
            
            NSInteger type = [[sessionDic objectForKey:posSessionType] integerValue];
            
            if(type == SLBSSessionEnter || type == SLBSSessionDwell) {
                NSInteger zoneID = [[sessionDic objectForKey:posSessionZoneID] integerValue];
                Zone* zone = [[ZoneDataManager sharedInstance] zoneForID:[NSNumber numberWithInteger:zoneID]];
                
                BOOL exitState = [self checkPositionExitState:zone location:coordination];
                
                if(exitState) {
                    id<PositionSessionManagerDelegate> delegate = [sessionDic objectForKey:posSessionDelegate];
                    [delegate sessionManager:self triggerPosZoneState:[NSNumber numberWithInteger:zoneID] zoneState:SLBSSessionExit];
                    [self removePositionSession:zoneID];
                    
                }
            }
        }

    }
    
    self.currentFloorID = coordination.floorID;
}

/**
 *  Exit 체크
 *  Enter 조건은 Polygon 진입시
 *  Exit 조건은 Polygon을 감싸는 외접원을 벗어난 경우
 *
 *  @param zone         Zone 정보
 *  @param coordination 현재 위치
 *
 *  @return Position Exit인 경우 TRUE, 그렇지 않으면 FALSE
 */
- (BOOL) checkPositionExitState:(Zone*)zone location:(SLBSCoordination*)coordination {
    CGPoint curPoint = CGPointMake(coordination.x, coordination.y);
    CGPoint centerPoint = CGPointMake(zone.center_x, zone.center_y);
    float distance = 0.0;
    
    //Todo
    //Zone 생성시 서버에서 Radius 계산하여 가져 있어야 하는지?
    //서버에서 데이터 받았을때 Radius 값 계산해야 하는지?
    for(ZoneCoord* zoneCoord in zone.coords)
    {
        CGPoint zonePoint = CGPointMake(zoneCoord.x, zoneCoord.y);
        float calDistance = [self distanceBetween:centerPoint and:zonePoint];
        if(calDistance > distance)
            distance = calDistance;
    }
    
    //Todo
    //현재는 외접원 벗어난 경우 Exit 처리
    //실 상황에 적용해보고 외접원보다 조금 더 크게 반경 잡아야 할 수도 있음.
    float curDistance = [self distanceBetween:curPoint and:centerPoint];
    
    NSLog(@"%s checkPositionExitState %@ %@, %f, %f", __PRETTY_FUNCTION__, zone.zone_id, coordination, curDistance, distance);
    if(curDistance > distance)
        return true;
    else
       return false;
}

/**
 *  거리 계산
 *
 *  @param p1 시작점
 *  @param p2 끝점
 *
 *  @return <#return value description#>
 */
- (float) distanceBetween : (CGPoint) p1 and: (CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}

/**
 *  Timer 초기화 함수
 *
 *  @param timer NStimer
 */
- (void)resetTimer:(NSTimer*)timer {
    timer = nil;
}
@end
