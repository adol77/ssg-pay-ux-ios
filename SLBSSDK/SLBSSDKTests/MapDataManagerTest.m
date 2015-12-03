//
//  MapDataManagerTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 9..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MapDataManager.h"
#import "ZoneNet.h"

@interface MapDataManagerTest : XCTestCase <MapDataManagerDelegate>
@end

@implementation MapDataManagerTest {
    MapDataManager* manager;
    XCTestExpectation* expectation;
}

- (void)setUp {
    [super setUp];
    [ZoneNet requestZoneListWithAccessToken:@"asdf" block:^(ZoneNet* net){}];
    manager = [[MapDataManager alloc] init];
    manager.delegate = self;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    expectation = [self expectationWithDescription:@"onMapReady"];
    [manager loadMapInfo:1 token:@"asdf"];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {}];
}

- (void)mapdataManager:(MapDataManager *)manager onMapReady:(SLBSMapData*)mapData
{
    [expectation fulfill];
}

@end
