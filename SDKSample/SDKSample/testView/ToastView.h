//
//  ToastView.h
//  Copyright (c) 2015 Nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastView : UIView

+ (void)popupToastViewWithMessage:(NSString *)message;
+ (void)popupToastViewWithMessage:(NSString *)message height:(CGFloat)height;
- (id)initWithFrame:(CGRect)frame string:(NSString*)string;

@end
