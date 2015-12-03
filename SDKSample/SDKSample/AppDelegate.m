//
//  AppDelegate.m
//  SDKSample
//
//  Created by Regina on 2015. 8. 28..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import "AppDelegate.h"

#import "SLBSGroupLogController.h"
#import <SLBSSDK/ApplicationManager.h>
#import <SLBSSDK/Zone.h>

#import "AppDataManager.h"
#import "CampaignManager.h"
#import "CampaignArchiver.h"
#import "NetworkDataRequester.h"

#import "HomeViewController.h"
#import "UIViewController+Utility.h"

#import "AppDefine.h"
#import "DateTimeUtil.h"
#import "ColorUtil.h"
#import "Util.h"
#import "NotiView.h"
#import "Campaign.h"

//#define TEST_SAMPLE_UIMODE          1
#if TEST_SAMPLE_UIMODE
#import "TestMenuTableViewController.h"
#endif

#import "CampaignConditionChecker.h" // @SSG

@interface AppDelegate () <SLBSZoneCampaignManagerDelegate>

@property (nonatomic, strong) AppDataManager *appDataManager;
@property (nonatomic, strong) CampaignManager *campaignManager;

@property (nonatomic, strong) UIView *campaignPopupBackView;
@property (nonatomic, strong) UILabel *campaignTitleLabel;
@property (nonatomic, strong) UIImageView *campaignImageView;

#ifdef CAMPAIGN_POPUP_SHOW_ONLY_ONE
@property (nonatomic, assign) BOOL processCampaign;
#endif

// @SSG
@property (nonatomic, strong) UIView *parkingCampaignPopupBackView;
@property (nonatomic, strong) Campaign* parkingCampaign;
//

@end

@implementation AppDelegate
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[SLBSGroupLogController sharedInstance] start];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *viewController;
#if TEST_SAMPLE_UIMODE
    viewController = [[TestMenuTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
//    viewController = (UIViewController *)nav;
#else
    viewController = [[HomeViewController alloc] init];
#endif
    
    self.window.rootViewController = viewController;
    
    [self checkIfStartedByNotification:application didFinishLaunchingWithOptions:launchOptions];
    [self registerNotificationSetting:application];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    application.applicationIconBadgeNumber = 0;
    
    [self initManager];
    
    // for debugging
#ifdef CAMPAIGN_POPUP_SHOW_ONLY_ONE
    self.processCampaign = YES;
#endif
    
    return YES;
}

- (void)initManager {
    self.appDataManager = [AppDataManager sharedInstance];
    self.appDataManager.campaignArray = [NSMutableArray arrayWithArray:[CampaignArchiver unarchiveCampaignAll]];
    
    [self initCampaignPopupView];

    self.campaignManager = [[CampaignManager alloc] init];
    
    [[SLBSZoneCampaignManager sharedInstance] setDelegate:self];
    [[SLBSZoneCampaignManager sharedInstance] startMonitoring];
}

// 알림을 통한 진입인지 확인
- (void)checkIfStartedByNotification:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotif){
        // 알림으로 인해 앱이 실행된 경우
        //        NSNumber *campaignId = [Util getCampaignIdFromNotification:localNotif];
        //        Campaign *campaign = [self.campaignChecker findCampaign:campaignId];
        //        if (campaign) {
        //            if ([self isCamPaignPopupFloated]) {
        //                [self removeNoti:application noti:localNotif];
        //            } else {
        //                [self showCampaignPopupViewWithCampaign:campaign];
        //            }
        //        } else {
        //            [self removeNoti:application noti:localNotif];
        //        }
    }
}

