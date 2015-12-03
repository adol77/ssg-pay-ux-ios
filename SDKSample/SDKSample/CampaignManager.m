//
//  CampaignManager.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/16/15.
//  Copyright © 2015 Regina. All rights reserved.
//
// - async task
// - check campaign condition(using CampaignConditionChecker)
// - download campaign info
// - download campaign image
// - archive campaign (using CampaignArchiver)
// - show campaign popup or noti

#import "CampaignManager.h"
#import "CampaignConditionChecker.h"
#import "AppDataManager.h"
#import "NetworkDataRequester.h"
#import "CampaignArchiver.h"

#import <SLBSSDK/TSDebugLogManager.h>
#import <SLBSSDK/Zone.h>
#import <NotificationCenter/NotificationCenter.h>

#import "Util.h"
#import "AppDefine.h"
#import "AppDelegate.h"

@interface CampaignManager ()

@property (nonatomic, strong) CampaignConditionChecker *campaignChecker;

@end

@implementation CampaignManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.campaignChecker = [[CampaignConditionChecker alloc] init];
    }
    
    return self;
}

- (void)processCampaign:(SLBSZoneCampaignInfo*)zoneCampaignInfo {
    [self.campaignChecker addZoneCampaignInfo:zoneCampaignInfo];
    
    if ([self.campaignChecker checkIfCampaignConditionIsAllowed:zoneCampaignInfo]==YES) {
        [self doNotificationByBackgroundState:zoneCampaignInfo.name campaignId:zoneCampaignInfo.ID];
        [self downloadCampaign:zoneCampaignInfo resultBlock:^(NSNumber *campaignId) {
            if (campaignId!=nil) {
                Campaign *foundCampaign = [self.campaignChecker findCampaign:campaignId];
                [self downloadCampaignImage:foundCampaign];
                [self archiveCampaign:foundCampaign.campaignId];
            
                // @SSG
                if ([foundCampaign.type intValue] == 3) { // for parking
                    [self.campaignChecker removeZoneCampaign:campaignId];
                    [CampaignArchiver removeCampaignFile:[campaignId intValue]];
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    if ([appDelegate isCamPaignPopupFloated]==YES) {
                        [self doNotificationByActiveState:zoneCampaignInfo.name campaignId:zoneCampaignInfo.ID];
                    } else {
                        [appDelegate showParkingCampaignPopupViewWithParkingCampaign:foundCampaign];
                    }
                }
                //
                else {
                    // show campaign popup
                    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                    if ([appDelegate isCamPaignPopupFloated]==YES) {
                        [self doNotificationByActiveState:zoneCampaignInfo.name campaignId:zoneCampaignInfo.ID];
                    } else {
                        [appDelegate showCampaignPopupViewWithCampaign:foundCampaign];
                    }
                    if ([foundCampaign.title compare:@"SSG Pay 1 진입"]==NSOrderedSame) {
                       // [[UIViewController todayViewController] hideViewController];
                        
                        //[[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY3"];
                        [[NCWidgetController widgetController] setHasContent:YES forWidgetWithBundleIdentifier:@"com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY4"];
                    }
                    //if ([foundCampaign.title compare:@"SSG Pay 1 Exit"]==NSOrderedSame) {
                    //    [[NCWidgetController widgetController] setHasContent:NO forWidgetWithBundleIdentifier:@"com.ssg.platform.lbs.SSG-LBS-Platform.SSG-PAY"];
                    //}
                }
            }
        }];
    }
}

- (void)selectLocalNotification:(UILocalNotification*)localNoti {
    NSNumber *campaignId = [Util getCampaignIdFromNotification:localNoti];
    Campaign *campaign = [self.campaignChecker findCampaign:campaignId];
    if (campaign) {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        // @SSG
        if ([campaign.type intValue] == 3) { // for parking
            [appDelegate showParkingCampaignPopupViewWithParkingCampaign:campaign];
        }
        else {
            [appDelegate showCampaignPopupViewWithCampaign:campaign];
        }
        //

        // remove local notification
        UIApplication * application = [UIApplication sharedApplication];
        [application cancelLocalNotification:localNoti];
    }
}

- (void)doNotificationByBackgroundState:(NSString*)campaignName campaignId:(NSNumber*)campaignId {
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    
    if (appState==UIApplicationStateBackground) {
        [self addLocalNotification:campaignName infoId:campaignId];
    }
}

- (void)doNotificationByActiveState:(NSString*)campaignName campaignId:(NSNumber*)campaignId {
    UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
    
    if (appState==UIApplicationStateActive) {
        [self addLocalNotification:campaignName infoId:campaignId];
    }
}

- (void)addLocalNotification:(NSString*)name infoId:(NSNumber*)infoId {
    [Util addLocalNotificationWithBody:[NSString stringWithFormat:@"%@을 수신하였습니다", name]
                            totBadgeNo:0
                            campaignId:infoId];
}

- (void)downloadCampaign:(SLBSZoneCampaignInfo*)zoneCampaignInfo resultBlock:(void (^)(NSNumber *campaignId))resultBlock {
    NetworkDataRequester *requester = [NetworkDataRequester sharedInstance];

    dispatch_async(dispatch_get_main_queue(), ^{
        [requester requestCampaignInfo:^(NSArray *campaignArray) {
            if (campaignArray!=nil && campaignArray.count > 0) {
                // Use first campaign on assuming that only single campaign exist
                Campaign *campaign = [campaignArray objectAtIndex:0];
                Campaign *updatedCampaign = [self.campaignChecker updateCampaign:campaign zoneCampaignInfo:zoneCampaignInfo];
                resultBlock(updatedCampaign.campaignId);
            } else {
                TSGLog(TSLogGroupApplication, @"No Campaign Info!!!");
                resultBlock(nil);
            }
        } campaignId:[zoneCampaignInfo.ID intValue]];
    });
}

- (void)downloadCampaignImage:(Campaign*)campaign {
    if (campaign.imageFilePath!=nil && campaign.imageFilePath.length > 0) {
        return;
    }

    // download image
    NSString *composedImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_IP_HEAD, campaign.imageUrl];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:composedImageUrl]]];

    // extract image filename
    NSArray *comps = [campaign.imageUrl componentsSeparatedByString:@"/"];
    NSString *imageFilename = [comps objectAtIndex:comps.count - 1];
    
    // make image file path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:imageFilename];
    
    // save image to file
    BOOL writed = [UIImagePNGRepresentation(image) writeToFile:imageFilePath atomically:YES];
    if (writed==YES) {
        // update image path to campaign
        [self.campaignChecker updateDownloadedImagePath:imageFilePath campaignId:(NSNumber*)campaign.campaignId];
    }
}

- (void)archiveCampaign:(NSNumber*)campaignId {
    Campaign *foundCampaign = [self.campaignChecker findCampaign:campaignId];
    [CampaignArchiver archiveCampaign:foundCampaign campaignId:[campaignId intValue]];
}



@end
