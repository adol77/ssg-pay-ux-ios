//
//  DirectionDetailViewController.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/18/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapInfoProvider.h"

#import "SearchViewController.h"
#import "CampaignInboxViewController.h"

@protocol MapDirectionDelegate <NSObject>

-(void)startMapDirection;
-(void)endMapDirection;

@end

@interface DirectionDetailViewController : UIViewController

@property (nonatomic, strong) id<MapDirectionDelegate> mapDirectionDelegate;
@property (nonatomic, strong) MapInfoProvider *mapInfoProvider;

@property (nonatomic, strong) id<MapCommandDelegate> mapCommandDelegate;

@end
