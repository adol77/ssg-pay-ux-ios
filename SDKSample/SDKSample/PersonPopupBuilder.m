//
//  PersonPopupBuilder.m
//  SDKSample
//
//  Created by s1-laptop on 2015. 11. 9..
//  Copyright © 2015년 Regina. All rights reserved.
//

#import "PersonPopupBuilder.h"

#import "AppDefine.h"
#import "ColorUtil.h"

@implementation PersonPopupBuilder

- (UIView*)buildPopupBackView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [ColorUtil popupBgColor];
    
    return view;
}

- (UIView*)buildPopupMainView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

- (UIView*)buildPopupDescMainView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

static NSString *noInfoText = @"정보 없음";

- (UILabel*)buildPopupDescNameLabel:(CGRect)frame label:(NSString*)label {
    UILabel *view = [[UILabel alloc] initWithFrame:frame];
    
    view.textColor = [ColorUtil ParkingTxtColor];
    view.font = [UIFont boldSystemFontOfSize:20];
    if (label!=nil && label.length > 0) {
        view.text = label;
    } else {
        view.text = noInfoText;
    }
    
    return view;
}

- (UILabel*)buildPopupDescItemLabel:(CGRect)frame label:(NSString*)label {
    CGFloat descFontSize = 16;
    
    UILabel *view = [[UILabel alloc] initWithFrame:frame];
    view.text = label;
    view.font = [UIFont systemFontOfSize:descFontSize];
    view.textColor = [ColorUtil ParkingTxtColor];
    
    return view;
}


- (UIButton*)buildPopupMapDirectionButton:(CGRect)frame tag:(int)tag {
    UIButton *view = [[UIButton alloc] initWithFrame:frame];
    
    [view setTitle:@"길 안내" forState:UIControlStateNormal];
    
    UIImage *buttonBackImgNor = [UIImage imageNamed:@"popup_nor_btn_bg"];
    UIImage *buttonBackImgPre = [UIImage imageNamed:@"popup_pre_btn_bg"];
    UIImage *buttonBackImgNorStretched = [buttonBackImgNor resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    UIImage *buttonBackImgPreStretched = [buttonBackImgPre resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    
    [view setBackgroundImage:buttonBackImgNorStretched forState:UIControlStateNormal];
    [view setBackgroundImage:buttonBackImgPreStretched forState:UIControlStateSelected];
    
    [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view setTitleColor:[ColorUtil selectionButtonColor] forState:UIControlStateHighlighted];
    
    view.tag = tag;
    
    return view;
}

- (void)buildPopupImageView:(UIImageView*)imageView imageUrl:(NSString*)imageUrl {
    if (imageUrl.length > 0) {
        NSString *composedImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_IP_HEAD, imageUrl];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:composedImageUrl]];
            if (imgData) {
                UIImage *image = [UIImage imageWithData:imgData];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imageView setImage:image];
                    });
                }
            }
        });
    } else {
        UIImage *image = [UIImage imageNamed:@"popup_slab_emblem"];
        [imageView setImage:image];
    }
}

- (UIButton*)buildCloseButton:(CGRect)frame {
    UIButton *view = [[UIButton alloc] initWithFrame:frame];
    
    UIImage *closeButtonImgNor = [UIImage imageNamed:@"campaign_popup_close_nor_btn"];
    UIImage *closeButtonImgPre = [UIImage imageNamed:@"campaign_popup_close_pre_btn"];
    
    [view setImage:closeButtonImgNor forState:UIControlStateNormal];
    [view setImage:closeButtonImgPre forState:UIControlStateSelected];
    
    return view;
}

- (UIButton*)buildTopSeparatorLine:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [ColorUtil mainRedColor];
    
    return view;
}

@end

