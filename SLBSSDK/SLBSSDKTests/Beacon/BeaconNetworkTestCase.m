//
//  BeaconNetworkTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BeaconNet.h"
#import "Beacon.h"

@interface BeaconNetworkTestCase : XCTestCase

@end

@implementation BeaconNetworkTestCase

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

-(void)testBeaconListQuery {
    NSString* accessToken = @"accessToken";
    [BeaconNet requestBeaconListWithAccessToken:accessToken block:^(BeaconNet* net) {
        XCTAssertEqual(net.returnCode, 0, "BeaconListQuery Fail");
    }];
}

-(void)testBeaconListQueryWithCompanyID {
    NSString* accessToken = @"accessToken";
    NSNumber* companyID = [NSNumber numberWithInt:69];
    NSNumber* branchID = [NSNumber numberWithInt:126];
    NSNumber* floorID = [NSNumber numberWithInt:-1];
    [BeaconNet requestBeaconListWithCompanyID:companyID branchID:branchID floorID:floorID token:accessToken block:^(BeaconNet* net) {
        XCTAssertEqual(net.returnCode, 0, "BeaconListQueryWithCompanyID Fail");
    }];
    
}

- (void)testBeaconListQueryWithUUID {
    NSString* accessToken = @"accessToken";
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"89F9DA42-BA67-4DB3-9231-B0F98C8D6F5B"];
    NSNumber* major = [NSNumber numberWithInt:1];
    NSNumber* minor = [NSNumber numberWithInt:1];
    [BeaconNet requestBeaconListWithUUID:[uuid UUIDString] major:major minor:minor token:accessToken block:^(BeaconNet* net){
         XCTAssertEqual(net.returnCode, 0, "BeaconListQuery Fail");
    }];
}


@end
