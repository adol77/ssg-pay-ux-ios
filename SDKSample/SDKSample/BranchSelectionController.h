//
//  BranchSelectionController.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/5/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionController.h"

@protocol BranchSelectionDelegate <NSObject>
-(void)reloadFloorData;
@end

@interface BranchSelectionController : SelectionController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) id<BranchSelectionDelegate> branchSelectionDelegate;

- (instancetype)init:(MapInfoProvider*)mapInfoProvider;

@end
