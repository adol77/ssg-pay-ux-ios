//
//  SLBSGroupLogViewController.h
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 15..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBSLogEntity.h"

@interface SLBSGroupLogViewController : UIViewController

@end

@interface SLBSLogCell : UITableViewCell

@property (nonatomic, weak) SLBSLogEntity *entity;

@end