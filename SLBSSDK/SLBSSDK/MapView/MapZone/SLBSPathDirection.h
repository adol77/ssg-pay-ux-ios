//
//  SLBSPathDirection.h
//  Created by Lee muhyeon on 2015. 10. 30..
//

#import <UIKit/UIKit.h>

/**
 *  Map Direction 정보
 */
typedef NS_ENUM(NSInteger, SLBSMapDirection) {
    /**
     *  Unknown
     */
    SLBSMapDirectionUnknown = 0,
    /**
     *  East
     */
    SLBSMapDirectionEast = 1,
    /**
     *  North
     */
    SLBSMapDirectionNorth,
    /**
     *  West
     */
    SLBSMapDirectionWest,
    /**
     *  South
     */
    SLBSMapDirectionSouth,
};

@interface SLBSPathDirectionHelper : NSObject

+ (double)calcPathDirWithPoint:(CGPoint)p1 otherPoint:(CGPoint) p2;
+ (SLBSMapDirection)directionForMapPathWithPoint:(CGPoint)p1 otherPoint:(CGPoint)p2;
+ (NSArray *)pathDicrectionFilter:(NSArray*)arr;
+ (NSArray *)pathMatchFilter:(NSArray*)arr;
+ (UIImage *)imageForMapDirectionWithLength:(CGFloat)length tileImage:(UIImage *)tile margin:(CGFloat*)margin interval:(CGFloat)interval;
+ (NSArray *)directionViewsFromPaths:(NSArray *)paths;
+ (CGRect)CGRectFromCGPoint:(CGPoint)p1 length:(CGFloat)length width:(CGFloat)width;
+ (CGRect)CGRectFromCGPoint:(CGPoint)p1 otherPoint:(CGPoint)p2 width:(CGFloat)width;

@end
