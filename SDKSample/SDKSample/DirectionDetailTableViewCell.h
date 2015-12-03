//
//  DirectionDetailTableViewCell.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/19/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DirectionDetailTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier parentFrame:(CGRect)parentFrame;

- (void)updateFloorName:(NSString*)floorName branchName:(NSString*)branchName;
- (void)updateStartIconDesc:(NSString*)desc;
- (void)updateEndIconDesc:(NSString*)desc;
- (void)updateDesc:(NSString*)desc;

@end
