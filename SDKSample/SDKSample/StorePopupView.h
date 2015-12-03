//
//  StorePopupView.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/15/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SLBSSDK/Zone.h>
#import <SLBSSDK/SLBSFloor.h>

#import "MapInfoProvider.h"

@interface StorePopupView : UIView

@property (nonatomic, strong) UIButton *storeDirectButton;
@property (nonatomic, strong) UIButton *storeCloseButton;

- (instancetype)initWithFrame:(CGRect)frame zone:(Zone*)zone floor:(SLBSFloor*)floor;

@end
