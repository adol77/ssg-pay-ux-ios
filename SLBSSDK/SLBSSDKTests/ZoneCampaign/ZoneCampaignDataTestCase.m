//
//  ZoneCampaignDataTestCase.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 2..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SLBSKitDefine.h"
#import "ZoneCampaignDataManager.h"

@interface ZoneCampaignDataTestCase : XCTestCase

@property (nonatomic, strong) NSDictionary *raw;

@end

@implementation ZoneCampaignDataTestCase

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSString *json = @"{\
        \"ret_data\": {\
            \"campaign_array\": [\
                               {\
                                   \"zone_array\": [\
                                                  {\
                                                      \"id\": 1,\
                                                      \"zone_id\": 1,\
                                                      \"campaign_id\": 1\
                                                  },\
                                                  {\
                                                      \"id\": 2,\
                                                      \"zone_id\": 2,\
                                                      \"campaign_id\": 1\
                                                  },\
                                                  {\
                                                      \"id\": 3,\
                                                      \"zone_id\": 3,\
                                                      \"campaign_id\": 1\
                                                  },\
                                                  {\
                                                      \"id\": 4,\
                                                      \"zone_id\": 4,\
                                                      \"campaign_id\": 1\
                                                  }\
                                                  ],\
                                   \"marketing_type\": 1,\
                                   \"off_week\": \"2/4\",\
                                   \"working_condition\": 1,\
                                   \"interval\": 1,\
                                   \"max_count_per_customer\": 5,\
                                   \"type\": 1,\
                                   \"id\": 1,\
                                   \"off_day\": 1,\
                                   \"end_time\": \"18:00\",\
                                   \"loitering_time\": 10,\
                                   \"name\": \"샘플 캠페인 1\",\
                                   \"owner_group\": 1,\
                                   \"start_time\": \"10:00\",\
                                   \"app_specific_data\": \"https://ssg.lbs.com\",\
                                   \"app_id\": 1\
                               },\
                               {\
                                   \"zone_array\": [\
                                                  {\
                                                      \"id\": 5,\
                                                      \"zone_id\": 6,\
                                                      \"campaign_id\": 2\
                                                  },\
                                                  {\
                                                      \"id\": 7,\
                                                      \"zone_id\": 10,\
                                                      \"campaign_id\": 2\
                                                  },\
                                                  {\
                                                      \"id\": 10,\
                                                      \"zone_id\": 13,\
                                                      \"campaign_id\": 2\
                                                  }\
                                                  ],\
                                   \"marketing_type\": 1,\
                                   \"off_week\": \"2/4\",\
                                   \"working_condition\": 1,\
                                   \"interval\": 1,\
                                   \"max_count_per_customer\": 5,\
                                   \"type\": 1,\
                                   \"id\": 2,\
                                   \"off_day\": 1,\
                                   \"end_time\": \"18:00\",\
                                   \"loitering_time\": 10,\
                                   \"name\": \"샘플 캠페인 2\",\
                                   \"owner_group\": 1,\
                                   \"start_time\": \"10:00\",\
                                   \"app_specific_data\": \"https://ssg.lbs.com\",\
                                   \"app_id\": 1\
                               }\
                               ],\
            \"msg\": \"SUCCESS\"\
        }\
    }";
    
    NSError *error = nil;
    self.raw = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"self.raw : %@", self.raw);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)initializeDataBase {
    
}

- (void)test01SetAndGetCampaignsWithStorage {
    NSArray *sources = [[self.raw objectForKey:@"ret_data"] objectForKey:@"campaign_array"];
    NSArray *campaigns = [SLBSZoneCampaignInfo zoneCampaignsWithSources:sources];
    [[ZoneCampaignDataManager sharedInstance] setZoneCampaigns:campaigns];
    NSArray *readCampaigns = [[ZoneCampaignDataManager sharedInstance] zoneCampaignsFromStorage];
    XCTAssertEqual([campaigns count], [readCampaigns count], "ZoneCampaign list read/write error");
    XCTAssertEqual([[[ZoneCampaignDataManager sharedInstance] zoneCampaigns] count], [readCampaigns count], "ZoneCampaign list read/write error");
    XCTAssert(YES, @"ZoneCampaign list read/write Pass");
}


- (void)test02QuaryZoneCampaignWithID {
    SLBSZoneCampaignInfo *campaign;
    campaign = [[ZoneCampaignDataManager sharedInstance] zoneCampaignWithID:[NSNumber numberWithInteger:1]];
    XCTAssertTrue(campaign, "quary ZoneCampaign ID = 1");
    campaign = [[ZoneCampaignDataManager sharedInstance] zoneCampaignWithID:[NSNumber numberWithInteger:200]];
    XCTAssertFalse(campaign, "quary ZoneCampaign ID = 200");
    XCTAssert(YES, @"zoneCampaignWithID Pass");
}

- (void)test03QuaryZoneCampaignWithName {
    SLBSZoneCampaignInfo *campaign;
    campaign = [[ZoneCampaignDataManager sharedInstance] zoneCampaignWithName:@"샘플 캠페인 2"];
    XCTAssertTrue(campaign, "quary ZoneCampaign Name = 샘플 캠페인 2");
    campaign = [[ZoneCampaignDataManager sharedInstance] zoneCampaignWithName:@"샘플 캠페인 200"];
    XCTAssertFalse(campaign, "quary ZoneCampaign Name = 샘플 캠페인 200");
    XCTAssert(YES, @"zoneCampaignWithName Pass");
}

- (void)test04QuaryZoneCampaignWithZoneNumber {
    NSArray *campaigns;
    campaigns = [[ZoneCampaignDataManager sharedInstance] zoneCampaignsWithZoneID:[NSNumber numberWithInteger:6]];
    XCTAssertEqual([campaigns count], 1, "quary ZoneCampaign ZoneID = 6");
    campaigns = [[ZoneCampaignDataManager sharedInstance] zoneCampaignsWithZoneID:[NSNumber numberWithInteger:60]];
    XCTAssertFalse(campaigns, "quary ZoneCampaign ZoneID = 60");
    XCTAssert(YES, @"zoneCampaignsWithZoneID Pass");
}

- (void)test05QuaryZoneCampaignWithZoneNumberAndSessionType {
    NSArray *campaigns;
    campaigns = [[ZoneCampaignDataManager sharedInstance] zoneCampaignsWithZoneID:[NSNumber numberWithInteger:6] sessionType:1];
    XCTAssertEqual([campaigns count], 1, "quary ZoneCampaign ZoneID = 6 AND sessionType = 1");
    campaigns = [[ZoneCampaignDataManager sharedInstance] zoneCampaignsWithZoneID:[NSNumber numberWithInteger:6] sessionType:2];
    XCTAssertFalse(campaigns, "quary ZoneCampaign ZoneID = 6 AND sessionType = 2");
    XCTAssert(YES, @"zoneCampaignsWithZoneID Pass");
}


//- (NSArray *)zoneCampaignsWithZoneID:(NSNumber *)zoneID;
//- (NSArray *)zoneCampaignsWithZoneID:(NSNumber *)zoneID sessionType:(SLBSSessionType)sessionType;


@end
