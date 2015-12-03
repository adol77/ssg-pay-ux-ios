//
//  CampaignConditionCheckerTests.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/1/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CampaignConditionChecker.h"

@interface CampaignConditionCheckerTests : XCTestCase

@end

@implementation CampaignConditionCheckerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testParseOffWeek {
//    NSString *str1 = @"1";
//    NSArray *parsedArray1 = [CampaignConditionChecker parseOffWeek:str1];
//    if (parsedArray1==nil) {
//        XCTAssert(NO, @"parsedArray1 is nil");
//    }
//    
//    for (NSString *element in parsedArray1) {
//        NSLog(@"parsedArray1 string=%@", element);
//    }
//
//    NSString *str2 = @"2/4";
//    NSArray *parsedArray2 = [CampaignConditionChecker parseOffWeek:str2];
//    if (parsedArray2==nil) {
//        XCTAssert(NO, @"parsedArray2 is nil");
//    }
//
//    for (NSString *element in parsedArray2) {
//        NSLog(@"parsedArray2 string=%@", element);
//    }
//}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
