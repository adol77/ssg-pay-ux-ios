//
//  AppDelegate.h
//  SDKSample
//
//  Created by Regina on 2015. 8. 28..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Campaign.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

- (BOOL)isCamPaignPopupFloated;
- (void)showCampaignPopupViewWithCampaign:(Campaign*)campaign;
- (void)reloadCampaignPopupViewWithCampaign:(Campaign*)campaign;

// @SSG
- (BOOL)isParkingCamPaignPopupFloated;
- (void)showParkingCampaignPopupViewWithParkingCampaign:(Campaign*)campaign;

@end
