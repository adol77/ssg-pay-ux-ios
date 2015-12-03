//
//  DeviceManagerTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 21..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DeviceManager.h"
#import "DeviceNet.h"

@interface DeviceManagerTestCase : XCTestCase
@property NSString* otp;
@property NSDictionary* deviceProfile;
@property NSString* appID;
@end

@implementation DeviceManagerTestCase

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

- (void)testCreateInstance {
    XCTAssertNotNil([DeviceManager sharedInstance], "Pass");
}

- (void)testCreateJWT {
  //  XCTAssertNotNil([[DeviceManager sharedInstance] createJWT:_otp deviceInfo:_deviceProfile appID:_appID], "Create JWT Pass");
}

- (void)testAuth {
    NSString* otp = [[DeviceManager sharedInstance] generateOTP];
    NSDictionary* deviceInfo = [[DeviceManager sharedInstance] createDeviceProfile];
    [DeviceNet requestAuthWithOTP:otp deviceInfo:deviceInfo block:^(DeviceNet* net) {
        if(net.accessToken) {
            XCTAssertNotNil(net.accessToken);
        }
    }];
}

- (void)testGetDeviceID {
    NSString* otp = [[DeviceManager sharedInstance] generateOTP];
    NSDictionary* deviceInfo = [[DeviceManager sharedInstance] createDeviceProfile];
    NSString* token = [[DeviceManager sharedInstance] accessToken];
    [DeviceNet requestDeviceIDWithAccessToken:token deviceInfo:deviceInfo block:^(DeviceNet* net) {
        if(net.deviceID) {
            XCTAssertNotNil(net.deviceID);
        }
    }];
}


- (void)testReAuth {
    NSString* otp = [[DeviceManager sharedInstance] generateOTP];
    NSDictionary* deviceInfo = [[DeviceManager sharedInstance] createDeviceProfile];
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    [DeviceNet requestReAuthWithOTP:otp deviceInfo:deviceInfo deviceID:deviceID block:^(DeviceNet* net) {
        if(net.accessToken) {
            XCTAssertNotNil(net.accessToken);
        }
    }];
}


- (void)testRequestServer{
    [[DeviceManager sharedInstance] requestReAuthToServerWithBlock:^(BOOL successed){
        if(successed)
        {
            XCTAssertNotNil([[DeviceManager sharedInstance] deviceID], @"Get DeviceID From Server Pass");
            XCTAssertNotNil([[DeviceManager sharedInstance] accessToken], @"Get Token From Server Pass");
        }
        else
            XCTFail(@"RequestServer Fail");
    }];
}

- (void)testPolicy {
    NSString* token = [[DeviceManager sharedInstance] accessToken];
    NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
    [DeviceNet requestPolicyWithAccessToken:token deviceID:deviceID block:^(DeviceNet* net){
        if(net.policyInfo) {
            XCTAssertNotNil(net.policyInfo);
        }
    }];
}

 
@end
