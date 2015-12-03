//
//  NotiView.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/7/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotiView : UIView

+ (void)popupNotiViewWithMessage:(NSString *)message;
+ (void)popupNotiViewWithMessage:(NSString *)message height:(CGFloat)height;
- (id)initWithFrame:(CGRect)frame string:(NSString*)string;

@end
