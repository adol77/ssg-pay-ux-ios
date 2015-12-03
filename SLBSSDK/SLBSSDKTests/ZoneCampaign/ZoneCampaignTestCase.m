//
//  ZoneCampaignTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SLBSZoneCampaignManager.h"
#import "SLBSZoneCampaignInfo.h"

@interface ZoneCampaignTestCase : XCTestCase <SLBSZoneCampaignManagerDelegate>
{
     __weak XCTestExpectation *_expectation;
}
@end

@implementation ZoneCampaignTestCase

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

- (void)testZoneCampaignMonitoring
{
    _expectation = [self expectationWithDescription:@"SLBSZoneCampaignDeleagate"];
    
    [[SLBSZoneCampaignManager sharedInstance] setDelegate:self];
    [[SLBSZoneCampaignManager sharedInstance] startMonitoring];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
    XCTAssert(YES, @"Pass");
}

- (void)zoneCampaignManager:(SLBSZoneCampaignManager *)manager onCampaignPopup:(NSArray *)zoneCampaignList {
    for(SLBSZoneCampaignInfo* zoneCampaignInfo in zoneCampaignList)
    {
        NSLog(@"campaign id %d", [zoneCampaignInfo.ID intValue]);
        XCTAssertEqual([zoneCampaignInfo.ID intValue], 2000, "ZoneCampaign Pass");
    }
    
    [_expectation fulfill];

}
@end
