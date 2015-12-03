//
//  StorePopupBuilder.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/14/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StorePopupBuilder : NSObject

- (UIView*)buildPopupBackView:(CGRect)frame;
- (UIView*)buildPopupMainView:(CGRect)frame;
- (UIView*)buildPopupDescMainView:(CGRect)frame;

- (UILabel*)buildPopupDescTitleLabel:(CGRect)frame label:(NSString*)label;
- (UILabel*)buildPopupDescItemTitleLabel:(CGRect)frame label:(NSString*)label;
- (UILabel*)buildPopupDescItemValueLabelLine1:(CGRect)frame label:(NSString*)label;
- (UILabel*)buildPopupDescItemValueLabelLine2:(CGRect)frame label:(NSString*)label;

- (UIButton*)buildPopupMapDirectionButton:(CGRect)frame tag:(int)tag;
- (void)buildPopupImageView:(UIImageView*)imageView imageUrl:(NSString*)imageUrl;
- (UIButton*)buildCloseButton:(CGRect)frame;

@end
