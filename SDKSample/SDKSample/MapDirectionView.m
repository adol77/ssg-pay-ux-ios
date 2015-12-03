//
//  MapDirectionView.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/15/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "MapDirectionView.h"
#import "ColorUtil.h"

@interface MapDirectionView ()

@property (nonatomic, strong) UIView *mapDirectionMainView;
@property (nonatomic, strong) UILabel *startTitleLabel;
@property (nonatomic, strong) UILabel *endTitleLabel;

@end

@implementation MapDirectionView

- (instancetype)initWithFrame:(CGRect)frame {
    UIImage *closeButtonImgNor = [UIImage imageNamed:@"map_find_close_nor_btn"];
    UIImage *closeButtonImgPre = [UIImage imageNamed:@"map_find_close_pre_btn"];
    
    CGFloat buttonHeight = closeButtonImgNor.size.height;
    CGFloat buttonWidth = (frame.size.width - (9*2) - 6) / 2;
    
    CGRect viewFrame = CGRectMake(0,
                                  frame.size.height - (buttonHeight + 9),
                                  frame.size.width,
                                  (buttonHeight + 9));
    self = [super initWithFrame:viewFrame];
    
    if (self) {
        self.mapDirectionMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        // direction close
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(9, 0, buttonWidth, buttonHeight)];
        
        UIImage *closeButtonBackImgNor = [UIImage imageNamed:@"map_find_bg_nor_btn"];
        UIImage *closeButtonBackImgPre = [UIImage imageNamed:@"map_find_bg_pre_btn"];
        UIImage *closeButtonBackImgNorStretched = [closeButtonBackImgNor resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        UIImage *closeButtonBackImgPreStretched = [closeButtonBackImgPre resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        
        [closeButton setBackgroundImage:closeButtonBackImgNorStretched forState:UIControlStateNormal];
        [closeButton setBackgroundImage:closeButtonBackImgPreStretched forState:UIControlStateSelected];
        [closeButton setImage:closeButtonImgNor forState:UIControlStateNormal];
        [closeButton setImage:closeButtonImgPre forState:UIControlStateSelected];
        
        closeButton.frame = CGRectMake(9, 0, buttonWidth, buttonHeight);
        
        closeButton.contentMode = UIViewContentModeCenter;
        [closeButton addTarget:self action:@selector(mapDirectionExitClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mapDirectionMainView addSubview:closeButton];
        
        // view in details
        UIImage *detailButtonImgNor = [UIImage imageNamed:@"map_find_detail_nor_btn"];
        UIImage *detailButtonImgPre = [UIImage imageNamed:@"map_find_detail_pre_btn"];
        
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width/2 + 3, 0, buttonWidth, buttonHeight)];

        UIImage *detailButtonBackImgNor = [UIImage imageNamed:@"map_find_bg_nor_btn"];
        UIImage *detailButtonBackImgPre = [UIImage imageNamed:@"map_find_bg_pre_btn"];
        UIImage *detailButtonBackImgNorStretched = [detailButtonBackImgNor resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        UIImage *detailButtonBackImgPreStretched = [detailButtonBackImgPre resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        
        [detailButton setBackgroundImage:detailButtonBackImgNorStretched forState:UIControlStateNormal];
        [detailButton setBackgroundImage:detailButtonBackImgPreStretched forState:UIControlStateSelected];
        [detailButton setImage:detailButtonImgNor forState:UIControlStateNormal];
        [detailButton setImage:detailButtonImgPre forState:UIControlStateSelected];
        detailButton.contentMode = UIViewContentModeCenter;
        [detailButton addTarget:self action:@selector(mapDirectionDetailClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.mapDirectionMainView addSubview:detailButton];
        
        [self addSubview:self.mapDirectionMainView];
    }
    
    return self;
}

- (void)mapDirectionExitClicked {
    [self showTwoButtonAlertPopupWithTitle:@"길 안내를 종료 하시겠습니까?"];
}

- (void)mapDirectionDetailClicked {
    [self.mapDirectionButtonDelegate selectedDirectionDetailShow];
}

- (void)showTwoButtonAlertPopupWithTitle:(NSString*)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"종료", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"종료"]) {
        [self.mapDirectionButtonDelegate selectedMapDirectionExit];
    } else if ([title isEqualToString:@"취소"]) {
        
    }
}


@end
