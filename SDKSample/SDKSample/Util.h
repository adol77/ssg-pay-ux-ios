//
//  Util.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/22/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Util : NSObject

+ (void)showAlertPopupWithTitle:(NSString*)title;
+ (void)addLocalNotification;
+ (void)addLocalNotificationWithBody:(NSString*)body totBadgeNo:(int)totBadgeNo campaignId:(NSNumber*)campaignId;
+ (NSNumber*)getCampaignIdFromNotification:(UILocalNotification*)localNoti;

@end
