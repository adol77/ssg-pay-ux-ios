//
//  PersonPopupBuilder.h
//  SDKSample
//
//  Created by s1-laptop on 2015. 11. 9..
//  Copyright © 2015년 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonPopupBuilder : NSObject

- (UIView*)buildPopupBackView:(CGRect)frame;
- (UIView*)buildPopupMainView:(CGRect)frame;
- (UIView*)buildPopupDescMainView:(CGRect)frame;

- (UILabel*)buildPopupDescNameLabel:(CGRect)frame label:(NSString*)label;
- (UILabel*)buildPopupDescItemLabel:(CGRect)frame label:(NSString*)label;

- (UIButton*)buildPopupMapDirectionButton:(CGRect)frame tag:(int)tag;
- (void)buildPopupImageView:(UIImageView*)imageView imageUrl:(NSString*)imageUrl;
- (UIButton*)buildCloseButton:(CGRect)frame;
- (UIButton*)buildTopSeparatorLine:(CGRect)frame;

@end