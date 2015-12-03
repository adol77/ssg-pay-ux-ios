//
//  TSLogTableViewController.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSDebugLogManager.h"

@interface TSLogTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *logs;

@end

@interface TSLogCell : UITableViewCell

@property (nonatomic, weak) TSLogEntity *entity;

@end