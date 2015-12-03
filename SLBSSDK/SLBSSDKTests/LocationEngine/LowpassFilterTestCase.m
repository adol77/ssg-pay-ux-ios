//
//  LowpassFilterTestCase.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LOCCoordinate.h"
#import "LowpassFilter.h"

@interface LowpassFilterTestCase : XCTestCase
@end

@implementation LowpassFilterTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// 좌표가 하나일 때는 그대로 리턴
-(void)testOneMap {
    id pos= [[LOCCoordinate alloc] initWithMap: 1 X:1. Y:1.];
    id filter = [[LowpassFilter alloc] initWithSize:1];
    LOCCoordinate* newPos = [filter filter:pos];
    XCTAssert([newPos equal:pos]);
}

// 서로 다른 층이 섞여 있다면 major 층만을 반영하여야 함.
-(void)testMajorMap {
    NSArray* positions = [NSArray arrayWithObjects:
        [[LOCCoordinate alloc] initWithMap: 1 X:1. Y:1.],
        [[LOCCoordinate alloc] initWithMap: 2 X:1. Y:1.],
        [[LOCCoordinate alloc] initWithMap: 2 X:1. Y:1.],
        [[LOCCoordinate alloc] initWithMap: 4 X:1. Y:1.],
                            nil];
    
    id filter = [[LowpassFilter alloc] init];
    for(LOCCoordinate* pos in positions) {
        [filter filter:pos];
    }
    XCTAssertEqual(2, [filter findMajorMapId]);
}

// 좌표갯수가 이동 평균 크기 이하일 때는 평균리턴
-(void)test2 {
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap: 3 X:1. Y:6.],
                          [[LOCCoordinate alloc] initWithMap: 3 X:2. Y:7.],
                          [[LOCCoordinate alloc] initWithMap: 3 X:3. Y:8.],
                          [[LOCCoordinate alloc] initWithMap: 3 X:4. Y:9.],
                          nil];
    
    id filter = [[LowpassFilter alloc] initWithSize:6];
    LOCCoordinate* newPos;
    for(LOCCoordinate* pos in positions) {
        newPos = [filter filter:pos];
    }
    XCTAssert([newPos equal:[[LOCCoordinate alloc] initWithMap:3 X:2.5 Y:7.5]]);
}

// 좌표갯수가 이동 평균 크기 초과인 경우는 이동 평균 크기 만큼만
-(void)test3 {
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap: 3 X:1. Y:6.],
                          [[LOCCoordinate alloc] initWithMap: 3 X:2. Y:7.],
                          [[LOCCoordinate alloc] initWithMap: 3 X:3. Y:8.],
                          [[LOCCoordinate alloc] initWithMap: 3 X:4. Y:9.],
                          nil];
    
    id filter = [[LowpassFilter alloc] initWithSize:2];
    LOCCoordinate* newPos;
    for(LOCCoordinate* pos in positions) {
        newPos = [filter filter:pos];
    }
    NSLog(@"newPos: %@", newPos);
    XCTAssert([newPos equal:[[LOCCoordinate alloc] initWithMap:3 X:3.5 Y:8.5]]);
}

@end
