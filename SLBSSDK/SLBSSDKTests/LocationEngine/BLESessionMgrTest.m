//
//  BLESessionMgrTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BLEBeaconInfo.h"
#import "BLEBeaconSession.h"
#import "BLEBeaconScan.h"
#import "BLESessionMgr.h"

@interface BLESessionMgrTestListener : NSObject<BLESessionMgrListener>
-(void)onDiscovery:(BLEBeaconInfo*)beacon;
-(void)onLost:(BLEBeaconInfo*)beacon;
@property BOOL discovery;
@property BOOL lost;
@end

@implementation BLESessionMgrTestListener
-(instancetype) init
{
    if ( self = [super init])
    {
        _discovery = _lost = NO;
    }
    return self;
}
-(void)onDiscovery:(BLEBeaconInfo*)beacon
{
    _discovery = YES;
}
-(void)onLost:(BLEBeaconInfo*)beacon
{
    _lost = YES;
}
@end


@interface BLESessionMgrTest : XCTestCase

@end


@implementation BLESessionMgrTest {
    NSUUID* uuid;
    BLEBeaconScan* scans[4];
    BLESessionMgr* sessionMgr;
    BLESessionMgrTestListener* listener;
}


- (void)setUp {
    [super setUp];
    uuid = [NSUUID UUID];
    
    const float rssi[4] = { -80.f, -70.f, -50.f, -40.f };
    for ( int i = 0 ; i < 4 ; i++ ) {
        BLEBeaconInfo* beacon = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:i+1];
        scans[i] = [[BLEBeaconScan alloc] initWith:beacon Rssi:rssi[i]];
    }
    
    sessionMgr = [[BLESessionMgr alloc] init];
    listener = [[BLESessionMgrTestListener alloc] init];
    sessionMgr.listener = listener;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDiscovery {
    [sessionMgr onSensorData:scans[0]];
    XCTAssert(listener.discovery);
}

- (void)testLost {
    [sessionMgr onSensorData:scans[0] On:0];
    [sessionMgr tick:15*1000];
    XCTAssert(listener.discovery);
    XCTAssert(listener.lost);
}

-(void)testStrongestBeacon {
    for ( int i = 0 ; i < 4 ; i++ ) {
        [sessionMgr onSensorData:scans[i]];
    }
    
    NSArray* output = [sessionMgr strongestBeaconScans:2];
    XCTAssertEqual(4, ((BLEBeaconSession*)(output[0])).beaconInfo.minor);
    XCTAssertEqual(3, ((BLEBeaconSession*)(output[1])).beaconInfo.minor);
}
@end
