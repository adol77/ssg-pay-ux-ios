//
//  NotiView.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/7/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "NotiView.h"
#import "UIViewController+Utility.h"

@interface NotiView ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation NotiView

#define NOTIVIEW_HEIGHT 64

+ (void)popupNotiViewWithMessage:(NSString *)message {
    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    [NotiView popupNotiViewWithMessage:message height:NOTIVIEW_HEIGHT + statusBarHeight];
}

+ (void)popupNotiViewWithMessage:(NSString *)message height:(CGFloat)height {
    //    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    NotiView *notiView = [[NotiView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height) string:message];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:notiView];
//    [[UIViewController currentViewController].view addSubview:notiView];
    //    [keyWindow.rootViewController.view addSubview:notiView];
}


- (id)initWithFrame:(CGRect)frame string:(NSString*)string {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-frame.size.height, frame.size.width, frame.size.height)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
//        self.layer.borderColor = [UIColor blackColor].CGColor;
//        self.layer.borderWidth = 2.0f;

        int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        // icon
        UIImage *icon = [UIImage imageNamed:@"noti_icon"];
        UIImageView *iconIV = [[UIImageView alloc] initWithImage:icon];
        iconIV.frame = CGRectMake(19, statusBarHeight + (NOTIVIEW_HEIGHT - 30)/2, 30, 30);
        
        [self addSubview:iconIV];
        
        // title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 + 19*2, statusBarHeight + NOTIVIEW_HEIGHT/4,
                                                                        frame.size.width - (30 + 19*2),
                                                                        NOTIVIEW_HEIGHT/4)];
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        titleLabel.text = appName;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLabel];
        
        // desc
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30 + 19*2, statusBarHeight + (NOTIVIEW_HEIGHT - 30)/2 + NOTIVIEW_HEIGHT/4,
                                                                   frame.size.width - (30 + 19*2),
                                                                   NOTIVIEW_HEIGHT/4 + 5)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = string;
        [self addSubview:label];
        
        // close button
        UIImage *closeButtonImgNor = [UIImage imageNamed:@"campaign_popup_close_nor_btn"];
        UIImage *closeButtonImgPre = [UIImage imageNamed:@"campaign_popup_close_pre_btn"];
        
        UIButton *notiCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 61, statusBarHeight + (NOTIVIEW_HEIGHT - 30)/2 - 19,
                                                                                   61, 61)];
        [notiCloseButton setImage:closeButtonImgNor forState:UIControlStateNormal];
        [notiCloseButton setImage:closeButtonImgPre forState:UIControlStateSelected];
        [notiCloseButton setContentMode:UIViewContentModeCenter];
        [notiCloseButton addTarget:self action:@selector(removeAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:notiCloseButton];
        
        // animation
        [UIView animateWithDuration:0.5f animations:^{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.alpha = 1.0f;
        } completion:^(BOOL finished){
        }];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(removeAction) userInfo:nil repeats:NO];
        
    }
    return self;
}

- (void)removeAction {
    [UIView animateWithDuration:0.20f animations:^{self.alpha = 0.3f;} completion:^(BOOL finished){
        if (self.timer != nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
        [self removeFromSuperview];
    }];
}

@end
