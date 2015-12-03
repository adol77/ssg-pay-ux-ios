//
//  FloorSelectionController.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/5/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionController.h"

@interface FloorSelectionController : SelectionController <UITableViewDataSource, UITableViewDelegate>

- (instancetype)init:(MapInfoProvider*)mapInfoProvider;

@end
