//
//  CampaignManager.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/16/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLBSSDK/SLBSZoneCampaignInfo.h>

@interface CampaignManager : NSObject

- (void)processCampaign:(SLBSZoneCampaignInfo*)zoneCampaignInfo;
- (void)selectLocalNotification:(UILocalNotification*)localNoti;

@end
