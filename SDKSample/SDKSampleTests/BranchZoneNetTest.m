//
//  BranchZoneNetTest.m
//  SDKSample
//
//  Created by KimHeedong on 2015. 9. 21..
//  Copyright © 2015년 Regina. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BranchZoneNetTest : XCTestCase

@end

@implementation BranchZoneNetTest {
    XCTestExpectation* expectation;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample {
//    expectation = [self expectationWithDescription:@"onMapReady"];
//    
//    [BranchZoneNet requestZoneListWithAccessToken:@"asdf" branchId:1 block:^(BranchZoneNet *netObject) {
//        if(netObject.returnCode == 0)
//        {
//            NSMutableArray *zoneList = [NSMutableArray array];
//            for(NSDictionary *zoneDic in netObject.zoneList) {
//                Zone* zone = [Zone zoneWithDictionary:zoneDic];
//                [zoneList addObject:zone];
//            }
//            NSLog(@"Request zoneList result : %d, count is %tu", (int)netObject.returnCode, zoneList.count);
//            [expectation fulfill];
//        }
//        else {
//            NSLog(@"Request zoneList result : %d", (int)netObject.returnCode);
//            [expectation fulfill];
//            XCTFail(@"returnError");
//        }
//        
//    }];
//    
//    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {}];
//}

@end
