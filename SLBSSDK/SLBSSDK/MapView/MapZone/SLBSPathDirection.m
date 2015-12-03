//
//  SLBSPathDirection.m
//  Created by Lee muhyeon on 2015. 10. 30..
//

#import "SLBSPathDirection.h"
#import "SLBSMapViewCommon.h"

#define degreesToRadians( degrees ) (double)( ( ( (double) degrees) ) * M_PI / 180.0f )

@implementation SLBSPathDirectionHelper

+ (double)calcPathDirWithPoint:(CGPoint)p1 otherPoint:(CGPoint) p2 {
    double dx = p2.x - p1.x;
    double dy = p2.y - p1.y;
    
    if ( dx >= 0. && dy >= 0.) {
        if ( dx >= dy ) return atan2(dy, dx);
        else return M_PI * 0.5 - atan2(dx, dy);
    }
    else if ( dx < 0. && dy >= 0. ) {
        dx = fabs(dx);
        
        if ( dx >= dy ) return M_PI - atan2(dy, dx);
        else return M_PI * 0.5 + atan2(dx, dy);
        
    }
    else if ( dx < 0. && dy < 0. ) {
        dx = fabs(dx);
        dy = fabs(dy);
        
        if ( dx >= dy ) return M_PI + atan2(dy, dx);
        else return M_PI * 1.5 - atan2(dx, dy);
    }
    else {
        dy = fabs(dy);
        if ( dx >= dy ) return M_PI * 2. - atan2(dy, dx);
        else return M_PI * 1.5 + atan2(dx, dy);
    }
    
    return 0;
}

+ (SLBSMapDirection)directionForMapPathWithPoint:(CGPoint)p1 otherPoint:(CGPoint)p2 {
    double direction = [SLBSPathDirectionHelper calcPathDirWithPoint:p1 otherPoint:p2];
    if ([SLBSPathDirectionHelper isDirectionEast:direction] == YES) {
        return SLBSMapDirectionEast;
    } else if ([SLBSPathDirectionHelper isDirectionWest:direction] == YES) {
        return SLBSMapDirectionWest;
    } else if ([SLBSPathDirectionHelper isDirectionNorth:direction] == YES) {
        return SLBSMapDirectionNorth;
    } else if ([SLBSPathDirectionHelper isDirectionSouth:direction] == YES) {
        return SLBSMapDirectionSouth;
    }
    return SLBSMapDirectionUnknown;
}

+ (NSArray *)pathDicrectionFilter:(NSArray*)arr {
    if ( arr == nil ) return nil;
    const NSUInteger len = arr.count;
    if ( len < 3 ) return arr;
    
    NSMutableArray* list = [NSMutableArray array];
    [list addObject:arr[0]];
    double oldDir = [SLBSPathDirectionHelper calcPathDirWithPoint:[arr[0] CGPointValue] otherPoint:[arr[1] CGPointValue]];
    
    for ( int i = 0 ; i < len - 1 ; i++ ) {
        NSValue* p = arr[i];
        NSValue* next = arr[i+1];
        double dir = [SLBSPathDirectionHelper calcPathDirWithPoint:[p CGPointValue] otherPoint:[next CGPointValue]];
        if ( fabs(oldDir - dir) > 0.034 ) {
            [list addObject:p];
            oldDir = dir;
        }
    }
    
    [list addObject:arr[len-1]];
    return [list copy];
}

+ (NSArray *)pathMatchFilter:(NSArray*)arr {

    return nil;
}

+ (UIImage *)imageForMapDirectionWithLength:(CGFloat)length tileImage:(UIImage *)tile margin:(CGFloat*)margin interval:(CGFloat)interval {
    CGFloat currentX = *margin;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(length, tile.size.height), NO, 2);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
//    CGContextFillRect(context, (CGRect){ {0,0}, {length, tile.size.height}} );
    
    CGRect drawFrame = CGRectMake(currentX, 0, tile.size.width, tile.size.height);
    while ((currentX+tile.size.width) < length) {
        *margin = length - currentX;
        [tile drawInRect:drawFrame];
        currentX = currentX + interval+tile.size.width;
        drawFrame.origin.x = currentX;
    }
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSArray *)directionViewsFromPaths:(NSArray *)paths {
    NSMutableArray *array = [NSMutableArray array];
    UIImage *arrowImage = [UIImage imageNamed:@"map_arrow_icon.png"];
    
    CGFloat margin = 0.0f;
    NSInteger pathCount = [paths count];
    for (NSInteger index = 0; index < (pathCount - 1); index++) {
        CGPoint start = [[paths objectAtIndex:index] CGPointValue];
        CGPoint end = [[paths objectAtIndex:index+1] CGPointValue];
        CGFloat length = distanceBetweenTwoPoint(start, end);
        UIImage *image = [SLBSPathDirectionHelper imageForMapDirectionWithLength:length tileImage:arrowImage margin:&margin interval:50/2];
        margin = 50 - margin;
        CGRect frame = [SLBSPathDirectionHelper CGRectFromCGPoint:start length:length width:arrowImage.size.height];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = frame;
        [array addObject:imageView];
        double direction = [SLBSPathDirectionHelper calcPathDirWithPoint:start otherPoint:end];
        imageView.layer.anchorPoint = CGPointMake(0.0f, 0.5f);
        imageView.frame = frame;
        imageView.layer.transform = CATransform3DMakeRotation(direction, 0, 0, 1);
    }
    
    return [NSArray arrayWithArray:array];
}

