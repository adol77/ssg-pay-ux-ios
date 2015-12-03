//
//  DirectionDetailTableViewCell.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/19/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "DirectionDetailTableViewCell.h"
#import "ColorUtil.h"

@interface DirectionDetailTableViewCell ()

@property (nonatomic, assign) CGRect parentFrame;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGFloat nameLabelWidth;
@property (nonatomic, assign) CGFloat descLeftMargin;
@property (nonatomic, assign) CGFloat descTextLeftMargin;
@property (nonatomic, assign) CGFloat descTextRightMargin;

@end

@implementation DirectionDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier parentFrame:(CGRect)parentFrame {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.parentFrame = parentFrame;
        self.cellHeight = 70;
        self.nameLabelWidth = 120;
        self.descLeftMargin = 20;
        self.descTextLeftMargin = 10;
        self.descTextRightMargin = 20;
        
        // floor
        UILabel *floorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.nameLabelWidth - 15, 30)];
        floorNameLabel.tag = 1;
        floorNameLabel.textColor = [ColorUtil mapDetailFloorColor];
        [floorNameLabel setContentMode:UIViewContentModeCenter];
        floorNameLabel.textAlignment = NSTextAlignmentCenter;
        floorNameLabel.font = [UIFont systemFontOfSize:24];
        [self.contentView addSubview:floorNameLabel];
        
        // branch
        UILabel *branchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, self.nameLabelWidth - 15, 20)];
        branchNameLabel.tag = 2;
        branchNameLabel.textColor = [ColorUtil mapDetailBranchColor];
        [branchNameLabel setContentMode:UIViewContentModeCenter];
        branchNameLabel.textAlignment = NSTextAlignmentCenter;
        branchNameLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:branchNameLabel];
        
        // desc
        UILabel *descLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(self.nameLabelWidth + self.descLeftMargin,
                                         5,
                                         self.parentFrame.size.width - self.nameLabelWidth - self.descLeftMargin - self.descTextRightMargin,
                                         self.cellHeight - 10)];
        descLabel.tag = 3;
        descLabel.textColor = [ColorUtil mapDetailDescColor];
        descLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:descLabel];
        
        // cell color
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [ColorUtil mapDetailDescColor];
    }
    
    return self;
}

- (void)updateFloorName:(NSString*)floorName branchName:(NSString*)branchName {
    UILabel *floorNameLabel = (UILabel*)[self.contentView viewWithTag:1];
    UILabel *branchNameLabel = (UILabel*)[self.contentView viewWithTag:2];

    floorNameLabel.text = floorName;
    branchNameLabel.text = branchName;
}

- (void)updateStartIconDesc:(NSString*)desc {
    UILabel *descLabel = (UILabel*)[self.contentView viewWithTag:3];
    UIImage *mapStartIcon = [UIImage imageNamed:@"map_find_start_icon"];
    descLabel.frame = CGRectMake(self.nameLabelWidth + self.descLeftMargin + mapStartIcon.size.width + self.descTextLeftMargin,
                                 5,
                                 self.parentFrame.size.width - self.nameLabelWidth - self.descLeftMargin - mapStartIcon.size.width - self.descTextRightMargin,
                                 self.cellHeight - 10);
    descLabel.text = desc;
    descLabel.textColor = [ColorUtil mapDetailStartColor];

    // update start icon
    [self hideMapIcon:self.contentView];
    [self showMapStartIcon:self.contentView rightView:descLabel];
}

- (void)updateEndIconDesc:(NSString*)desc {
    UILabel *descLabel = (UILabel*)[self.contentView viewWithTag:3];
    UIImage *mapEndIcon = [UIImage imageNamed:@"map_find_end_icon"];
    descLabel.frame = CGRectMake(self.nameLabelWidth + self.descLeftMargin + mapEndIcon.size.width + self.descTextLeftMargin,
                                 5,
                                 self.parentFrame.size.width - self.nameLabelWidth - self.descLeftMargin - mapEndIcon.size.width - self.descTextRightMargin,
                                 self.cellHeight - 10);
    descLabel.text = desc;
    descLabel.textColor = [ColorUtil mapDetailEndColor];
    
    // update end icon
    [self hideMapIcon:self.contentView];
    [self showMapEndIcon:self.contentView rightView:descLabel];
}

- (void)updateDesc:(NSString*)desc {
    [self hideMapIcon:self.contentView];
    
    UILabel *descLabel = (UILabel*)[self.contentView viewWithTag:3];
    descLabel.frame = CGRectMake(self.nameLabelWidth + self.descLeftMargin,
                                 5,
                                 self.parentFrame.size.width - self.nameLabelWidth - self.descLeftMargin - self.descTextRightMargin,
                                 self.cellHeight - 10);
    descLabel.text = desc;
    descLabel.textColor = [ColorUtil mapDetailDescColor];
}

- (void)updateDescColor:(UIColor*)descColor {
    UILabel *descLabel = (UILabel*)[self.contentView viewWithTag:3];
    descLabel.textColor = descColor;
}

- (void)showMapStartIcon:(UIView*)contentView rightView:(UIView*)rightView {
    UIImageView *mapStartIconIV = (UIImageView*)[contentView viewWithTag:4];
    if (mapStartIconIV==nil) {
        UIImage *mapStartIcon = [UIImage imageNamed:@"map_find_start_icon"];
        mapStartIconIV = [[UIImageView alloc] initWithImage:mapStartIcon];
        mapStartIconIV.tag = 4;
        [mapStartIconIV setContentMode:UIViewContentModeCenter];
        mapStartIconIV.frame = CGRectMake(self.nameLabelWidth + self.descLeftMargin,
                                          (self.cellHeight - mapStartIcon.size.height)/2,
                                          mapStartIcon.size.width,
                                          mapStartIcon.size.height);
        [contentView addSubview:mapStartIconIV];
    } else {
        
    }
}

- (void)showMapEndIcon:(UIView*)contentView rightView:(UIView*)rightView {
    UIImageView *mapEndIconIV = (UIImageView*)[contentView viewWithTag:5];
    if (mapEndIconIV==nil) {
        UIImage *mapEndIcon = [UIImage imageNamed:@"map_find_end_icon"];
        mapEndIconIV = [[UIImageView alloc] initWithImage:mapEndIcon];
        mapEndIconIV.tag = 5;
        mapEndIconIV.frame = CGRectMake(self.nameLabelWidth + self.descLeftMargin,
                                        (self.cellHeight - mapEndIcon.size.height)/2,
                                        mapEndIcon.size.width,
                                        mapEndIcon.size.height);
        [contentView addSubview:mapEndIconIV];
    } else {
        
    }
}

- (void)hideMapIcon:(UIView*)contentView {
    UIImageView *mapStartIconIV = (UIImageView*)[contentView viewWithTag:4];
    if (mapStartIconIV!=nil) {
        [mapStartIconIV removeFromSuperview];
    }
    
    UIImageView *mapEndIconIV = (UIImageView*)[contentView viewWithTag:5];
    if (mapEndIconIV!=nil) {
        [mapEndIconIV removeFromSuperview];
    }
}

@end
