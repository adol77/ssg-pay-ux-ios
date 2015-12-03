//
//  LogManagerTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LogManager.h"
#import "DeviceManager.h"

@interface LogManagerTestCase : XCTestCase

@end

@implementation LogManagerTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSendLog {
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    NSString* appID = [[DeviceManager sharedInstance] appID];
    
    
    [[LogManager sharedInstance] saveLogWithDeviceID:deviceID appID:appID eventType:[NSNumber numberWithInteger:SLBSLogEventAdd] logType:[NSNumber numberWithInteger:SLBSLogApp]];
     XCTAssert(@"success");
}

- (void)testSendRouteLog {
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    NSString* appID = [[DeviceManager sharedInstance] appID];
      NSString* locationLog = [NSString stringWithFormat:@"%@_%@_%@_%f_%f", [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:1], 1.1f, 1.1f];
   
    [[LogManager sharedInstance] saveRouteLogWithDeviceID:deviceID appID:appID locationLog:locationLog companyID:[NSNumber numberWithInt:1] branchID:[NSNumber numberWithInt:1] floorID:[NSNumber numberWithInt:1] coordX:1.1f coordY:1.1f zoneID:[NSNumber numberWithInt:1] zoneCampaignID:[NSNumber numberWithInt:1] zoneLogType:[NSNumber numberWithInt:1]];
   
    XCTAssert(@"success");
}@end
