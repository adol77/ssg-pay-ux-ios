//
//  GeofenceControlTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 28..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GeofenceControl.h"

@interface GeofenceControlTest : XCTestCase

@end

@implementation GeofenceControlTest {
    GeofenceControl* control;
}

- (void)setUp {
    [super setUp];
    control = [[GeofenceControl alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPowerControl {
    [control setPowerManagePolicy:[LSPowerManagePolicy periodicPolicy] On:0];
    [control startScan:0];
    
    for ( int i = 0 ; i < 30 ; i++ ) {
        [control tick:(i*500)];
    }
    [control setPowerManagePolicy:[LSPowerManagePolicy fullPolicy] On:15000];
    for ( int i = 0 ; i < 30 ; i++ ) {
        [control tick:((30+i)*500)];
    }
    
    
}



@end
