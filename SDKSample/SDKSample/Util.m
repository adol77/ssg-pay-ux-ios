//
//  Util.m
//  SDKSample
//
//  Created by Jeoungsoo on 9/22/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "Util.h"

@implementation Util

#define LOCAL_NOTI_CAMPAIGN_ID_KEY      @"campaign_id"

+ (void)showAlertPopupWithTitle:(NSString*)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"확인"
                                              otherButtonTitles:nil];
    [alertView show];
}

//+ (void)addLocalNotification {
//    NSLog(@"***** addLocalNotification()");
//    
//    UILocalNotification *localNofication = [[UILocalNotification alloc] init];
//    
//    localNofication.alertBody = @"캠페인 1";
//    localNofication.alertAction = @"View";
//    localNofication.soundName = UILocalNotificationDefaultSoundName;
//    localNofication.applicationIconBadgeNumber = 1;
//    
//    [[UIApplication sharedApplication] presentLocalNotificationNow:localNofication];
//}

+ (void)addLocalNotificationWithBody:(NSString*)body totBadgeNo:(int)totBadgeNo campaignId:(NSNumber*)campaignId {
    NSLog(@"***** addLocalNotification()");
    
    UILocalNotification *localNofication = [[UILocalNotification alloc] init];
    
    localNofication.alertBody = body;
    localNofication.alertAction = @"View";
    localNofication.soundName = UILocalNotificationDefaultSoundName;
    localNofication.applicationIconBadgeNumber = totBadgeNo;
    
    localNofication.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", [campaignId intValue]]
                                                           forKey:LOCAL_NOTI_CAMPAIGN_ID_KEY];
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNofication];
}

+ (NSNumber*)getCampaignIdFromNotification:(UILocalNotification*)localNoti {
    NSDictionary *dic = localNoti.userInfo;
    NSString *campaignIdStr = [dic valueForKey:LOCAL_NOTI_CAMPAIGN_ID_KEY];
    NSNumber *campaignId = [NSNumber numberWithInt:[campaignIdStr intValue]];

    return campaignId;
}


@end
