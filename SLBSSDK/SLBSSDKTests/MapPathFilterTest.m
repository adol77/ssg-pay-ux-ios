//
//  MapPathFilterTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MapPathFilter.h"
#import "MapPathViewData.h"

@interface MapPathFilterTest : XCTestCase

@end

@implementation MapPathFilterTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (NSArray*)sample {
    NSMutableArray* arr = [NSMutableArray array];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:1 vertexName:@"v" x:0. y:0.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:2 vertexName:@"v" x:10. y:0.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:3 vertexName:@"v" x:20. y:0.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:4 vertexName:@"v" x:20. y:10.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:5 vertexName:@"v" x:30. y:10.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:6 vertexName:@"v" x:40. y:10.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:7 vertexName:@"v" x:40. y:0.]];
    return [arr copy];
}

- (NSArray*)expected {
    NSMutableArray* arr = [NSMutableArray array];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:1 vertexName:@"v" x:0. y:0.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:3 vertexName:@"v" x:20. y:0.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:4 vertexName:@"v" x:20. y:10.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:6 vertexName:@"v" x:40. y:10.]];
    [arr addObject:[[MapPathViewData alloc] initWithMapId:100 mapName:@"map" graphId:101 vertexId:7 vertexName:@"v" x:40. y:0.]];
    return [arr copy];
}

- (void)testFilter {
    NSArray* sample = self.sample;
    NSArray* expected = self.expected;
    
    NSArray* result = MapPathFilter(sample);
    XCTAssertEqual(expected.count, result.count);
    
    for ( int i = 0 ; i < result.count ; i++ ) {
        MapPathViewData* e = expected[i];
        MapPathViewData* r = result[i];
        XCTAssertEqual(e.vertexId, r.vertexId);
    }
}



@end
