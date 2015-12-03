//
//  ZoneCampaignNetTestCase.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 3..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DeviceManager.h"
#import "ZoneCampaignNet.h"
//#define GFDEBUG_ENABLE
#import "GFDebug.h"

@interface ZoneCampaignNetTestCase : XCTestCase

@property (nonatomic, assign) NSTimeInterval timeoutInterval;

@end

@implementation ZoneCampaignNetTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.timeoutInterval = 30;
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

- (void)test01RequestCampaignsWithAccessToken {
     XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works Correctly!"];
    [ZoneCampaignNet requestCampaignsWithAccessToken:[[DeviceManager sharedInstance] accessToken] block:^(ZoneCampaignNet *rapiObject) {
        GFLog(@"requestCampaignsWithAccessToken returnCode(%ld)\nZoneCampaigns %@", (long)rapiObject.returnCode, rapiObject.campaigns);
        XCTAssertEqual(rapiObject.returnCode, 0, "requestCampaignsWithAccessToken error returnCode");
        XCTAssertTrue([rapiObject.campaigns count] > 0, "requestCampaignsWithAccessToken empty data");
        [expectation fulfill];
    }];
    
    //Wait 1 second for fulfill method called, otherwise fail:
    [self waitForExpectationsWithTimeout:self.timeoutInterval handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)test02RequestCampaignWithID{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works Correctly!"];
    NSNumber *campaignID = [NSNumber numberWithInteger:14];
    [ZoneCampaignNet requestCampaignWithID:campaignID accessToken:[[DeviceManager sharedInstance] accessToken] block:^(ZoneCampaignNet *rapiObject) {
        GFLog(@"requestCampaignWithID returnCode(%ld)\nZoneCampaign %@", (long)rapiObject.returnCode, rapiObject.campaign);
        XCTAssertEqual(rapiObject.returnCode, 0, "testRequestCampaignWithID(%@) error returnCode", campaignID);
        XCTAssertTrue(rapiObject.campaign, "testRequestCampaignWithID empty data");
        [expectation fulfill];
    }];
    
    //Wait 1 second for fulfill method called, otherwise fail:
    [self waitForExpectationsWithTimeout:self.timeoutInterval handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)test03RequestCampaignsWithZoneID {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works Correctly!"];
    NSArray *zoneIDs = @[@1,@3];
    [ZoneCampaignNet requestCampaignsWithZoneIDs:zoneIDs accessToken:[[DeviceManager sharedInstance] accessToken] block:^(ZoneCampaignNet *rapiObject) {
        GFLog(@"requestCampaignsWithZoneID returnCode(%ld)\nZoneCampaigns %@", (long)rapiObject.returnCode, rapiObject.campaigns);
        XCTAssertEqual(rapiObject.returnCode, 0, "requestCampaignsWithZoneID(%@) error returnCode", zoneIDs);
        XCTAssertTrue([rapiObject.campaigns count] > 0, "requestCampaignsWithZoneID empty data");
        [expectation fulfill];
    }];
    
    //Wait 1 second for fulfill method called, otherwise fail:
    [self waitForExpectationsWithTimeout:self.timeoutInterval handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)test04RequestZoneWithCampaignID {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works Correctly!"];
    NSNumber *campaignID = [NSNumber numberWithInteger:19];
    [ZoneCampaignNet requestZonesWithCampaignID:campaignID accessToken:[[DeviceManager sharedInstance] accessToken] block:^(ZoneCampaignNet *rapiObject) {
        GFLog(@"requestZonesWithCampaignID returnCode(%ld)\nZones %@", (long)rapiObject.returnCode, rapiObject.zoneIDs);
        XCTAssertEqual(rapiObject.returnCode, 0, "requestZonesWithCampaignID(%@) error returnCode", campaignID);
        XCTAssertTrue([rapiObject.zoneIDs count] > 0, "requestZonesWithCampaignID empty data");
        [expectation fulfill];
    }];
    
    //Wait 1 second for fulfill method called, otherwise fail:
    [self waitForExpectationsWithTimeout:self.timeoutInterval handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

@end
