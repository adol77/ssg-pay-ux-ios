//
//  SLBSMapManagerTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 9..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SLBSMapManager.h"
#import "SLBSKitDefine.h"


@interface SLBSMapManagerTest : XCTestCase <SLBSMapManagerDelegate, SLBSMapViewInterface>

@end

@implementation SLBSMapManagerTest {
    SLBSMapManager* manager;
    XCTestExpectation* expectation;
    int loadedMapId;
}

- (void)shouldLoadMapData:(SLBSMapViewData *)data
{
    loadedMapId = data.ID.intValue;
    [expectation fulfill];
}

- (void)setCurrentPositionImage:(UIImage *)image
{
    
}

- (BOOL)setSelectedZone:(NSNumber *)zoneID
{
    return NO;
}

- (void)setCurrentPosition:(CGPoint)position moveCenter:(BOOL)move
{
    
}

- (void)loadPath:(NSArray*)paths
{
    
}


- (void)mapManager:(SLBSMapManager *)manager onMapReady:(SLBSMapData*)mapData
{
    XCTAssertNotNil(mapData);
}

-(void)wait:(int)sec{
    XCTestExpectation* e = [self expectationWithDescription:@"wait"];
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC);
    dispatch_block_t block = ^(void) {
        [e fulfill];
    };
    dispatch_after(t, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), block);
    [self waitForExpectationsWithTimeout:sec*5 handler:nil];
}

- (void)setUp {
    [super setUp];
    loadedMapId = -1;
    manager = [SLBSMapManager sharedInstance];
    manager.delegate = self;
    manager.view = self;
    [manager startMonitoring];
    [self wait:5];
}

- (void)tearDown {
    [manager stopMonitoring];
    [super tearDown];
}

- (void)testSetCurPos {
 /*   expectation = [self expectationWithDescription:@"onMapReady"];
    [manager setCurrentMap:1 x:0 y:0 center:NO];
    [self waitForExpectationsWithTimeout:3600 handler:nil];*/
}

- (void)testLoadBitmap {
    const NSString* url = @"http://" SERVER_IP @"/v1/mms/resources/1f.png";
    
    UIImage* output = [manager loadMapImage:url];
    CGSize size = [output size];
    XCTAssertNotNil(output);
}

- (void)testPeeping {
    expectation = [self expectationWithDescription:@"setCurrentMap"];
    [manager setCurrentMap:1 x:0 y:0 center:NO];
    [self waitForExpectationsWithTimeout:3600 handler:nil];
    XCTAssertEqual(1, loadedMapId);
    
    expectation = [self expectationWithDescription:@"enablePeeping"];
    //[manager enablePeeping:2 x:10. y:20. ];
    [self waitForExpectationsWithTimeout:3600 handler:nil];
    XCTAssertEqual(2, loadedMapId);
    
    expectation = [self expectationWithDescription:@"disablePeeping"];
    //[manager disablePeeping];
    [self waitForExpectationsWithTimeout:3600 handler:nil];
    XCTAssertEqual(1, loadedMapId);
    
}
@end
