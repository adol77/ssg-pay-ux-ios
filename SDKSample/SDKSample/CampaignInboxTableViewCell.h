//
//  CampaignInboxTableViewCell.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/28/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCommandProtocol.h"

@interface CampaignInboxTableViewCell : UITableViewCell

@property (nonatomic, strong) id<StoreCommandDelegate> storeCommandDelegate;
@property (nonatomic, strong) NSNumber *arrayIndex;

- (void)updateTitle:(NSString*)title;

- (void)updateAllIconDisplay:(BOOL)showIcon;
- (void)updateMoveToIconDisplay:(BOOL)showIcon;
- (void)updateDirectToIconDisplay:(BOOL)showIcon;
- (void)updateSeparatorIconDisplay:(BOOL)showIcon;

@end
