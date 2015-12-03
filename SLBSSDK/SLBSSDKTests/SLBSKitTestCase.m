//
//  SLBSKitTestCase.m
//  SLBSKit
//
//  Created by regina lee on 2015. 8. 21..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLBSKit.h"
#import "SLBSKitDefine.h"

#define TEST_LOCATION
//#define TEST_ZONECAMPAIGN
//#define TEST_MAP

@interface SLBSKitTestCase : XCTestCase <SLBSKitLocationDelegate, SLBSKitMapDelegate, SLBSKitZoneCampaignDelegate>
{
    __weak XCTestExpectation *_expectation;
}
@end

@implementation SLBSKitTestCase

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

- (void)testCreateInstance
{
    XCTAssertNotNil([SLBSKit sharedInstance], "Pass");
}

#ifdef TEST_LOCATION
- (void)testLocationDelegate
{
 //   _expectation = [self expectationWithDescription:@"SLBSKitLocationDeleagate"];
    
    [[SLBSKit sharedInstance] setLocationDelegate:self];
    [[SLBSKit sharedInstance] startService:SLBSServiceLocation];
    
    //Location쪽 풀 구현 이후 테스트 위해 TimeOut 체크 추가
    /*[self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];*/
    
//    [self waitForExpectationsWithTimeout:2 handler:nil];
    XCTAssert(YES, @"Pass");
}
#endif

#ifdef TEST_ZONECAMPAIGN
- (void)testZoneCampaignDelegate
{
    _expectation = [self expectationWithDescription:@"SLBSKitZoneCampaignDeleagate"];
    
    [[SLBSKit sharedInstance] setZoneCampaignDelegate:self];
    [[SLBSKit sharedInstance] startService:SLBSServiceZoneCampaign];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
    XCTAssert(YES, @"Pass");
}
#endif

#ifdef TEST_MAP
- (void)testMapDataDelegate
{
    _expectation = [self expectationWithDescription:@"SLBSKitMapDeleagate"];
    
    [[SLBSKit sharedInstance] setMapDelegate:self];
    [[SLBSKit sharedInstance] startService:SLBSServiceMap];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
    
   
}
#endif

#pragma SLBSKitLocationDelegate
- (void)slbskit:(SLBSKit *)manager onLocation:(SLBSCoordination *)location
{
    //XCTAssertEqual(location.floor, 1000, "Location Pass");
    
    [_expectation fulfill];
}

- (void)slbskit:(SLBSKit *)manager didEventCampaign:(SLBSZoneCampaignInfo *)zoneCampaignInfo
{
    XCTAssertEqual(zoneCampaignInfo.ID, @2000, "ZoneCampaign Pass");
    
   [_expectation fulfill];
}

- (void)slbskit:(SLBSKit *)manager onMapReady:(SLBSMapData *)mapData
{
    XCTAssertEqual(mapData.map_id, 3000, "Map Pass");
    
   [_expectation fulfill];
}




@end
