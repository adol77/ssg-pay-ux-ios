//
//  LogNetTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LogNet.h"
#import "SLBSKitDefine.h"
#import "DeviceManager.h"

@interface LogNetTestCase : XCTestCase

@end

@implementation LogNetTestCase

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
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    NSString* appID = [[DeviceManager sharedInstance] appID];
   
    [LogNet sendLogWithAccessToken:accessToken deviceID:deviceID appID:appID userID:[NSNumber numberWithInt:-1] eventType:[NSNumber numberWithInteger:SLBSLogEventAdd] logType:[NSNumber numberWithInteger:SLBSLogApp] timeStamp:@"2015-10-02 21:23:00" block:^(LogNet* net) {
        if(net.returnCode == 0)
            XCTAssert(net.returnCode);
    }];
}

- (void)testSendRouteLog {
    NSString* accessToken = [[DeviceManager sharedInstance] accessToken];
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    NSString* appID = [[DeviceManager sharedInstance] appID];
    NSString* locationLog = [NSString stringWithFormat:@"%@_%@_%@_%f_%f", [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:1], 1.1f, 1.1f];
    
    [LogNet sendRouteLogWithAccessToken:accessToken deviceID:deviceID appID:appID locationLog:locationLog companyID:[NSNumber numberWithInteger:1] branchID:[NSNumber numberWithInteger:1] floorID:[NSNumber numberWithInteger:1] coordX:1.1f coordY:1.1f zoneID:[NSNumber numberWithInteger:1] zoneCampaignID:[NSNumber numberWithInteger:1] zoneLogType:[NSNumber numberWithInteger:1] timeStamp:@"2015-10-02 21:23:00" block:^(LogNet* net) {
        XCTAssert(net.returnCode);
    }];
}
@end
