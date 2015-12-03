//
//  ToastView.m
//  Copyright (c) 2015 Nemustech. All rights reserved.
//

#import "ToastView.h"
#import "UIViewController+Utility.h"

@interface ToastView ()
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ToastView

+ (void)popupToastViewWithMessage:(NSString *)message {
    [ToastView popupToastViewWithMessage:message height:64];
}

+ (void)popupToastViewWithMessage:(NSString *)message height:(CGFloat)height {
//    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    ToastView *toastView = [[ToastView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height) string:message];
    [[UIViewController currentViewController].view addSubview:toastView];
//    [keyWindow.rootViewController.view addSubview:toastView];
}


- (id)initWithFrame:(CGRect)frame string:(NSString*)string {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-frame.size.height, frame.size.width, frame.size.height)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        self.alpha = 0.3f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, self.frame.size.height)];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.text = string;
        [self addSubview:label];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
