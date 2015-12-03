//
//  SLBSMapViewCommon.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 10. 15..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAP_ANIMATION_DURATION_SHORT        0.1
#define MAP_ANIMATION_DURATION_MIDDLE       0.3
#define MAP_ANIMATION_DURATION_HARFLONG     0.5
#define MAP_ANIMATION_DURATION_LONG         1.0

#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]

struct SLBSTransform3Ds {
    CATransform3D rotateXaxis;
    CATransform3D rotateZaxis;
    CATransform3D translation;
    CATransform3D scale;
};
typedef struct SLBSTransform3Ds SLBSTransform3Ds;

CG_INLINE CGPoint
CGPointNearbyintForRetina(CGPoint origin)
{
    CGPoint p; p.x = nearbyintl(origin.x/2); p.y = nearbyintl(origin.y/2); return p;
}

CG_INLINE CGPoint
CGPointIntegral(CGPoint origin)
{
    CGPoint p; p.x = roundf(origin.x); p.y = roundf(origin.y); return p;
}

CG_INLINE CGRect
CGRectNearbyintForRetina(CGRect origin)
{
    CGRect rect;
    rect.origin.x = nearbyintl(origin.origin.x/2.0f);
    rect.origin.y = nearbyintl(origin.origin.y/2.0f);
    rect.size.width = nearbyintl(origin.size.width/2.0f);
    rect.size.height = nearbyintl(origin.size.height/2.0f);
    return rect;
}

CGFloat distanceBetweenTwoPoint(CGPoint point1, CGPoint point2);

@interface SLBSMapViewCommon : NSObject

@end

///////////////
//#define MAP_LOG_ENALBED

#ifdef MAP_LOG_ENALBED
#warning    MAP_LOG_ENALBED(Mode ON)

#define CJK_MAPLOG_ENABLE 0
static inline NSString* NStringForMapCJKFromUTF8(NSString *str) {
#if CJK_MAPLOG_ENABLE
#warning    2Byte Unicode Debug Log Enabled
    NSString* strT= [str stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)strT, NULL, transform, YES);
    
    return strT;
#else
    return str;
#endif
}

#if CJK_MAPLOG_ENABLE
#define MapLog(s, ...)	\
NSLog(@"\n(MAPVIEW)%s {\n\t%@\n}\n", __PRETTY_FUNCTION__, NStringForMapCJKFromUTF8([NSString stringWithFormat:(s), ##__VA_ARGS__]));
#else
#define MapLog(s, ...)	\
NSLog(@"\n(MAPVIEW)%s {\n\t%@\n}\n", __PRETTY_FUNCTION__, [NSString stringWithFormat:(s), ##__VA_ARGS__]);
#endif

#else
#define MapLog( s, ... ) {}
#endif

#define resultstr(success)  success?@"success":@"fail"
#define boolstr(boolValue)  boolValue?@"YES":@"NO"
////////////////////////
