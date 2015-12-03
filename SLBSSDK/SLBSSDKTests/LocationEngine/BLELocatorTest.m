//
//  BLELocatorTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BLEBeaconInfo.h"
#import "BLELocator.h"
#import "BLELocationSource.h"
#import "LOCCoordinate.h"
#import "BLEBeaconSession.h"
#import "LSLocationCandidate.h"

@interface BLELocatorTestLocationSource : NSObject<BLELocationSource>
-(NSUUID*)uuid;
-(BLEBeaconInfo*)beacons:(int)index;
-(LOCCoordinate*)positions:(int)index;
-(BLEBeaconSession*)sessions:(int)index;
-(NSArray*)sessionArray;
@end

@implementation BLELocatorTestLocationSource {
    NSUUID* uuid;
    BLEBeaconInfo* beacons[5];
    LOCCoordinate* positions[5];
    BLEBeaconSession* sessions[5];
}
-(instancetype)init
{
    uuid = [NSUUID UUID];
    if ( self = [super init ] ) {
        beacons[0] = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:1];
        beacons[1] = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:2];
        beacons[2] = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:3];
        beacons[3] = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:4];
        beacons[4] = [[BLEBeaconInfo alloc] initWithUUID:uuid Major:1 Minor:5];
        
        positions[0] = [[LOCCoordinate alloc] initWithMap:2 X:1. Y:1.];
        positions[1] = [[LOCCoordinate alloc] initWithMap:1 X:1. Y:2.];
        positions[2] = [[LOCCoordinate alloc] initWithMap:1 X:1. Y:3.];
        positions[3] = [[LOCCoordinate alloc] initWithMap:1 X:1. Y:4.];
        positions[4] = [[LOCCoordinate alloc] initWithMap:1 X:1. Y:5.];
        
        sessions[0] = [[BLEBeaconSession alloc] initWith:beacons[0]]; [sessions[0] updateRssi:-50.f];
        sessions[1] = [[BLEBeaconSession alloc] initWith:beacons[1]]; [sessions[1] updateRssi:-60.f];
        sessions[2] = [[BLEBeaconSession alloc] initWith:beacons[2]]; [sessions[2] updateRssi:-70.f];
        sessions[3] = [[BLEBeaconSession alloc] initWith:beacons[3]]; [sessions[3] updateRssi:-75.f];
        sessions[4] = [[BLEBeaconSession alloc] initWith:beacons[4]]; [sessions[4] updateRssi:-80.f];
    }
    return self;
}
-(NSUUID*)uuid { return uuid; }
-(BLEBeaconInfo*)beacons:(int)index { return beacons[index]; }
-(LOCCoordinate*)positions:(int)index { return positions[index]; }
-(BLEBeaconSession*)sessions:(int)index { return sessions[index]; }
-(NSArray*)sessionArray { return [NSArray arrayWithObjects:sessions count:5]; }

-(LOCCoordinate*)findBeaconLocation:(BLEBeaconInfo*)beacon
{
    for ( int i = 0 ; i < 5 ; i++ ) {
        if ( [beacon isEqual:beacons[i]] ) return positions[i];
    }
    return nil;
}
@end


@interface BLELocatorTest : XCTestCase
@end

@implementation BLELocatorTest {
    BLELocator* locator;
    BLELocatorTestLocationSource* source;
}

- (void)setUp {
    [super setUp];
    locator = [[BLELocator alloc] init];
    source = [[BLELocatorTestLocationSource alloc] init];
    locator.beaconLocationSource = source;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLocationSource {
    BLEBeaconInfo* beacon = [[BLEBeaconInfo alloc] initWithUUID:source.uuid Major:1 Minor:1];
    LOCCoordinate* found = [source findBeaconLocation:beacon];
    XCTAssertEqual([source positions:0], found);
}

- (void)testBuildCandidate {
    NSArray* sessionArray = [source sessionArray];
    NSMutableArray* candidates = [locator buildCandidates:sessionArray];
    
    for ( int i = 0 ; i < 5 ; i++ ) {
        LSLocationCandidate* lc = candidates[i];
        XCTAssertEqual([source positions:i], lc.position);
    }
}

-(void)testFindMajorMap {
    NSArray* sessionArray = [source sessionArray];
    NSMutableArray* candidates = [locator buildCandidates:sessionArray];

    int majorMap = [locator findMajorMap:candidates];
    XCTAssertEqual(1, majorMap);
}

-(void)testRemoveOutMapLocation {
    NSArray* sessionArray = [source sessionArray];
    NSMutableArray* candidates = [locator buildCandidates:sessionArray];
    XCTAssertEqual(5, candidates.count);
    
    [locator removeLocation:candidates NotIn:1];
    XCTAssertEqual(4, candidates.count);
    
    LSLocationCandidate* lc = candidates[0];
    XCTAssertEqual([source positions:1], lc.position);
}

@end