- (void)registerNotificationSetting:(UIApplication*)application {
    // register user notification setting
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes :(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        //iOS 7 & earlier
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
}

- (void)removeNoti:(UIApplication*)application noti:(UILocalNotification*)noti {
    // cancel noti
    [application cancelLocalNotification:noti];
    
//    // update badge number
//    self.totalBadgeNumber = [NSNumber numberWithInt:[self.totalBadgeNumber intValue]-1];
//    [application setApplicationIconBadgeNumber:[self.totalBadgeNumber intValue]];
}


#pragma mark - Zone Campaign

- (void)zoneCampaignManager:(SLBSZoneCampaignManager *)manager onCampaignPopup:(NSArray *)zoneCampaignList {

    // show log
    for(SLBSZoneCampaignInfo* zoneCampaignInfo in zoneCampaignList) {
        NSString* sessionType ;
        if([zoneCampaignInfo.workingCondition intValue] == 1)
            sessionType = @"Enter";
        else if ([zoneCampaignInfo.workingCondition intValue] == 2)
            sessionType = @"Exit";
        else if([zoneCampaignInfo.workingCondition intValue] == 3)
            sessionType = @"Dwell";
        
        TSGLog(TSLogGroupApplication, @"Campaign was arrived! Name=%@, WorkingCondition=%@", zoneCampaignInfo.name, sessionType);
    }

    // processing
#ifdef CAMPAIGN_POPUP_SHOW_ONLY_ONE
    if (self.processCampaign==YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for(SLBSZoneCampaignInfo* zoneCampaignInfo in zoneCampaignList) {
                [self.campaignManager processCampaign:zoneCampaignInfo];
                self.processCampaign = NO;
            }
        });
    }
#else
    dispatch_async(dispatch_get_main_queue(), ^{
        for(SLBSZoneCampaignInfo* zoneCampaignInfo in zoneCampaignList) {
            [self.campaignManager processCampaign:zoneCampaignInfo];
        }
    });
#endif
}

//- (void)notifyOnCampaignPopup:(NSArray *)zoneCampaignList {
//    TSGLog(TSLogGroupApplication, @">>> notifyOnCampaignPopup()");
//    
//    for(SLBSZoneCampaignInfo* zoneCampaignInfo in zoneCampaignList) {
//        [self.campaignManager processCampaign:zoneCampaignInfo];
//    }
//    
//    NetworkDataRequester *requester = [NetworkDataRequester sharedInstance];
//    
//    for(SLBSZoneCampaignInfo* zoneCampaignInfo in zoneCampaignList) {
//        [self.campaignChecker addZoneCampaignInfo:zoneCampaignInfo];
//        
//        if ([self.campaignChecker checkIfCampaignConditionIsAllowed:zoneCampaignInfo]==YES) {
//            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground) {
//                [Util addLocalNotificationWithBody:[NSString stringWithFormat:@"%@을 수신하였습니다", zoneCampaignInfo.name]
//                                        totBadgeNo:[self.totalBadgeNumber intValue]
//                                        campaignId:zoneCampaignInfo.ID];
//            }
//            
//            [requester requestCampaignInfo:^(NSArray *campaignArray) {
//                if (campaignArray!=nil) {
//                    for (int i=0; i<campaignArray.count; i++) {
//                        Campaign *campaign = [campaignArray objectAtIndex:i];
//                        Campaign *existCampaign = [self.campaignChecker existCampaign:zoneCampaignInfo];
//                        
//                        // 연관된 zone id와 zone type을 저장
//                        Zone *associatedZone = [self findZoneTypeWithZoneId:existCampaign.zoneId];
//                        existCampaign.zoneId = associatedZone.zone_id;
//                        existCampaign.zoneType = associatedZone.type;
//                        
//                        [self.campaignChecker migrateReceivedInfo:existCampaign downloadCampaign:campaign campaignId:zoneCampaignInfo.ID];
//                        
//                        if ([self isCamPaignPopupFloated] && [[UIApplication sharedApplication] applicationState]== UIApplicationStateActive) {
//                            [Util addLocalNotificationWithBody:[NSString stringWithFormat:@"%@을 수신하였습니다", campaign.title]
//                                                    totBadgeNo:[self.totalBadgeNumber intValue]
//                                                    campaignId:campaign.campaignId];
//                            self.totalBadgeNumber = [NSNumber numberWithInt:[self.totalBadgeNumber intValue]+1];
//                        } else {
//                            [self showCampaignPopupViewWithCampaign:campaign];
//                        }
//                    }
//                } else {
//                    TSGLog(TSLogGroupApplication, @"No Campaign Info!!!");
//                }
//            } campaignId:[zoneCampaignInfo.ID intValue]];
//        }
//        
//    }
//
//}

