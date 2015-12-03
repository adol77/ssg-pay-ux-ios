//
//  MapImageCacheTest.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 16..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MapImageCache.h"

@interface MapImageCacheTest : XCTestCase

@end

@implementation MapImageCacheTest {
    MapImageCache* cache;
}

- (void)setUp {
    [super setUp];
    cache = [[MapImageCache alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testCache {
    NSString* URL = @"url";
    UIImage* IMG = [[UIImage alloc] init];
    XCTAssertNil([cache imageForKey:URL]);
    [cache addImage:IMG forKey:URL];
    XCTAssertNotNil([cache imageForKey:URL]);
}

@end
