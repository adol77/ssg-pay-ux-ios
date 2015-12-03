//
//  BeaconDataTestCase.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BeaconDataManager.h"
#import "Beacon.h"

@interface BeaconDataTestCase : XCTestCase
@property (nonatomic, strong) NSDictionary *beaconDic;
@end

@implementation BeaconDataTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString* beaconJson =
        @"{\"beacon_list\": \
            {\
                \"str_reg_date\":\"2015-09-02\", \
                \"str_upd_date\":\"2015-09-02\", \
                \"minor\":1,\
                \"beacon_loc \":{\
                    \"company_id\":69,\
                    \"str_reg_date\":\"2015-09-02\",\
                    \"str_upd_date\":\"2015-09-02\",\
                    \"creator_id\":1,\
                    \"id\":141,\
                    \"floor_id\":127,\
                    \"description\":\"\",\
                    \"validity\":1,\
                    \"editor_id\":1,\
                    \"beacon_id\":142,\
                    \"branch_id\":126,\
                    \"y\":2.2,\
                    \"x\":1.1 \
            },\
            \"type\":-1,\
            \"creator_id\":1,\
            \"serial_number\":\"\",\
            \"id\":142,\
            \"mac_address\":\"\",\
            \"broadcast_freq\":-1,\
            \"image_url\":\"\",\
            \"validity\":1,\
            \"description\":\"\",\
            \"name\":\"\",\
            \"uuid\":\"89F9DA42-BA67-4DB3-9231-B0F98C8D6F5B\",\
            \"editor_id\":1,\
            \"major\":1,\
            \"beacon_status\":{\
                \"id\":81,\
                \"str_reg_date\":\"2015-09-02\",\
                \"humidity\":100.0,\
                \"str_upd_date\":\"2015-09-02\",\
                \"validity\":1,\
                \"battery\":100.0,\
                \"editor_id\":1,\
                \"illumination\":100.0,\
                \"creator_id\":1,\
                \"beacon_id\":142,\
                \"temperature\":30.0 \
            },\
            \"tx_power\":0 \
    },\
    \"extra_info\":{\
        \"tot_page_count\":0,\
        \"sort_column\":\"\",\
        \"page_index\":0,\
        \"search_filter\":\"\",\
        \"record_count_per_page\":-1,\
    \"order_by\":1}}";
    
    NSError *error = nil;
    self.beaconDic = [NSJSONSerialization JSONObjectWithData:[beaconJson dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
   // NSLog(@"beaconDic : %@", self.beaconDic);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSaveData {
    NSMutableArray* writeBeacons = [[NSMutableArray alloc] init];
    Beacon* beacon = [Beacon beaconWithDictionary:[self.beaconDic objectForKey:@"beacon_list"]];
    [writeBeacons addObject:beacon];
    [[BeaconDataManager sharedInstance] setBeacons:writeBeacons];
    NSArray *readBeacons = [[BeaconDataManager sharedInstance] beacons];
    XCTAssertEqual([writeBeacons count], [readBeacons count], "ZoneCampaign list read/write error");
    XCTAssert(YES, @"ZoneCampaign list read/write Pass");

}

- (void)testQueryWithBeaconID {
    [self testSaveData];
    Beacon* beacon = [[BeaconDataManager sharedInstance] beaconForID:[NSNumber numberWithInt:142]];
    XCTAssertEqual([beacon.beacon_id integerValue], 142, "Pass");
    XCTAssert(YES, @"beaconForID Pass");
}

- (void)testQueryWithBeaconInfo {
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:@"89F9DA42-BA67-4DB3-9231-B0F98C8D6F5B"];
    NSNumber* major = [NSNumber numberWithInt:1];
    NSNumber* minor = [NSNumber numberWithInt:1];
    Beacon* beacon = [[BeaconDataManager sharedInstance] beaconForUUID:uuid major:major minor:minor];
    NSString* uuidString = [uuid UUIDString];
    XCTAssertTrue([beacon.uuid isEqualToString:uuidString],
                  @"Strings are not equal %@ %@", uuidString, beacon.uuid);
    XCTAssertEqual([beacon.major integerValue], 1, "Major error");
    XCTAssertEqual([beacon.minor integerValue], 1, "Minor error");
    XCTAssert(YES, @"beaconForUUID Pass");
}

@end