- (BOOL)isCamPaignPopupFloated {
    if (self.campaignPopupBackView!=nil) {
        if ([self.campaignPopupBackView superview]!=nil) {
            return YES;
        }
    }
    
    return NO;
}

- (void)initCampaignPopupView {
    self.campaignPopupBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.campaignPopupBackView.backgroundColor = [ColorUtil popupBgColor];
    
    CGFloat popupWidth = 282;
    CGFloat popupHeight = 325;

    // main view
    UIView *campaignPopupMainView = [[UIView alloc] initWithFrame:
                                     CGRectMake(([UIScreen mainScreen].bounds.size.width - popupWidth)/2,
                                                ([UIScreen mainScreen].bounds.size.height - popupHeight)/2,
                                                popupWidth, popupHeight)];
    
    campaignPopupMainView.backgroundColor = [UIColor whiteColor];
    [self.campaignPopupBackView addSubview:campaignPopupMainView];
    
    // top separator
    UIView *topSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupWidth, 4)];
    topSepView.backgroundColor = [ColorUtil mainRedColor];
    [campaignPopupMainView addSubview:topSepView];
    
    // title
    self.campaignTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 4, popupWidth, 48)];
    self.campaignTitleLabel.textColor = [ColorUtil mainRedColor];
    self.campaignTitleLabel.font = [UIFont systemFontOfSize:19];
    [campaignPopupMainView addSubview:self.campaignTitleLabel];
    
    // image
    self.campaignImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 52, 260, 262)];
    [campaignPopupMainView addSubview:self.campaignImageView];
    
    // close button
    UIImage *closeButtonImgNor = [UIImage imageNamed:@"campaign_popup_close_nor_btn"];
    UIImage *closeButtonImgPre = [UIImage imageNamed:@"campaign_popup_close_pre_btn"];
    
    UIButton *campaignCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(popupWidth - 45, 4, 45, 45)];
    [campaignCloseButton setImage:closeButtonImgNor forState:UIControlStateNormal];
    [campaignCloseButton setImage:closeButtonImgPre forState:UIControlStateSelected];
    [campaignCloseButton setContentMode:UIViewContentModeCenter];
    [campaignCloseButton addTarget:self action:@selector(campaignCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [campaignPopupMainView addSubview:campaignCloseButton];
}

- (void)showCampaignPopupViewWithCampaign:(Campaign*)campaign {
    [self reloadCampaignPopupViewWithCampaign:campaign];
    
    if ([self isCamPaignPopupFloated]==NO) {
//        UIViewController *topViewController = [UIViewController currentViewController];
//        [topViewController.view addSubview:self.campaignPopupBackView];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self.campaignPopupBackView];
    }
}

- (void)reloadCampaignPopupViewWithCampaign:(Campaign*)campaign {
    // title
    self.campaignTitleLabel.text = campaign.title;
    
    // image
    if (campaign.imageFilePath!=nil) {
        UIImage *imageFile = [UIImage imageWithContentsOfFile:campaign.imageFilePath];
        if (imageFile==nil) {
            // TODO imageFile is nil why?
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *composedImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_IP_HEAD, campaign.imageUrl];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:composedImageUrl]]];
                [self.campaignImageView setImage:image];
            });
        } else {
            [self.campaignImageView setImage:imageFile];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *composedImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_IP_HEAD, campaign.imageUrl];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:composedImageUrl]]];
            [self.campaignImageView setImage:image];
        });
    }
}

- (void)hideCampaignPopupView {
    [self.campaignPopupBackView removeFromSuperview];
}

- (void)campaignCloseButtonClicked {
    [self hideCampaignPopupView];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"didReceiveLocalNotification()");
    
    if(application.applicationState == UIApplicationStateActive){
        // Foreground에서 알림 수신
        // NotiView 표시
        [NotiView popupNotiViewWithMessage:notification.alertBody];
        application.applicationIconBadgeNumber = 0;
    } else if (application.applicationState == UIApplicationStateInactive) {
        // local notification을 터치했을 경우
        [self.campaignManager selectLocalNotification:notification];
        application.applicationIconBadgeNumber = 0;
    } else if (application.applicationState == UIApplicationStateBackground) {
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[SLBSGroupLogController sharedInstance] stop];
}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{

    NSDate *fetchStart = [NSDate date];

    NSLog(@"performFetchWithCompletionHandler");

    [[ApplicationManager sharedInstance] fetchNewDataWithCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);

        NSDate *fetchEnd = [NSDate date];
        NSTimeInterval timeElapsed = [fetchEnd timeIntervalSinceDate:fetchStart];
        NSLog(@"Background Fetch Duration: %f seconds", timeElapsed);

    } ];

}


