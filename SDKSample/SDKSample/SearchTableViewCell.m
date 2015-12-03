//
//  SearchTableViewCell.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/7/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "ColorUtil.h"

@interface SearchTableViewCell ()

@property (nonatomic, strong) UILabel *searchNameLabel;
@property (nonatomic, strong) UILabel *searchNameDescLabel;
@property (nonatomic, strong) UIImageView *campaignIconIV;
@property (nonatomic, strong) UIButton *moveToLocButton;
@property (nonatomic, strong) UIButton *selectToArrivalButton;
@property (nonatomic, strong) UIImageView *iconSeparatorIV;

@property (nonatomic, assign) CGFloat iconAreaWidth;

@end

@implementation SearchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        const CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
        self.iconAreaWidth = 160;
        
        // search name
        self.searchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10,
                                                                         kWidth - self.iconAreaWidth, 40)];
        self.searchNameLabel.textColor = [UIColor whiteColor];
        self.searchNameLabel.font = [UIFont systemFontOfSize:20];
//        self.searchNameLabel.backgroundColor = [UIColor greenColor];
        
        [self.contentView addSubview:self.searchNameLabel];
        
        // search name desc
        self.searchNameDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40,
                                                                             kWidth, 20)];
        self.searchNameDescLabel.textColor = [ColorUtil searchResultDescColor];
        self.searchNameDescLabel.font = [UIFont systemFontOfSize:12];
//        self.searchNameDescLabel.backgroundColor = [UIColor magentaColor];
        [self.contentView addSubview:self.searchNameDescLabel];
        
        // campaign icon
        CGFloat iconWidth = 40;
        CGFloat cellHeight = 70;
        CGFloat separatorWidth = 10;
        
        UIImage *campaignIcon = [UIImage imageNamed:@"search_campaign_icon"];
        self.campaignIconIV = [[UIImageView alloc] initWithImage:campaignIcon];

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
        
        // icon separator label
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
        
//        NSLog(@"selectToArrivalButton rect=%@", NSStringFromCGRect(self.selectToArrivalButton.frame));
        
        self.selectToArrivalButton.contentMode = UIViewContentModeCenter;
        [self.selectToArrivalButton setImage:selectToArrivalButtonImgNor forState:UIControlStateNormal];
        [self.selectToArrivalButton setImage:selectToArrivalButtonImgPre forState:UIControlStateSelected];
        
        [self.selectToArrivalButton addTarget:self action:@selector(selectToArrivalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectToArrivalButton setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.selectToArrivalButton];

        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    const CGFloat kHeight = self.frame.size.height;
    CGFloat newTop;
    CGRect newFrame;
    {
        newTop = roundf((kHeight - self.moveToLocButton.frame.size.height)/2);
        newFrame = CGRectIntegral(self.moveToLocButton.frame);
        newFrame.origin.y = newTop;
        self.moveToLocButton.frame = newFrame;
    }
    {
        newTop = roundf((kHeight - self.selectToArrivalButton.frame.size.height)/2);
        newFrame = CGRectIntegral(self.selectToArrivalButton.frame);
        newFrame.origin.y = newTop;
        self.selectToArrivalButton.frame = newFrame;
    }
}

- (void)updateSearchName:(NSString*)searchName {
    // line break removed
    NSString *removedLineBreakStr = [searchName stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
    removedLineBreakStr = [removedLineBreakStr stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    const CGFloat kWidth = [UIScreen mainScreen].bounds.size.width;
    CGRect nameBounds = [removedLineBreakStr boundingRectWithSize:CGSizeMake(kWidth - self.iconAreaWidth,
                                                                             26)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:self.searchNameLabel.font}
                                                          context:nil];
    nameBounds.origin.x = 15;
    nameBounds.origin.y = 15;
    
    self.searchNameLabel.text = removedLineBreakStr;
    
    self.searchNameLabel.frame = nameBounds;
}

- (void)updateSearchNameDesc:(NSString*)searchNameDesc {
    self.searchNameDescLabel.text = searchNameDesc;
}

- (void)updateCampaignIconWithCount:(int)campaignCount {
    if (campaignCount > 0) {
        UIImage *campaignIcon = [UIImage imageNamed:@"search_campaign_icon"];
        self.campaignIconIV.frame = CGRectMake(self.searchNameLabel.frame.origin.x + self.searchNameLabel.frame.size.width + 5,
                                               self.searchNameLabel.frame.origin.y + 2,
                                               campaignIcon.size.width,
                                               campaignIcon.size.height);
        [self.contentView addSubview:self.campaignIconIV];
    } else {
        if ([self.campaignIconIV superview]!=nil) {
            [self.campaignIconIV removeFromSuperview];
        }
    }
}


- (void)moveToLocButtonClicked:(id)sender {
    [self.storeCommandDelegate moveToStoreFromCell:[self.arrayIndex intValue]];
}

- (void)selectToArrivalButtonClicked:(id)sender {
    [self.storeCommandDelegate directToStoreFromCell:[self.arrayIndex intValue]];
}

@end
