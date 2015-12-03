//
//  MapMatchingFilterTestCase.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LOCCoordinate.h"
#import "LOCLineSegment.h"
#import "MapRoadSource.h"
#import "MapMatchingFilter.h"

@interface MapSource : NSObject<MapRoadSource>
-(int)count;
-(NSArray*)roadsInMap:(int)mapId;
-(void)add:(LOCLineSegment*)segment;
@end

@implementation MapSource {
    NSMutableArray* roads;
}

-(instancetype)init {
    if ( self = [super init] ) {
        roads = [[NSMutableArray alloc] init];
    }
    return self;
}

-(int)count {
    return (int)[roads count];
}

-(NSArray*)roadsInMap:(int)mapId {
    return [roads copy];
}

-(void)add:(LOCLineSegment*)segment {
    [roads addObject:segment];
}
@end

@interface MapMatchingFilterTestCase : XCTestCase
@end

// isProjectionInSegment를 테스트하자
@implementation MapMatchingFilterTestCase {
    MapMatchingFilter* filter;
}

- (void)setUp {
    [super setUp];
    filter = [[MapMatchingFilter alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testIsSegmentInMap {
    
    NSArray* positions = [NSArray arrayWithObjects:
        [[LOCCoordinate alloc] initWithMap:1 X:0. Y:0.],
        [[LOCCoordinate alloc] initWithMap:1 X:10. Y:0.],
        [[LOCCoordinate alloc] initWithMap:2 X:5. Y:3.],
        [[LOCCoordinate alloc] initWithMap:2 X:6. Y:3.],
        nil];
    
    LOCLineSegment* segment1 = [[LOCLineSegment alloc] initWithStart:positions[0] End: positions[1]];
    LOCLineSegment* segment2 = [[LOCLineSegment alloc] initWithStart:positions[1] End: positions[2]];
    LOCLineSegment* segment3 = [[LOCLineSegment alloc] initWithStart:positions[2] End: positions[3]];
    
    XCTAssert([MapMatchingFilter isSegment:segment1 InMap:1]);
    XCTAssertFalse([MapMatchingFilter isSegment:segment2 InMap:2]);
    XCTAssertFalse([MapMatchingFilter isSegment:segment3 InMap:3]);
}

// getProjection 을 테스트하자. 수평선인 경우
-(void)testIsProjectionInSegment {
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap:1 X:0. Y:0.],
                          [[LOCCoordinate alloc] initWithMap:1 X:10. Y:0.],
                          [[LOCCoordinate alloc] initWithMap:1 X:10. Y:0.],
                          [[LOCCoordinate alloc] initWithMap:1 X:20. Y:0.],
                          nil];
    LOCLineSegment* segment1 = [[LOCLineSegment alloc] initWithStart:positions[0] End: positions[1]];
    LOCLineSegment* segment2 = [[LOCLineSegment alloc] initWithStart:positions[2] End: positions[3]];
    
    struct Projection proj = { 5., 5., 0. };
    XCTAssert([MapMatchingFilter isProjection:proj On:segment1]);
    XCTAssertFalse([MapMatchingFilter isProjection:proj On:segment2]);
}

-(void)testGetProjection1 {
    
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap:1 X:0. Y:0.],
                          [[LOCCoordinate alloc] initWithMap:1 X:10. Y:0.],
                          nil];
    
    LOCLineSegment* segment = [[LOCLineSegment alloc] initWithStart:positions[0] End: positions[1]];
    
    struct Projection expected = { 5., 5., 0. };
    
    LOCCoordinate* pos = [[LOCCoordinate alloc] initWithMap:1 X:5. Y:5.];
    struct Projection got = [MapMatchingFilter calcProjection:pos On:segment];
    
    XCTAssert(expected.distance == got.distance);
    XCTAssert(expected.x == got.x);
    XCTAssert(expected.y == got.y);
    
}
// getProjection 을 테스트하자. 수직선인 경우
-(void)testGetProjection2 {
    
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap:1 X:0. Y:0.],
                          [[LOCCoordinate alloc] initWithMap:1 X:0. Y:10.],
                          nil];
    
    LOCLineSegment* segment = [[LOCLineSegment alloc] initWithStart:positions[0] End: positions[1]];
    
    struct Projection expected = { 5., 0., 5. };
    
    LOCCoordinate* pos = [[LOCCoordinate alloc] initWithMap:1 X:5. Y:5.];
    struct Projection got = [MapMatchingFilter calcProjection:pos On:segment];
    
    XCTAssert(expected.distance == got.distance);
    XCTAssert(expected.x == got.x);
    XCTAssert(expected.y == got.y);
    
}

// getProjection 을 테스트하자. 빗면인 경우
-(void)testGetProjection3 {
    
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap:1 X:0. Y:0.],
                          [[LOCCoordinate alloc] initWithMap:1 X:10. Y:10.],
                          nil];
    
    LOCLineSegment* segment = [[LOCLineSegment alloc] initWithStart:positions[0] End: positions[1]];
    
    struct Projection expected = { 4.*sqrt(2.), 5., 5. };
    
    LOCCoordinate* pos = [[LOCCoordinate alloc] initWithMap:1 X:1. Y:9.];
    struct Projection got = [MapMatchingFilter calcProjection:pos On:segment];
    
    XCTAssert(expected.distance == got.distance);
    XCTAssert(expected.x == got.x);
    XCTAssert(expected.y == got.y);
    
}

// 세그먼트 하나를 주고 매칭되는 지 보자.
-(void)testFilter {
    NSArray* positions = [NSArray arrayWithObjects:
                          [[LOCCoordinate alloc] initWithMap:1 X:0. Y:0.],
                          [[LOCCoordinate alloc] initWithMap:1 X:10. Y:0.],
                          [[LOCCoordinate alloc] initWithMap:1 X:5. Y:3.],
                          [[LOCCoordinate alloc] initWithMap:1 X:5. Y:0.],
                          nil];
    MapSource* source = [[MapSource alloc] init];
    [source add:[[LOCLineSegment alloc] initWithStart:positions[0] End:positions[1]]];
    filter.mapRoadSource = source;
    
    LOCCoordinate* newPos = [filter filter:positions[2]];
    XCTAssertNotNil(newPos);
    XCTAssert([newPos equal:positions[3]]);
    
}

@end