///////////////////////////////////////////////////////////////
// SSG added

- (void)showParkingCampaignPopupViewWithParkingCampaign:(Campaign*)campaign {

    if (self.parkingCampaignPopupBackView!=nil) {
        if ([self.parkingCampaignPopupBackView superview]!=nil) {
            [self.parkingCampaignPopupBackView removeFromSuperview];
        }
    }

    self.parkingCampaign = campaign;

    if ([self isParking]) {
        return;
    }

    // back view
    self.parkingCampaignPopupBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.parkingCampaignPopupBackView.backgroundColor = [ColorUtil popupBgColor];

    CGFloat popupWidth = 282;
    CGFloat popupHeight = 350;
    // main view
    UIView *parkingCampaignPopupMainView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - popupWidth)/2,
                                                                                    ([UIScreen mainScreen].bounds.size.height - popupHeight)/3,
                                                                                    popupWidth, popupHeight)];
    parkingCampaignPopupMainView.backgroundColor = [UIColor whiteColor];
    [self.parkingCampaignPopupBackView addSubview:parkingCampaignPopupMainView];

    // top separator
    UIView *topSepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, popupWidth, 4)];
    topSepView.backgroundColor = [ColorUtil mainRedColor];
    [parkingCampaignPopupMainView addSubview:topSepView];

    // image

    UIImageView *parkingCampaignImageView = [[UIImageView alloc] initWithFrame:CGRectMake(64, 35, 150, 110)];
    if (campaign.imageFilePath!=nil) {
        UIImage *imageFile = [UIImage imageWithContentsOfFile:campaign.imageFilePath];
        if (imageFile==nil) {
            // TODO imageFile is nil why?
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *composedImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_IP_HEAD, campaign.imageUrl];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:composedImageUrl]]];
                [parkingCampaignImageView setImage:image];
                [parkingCampaignPopupMainView addSubview:parkingCampaignImageView];
            });
        } else {
            [parkingCampaignImageView setImage:imageFile];
            [parkingCampaignPopupMainView addSubview:parkingCampaignImageView];
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *composedImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_IP_HEAD, campaign.imageUrl];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:composedImageUrl]]];
            [parkingCampaignImageView setImage:image];
            [parkingCampaignPopupMainView addSubview:parkingCampaignImageView];
        });
    }

    // close button
    UIImage *closeButtonImgNor = [UIImage imageNamed:@"campaign_popup_close_nor_btn"];
    UIImage *closeButtonImgPre = [UIImage imageNamed:@"campaign_popup_close_pre_btn"];

    UIButton *parkingCampaignCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(popupWidth - 45, 4, 45, 45)];
    [parkingCampaignCloseButton setImage:closeButtonImgNor forState:UIControlStateNormal];
    [parkingCampaignCloseButton setImage:closeButtonImgPre forState:UIControlStateSelected];
    [parkingCampaignCloseButton setContentMode:UIViewContentModeCenter];
    [parkingCampaignCloseButton addTarget:self action:@selector(parkingCampaignCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [parkingCampaignPopupMainView addSubview:parkingCampaignCloseButton];

    UIViewController *topViewController = [UIViewController currentViewController];
    [topViewController.view addSubview:self.parkingCampaignPopupBackView];

    // description head
    UILabel *parkingCampaignDescHeadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, popupWidth, 20)];
    parkingCampaignDescHeadLabel.text = @"고객님은 현재";
    parkingCampaignDescHeadLabel.textColor = [ColorUtil ParkingTxtColor];
    parkingCampaignDescHeadLabel.font = [UIFont systemFontOfSize:19];
    [parkingCampaignDescHeadLabel setNumberOfLines:0];
    parkingCampaignDescHeadLabel.lineBreakMode = NSLineBreakByWordWrapping;
    parkingCampaignDescHeadLabel.textAlignment = NSTextAlignmentCenter;
    [parkingCampaignPopupMainView addSubview:parkingCampaignDescHeadLabel];

    // description parking area
    UILabel *parkingCampaignDescAreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 195, popupWidth, 20)];
    parkingCampaignDescAreaLabel.text = campaign.title;
    parkingCampaignDescAreaLabel.textColor = [ColorUtil ParkingAreaTxtColor];
    parkingCampaignDescAreaLabel.font = [UIFont systemFontOfSize:19];
    [parkingCampaignDescAreaLabel setNumberOfLines:0];
    parkingCampaignDescAreaLabel.lineBreakMode = NSLineBreakByWordWrapping;
    parkingCampaignDescAreaLabel.textAlignment = NSTextAlignmentCenter;
    [parkingCampaignPopupMainView addSubview:parkingCampaignDescAreaLabel];

    // description mid
    UILabel *parkingCampaignDescMidlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, popupWidth, 20)];
    parkingCampaignDescMidlLabel.text = @"구역에 계십니다.";
    parkingCampaignDescMidlLabel.textColor = [ColorUtil ParkingTxtColor];
    parkingCampaignDescMidlLabel.font = [UIFont systemFontOfSize:19];
    [parkingCampaignDescMidlLabel setNumberOfLines:0];
    parkingCampaignDescMidlLabel.lineBreakMode = NSLineBreakByWordWrapping;
    parkingCampaignDescMidlLabel.textAlignment = NSTextAlignmentCenter;
    [parkingCampaignPopupMainView addSubview:parkingCampaignDescMidlLabel];

    // description tail
    UILabel *parkingCampaignDescTailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 245, popupWidth, 20)];
    parkingCampaignDescTailLabel.text = @"주차 위치를 저장 하시겠습니까?";
    parkingCampaignDescTailLabel.textColor = [ColorUtil ParkingTxtColor];
    parkingCampaignDescTailLabel.font = [UIFont systemFontOfSize:19];
    [parkingCampaignDescTailLabel setNumberOfLines:0];
    parkingCampaignDescTailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    parkingCampaignDescTailLabel.textAlignment = NSTextAlignmentCenter;
    [parkingCampaignPopupMainView addSubview:parkingCampaignDescTailLabel];

    // done button
    UIButton *parkingCampaingOKButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                                   popupHeight - 50,
                                                                                   popupWidth, 50)];
    parkingCampaingOKButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [parkingCampaingOKButton setTitle:@"확인" forState:UIControlStateNormal];
    [parkingCampaingOKButton addTarget:self action:@selector(parkingCampaignDoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [parkingCampaingOKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [parkingCampaingOKButton setBackgroundColor:[ColorUtil mainRedColor]];
    [parkingCampaignPopupMainView addSubview:parkingCampaingOKButton];

}

- (BOOL)isParkingCamPaignPopupFloated {
    if (self.parkingCampaignPopupBackView!=nil) {
        if ([self.parkingCampaignPopupBackView superview]!=nil) {
            return YES;
        }
    }
    return NO;
}

- (void)parkingCampaignCloseButtonClicked {
    [self hideParkingCampaignPopupView];
}

- (void)parkingCampaignDoneButtonClicked {
    CampaignConditionChecker *campaignChecker = [[CampaignConditionChecker alloc] init];
    [campaignChecker addZoneCampaign:self.parkingCampaign];
    [CampaignArchiver archiveCampaign:self.parkingCampaign campaignId:[self.parkingCampaign.campaignId intValue]];
    [self hideParkingCampaignPopupView];
}

- (void)hideParkingCampaignPopupView {
    [self.parkingCampaignPopupBackView removeFromSuperview];
    self.parkingCampaignPopupBackView = nil;
}

- (BOOL)isParking {
    for (Zone *zone in self.appDataManager.campaignArray) {
        if ([zone.type intValue] == 3) { // for parking
            return TRUE;
        }
    }
    return FALSE;
}

@end
