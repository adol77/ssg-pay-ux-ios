//
//  StorePopupView.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/15/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "AppDefine.h"
#import "StorePopupView.h"
#import "StorePopupBuilder.h"
#import "PersonPopupBuilder.h"
#import <SLBSSDK/SLBSFloor.h>
#import <SLBSSDK/SLBSCompany.h>

@interface StorePopupView ()

@property (nonatomic, strong) MapInfoProvider *mapInfoProvider;
@property (nonatomic, strong) UIView *storePopupBackView;

@end

@implementation StorePopupView

- (instancetype)initWithFrame:(CGRect)frame zone:(Zone*)zone floor:(SLBSFloor*)floor {
    self = [super initWithFrame:frame];
    if (self) {
        if ([zone.store_company_id intValue] == SHINSEGAE_INC)
            [self drawPersonPopup:frame zone:zone floor:floor];
        else
            [self drawStorePopup:frame zone:zone floor:floor];
    }
    
    return self;
}

- (void) drawStorePopup:(CGRect)frame zone:(Zone*)zone floor:(SLBSFloor*)floor {
    StorePopupBuilder *popupBuilder = [[StorePopupBuilder alloc] init];
    CGFloat popupWidth = 282;
    CGFloat popupHeight = 393;
    
    // back view
    self.storePopupBackView = [popupBuilder buildPopupBackView:frame];
    
    // main view
    UIView *storePopupMainView = [popupBuilder buildPopupMainView:CGRectMake((frame.size.width - popupWidth)/2,
                                                                             (frame.size.height - popupHeight)/2,
                                                                             popupWidth, popupHeight)];
    [self.storePopupBackView addSubview:storePopupMainView];
    
    // description area
    CGFloat leftMargin = 15;
    CGFloat fieldTitleWidth = 80;
    CGFloat fieldHeight = 25;
    
    // description view of main view
    UIView *descMainView = [popupBuilder buildPopupDescMainView:CGRectMake(0, 188, popupWidth, 161)];
    [storePopupMainView addSubview:descMainView];
    
    // title view in description view
    // zone.name을 임시로 사용. 원래는 tenant_name이 맞음
    UILabel *storeTitleLabel = [popupBuilder buildPopupDescTitleLabel:CGRectMake(leftMargin, 10, popupWidth, 40)
                                                                label:zone.name];
    //        UILabel *storeTitleLabel = [popupBuilder buildPopupDescTitleLabel:CGRectMake(leftMargin, 10, popupWidth, 40)
    //                                                                    label:zone.tenant_name];
    [descMainView addSubview:storeTitleLabel];
    
    // store location
    UILabel *storeLocationLabel = [popupBuilder
                                   buildPopupDescItemTitleLabel:CGRectMake(leftMargin,
                                                                           storeTitleLabel.frame.origin.y + storeTitleLabel.frame.size.height,
                                                                           fieldTitleWidth, fieldHeight)
                                   label:@"매장위치"];
    [descMainView addSubview:storeLocationLabel];
    
    // store location value
    //    Floor *floor = [self.mapInfoProvider getFloorByMapId:[zone.map_id intValue]];
    UILabel *storeLocationValueLabel = [popupBuilder
                                        buildPopupDescItemValueLabelLine1:CGRectMake(fieldTitleWidth,
                                                                                     storeTitleLabel.frame.origin.y + storeTitleLabel.frame.size.height,
                                                                                     popupWidth - fieldTitleWidth,
                                                                                     fieldHeight)
                                        label:floor.name];
    [descMainView addSubview:storeLocationValueLabel];
    
    // store tel
    UILabel *storeTelLabel = [popupBuilder
                              buildPopupDescItemTitleLabel:CGRectMake(leftMargin,
                                                                      storeLocationLabel.frame.origin.y + storeLocationLabel.frame.size.height,
                                                                      fieldTitleWidth, fieldHeight)
                              label:@"전화번호"];
    [descMainView addSubview:storeTelLabel];
    
    // store tel value
    UILabel *storeTelValueLabel = [popupBuilder
                                   buildPopupDescItemValueLabelLine1:CGRectMake(fieldTitleWidth,
                                                                                storeLocationLabel.frame.origin.y + storeLocationLabel.frame.size.height,
                                                                                popupWidth - fieldTitleWidth, fieldHeight)
                                   label:zone.tenant_phone_num];
    [descMainView addSubview:storeTelValueLabel];
    
    // store desc
    UILabel *storeDescLabel = [popupBuilder
                               buildPopupDescItemTitleLabel:CGRectMake(leftMargin, storeTelLabel.frame.origin.y + storeTelLabel.frame.size.height,
                                                                       fieldTitleWidth, fieldHeight)
                               label:@"상세정보"];
    [descMainView addSubview:storeDescLabel];
    
    // store desc value
    NSString *descValue = zone.tenant_description;
    //        descValue = @"가나다라마바";
    //        descValue = @"가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사가나다라마바사";
    UILabel *storeDescValueLabel = [popupBuilder
                                    buildPopupDescItemValueLabelLine2:CGRectMake(fieldTitleWidth,
                                                                                 storeTelLabel.frame.origin.y + storeTelLabel.frame.size.height,
                                                                                 popupWidth - fieldTitleWidth - 20,
                                                                                 22*2)
                                    label:descValue];
    CGRect storeDescBounds = [descValue boundingRectWithSize:CGSizeMake(popupWidth - fieldTitleWidth - 20, fieldHeight*2)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:storeDescValueLabel.font}
                                                     context:nil];
    
    if (storeDescBounds.size.width <= storeDescValueLabel.frame.size.width) {
        storeDescValueLabel.text = [NSString stringWithFormat:@"%@\n", descValue];
    }
    [descMainView addSubview:storeDescValueLabel];
    
    // 길 안내 button
    self.storeDirectButton = [popupBuilder buildPopupMapDirectionButton:CGRectMake(0, popupHeight - 44, popupWidth, 44)
                                                                    tag:[zone.zone_id intValue]];
    [storePopupMainView addSubview:self.storeDirectButton];
    
    // store image
    UIImageView *storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, popupWidth, 184)];
    [popupBuilder buildPopupImageView:storeImageView imageUrl:zone.tenant_image];
    [storePopupMainView addSubview:storeImageView];
    

    
    [self addSubview:self.storePopupBackView];
}


