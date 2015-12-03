//
//  NSString+ExtendedStringDrawFont.m
//  tuiliseApp
//
//  Created by Lee muhyeon on 2015. 10. 20..
//  Copyright (c) 2015년 com.lmh. All rights reserved.
//

#import "NSString+ExtendedStringDrawFont.h"

@implementation NSString (ExtendedStringDrawFont)

- (UIFont *)fontForSize:(CGSize)size fontSize:(CGFloat)fontSize minimumFontSize:(CGFloat)minimumFontSize bold:(BOOL)bold {
    fontSize++;
    minimumFontSize = nearbyintl(minimumFontSize);
    UIFont *font = nil;
    CGFloat heightWithFont = 0;
    CGFloat longestWordWidth = 0;
    do {
        if (fontSize < minimumFontSize) {
            break;
        }
        if (bold) {
            font = [UIFont boldSystemFontOfSize:fontSize--];
        } else {
            font = [UIFont systemFontOfSize:fontSize--];
        }
        CGSize boundingSize = [self boundingSizeWithfont:font inSize:size];
        heightWithFont = boundingSize.height;
        
        // Be sure that words are not truncated (that they fits in the maximum width)
        longestWordWidth = 0;
        for (NSString *word in [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
            CGSize wordSize = [word sizeWithAttributes:@{NSFontAttributeName:font}];
            longestWordWidth = MAX(longestWordWidth, wordSize.width);
        }
        
        // Loop until the text at the current size fits the maximum width/height.
    } while (heightWithFont > size.width || longestWordWidth > size.width);

    return font;
}

- (UIFont *)fontForSize:(CGSize)size fontSize:(CGFloat)fontSize minimumFontSize:(CGFloat)minimumFontSize {
    fontSize++;
    minimumFontSize = nearbyintl(minimumFontSize);
    UIFont *font = nil;
    CGFloat heightWithFont = 0;
    CGFloat longestWordWidth = 0;
    do {
        if (fontSize < minimumFontSize) {
            break;
        }
        font = [UIFont systemFontOfSize:fontSize--];
        CGSize boundingSize = [self boundingSizeWithfont:font inSize:size];
        heightWithFont = boundingSize.height;
        longestWordWidth = boundingSize.width;
        
    } while (heightWithFont > size.height || longestWordWidth > size.width);
    
    return font;
}

- (CGSize)boundingSizeWithfont:(UIFont *)font inSize:(CGSize)size {
    CGRect boundingRect = [self boundingRectWithSize:CGSizeMake(size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: font} context:nil];
    return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
}

@end
