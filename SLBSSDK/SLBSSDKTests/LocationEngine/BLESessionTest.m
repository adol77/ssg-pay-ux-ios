//
//  BLESessionTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BLEBeaconInfo.h"
#import "BLEBeaconSession.h"

@interface BLESessionTest : XCTestCase

@end

@implementation BLESessionTest {
    NSUUID* uuid;
    BLEBeaconInfo* beacon;
    BLEBeaconSession* session;
}


- (void)setUp {
    [super setUp];
    uuid = [NSUUID UUID];
    beacon = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:1];
    session = [[BLEBeaconSession alloc] initWith:beacon];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAverage {
    [session updateRssi:-75.f];
    [session updateRssi:-85.f];
    XCTAssertEqual(-80.f, session.avgRssi);
    
}

- (void)testLPF {
    [session updateRssi:-60.f];
    [session updateRssi:-85.f];
    [session updateRssi:-75.f];
    [session updateRssi:-85.f];
    [session updateRssi:-75.f];
    [session updateRssi:-80.f];
    XCTAssertEqual(-80.f, session.avgRssi);
}

@end
