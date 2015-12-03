//
//  BLEBeaconInfoTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BLEBeaconInfo.h"

@interface BLEBeaconInfoTest : XCTestCase

@end

@implementation BLEBeaconInfoTest {
    BLEBeaconInfo* beaconInfo;
    NSUUID* uuid;
}

- (void)setUp {
    [super setUp];
    uuid = [NSUUID UUID];
    beaconInfo = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:1];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCopy {
    BLEBeaconInfo* new = [beaconInfo copy];
    XCTAssertNotEqual(beaconInfo, new);
    XCTAssert([beaconInfo isEqual:new]);
}

- (void)testDictionary {
    BLEBeaconInfo* new = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:1];
    NSMutableDictionary* dict = [ NSMutableDictionary dictionary];
    [dict setObject:@1 forKey:beaconInfo];
    
    id o = [dict objectForKey:new];
    XCTAssertNotNil(o);
    XCTAssert([o isKindOfClass:[NSNumber class]]);
    
    NSNumber* n = o;
    XCTAssertEqual(1, n.intValue);
}

@end
