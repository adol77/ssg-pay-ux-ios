//
//  ProximitySessionManager.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 9..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "ProximitySessionManager.h"
#import "TSDebugLogManager.h"

const double DWELL_DURATION = 60.0f;
const double EXIT_DURATION = 15.0f;

const NSString *SESSION_DWELL_TIMER         = @"dwelltimer";
const NSString *SESSION_EXIT_TIMER          = @"exittimer";
const NSString *SESSION_ZONE_ID             = @"zoneID";
const NSString *SESSION_TYPE               = @"type";
const NSString *SESSION_DELEGATE           = @"delegate";


@interface ProximitySessionManager()
@property NSMutableArray* proximitySessionList;
@end

@implementation ProximitySessionManager

+ (ProximitySessionManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static ProximitySessionManager *sharedProximitySessionManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedProximitySessionManager = [[ProximitySessionManager alloc] init];
    });
    return sharedProximitySessionManager;
}

- (instancetype)init {
    self = [super init];
    
    _proximitySessionList = [[NSMutableArray alloc] init];
    return self;
}


- (void)detectSessionOfProximity:(NSInteger)zoneID delegate:(id<ProximitySessionManagerDelegate>)delegate {
    //TSGLog(TSLogGroupLocation, @"detectSessionOfProximity zoneID %ld", (long)zoneID);
    
    NSMutableDictionary* zoneSessionDic = [self getProximitySession:zoneID];
    
    if(zoneSessionDic == nil) {
        [self addProximitySession:zoneID delegate:delegate];
        [delegate sessionManager:self triggerProxZoneState:[NSNumber numberWithInteger:zoneID] zoneState:SLBSSessionEnter];
    }
    else {
        [self stopTimer:zoneSessionDic];
        [self updateTimer:zoneSessionDic];
    }
}


/**
 *  PositionSession Dictionary 추가
 *  Zone Detection 완료되었기 때문에 Enter로 추가
 *
 *  @param zoneID   Zone ID
 *  @param delegate Geofence와 혼용하여 사용할거라, 각 Suite별 Delegate 처리를 위해 각 PositionSession별 Delegate 관리
 */
- (void)addProximitySession:(NSInteger)zoneID delegate:(id<ProximitySessionManagerDelegate>)delegate{
    // TSGLog(TSLogGroupLocation, @"addProximitySession zoneID %ld", (long)zoneID);
    
    NSTimer* dwellTimer = [NSTimer scheduledTimerWithTimeInterval:DWELL_DURATION target:self selector:@selector(checkDwell:) userInfo:[NSNumber numberWithInteger:zoneID] repeats:YES];
    NSTimer* exitTimer = [NSTimer scheduledTimerWithTimeInterval:EXIT_DURATION target:self selector:@selector(checkExit:) userInfo:[NSNumber numberWithInteger:zoneID] repeats:YES];
    

    NSMutableDictionary* sessionDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInteger:zoneID], SESSION_ZONE_ID,
                                [NSNumber numberWithInteger:SLBSSessionEnter], SESSION_TYPE,
                                exitTimer, SESSION_EXIT_TIMER,
                                dwellTimer, SESSION_DWELL_TIMER,
                                delegate, SESSION_DELEGATE,
                                       nil];
    
    [_proximitySessionList addObject:sessionDic];
}

/**
 *  Proximity Session Dictionary 삭제
 *  Session Type Exit 시 사용
 *
 *  @param zoneID Zone ID
 */
- (void)removeProximitySession:(NSInteger)zoneID {
    NSMutableDictionary* sessionDic = [self getProximitySession:zoneID];
    
    if(sessionDic !=nil)
    {
        //TSGLog(TSLogGroupLocation, @"removeProximitySession zoneID %ld", (long)zoneID);

        NSInteger index = [_proximitySessionList indexOfObject:sessionDic];
        [_proximitySessionList removeObjectAtIndex:index];
    }
    
}

/**
 *  Proximity Session Dictionary Update
 *  대부분 SessionType Dwell 저장시 사용
 *
 *  @param zoneID      Zone ID
 *  @param sessionType SessionType
 */
- (void)updateProximitySession:(NSInteger)zoneID session:(NSInteger)sessionType {
    NSMutableDictionary* sessionDic = [self getProximitySession:zoneID];
    NSInteger index = [_proximitySessionList indexOfObject:sessionDic];
    NSNumber* beforeType = [sessionDic objectForKey:SESSION_TYPE];
 
    // TSGLog(TSLogGroupLocation, @"updateProximitySession zoneID %ld beforetype %@ aftertype %ld", (long)zoneID, beforeType, (long)sessionType);
    
    [sessionDic setObject:[NSNumber numberWithInteger:sessionType] forKey:SESSION_TYPE];
    
    [_proximitySessionList replaceObjectAtIndex:index withObject:sessionDic];
}

/**
 *  Proximity Session Query
 *
 *  @param zoneID Zone ID
 *
 *  @return Position Session Dictionary
 */
