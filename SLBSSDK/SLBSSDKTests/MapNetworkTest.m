//
//  MapNetworkTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MapNet.h"


@interface MapNetworkTest : XCTestCase

@end

@implementation MapNetworkTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works Correctly!"];
    
    //+(void)getMapData:(NSString*)accessToken mapId:(int)mapId block:(void (^)(MapInfo* response))block;

    [MapNet getMapData:@"asdf" mapId:1 block:^(SLBSMapData *response) {
        NSLog(@"response");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
    }];
    
    
}

- (void)testFindPath {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Method Works Correctly!"];
    
    [MapNet findPath:@"asdf" startMapId:1 startX:100. startY:100. endMapId:3 endX:100. endY:100. block:^(NSArray *response) {
        NSLog(@"response");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {}];
    
    
}

@end
