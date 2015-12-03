//
//  NetworkDataRequester.h
//  SampleApplication
//
//  Created by Jeoungsoo on 9/7/15.
//  Copyright (c) 2015 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkDataRequester : NSObject

+ (NetworkDataRequester*)sharedInstance;
+ (NSTimeInterval)getURLRequestTimeout;

- (void)requestCampaignInfo:(void (^)(NSArray* campaignArray))resultBlock campaignId:(int)campaignId;

@end