- (NSMutableDictionary*)getProximitySession:(NSInteger)zoneID {
    //TSGLog(TSLogGroupLocation, @"getPositionSession zoneID %ld", (long)zoneID);
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"zoneID == %ld", zoneID];
    NSArray * fetchResults = [_proximitySessionList filteredArrayUsingPredicate:predicate];
    
    if([fetchResults count] == 0)
        return nil;
    
    return [fetchResults objectAtIndex:0];
}

/**
 *  Dwell Timer 동작시 호출되는 함수
 *  1분에 한번씩 호출되며 Enter/Dwell 상태 체크하여 Dwell 유지되어 있는 Position의 경우 Dwell 상태 전달
 *
 *  @param timer Dwell Timer
 */
- (void)checkDwell:(NSTimer*)timer {
    
    NSNumber* zoneID = (NSNumber*)[timer userInfo];
    
    NSDictionary* sessionDic = [self getProximitySession:[zoneID integerValue]];
    if(sessionDic == nil){
        [timer invalidate];
        [timer fire];
        timer = nil;
    }
    
    NSInteger type = [[sessionDic objectForKey:SESSION_TYPE] integerValue];
    if(type == SLBSSessionEnter) {
        [self updateProximitySession:[[sessionDic objectForKey:SESSION_ZONE_ID] integerValue] session:SLBSSessionDwell];
        id<ProximitySessionManagerDelegate> delegate = [sessionDic objectForKey:SESSION_DELEGATE];
        [delegate sessionManager:self triggerProxZoneState:[sessionDic objectForKey:SESSION_ZONE_ID] zoneState:SLBSSessionDwell];
        
    }
    else if(type == SLBSSessionDwell) {
        id<ProximitySessionManagerDelegate> delegate = [sessionDic objectForKey:SESSION_DELEGATE];
        [delegate sessionManager:self triggerProxZoneState:[sessionDic objectForKey:SESSION_ZONE_ID] zoneState:SLBSSessionDwell];
    }
}

/**
 *  Exit Timer 동작시 호출되는 함수
 *  15초에 한번씩 호출되며 해당 함수 호출되는 경우 Exit 처리
 *
 *  @param timer NSTimer
 */
- (void)checkExit:(NSTimer*)timer {
    
    NSNumber* zoneID = (NSNumber*)[timer userInfo];
    
    NSDictionary* sessionDic = [self getProximitySession:[zoneID integerValue]];
    if(sessionDic == nil){
        [timer invalidate];
        [timer fire];
        timer = nil;
    }
    
    NSInteger type = [[sessionDic objectForKey:SESSION_TYPE] integerValue];
    if(type == SLBSSessionEnter || type == SLBSSessionDwell) {
        [self stopTimer:sessionDic];
       
        //Exit 알림
        id<ProximitySessionManagerDelegate> delegate = [sessionDic objectForKey:SESSION_DELEGATE];
        [delegate sessionManager:self triggerProxZoneState:[sessionDic objectForKey:SESSION_ZONE_ID] zoneState:SLBSSessionExit];
        
        //List에서 제거
        [self removeProximitySession:[zoneID integerValue]];

        
        
    }
}

/**
 *  Dwell/Exit Timer 업데이트
 *  해당 함수 불린 시점부터 Timer 다시 시작.
 *  @param zoneSessionDic <#zoneSessionDic description#>
 */
- (void)updateTimer:(NSMutableDictionary*)zoneSessionDic {
    NSInteger index = [_proximitySessionList indexOfObject:zoneSessionDic];
    NSNumber* zoneID = [zoneSessionDic objectForKey:SESSION_ZONE_ID];
    
    //DwellTimer 업데이트
    NSTimer* updateDwellTimer = [NSTimer scheduledTimerWithTimeInterval:DWELL_DURATION target:self selector:@selector(checkDwell:) userInfo:zoneID repeats:YES];
    //ExitTimer 업데이트
    NSTimer* updateExitTimer = [NSTimer scheduledTimerWithTimeInterval:EXIT_DURATION target:self selector:@selector(checkExit:) userInfo:zoneID repeats:YES];
    
    //Dictionary에 업데이트
    [zoneSessionDic setObject:updateDwellTimer forKey:SESSION_DWELL_TIMER];
    [zoneSessionDic setObject:updateExitTimer forKey:SESSION_EXIT_TIMER];
    
    //ProximityList에 업데이트
    [_proximitySessionList replaceObjectAtIndex:index withObject:zoneSessionDic];
}

- (void)stopTimer:(NSDictionary*)zoneSessionDic {
    //Dwell Timer 중지 및 초기화
    NSTimer* dwellTimer = [zoneSessionDic objectForKey:SESSION_DWELL_TIMER];
    [dwellTimer invalidate];
    dwellTimer = nil;
    
    //Exit Timer 중지 및 초기화
    NSTimer* exitTimer = [zoneSessionDic objectForKey:SESSION_EXIT_TIMER];
    [exitTimer invalidate];
    exitTimer = nil;
}
@end
