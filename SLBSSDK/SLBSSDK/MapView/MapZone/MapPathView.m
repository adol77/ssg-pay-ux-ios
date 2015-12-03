//
//  MapPathView.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 7..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapPathView.h"
#import "SLBSPathDirection.h"

@interface MapPathView () {
    BOOL isPathShow;
}

@property (nonatomic, assign) CGFloat scaleFactor;
@property (nonatomic, strong) UIImageView *departure;
@property (nonatomic, strong) UIImageView *destination;
@property (nonatomic, strong) NSMutableArray *passages;
@property (nonatomic, strong) NSMutableArray *directionViews;


@end

@implementation MapPathView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.scaleFactor = 1.0f;
        isPathShow = NO;
        self.directionViews = [NSMutableArray array];
    }
    return self;
}

- (void)showPath:(BOOL)show {
    isPathShow = show;
    if (show == YES) {
        [self updateDirectionViews];
        if (self.departure == nil) {
            self.departure = [[UIImageView alloc] initWithImage:self.dataController.pathDepartureIcon];
        }
        NSValue *departurePosition = self.dataController.departurePosition;
        if (departurePosition) {
            self.departure.center = [self translateInView:[departurePosition CGPointValue]];
            [self addSubview:self.departure];
        }
        
        if (self.destination == nil) {
            self.destination = [[UIImageView alloc] initWithImage:self.dataController.pathDestinationIcon];
        }
        NSValue *destinationPosition = self.dataController.destinationPosition;
        if (destinationPosition) {
            self.destination.center = [self translateInView:[destinationPosition CGPointValue]];
            [self addSubview:self.destination];
        }
        
        NSArray *passagePositions = self.dataController.passagePositions;
        if (passagePositions && [passagePositions count] > 0) {
            if (!self.passages) {
                self.passages = [NSMutableArray array];
            }
            
            for (NSValue *passage in passagePositions) {
                UIImageView *passageView = [[UIImageView alloc] initWithImage:self.dataController.pathPassageIcon];
                passageView.center = [self translateInView:[passage CGPointValue]];
                [self addSubview:passageView];
                [self.passages addObject:passageView];
            }
        }
    } else {
        if (self.departure) {
            [self.departure removeFromSuperview];
        }
        if (self.destination) {
            [self.destination removeFromSuperview];
        }
        if (self.passages && [self.passages count] > 0) {
            for (UIImageView *passageView in self.passages) {
                [passageView removeFromSuperview];
            }
            [self.passages removeAllObjects];
        }
        for (UIImageView *directionView in self.directionViews) {
            [directionView removeFromSuperview];
        }
        [self.directionViews removeAllObjects];
    }
    [self setNeedsDisplay];
}

- (void)updateDirectionViews {
    NSArray *array = [SLBSPathDirectionHelper directionViewsFromPaths:self.dataController.paths];
    [self.directionViews addObjectsFromArray:array];
    for (UIView *directionView in self.directionViews) {
        [self addSubview:directionView];
    }
}

- (void)setCurrentPosition:(CGPoint)position {
    if (!self.currentPositionView) {
        self.currentPositionView = [[UIImageView alloc] initWithImage:self.dataController.currentLocationIcon];
        [self addSubview:self.currentPositionView];
    }
    [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.currentPositionView.center = CGPointMake(position.x, position.y);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)initializeDeparturePositionImageView
{
//    self.start = [[UIImageView alloc] initWithImage:self.dataController.pathStartImage];
//    self.start.center = [self translateInView:[[self.dataController.paths firstObject] CGPointValue]];
//    [self addSubview:self.start];

    self.departure = [[UIImageView alloc] initWithImage:self.dataController.pathDepartureIcon];
//    CGPoint startPoint = [self translateInView:[self.dataController.startPosition CGPointValue]];
//    startPoint.y = startPoint.y - self.dataController.pathStartImage.size.height/2;
//    self.start.center = startPoint;
    self.departure.center = [self translateInView:[self.dataController.departurePosition CGPointValue]];
//    self.departure.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self addSubview:self.departure];
}

- (void)initializeDestinationPositionImageView {
//    self.end = [[UIImageView alloc] initWithImage:self.dataController.pathEndImage];
//    self.end.center = [self translateInView:[[self.dataController.paths objectAtIndex:[self.dataController.paths count]-1] CGPointValue]];
//    [self addSubview:self.end];
    
    self.destination = [[UIImageView alloc] initWithImage:self.dataController.pathDestinationIcon];
//    CGPoint endPoint = [self translateInView:[self.dataController.endPosition CGPointValue]];
//    endPoint.y = endPoint.y - self.dataController.pathStartImage.size.height/2;
//    self.end.center = endPoint;
    self.destination.center = [self translateInView:[self.dataController.destinationPosition CGPointValue]];
//    self.destination.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self addSubview:self.destination];
}

- (void)drawRect:(CGRect)rect
{
//    if (self.dataController.departurePosition) {
//        [self initializeDeparturePositionImageView];
//    } else {
//        if (self.departure) {
//            [self.departure removeFromSuperview];
//            self.departure = nil;
//        }
//    }
//    if (self.dataController.destinationPosition) {
//        [self initializeDestinationPositionImageView];
//    } else {
//        if (self.destination) {
//            [self.destination removeFromSuperview];
//            self.destination = nil;
//        }
//    }
    if(![self.dataController.paths count] > 0) return;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, self.dataController.pathStrokeColor.CGColor);
    CGContextSetLineWidth(context, self.dataController.pathLineWidth);
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    for (int idx = 0; idx < [self.dataController.paths count]; idx++) {
        CGPoint location = [[self.dataController.paths objectAtIndex:idx] CGPointValue];
        CGPoint translatedPoint = [self translateInView:CGPointMake(location.x, location.y)];
        if (idx == 0) {
            CGContextMoveToPoint(context,
                                 translatedPoint.x * self.scaleFactor,
                                 translatedPoint.y * self.scaleFactor);
        }
        else {
            CGContextAddLineToPoint(context,
                                    translatedPoint.x * self.scaleFactor,
                                    translatedPoint.y * self.scaleFactor);
        }
    }
 
    CGContextStrokePath(context);
}

- (CGPoint)translateInView:(CGPoint)origin {
    return CGPointMake((origin.x - self.frame.origin.x), (origin.y - self.frame.origin.y));
}

- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms {
//    CATransform3D transform = CATransform3DIdentity;
//    transform = CATransform3DConcat(CATransform3DConcat(CATransform3DConcat(transforms.scale, transforms.rotateZaxis), transforms.rotateXaxis), transforms.translation);
//    self.layer.transform = transform;
    if (isPathShow == YES && self.departure) {
        self.departure.layer.transform = CATransform3DInvert(transforms->rotateZaxis);
    }
    if (isPathShow == YES && self.destination) {
        self.destination.layer.transform = CATransform3DInvert(transforms->rotateZaxis);
    }
    if (isPathShow == YES && self.passages && [self.passages count] > 0) {
        for (UIImageView *passageView in self.passages) {
            passageView.layer.transform = CATransform3DInvert(transforms->rotateZaxis);
        }
    }
}

- (void)didEndTransforms:(SLBSTransform3Ds *)transforms {
    [self setNeedsDisplay];
}

- (void)resetTransforms:(SLBSTransform3Ds *)transforms {
}

@end
