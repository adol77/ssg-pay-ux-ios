//
//  GeofenceSuiteTest.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 18..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GeofenceSuite.h"

@interface GeofenceSuiteTest : XCTestCase <GeofenceSuiteDelegate>
{
    __weak XCTestExpectation *_expectation;
}
@end

@implementation GeofenceSuiteTest

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

- (void)testGeofenceSuite {
    _expectation = [self expectationWithDescription:@"GeofenceSuiteDelegate"];
    
    GeofenceSuite* geofenceSuite = [[GeofenceSuite alloc] init];
    [geofenceSuite startScan];
}

- (void)geofenceSuite:(GeofenceSuite *)manager onLocation:(CLLocation*)location {
    
    XCTAssert(location);
    
    [_expectation fulfill];
}

@end
