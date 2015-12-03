//
//  KalmanFilterTestCase.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LOCCoordinate.h"
#import "KalmanFilter.h"


@interface KalmanFilterTestCase : XCTestCase
@end

@implementation KalmanFilterTestCase {
    KalmanFilter* filter;
}

- (void)setUp {
    [super setUp];
    filter = [[KalmanFilter alloc] init];
}

// 층이 바뀌면 filter 상태를 reset하는 것으로 하자
-(void)testMultiMap {
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap: 1 X:1. Y:5.],
                          [[LOCCoordinate alloc] initWithMap: 3 X:4. Y:8.],
                          nil];
    
    LOCCoordinate* newPos;

    for(LOCCoordinate* pos in positions) {
        newPos = [filter filter:pos];
    }
    
    NSLog(@"newPos: %@", newPos);
    XCTAssert([newPos equal:positions[1]]);
    
}

// 같은 층이면 일단 필터링은 되어야 겠지.
-(void)testSameMap {
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap: 1 X:1. Y:5.],
                          [[LOCCoordinate alloc] initWithMap: 1 X:2. Y:6.],
                          [[LOCCoordinate alloc] initWithMap: 1 X:3. Y:7.],
                          [[LOCCoordinate alloc] initWithMap: 1 X:4. Y:8.],
                          nil];
    
    LOCCoordinate* newPos;
    
    for(LOCCoordinate* pos in positions) {
        newPos = [filter filter:pos];
    }
    
    NSLog(@"newPos: %@", newPos);
    XCTAssert(![newPos equal:positions[3]]);
    
}

@end
