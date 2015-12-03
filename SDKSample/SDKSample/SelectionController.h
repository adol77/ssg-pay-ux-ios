//
//  SelectionController.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/5/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapInfoProvider.h"

@interface SelectionController : NSObject

@property (nonatomic, strong) AppDataManager *appDataManager;
@property (nonatomic, strong) MapInfoProvider *mapInfoProvider;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

- (instancetype)init:(MapInfoProvider*)mapInfoProvider;
- (void)showCheckmarkTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath show:(BOOL)show;
- (void)showCheckmarkTableViewWithCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath show:(BOOL)show;
- (void)clearCheckmarkInTableView:(UITableView*)tableView array:(NSArray*)array;

@end
