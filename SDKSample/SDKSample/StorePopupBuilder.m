//
//  StorePopupBuilder.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/14/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "StorePopupBuilder.h"

#import "AppDefine.h"
#import "ColorUtil.h"

@implementation StorePopupBuilder

- (UIView*)buildPopupBackView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [ColorUtil popupBgColor];
    
    return view;
}

- (UIView*)buildPopupMainView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [ColorUtil mainRedColor];
    
    return view;
}

- (UIView*)buildPopupDescMainView:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}

static NSString *noInfoText = @"정보 없음";
- (UILabel*)buildPopupDescTitleLabel:(CGRect)frame label:(NSString*)label {
    UILabel *view = [[UILabel alloc] initWithFrame:frame];

    view.textColor = [ColorUtil mainRedColor];
    view.font = [UIFont boldSystemFontOfSize:20];
    if (label!=nil && label.length > 0) {
        view.text = label;
    } else {
        view.text = noInfoText;
    }
    
    return view;
}

- (UILabel*)buildPopupDescItemTitleLabel:(CGRect)frame label:(NSString*)label {
    CGFloat descFontSize = 16;
    
    UILabel *view = [[UILabel alloc] initWithFrame:frame];
    view.text = label;
    view.font = [UIFont systemFontOfSize:descFontSize];
    view.textColor = [ColorUtil mainRedColor];

    return view;
}

- (UILabel*)buildPopupDescItemValueLabelLine1:(CGRect)frame label:(NSString*)label {
    CGFloat descFontSize = 16;
    
    UILabel *view = [[UILabel alloc] initWithFrame:frame];
    
    if (label!=nil && label.length > 0) {
        view.text = label;
    } else {
        view.text = noInfoText;
    }
    view.font = [UIFont systemFontOfSize:descFontSize];
    view.textColor = [UIColor blackColor];
    
    return view;
}

- (UILabel*)buildPopupDescItemValueLabelLine2:(CGRect)frame label:(NSString*)label {
    CGFloat descFontSize = 16;
    
    UILabel *view = [[UILabel alloc] initWithFrame:frame];
    
    NSString *title = nil;
    
    if (label!=nil && label.length > 0) {
        title = label;
    } else {
        title = noInfoText;
    }
    
    view.font = [UIFont systemFontOfSize:descFontSize];
    view.textColor = [UIColor blackColor];
    view.numberOfLines = 2;
    view.contentMode = UIViewContentModeTop;
    view.lineBreakMode = NSLineBreakByWordWrapping;
    view.text = title;

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
        UIImage *image = [UIImage imageNamed:@"store_no_image"];
        [imageView setImage:image];
    }
}

- (UIButton*)buildCloseButton:(CGRect)frame {
    UIButton *view = [[UIButton alloc] initWithFrame:frame];
    
    UIImage *closeButtonImgNor = [UIImage imageNamed:@"popup_close_nor_btn"];
    UIImage *closeButtonImgPre = [UIImage imageNamed:@"popup_close_pre_btn"];
    
    [view setImage:closeButtonImgNor forState:UIControlStateNormal];
    [view setImage:closeButtonImgPre forState:UIControlStateSelected];
    
    return view;
}


@end
