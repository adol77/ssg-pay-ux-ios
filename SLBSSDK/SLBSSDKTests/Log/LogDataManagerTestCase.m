//
//  LogDataManagerTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LogDataManager.h"

@interface LogDataManagerTestCase : XCTestCase

@end

@implementation LogDataManagerTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testLogSave {
    NSMutableArray* logArray;
    [logArray addObject:@"test"];
    [logArray addObject:@"test1"];
    [logArray addObject:@"test2"];
    [logArray addObject:@"test3"];
    [logArray addObject:@"test4"];
    
    [[LogDataManager sharedInstance] setLogs:logArray];
    NSArray* resultArray = [[LogDataManager sharedInstance] logs];
    
    NSString* testString = [resultArray objectAtIndex:1];
    
    XCTAssertEqual(testString, @"test");
}

- (void)testRouteLogSave {
    NSMutableArray* logArray;
    [logArray addObject:@"test"];
    [logArray addObject:@"test1"];
    [logArray addObject:@"test2"];
    [logArray addObject:@"test3"];
    [logArray addObject:@"test4"];
    
    [[LogDataManager sharedInstance] setRoutes:logArray];
    NSArray* resultArray = [[LogDataManager sharedInstance] routes];
    
    NSString* testString = [resultArray objectAtIndex:1];
    
    XCTAssertEqual(testString, @"test");
}

@end