// @SSG

- (void) drawPersonPopup:(CGRect)frame zone:(Zone*)zone floor:(SLBSFloor*)floor {
 
    PersonPopupBuilder *popupBuilder = [[PersonPopupBuilder alloc] init];
    CGFloat popupWidth = 282;
    CGFloat popupHeight = 370;
    
    // back view
    self.storePopupBackView = [popupBuilder buildPopupBackView:frame];
    
    // main view
    UIView *storePopupMainView = [popupBuilder buildPopupMainView:CGRectMake((frame.size.width - popupWidth)/2,
                                                                             (frame.size.height - popupHeight)/2,
                                                                             popupWidth, popupHeight)];
    
    
    [self.storePopupBackView addSubview:storePopupMainView];

    
    // 길 안내 button
    self.storeDirectButton = [popupBuilder buildPopupMapDirectionButton:CGRectMake(0, popupHeight - 44, popupWidth, 44)
                                                                    tag:[zone.zone_id intValue]];
    [storePopupMainView addSubview:self.storeDirectButton];
    
    // store image
    UIImageView *storeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(107, 126, 175, 200)];
    [popupBuilder buildPopupImageView:storeImageView imageUrl:zone.tenant_image];
    [storePopupMainView addSubview:storeImageView];
    
    // close button
    self.storeCloseButton = [popupBuilder buildCloseButton:CGRectMake(popupWidth - 57, 0, 57, 57)];
    [storePopupMainView addSubview:self.storeCloseButton];
    
    // Top Separator line
    UIView *topSepView = [popupBuilder buildTopSeparatorLine:CGRectMake(0, 0, popupWidth, 4)];
    [storePopupMainView addSubview:topSepView];
    
    // description area
    CGFloat leftMargin = 15;
    CGFloat fieldTitleWidth = popupWidth / 2;
    CGFloat fieldHeight = 25;
    
    
    NSString* phoneNumber = @"No phone";
    NSString* mobileNumber = @"No mobile";
    
    NSArray* numbers = [zone.tenant_phone_num componentsSeparatedByString:@","];
    if (numbers != nil && [numbers count] >= 1) {
        if (numbers[0] != nil) {
            phoneNumber = [numbers[0] description];
        }
        if ([numbers count] >= 2 && numbers[1] != nil) {
            mobileNumber = [numbers[1] description];
        }
    }
    
    // Name
    UILabel *personNameLabel = [popupBuilder buildPopupDescNameLabel:CGRectMake(leftMargin, 30, popupWidth , fieldHeight)
                                                                label:zone.tenant_name];
    
    [storePopupMainView addSubview:personNameLabel];
    
    
    // Department
    UILabel *peronDepLabel = [popupBuilder buildPopupDescItemLabel:CGRectMake(leftMargin,
                                                                            personNameLabel.frame.origin.y + personNameLabel.frame.size.height,
                                                                            popupWidth, fieldHeight)
                                                              label:zone.tenant_description];
    [storePopupMainView addSubview:peronDepLabel];
    
    // Phone
    UILabel *personPhoneLabel = [popupBuilder buildPopupDescItemLabel:CGRectMake(leftMargin,
                                                                            peronDepLabel.frame.origin.y + peronDepLabel.frame.size.height,
                                                                            fieldTitleWidth, fieldHeight)
                                                                label:phoneNumber];
    [storePopupMainView addSubview:personPhoneLabel];
    
    // Mobile
    UILabel *personMobileLabel = [popupBuilder buildPopupDescItemLabel:CGRectMake(leftMargin,
                                                                                 personPhoneLabel.frame.origin.y + personPhoneLabel.frame.size.height,
                                                                                 fieldTitleWidth, fieldHeight)
                                                                label:mobileNumber];
    [storePopupMainView addSubview:personMobileLabel];
    
    [self addSubview:self.storePopupBackView];
    
}


@end
