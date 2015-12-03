//
//  NSString+ExtendedStringDrawFont.h
//  tuiliseApp
//
//  Created by Lee muhyeon on 2015. 10. 20..
//  Copyright (c) 2015년 com.lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (ExtendedStringDrawFont)

- (UIFont *)fontForSize:(CGSize)size fontSize:(CGFloat)fontSize minimumFontSize:(CGFloat)minimumFontSize bold:(BOOL)bold;


- (UIFont *)fontForSize:(CGSize)size fontSize:(CGFloat)fontSize minimumFontSize:(CGFloat)minimumFontSize;

@end
