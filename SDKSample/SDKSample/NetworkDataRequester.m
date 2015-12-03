//
//  NetworkDataRequester.m
//  SampleApplication
//
//  Created by Jeoungsoo on 9/7/15.
//  Copyright (c) 2015 ssg. All rights reserved.
//

#import "NetworkDataRequester.h"
#import "Util.h"
#import <SLBSSDK/TSDebugLogManager.h>

#import "CampaignNet.h"

@interface NetworkDataRequester ()

@property (nonatomic, strong) NSString *accessToken;

@end

@implementation NetworkDataRequester

+ (NetworkDataRequester*)sharedInstance {
    static dispatch_once_t oncePredicate;
    static NetworkDataRequester *sharedDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedDataManager = [[NetworkDataRequester alloc] init];
    });
    return sharedDataManager;
}

+ (NSTimeInterval)getURLRequestTimeout {
    return 10;
}

- (id)init {
    self = [super init];
    if (self) {
        self.accessToken = @"aslkdfjklsdfkl";
    }
    
    return self;
}

- (void)requestCampaignInfo:(void (^)(NSArray* campaignArray))resultBlock campaignId:(int)campaignId {
    CampaignNet* net = [[CampaignNet alloc] init];
    [net requestCampaignListWithAccessToken:self.accessToken campaignId:campaignId url:@"http://112.217.207.164:20080" block:^(BOOL success, CampaignNet* netObject){
        NSLog(@"Request Campaign Info");
        
        if (netObject!=nil) {
            CampaignNet* net = (CampaignNet*)netObject;
            NSArray *convertedCampaignArray = [CampaignNet convertCampaignListToCampaignArray:net.campaignList];
            resultBlock(convertedCampaignArray);
        } else {
            NSLog(@"Request Campaign Info Failed");
            resultBlock(nil);
        }
    }];
}

@end
