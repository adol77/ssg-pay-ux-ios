//
//  SearchTableViewCell.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/7/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreCommandProtocol.h"

@interface SearchTableViewCell : UITableViewCell

@property (nonatomic, strong) id<StoreCommandDelegate> storeCommandDelegate;
@property (nonatomic, strong) NSNumber *arrayIndex;

- (void)updateSearchName:(NSString*)searchName;
- (void)updateSearchNameDesc:(NSString*)searchNameDesc;
- (void)updateCampaignIconWithCount:(int)campaignCount;

@end