+ (CGRect)CGRectFromCGPoint:(CGPoint)p1 length:(CGFloat)length width:(CGFloat)width {
    CGRect frame = CGRectZero;
    frame.origin.x = p1.x;
    frame.origin.y = p1.y - width/2;
    frame.size.width = length;
    frame.size.height = width;
    return frame;
}

+ (CGRect)CGRectFromCGPoint:(CGPoint)p1 otherPoint:(CGPoint)p2 width:(CGFloat)width {
    CGRect frame = CGRectZero;
    if (p1.x == p2.x) {
        if (p1.y > p2.y) {
            frame.origin.x = p2.x - width/2;
            frame.origin.y = p2.y;
            frame.size.width = width;
            frame.size.height = p1.y - p2.y;
        } else if (p1.y < p2.y) {
            frame.origin.x = p1.x - width/2;
            frame.origin.y = p1.y;
            frame.size.width = width;
            frame.size.height = p2.y - p1.y;
        }
    } else if (p1.y == p2.y) {
        if (p1.x > p2.x) {
            frame.origin.x = p2.x;
            frame.origin.y = p2.y - width/2;
            frame.size.width = p1.x - p2.x;
            frame.size.height = width;
        } else if (p1.x < p2.x) {
            frame.origin.x = p1.x;
            frame.origin.y = p1.y - width/2;
            frame.size.width = p2.x - p1.x;
            frame.size.height = width;
        }
    }
    return frame;
}

+ (BOOL)isDirectionEast:(double)direction {
    NSNumber *directionValue = [NSNumber numberWithDouble:direction];
    if ([[NSNumber numberWithDouble:degreesToRadians(45*0)] compare:directionValue] != NSOrderedDescending &&
        [directionValue compare:[NSNumber numberWithDouble:degreesToRadians(45)]] != NSOrderedDescending) {
        return YES;
    }
    if ([[NSNumber numberWithDouble:degreesToRadians(45*7)] compare:directionValue] != NSOrderedDescending &&
        [directionValue compare:[NSNumber numberWithDouble:degreesToRadians(45*8)]] != NSOrderedDescending) {
        return YES;
    }
    return NO;
}

+ (BOOL)isDirectionWest:(double)direction {
    NSNumber *directionValue = [NSNumber numberWithDouble:direction];
    if ([[NSNumber numberWithDouble:degreesToRadians(45*3)] compare:directionValue] != NSOrderedDescending &&
        [directionValue compare:[NSNumber numberWithDouble:degreesToRadians(45*5)]] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+ (BOOL)isDirectionNorth:(double)direction {
    NSNumber *directionValue = [NSNumber numberWithDouble:direction];
    if ([[NSNumber numberWithDouble:degreesToRadians(45)] compare:directionValue] != NSOrderedDescending &&
        [directionValue compare:[NSNumber numberWithDouble:degreesToRadians(45*3)]] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+ (BOOL)isDirectionSouth:(double)direction {
    NSNumber *directionValue = [NSNumber numberWithDouble:direction];
    if ([[NSNumber numberWithDouble:degreesToRadians(45*5)] compare:directionValue] != NSOrderedDescending &&
        [directionValue compare:[NSNumber numberWithDouble:degreesToRadians(45*7)]] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

+ (void)testDirection {
    NSLog(@"0 : %.3f", ( ( 0.0f ) * M_PI / 180.0f ));
    NSLog(@"90 : %.3f", ( ( 90.0f ) * M_PI / 180.0f ));
    NSLog(@"180 : %.3f", ( ( 180.0f ) * M_PI / 180.0f ));
    NSLog(@"270 : %.3f", ( ( 270.0f ) * M_PI / 180.0f ));
    NSLog(@"360 : %.3f", ( ( 360.0f ) * M_PI / 180.0f ));
    
    for (CGFloat degree = 0; degree < 361; degree = degree + 0.5) {
        double direction = degreesToRadians(degree);
        if ([SLBSPathDirectionHelper isDirectionEast:direction] == YES) {
            NSLog(@"\tdegree %.2f : SLBSMapDirectionEast", degree);
        } else if ([SLBSPathDirectionHelper isDirectionWest:direction] == YES) {
            NSLog(@"\tdegree %.2f : SLBSMapDirectionWest", degree);
        } else if ([SLBSPathDirectionHelper isDirectionNorth:direction] == YES) {
            NSLog(@"\tdegree %.2f : SLBSMapDirectionNorth", degree);
        } else if ([SLBSPathDirectionHelper isDirectionSouth:direction] == YES) {
            NSLog(@"\tdegree %.2f : SLBSMapDirectionSouth", degree);
        }
    }
}

+ (void) compareSample {
    NSNumber *number1 = [NSNumber numberWithDouble:2.435345f];
    NSNumber *number2 = [NSNumber numberWithDouble:2.435345f];
    NSComparisonResult compareResult = [number1 compare:number2];
    switch (compareResult) {
        case NSOrderedSame: {
            NSLog(@"%@ = %@", number1, number2);
        } break;
        case NSOrderedAscending: {
            NSLog(@"%@ < %@", number1, number2);
        } break;
        case NSOrderedDescending: {
            NSLog(@"%@ > %@", number1, number2);
        } break;
            
        default:
            break;
    }
}

@end
