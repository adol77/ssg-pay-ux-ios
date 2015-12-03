//
//  SearchViewController.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/3/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapInfoProvider.h"
#import "MapCommandProtocol.h"

@interface SearchViewController : UIViewController

@property (nonatomic, strong) UIViewController *callerViewController;

@property (nonatomic, strong) id<MapCommandDelegate> mapCommandDelegate;
@property (nonatomic, strong) MapInfoProvider *mapInfoProvider;

- (void)setMapInfoProvider:(MapInfoProvider*)mapInfoProvider;

@end
