//
//  CampaignInboxViewController.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/18/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapCommandProtocol.h"
#import "MapInfoProvider.h"

@interface CampaignInboxViewController : UIViewController

@property (nonatomic, strong) UIViewController *callerViewController;

@property (nonatomic, strong) id<MapCommandDelegate> mapCommandDelegate;
@property (nonatomic, strong) MapInfoProvider *mapInfoProvider;

@end
