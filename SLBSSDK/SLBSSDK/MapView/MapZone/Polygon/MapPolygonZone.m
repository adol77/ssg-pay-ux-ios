//
//  PolygonView.m
//  indoornowMapviewSample
//
//  Created by Lee muhyeon on 2015. 8. 20..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "PolygonView.h"
#import "UIView+Additions.h"

@interface PolygonView ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign) BOOL selected;

@end

@implementation PolygonView

+ (instancetype)viewWithPolygon:(Polygon *)polygon
                      plotFrame:(CGRect)plotFrame
                    scaleFactor:(CGFloat)scaleFactor
{
    PolygonView *polygonView = [[PolygonView alloc] initWithFrame:plotFrame];
    polygonView.clipsToBounds = NO;
    polygonView.backgroundColor = [UIColor clearColor];
    polygonView.strokeColor = [[UIColor alloc] initWithWhite:1.0f alpha:1.0f];
    polygonView.fillColor = [[UIColor alloc] initWithWhite:1.0f alpha:0.5f];
    polygonView.textColor = [[UIColor alloc] initWithWhite:1.0f alpha:1.0f];
    polygonView.lineWidth = 2.0f;
    polygonView.polygon = polygon;
    polygonView.scaleFactor = scaleFactor;
    
//    polygonView.layer.shadowColor = [UIColor blackColor].CGColor;
//    polygonView.layer.shadowOffset = CGSizeMake(0, 1);
//    polygonView.layer.shadowOpacity = 1;
//    polygonView.layer.shadowRadius = 2.0;
//    polygonView.clipsToBounds = NO;

    [polygonView attachTextLabel:polygon.name];
    
    return polygonView;
}

- (void)attachTextLabel:(NSString*)text {
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    
    if (nil != text) {
        label.text = text;
    }
    label.font = self.textFont;
    label.textColor = self.textColor;
    label.textAlignment = NSTextAlignmentCenter;
    
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.layer.shadowOpacity = 1;
    label.layer.shadowRadius = 2.0;
    label.clipsToBounds = NO;

    self.textLabel = label;
    [self addSubview:self.textLabel];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
//    CGContextSetLineWidth(context, 2.0);
//
//    CGContextSetRGBFillColor(context, 255./255., 255./255., 255./255., 0.2);

    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);

    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);

    CGContextBeginPath(context);
    
    for (int idx = 0; idx < [self.polygon.locations count]; idx++) {
        Location *location = [self.polygon.locations objectAtIndex:idx];
        
        if (idx == 0) {
            CGContextMoveToPoint(context,
                                 location.x * self.scaleFactor,
                                 self.height - location.y * self.scaleFactor);
        }
        else {
            CGContextAddLineToPoint(context,
                                    location.x * self.scaleFactor,
                                    self.height - location.y * self.scaleFactor);
        }
    }
    
    CGContextClosePath(context);
//    CGContextFillPath(context);
//    CGContextStrokePath(context);
//    CGContextDrawPath(context, kCGPathFill);                       //채워서 그리기
//    CGContextDrawPath(context, kCGPathStroke);                     //테두리만 그리기
    CGContextDrawPath(context, kCGPathFillStroke);                 //테두리와 채우기 그리기
//
//    NSMutableParagraphStyle* paragraphStyle = [NSMutableParagraphStyle new];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//
//    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:17],
//                                  NSForegroundColorAttributeName: [UIColor redColor],
//                                  NSParagraphStyleAttributeName: paragraphStyle };
//    
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.polygon.name
//                                                                           attributes:attributes];
//    
//    CGRect boundingBox = [self.polygon boundingBox];
//    CGRect scaledBoundingBox = CGRectMake(boundingBox.origin.x * self.scaleFactor,
//                                          self.height - (boundingBox.origin.y + boundingBox.size.height) * self.scaleFactor,
//                                          boundingBox.size.width * self.scaleFactor,
//                                          boundingBox.size.height * self.scaleFactor);
//    
//    [attributedString drawInRect:scaledBoundingBox];
}

- (BOOL)isSelected {
    return _selected;
}

- (void)setSelected:(BOOL)selected {
    if (_selected == selected) {
        return;
    }
    
    _selected = selected;
    if (self.selected) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 0.5;
        animation.repeatCount = HUGE_VAL;
        animation.autoreverses = YES;
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:1.5];
        [self.layer addAnimation:animation forKey:@"scale-layer"];
    } else {
        [self.layer removeAllAnimations];
    }
}

@end
