//
//  CampaignNet.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/22/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CampaignNet : NSObject 
@property (readonly) NSArray *campaignList;

@property (nonatomic, strong, readonly) NSString *errorMsg;

- (void)requestCampaignListWithAccessToken:(NSString*)token campaignId:(int)campaignId url:(NSString*)url block:(void (^)(BOOL success, CampaignNet *netObject))block;
+ (NSArray*)convertCampaignListToCampaignArray:(NSArray*)campaignList;


@end
