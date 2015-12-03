//
//  PositionSessionTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 8..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//


#import <XCTest/XCTest.h>
#import "PositionSessionManager.h"
#import "ZoneNet.h"
#import "Zone.h"
#import "ZoneDataManager.h"

@interface PositionSessionTestCase : XCTestCase <PositionSessionManagerDelegate>
{
    __weak XCTestExpectation *_expectation;
}
@end

@implementation PositionSessionTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [self testRequestToServer];
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

- (void)testPositionSession {
    /*
    SLBSCoordination* coordination = [[SLBSCoordination alloc] init];
    coordination.x = 500;
    coordination.y = 200;
    
    [[PositionSessionManager sharedInstance] detectSessionOfPosition:384 coordination:coordination delegate:self];
    
    coordination.x = 600;
    coordination.y = 400;
    
    [[PositionSessionManager sharedInstance] checkPosition:coordination];
     */
}
- (void)sessionManager:(PositionSessionManager *)manager triggerPosZoneState:(NSNumber*)zoneID zoneState:(SLBSSessionType)zoneState {
 
    NSLog(@"%s triggerZoneState %d %ld", __PRETTY_FUNCTION__, [zoneID intValue], (long)zoneState);
    
   // [_expectation fulfill];
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
