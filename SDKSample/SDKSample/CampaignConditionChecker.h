//
//  CampaignConditionChecker.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/1/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLBSSDK/SLBSZoneCampaignInfo.h>

#import "Campaign.h"

@interface CampaignConditionChecker : NSObject

- (void)addZoneCampaignInfo:(SLBSZoneCampaignInfo*)zoneCampaignInfo;
- (BOOL)checkIfCampaignConditionIsAllowed:(SLBSZoneCampaignInfo*)zoneCampaignInfo;
- (Campaign*)updateCampaign:(Campaign*)campaign zoneCampaignInfo:(SLBSZoneCampaignInfo*)zoneCampaign;
- (void)updateDownloadedImagePath:(NSString*)imagePath campaignId:(NSNumber*)campaignId;
- (Campaign*)findCampaign:(NSNumber*)campaignId;

// @SSG
- (void)addZoneCampaign:(Campaign*)campaign;
- (void)removeZoneCampaign:(NSNumber*)campaignId;
- (BOOL)isParking;
//

@end
