//
//  ZoneSessionTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 8..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ProximitySessionManager.h"
#import "SLBSCoordination.h"

@interface ZoneSessionTestCase : XCTestCase <ProximitySessionManagerDelegate>
{
    __weak XCTestExpectation *_expectation;
}
@end

@implementation ZoneSessionTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testProximitySession {
    NSInteger zoneID = 384;
    [[ProximitySessionManager sharedInstance] detectSessionOfProximity:zoneID delegate:self];
}
- (void)sessionManager:(ProximitySessionManager *)manager triggerProxZoneState:(NSNumber*)zoneID zoneState:(SLBSSessionType)zoneState {
    
    NSLog(@"%s triggerZoneState %d %ld", __PRETTY_FUNCTION__, [zoneID intValue], (long)zoneState);
    
    // [_expectation fulfill];
}

@end
