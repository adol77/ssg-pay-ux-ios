//
//  ZoneNetworkTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZoneNet.h"
#import "Zone.h"
#import "ZoneDataManager.h"

@interface ZoneNetworkTestCase : XCTestCase

@end

@implementation ZoneNetworkTestCase

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

- (void)testRequestToServer {
    [ZoneNet requestZoneListWithAccessToken:@"qwer" block:^(ZoneNet* netObject){
       if(netObject.returnCode != 0)
       {
           NSMutableArray *zoneList = [NSMutableArray array];
           for(NSDictionary *zoneDic in netObject.zoneList) {
               Zone* zone = [Zone zoneWithDictionary:zoneDic];
               [zoneList addObject:zone];
           }
           
           [[ZoneDataManager sharedInstance] setZones:zoneList];
             NSLog(@"Request zoneList result : %d, count is %tu", (int)netObject.returnCode, zoneList.count);
       }
       else {
            NSLog(@"Request zoneList result : %d", (int)netObject.returnCode);
       }
    }];
}
@end
