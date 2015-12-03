//
//  ColorUtil.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/5/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "ColorUtil.h"

@implementation ColorUtil

+ (UIColor*)mainRedColor {
    return [UIColor colorWithRed:244/255.0f green:71/255.0f blue:55/255.0f alpha:1.0f];
}

+ (UIColor*)popupBgColor {
    return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
}

#pragma mark - Floor Selection

+ (UIColor*)floorLineColor {
    return [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
}

+ (UIColor*)floorLine2Color {
    return [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
}

+ (UIColor*)floorTextColor {
    return [UIColor colorWithRed:63.0f/255.0f green:63.0f/255.0f blue:63.0f/255.0f alpha:1.0f];
}

#pragma mark - Search

+ (UIColor*)searchBgColor {
    return [UIColor colorWithRed:61/255.0f green:61/255.0f blue:61/255.0f alpha:1.0f];
}

+ (UIColor*)searchLineColor {
    return [UIColor colorWithRed:77/255.0f green:77/255.0f blue:77/255.0f alpha:1.0f];
}

+ (UIColor*)searchResultDescColor {
    return [UIColor colorWithRed:176/255.0f green:176/255.0f blue:176/255.0f alpha:1.0f];
}


#pragma mark - Map Direction Detail

+ (UIColor*)mapDetailStartColor {
    return [UIColor colorWithRed:248/255.0f green:234/255.0f blue:156/255.0f alpha:1.0f];
}

+ (UIColor*)mapDetailEndColor {
    return [UIColor colorWithRed:244/255.0f green:71/255.0f blue:55/255.0f alpha:1.0f];
}

+ (UIColor*)mapDetailDescColor {
    return [UIColor whiteColor];
}

+ (UIColor*)mapDetailFloorColor {
    return [UIColor whiteColor];
}

+ (UIColor*)mapDetailBranchColor {
    return [ColorUtil searchResultDescColor];
}


#pragma mark - Selection Button

+ (UIColor*)selectionButtonColor {
    return [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
}


// @SSG

#pragma mark - Parking area txt

+ (UIColor*)ParkingTxtColor {
    return [UIColor colorWithRed:((float)((0X404040 & 0xFF0000) >> 16))/255.0
                           green:((float)((0X404040 & 0xFF00) >> 8))/255.0
                           blue:((float)(0X404040 & 0xFF))/255.0
                           alpha:1.0f];
}

+ (UIColor*)ParkingAreaTxtColor {
    return [UIColor colorWithRed:((float)((0Xf44737 & 0xFF0000) >> 16))/255.0
                           green:((float)((0Xf44737 & 0xFF00) >> 8))/255.0
                            blue:((float)(0Xf44737 & 0xFF))/255.0
                           alpha:1.0f];
}
//

@end
