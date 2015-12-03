//
//  GroupLogTestCase.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 21..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TSDebugLogManager.h"

@interface GroupLogTestCase : XCTestCase

@property (nonatomic, assign) NSInteger logCount;

@end

@implementation GroupLogTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorForCreatedLogEntity:) name:kSLBSNotificationCreatedLogEntity object:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testLog {
    [[TSDebugLogManager sharedInstance].logs removeAllObjects];
    
    TSGLog(TSLogGroupCommon, @"Sample Common LOG");
    
    TSGLog(TSLogGroupLocation, @"Sample Location LOG1");
    TSGLog(TSLogGroupLocation, @"Sample Location LOG2");
    
    TSGLog(TSLogGroupNetwork, @"Sample Network LOG1");
    TSGLog(TSLogGroupNetwork, @"Sample Network LOG2");
    TSGLog(TSLogGroupNetwork, @"Sample Network LOG3");
    
    TSGLog(TSLogGroupBeacon, @"Sample Beacon LOG1");
    TSGLog(TSLogGroupBeacon, @"Sample Beacon LOG2");
    TSGLog(TSLogGroupBeacon, @"Sample Beacon LOG3");
    TSGLog(TSLogGroupBeacon, @"Sample Beacon LOG4");
    
    TSGLog(TSLogGroupDevice, @"Sample Device LOG");
    
    TSGLog(TSLogGroupCampaign, @"Sample Campaign LOG1 LOOOOOOOOOO saiufhsid sydgfusygdfusydf uysgdfuysdf uysdgfusydf uysdgfusydgf");
    TSGLog(TSLogGroupCampaign, @"Sample Campaign LOG2");
    
    TSGLog(TSLogGroupZone, @"Sample Zone LOG1");
    TSGLog(TSLogGroupZone, @"Sample Zone LOG2");
    TSGLog(TSLogGroupZone, @"Sample Zone LOG3");
    
    TSGLog(TSLogGroupMap, @"Sample Map LOG");
    TSGLog(TSLogGroupApplication, @"Sample Application LOG");
    TSGLog(TSLogGroupStore, @"Sample Store LOG");
    
    XCTAssertEqual([[TSDebugLogManager sharedInstance].logs count], 19, "log count error(19 != %ld)", (long)[[TSDebugLogManager sharedInstance].logs count]);
    XCTAssertEqual(self.logCount, 19, "notification count error(19 != %ld)", (long)self.logCount);
    
    NSInteger count = -1;
    count = [self countForLogGroup:TSLogGroupCommon];
    XCTAssertEqual(count, 1, "log count error for common (1 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupLocation];
    XCTAssertEqual(count, 2, "log count error for Location (2 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupNetwork];
    XCTAssertEqual(count, 3, "log count error for Network (3 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupBeacon];
    XCTAssertEqual(count, 4, "log count error for Beacon (4 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupDevice];
    XCTAssertEqual(count, 1, "log count error for Device (1 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupCampaign];
    XCTAssertEqual(count, 2, "log count error for Campaign (2 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupZone];
    XCTAssertEqual(count, 3, "log count error for Zone (3 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupMap];
    XCTAssertEqual(count, 1, "log count error for Map (1 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupApplication];
    XCTAssertEqual(count, 1, "log count error for Application (1 != %ld)", (long)count);
    count = -1;
    count = [self countForLogGroup:TSLogGroupStore];
    XCTAssertEqual(count, 1, "log count error for Store (1 != %ld)", (long)count);
}

- (void)selectorForCreatedLogEntity:(NSNotification *)notification {
    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), notification);
    self.logCount++;
}

- (NSInteger)countForLogGroup:(TSLogGroup)group {
    NSArray *filteredArray = [[TSDebugLogManager sharedInstance].logs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"group == %ld", group]];
    NSInteger count = [filteredArray count];
    return count;
}

@end
