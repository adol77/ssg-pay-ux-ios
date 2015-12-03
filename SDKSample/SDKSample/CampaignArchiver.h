//
//  CampaignArchiver.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/24/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Campaign.h"

@interface CampaignArchiver : NSObject

+ (void)archiveCampaign:(Campaign*)campaign campaignId:(int)campaignId;
+ (NSArray*)unarchiveCampaignAll;
+ (BOOL)removeAllCampaignFile;
+ (BOOL)removeCampaignFile:(int)campaignId; // @SSG

@end
