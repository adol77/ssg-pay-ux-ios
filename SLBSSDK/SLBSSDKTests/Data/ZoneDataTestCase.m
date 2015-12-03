//
//  ZoneDataTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 25..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ZoneDataManager.h"
#import "Zone.h"

@interface ZoneDataTestCase : XCTestCase

@end

@implementation ZoneDataTestCase

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

- (void)testZoneQuery {
    NSMutableArray* zoneList = [NSMutableArray array];

    NSDictionary* storeDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"18:00", @"opening_hour_end",
                              @"20:00", @"opening_hour_start", nil];
    
    NSDictionary* zoneDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:1] , @"id",
                             [NSNumber numberWithInt:1], @"map_id",
                             [NSNumber numberWithInt:1], @"beacon_id",
                             storeDic, @"store",
                             nil];
    
    Zone* newZone = [Zone zoneWithDictionary:zoneDic];
    [zoneList addObject:newZone];
    
    [[ZoneDataManager sharedInstance] setZones:zoneList];
    
    Zone* zone = [[ZoneDataManager sharedInstance] zoneForID:[NSNumber numberWithInt:1]];

    NSInteger zoneID = [zone.zone_id integerValue];
    XCTAssertEqual(zoneID,  1, @"Success");
}

@end
