//
//  CampaignInboxTableViewCell.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/28/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "CampaignInboxTableViewCell.h"

@interface CampaignInboxTableViewCell ()

@property (nonatomic, strong) UIButton *moveToLocButton;
@property (nonatomic, strong) UIImageView *iconSeparatorIV;
@property (nonatomic, strong) UIButton *selectToArrivalButton;

@end

@implementation CampaignInboxTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        const CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
        const CGFloat iconWidth = 40;
        const CGFloat separatorWidth = 10;
        const CGFloat cellHeight = 70;

        
        UIImage *iconSepImg = [UIImage imageNamed:@"gray_line"];
        
        // moveToLocButton
        UIImage *moveToLocButtonImgNor = [UIImage imageNamed:@"search_position_nor_btn"];
        UIImage *moveToLocButtonImgPre = [UIImage imageNamed:@"search_position_pre_btn"];
        
        self.moveToLocButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth - (iconWidth*2) - separatorWidth,
                                                                               0,
                                                                               iconWidth,
                                                                               cellHeight)];
        self.moveToLocButton.contentMode = UIViewContentModeCenter;
        [self.moveToLocButton setImage:moveToLocButtonImgNor forState:UIControlStateNormal];
        [self.moveToLocButton setImage:moveToLocButtonImgPre forState:UIControlStateSelected];
        
        [self.moveToLocButton addTarget:self action:@selector(moveToLocButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.moveToLocButton setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.moveToLocButton];
        
        self.iconSeparatorIV = [[UIImageView alloc]
                                        initWithFrame:CGRectMake(kWidth - iconWidth - separatorWidth,
                                                                 (cellHeight - iconSepImg.size.height)/2,
                                                                 separatorWidth, iconSepImg.size.height)];
        [self.iconSeparatorIV setImage:iconSepImg];
        self.iconSeparatorIV.contentMode = UIViewContentModeCenter;
        
        [self.contentView addSubview:self.iconSeparatorIV];
        
        // selectToArrivalButton
        UIImage *selectToArrivalButtonImgNor = [UIImage imageNamed:@"search_find_nor_btn"];
        UIImage *selectToArrivalButtonImgPre = [UIImage imageNamed:@"search_find_pre_btn"];
        
        self.selectToArrivalButton = [[UIButton alloc] initWithFrame:CGRectMake(kWidth - iconWidth,
                                                                                     0,
                                                                                     iconWidth,
                                                                                     cellHeight)];
        self.selectToArrivalButton.contentMode = UIViewContentModeCenter;
        [self.selectToArrivalButton setImage:selectToArrivalButtonImgNor forState:UIControlStateNormal];
        [self.selectToArrivalButton setImage:selectToArrivalButtonImgPre forState:UIControlStateSelected];
        
        [self.selectToArrivalButton addTarget:self action:@selector(selectToArrivalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectToArrivalButton setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.selectToArrivalButton];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:20];
    }
    
    return self;
}

- (void)updateTitle:(NSString*)title {
    self.textLabel.text = title;
}

- (void)updateAllIconDisplay:(BOOL)showIcon {
    [self updateMoveToIconDisplay:showIcon];
    [self updateDirectToIconDisplay:showIcon];
    [self updateSeparatorIconDisplay:showIcon];
}

- (void)updateMoveToIconDisplay:(BOOL)showIcon {
    self.moveToLocButton.hidden = showIcon;
}

- (void)updateDirectToIconDisplay:(BOOL)showIcon {
    self.selectToArrivalButton.hidden = showIcon;
}

- (void)updateSeparatorIconDisplay:(BOOL)showIcon {
    self.iconSeparatorIV.hidden = showIcon;
}

- (void)moveToLocButtonClicked:(id)sender {
    [self.storeCommandDelegate moveToStoreFromCell:[self.arrayIndex intValue]];
}

- (void)selectToArrivalButtonClicked:(id)sender {
    [self.storeCommandDelegate directToStoreFromCell:[self.arrayIndex intValue]];
}

@end
