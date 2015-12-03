//
//  FloorSelectionView.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/15/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapInfoProvider.h"

@protocol FloorSelectionDelegate <NSObject>

- (void)floorSelectedByFloorChanged:(BOOL)floorChanged;

@end

@interface FloorSelectionView : UIView

@property (nonatomic, strong) id<FloorSelectionDelegate> floorSelectionDelegate;

- (instancetype)initWithFrame:(CGRect)frame mapInfoProvider:(MapInfoProvider*)mapInfoProvider;
- (void)updateFloorSelection;

@end
