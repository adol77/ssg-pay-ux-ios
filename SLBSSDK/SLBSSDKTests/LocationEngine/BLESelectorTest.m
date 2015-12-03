//
//  BLESelectorTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BLESelector.h"
#import "LSLocationCandidate.h"
#import "LOCCoordinate.h"


@interface BLESelectorTestListener : NSObject<BLELocationExaminerListener>
@property LOCCoordinate* coordinate;
@end

@implementation BLESelectorTestListener
@synthesize coordinate;
-(void)onLocationSelected:(LOCCoordinate*)_coordinate
{
    coordinate = _coordinate;
}
@end


@interface BLESelectorTest : XCTestCase

@end

@implementation BLESelectorTest {
    BLESelector* selector;
    LOCCoordinate* locations[5];
    LSLocationCandidate* candidates[5];
    BLESelectorTestListener* listener;
}

- (void)setUp {
    [super setUp];
    selector = [[BLESelector alloc] init];
    for ( int i = 0 ; i < 5 ; i++ ) {
        locations[i] = [[LOCCoordinate alloc] initWithMap:1 X:1. Y:(1.*i+1.)];
        candidates[i] = [[LSLocationCandidate alloc] initWithPosition:locations[i] Weight:1.f];
    }
    listener = [[BLESelectorTestListener alloc] init];
    selector.listener = listener;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLocation {
    [selector findLocation:[NSArray arrayWithObjects:candidates count:5]];
    XCTAssertEqualWithAccuracy(1.f, listener.coordinate.X, 0.001f);
    XCTAssertEqualWithAccuracy(2.f, listener.coordinate.Y, 0.001f);
}


@end
