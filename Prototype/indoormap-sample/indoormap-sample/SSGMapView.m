//
//  SSGMapView.m
//  indoornowMapviewSample
//
//  Created by Lee muhyeon on 2015. 8. 20..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "SSGMapView.h"
#import "POIView.h"
#import "PolygonView.h"

#define initlog(s) NSLog(@"%@-%@", NSStringFromSelector(_cmd), s)

@interface SSGMapView () < UIGestureRecognizerDelegate > {
    CATransform3D rotateXaxis_;
    CATransform3D rotateZaxis_;
    CATransform3D translation_;
    CATransform3D scale_;
    
    NSInteger currentScale_;
    NSInteger currentDegree_;
    CGPoint originCenter_;
}

@property (nonatomic, strong) UIImageView *mapView;
@property (nonatomic, strong) UIView *polygonView;
@property (nonatomic, strong) UIView *poiView;
@property (nonatomic, strong) NSMutableArray *polygons;
@property (nonatomic, strong) NSMutableArray *pois;

@end


@implementation SSGMapView

#pragma mark - define & constant
const long kMinScale = 5;
const long kMaxScale = 15;
const long kMinDegree = 0;
const long kMaxDegree = 26;

#define degreesToRadians( degrees ) ( ( degrees ) * M_PI / 180.0f )
#define radiansToDegrees( radians ) ( ( radians ) * 180.0f / M_PI )
#define currentScale( layer )   [[layer valueForKeyPath:@"transform.scale"] floatValue]
#define currentRotateX( layer ) [[layer valueForKeyPath:@"transform.rotation.x"] floatValue]
#define currentRotateY( layer ) [[layer valueForKeyPath:@"transform.rotation.y"] floatValue]
#define currentRotateZ( layer ) [[layer valueForKeyPath:@"transform.rotation.z"] floatValue]

#define UIColorFromRGBA(rgbValue, a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 blue:((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]

#pragma mark - initialize
- (instancetype)initWithMapData:(NSDictionary *)mapData
{
    self = [super init];
    if (self) {
        [self valueInitialize];
        [self gestureInitialize];
        [self mapInitialize];
        [self poiInitialize];
        [self polygonInitialize];
    }
    return self;
}

- (void)valueInitialize {
    rotateXaxis_ = rotateZaxis_ = translation_ = scale_ = CATransform3DIdentity;
    rotateXaxis_.m34 = -1.0f/1000.0f;
    currentScale_ = 1;
    currentDegree_ = 0;
}

- (void)gestureInitialize {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    rotation.delegate = self;
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinch.delegate = self;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    singleTap.delegate = self;
    singleTap.numberOfTapsRequired = 1;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    self.gestureRecognizers = @[pan, rotation, pinch, doubleTap, singleTap];
}

- (void)mapInitialize {
    self.mapView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ssg-1F.png"]];
    self.mapView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.mapView];
}

- (void)poiInitialize {
    NSArray *poiPositions = @[[NSValue valueWithCGPoint:CGPointMake(1160/2, 128/2)],
                              [NSValue valueWithCGPoint:CGPointMake(824/2, 146/2)],
                              [NSValue valueWithCGPoint:CGPointMake(694/2, 510/2)],
                              [NSValue valueWithCGPoint:CGPointMake(534/2, 556/2)],
                              [NSValue valueWithCGPoint:CGPointMake(1310/2, 806/2)],
                              [NSValue valueWithCGPoint:CGPointMake(1310/2, 842/2)],
                              [NSValue valueWithCGPoint:CGPointMake(114/2, 928/2)]];
    self.pois = [NSMutableArray array];
    for (NSValue *centerValue in poiPositions) {
        POIView *poi = [[POIView alloc] initWithCenter:[centerValue CGPointValue]];
        [self.mapView addSubview:poi];
        [self.pois addObject:poi];
    }
}

- (void)polygonInitialize {
//    [self polygonViewWithLocations:@[[[Location alloc] initWithX:2/2 y:2/2 z:0],
//                                     [[Location alloc] initWithX:40/2 y:2/2 z:0],
//                                     [[Location alloc] initWithX:40/2 y:40/2 z:0],
//                                     [[Location alloc] initWithX:2/2 y:40/2 z:0]] name:@"test1"];
//    [self polygonViewWithLocations:@[[[Location alloc] initWithX:274/2 y:4/2 z:0],
//                                     [[Location alloc] initWithX:496/2 y:4/2 z:0],
//                                     [[Location alloc] initWithX:496/2 y:162/2 z:0],
//                                     [[Location alloc] initWithX:274/2 y:162/2 z:0]] name:@"test2"];
//    [self polygonViewWithLocations:@[[[Location alloc] initWithX:916/2 y:860/2 z:0],
//                                     [[Location alloc] initWithX:1134/2 y:860/2 z:0],
//                                     [[Location alloc] initWithX:1134/2 y:1014/2 z:0],
//                                     [[Location alloc] initWithX:916/2 y:1014/2 z:0]] name:@"토즈"];
    self.polygons = [NSMutableArray array];
    
    {
        NSArray *locations = @[[[Location alloc] initWithX:0 y:0 z:0],
                               [[Location alloc] initWithX:(496-274)/2 y:0 z:0],
                               [[Location alloc] initWithX:(496-274)/2 y:162/2 z:0],
                               [[Location alloc] initWithX:0 y:162/2 z:0]];
        Polygon *polygon = [[Polygon alloc] initWithId:[NSNumber numberWithInteger:1001] name:@"토즈" locations:locations];
        PolygonView *polygonView = [PolygonView viewWithPolygon:polygon plotFrame:CGRectMake(274/2, 0, (496-274)/2, 162/2) scaleFactor:1];
        polygonView.strokeColor = UIColorFromRGBA(0x993cf3, 1.0f);
        polygonView.fillColor = UIColorFromRGBA(0x993cf3, 0.5f);
        [self.polygons addObject:polygonView];
        [self.mapView addSubview:polygonView];
    }
    {
        NSArray *locations = @[[[Location alloc] initWithX:0 y:48/2 z:0],
                               [[Location alloc] initWithX:72/2 y:48/2 z:0],
                               [[Location alloc] initWithX:72/2 y:0 z:0],
                               [[Location alloc] initWithX:242/2 y:0 z:0],
                               [[Location alloc] initWithX:242/2 y:158/2 z:0],
                               [[Location alloc] initWithX:0 y:158/2 z:0]
                               ];
        Polygon *polygon = [[Polygon alloc] initWithId:[NSNumber numberWithInteger:1002] name:@"미우미우" locations:locations];
        PolygonView *polygonView = [PolygonView viewWithPolygon:polygon plotFrame:CGRectMake(798/2, 0, (1040-798)/2, 158/2) scaleFactor:1];
        polygonView.strokeColor = UIColorFromRGBA(0x306100, 1.0f);
        polygonView.fillColor = UIColorFromRGBA(0x306100, 0.5f);
        [self.polygons addObject:polygonView];
        [self.mapView addSubview:polygonView];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.frame = newSuperview.frame;
    self.mapView.center = self.center;
//    float fitScale = self.frame.size.width / self.mapView.frame.size.width;
//    scale_ = CATransform3DScale(scale_, fitScale, fitScale, 1);
//    [self applyTransformation];
}

#pragma mark - transform
- (void)applyTransformationWithAnimation:(BOOL)animated {
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DConcat(CATransform3DConcat(CATransform3DConcat(scale_, rotateZaxis_), rotateXaxis_), translation_);
    self.mapView.layer.transform = transform;
    for (POIView *poi in self.pois) {
        poi.layer.transform = CATransform3DInvert(rotateZaxis_);
    }

    for (PolygonView *polygonView in self.polygons) {
        polygonView.textLabel.layer.transform = CATransform3DInvert(rotateZaxis_);
    }
//    if (animated == NO) {
//        BOOL intersects = CGRectIntersectsRect(self.mapView.frame, self.frame);
//        if (intersects == NO) {
//            [self performSelector:@selector(applyInvertTransformation:) withObject:nil afterDelay:0.1];
//        }
//    }
}

- (void)applyInvertTransformation:(id)sender {
    initlog(@"");
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        CATransform3D transform = CATransform3DIdentity;
//        self.mapView.layer.transform = transform;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - event handling
//-(void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer*)recognizer {
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        CGPoint location = [recognizer locationInView:self];
//        CGPoint mapLocation = [self convertPoint:location toView:self.mapView];
//        NSLog(@"%f, %f", mapLocation.x, mapLocation.y);
//        self.maskView.layer.anchorPoint = mapLocation;
//    }
//}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self];
//    BOOL isContains = CGRectContainsPoint(self.mapView.frame, location);
    BOOL isContains = CGRectContainsPoint(CGRectMake(self.mapView.bounds.origin.x-100, self.mapView.bounds.origin.y-100, self.mapView.bounds.size.width+200, self.mapView.bounds.size.height+200), [self convertPoint:location toView:self.mapView]);//rotate 영역을 체크하기 위한 추가 지원 루틴!!!!
    if (isContains == NO) {
        return;
    }
//    [self adjustAnchorPointForGestureRecognizer:sender];
    switch (sender.state) {
        case UIGestureRecognizerStateEnded: {
            CGPoint velocity = [sender velocityInView:self];
            translation_ = CATransform3DTranslate(translation_, velocity.x*0.05, velocity.y*0.05, 0);
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self applyTransformationWithAnimation:YES];
            } completion:^(BOOL finished) {
                BOOL intersects = CGRectIntersectsRect(self.mapView.frame, self.frame);
                if (intersects == NO) {
//                    [self performSelector:@selector(applyInvertTransformation:) withObject:nil afterDelay:0];
                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        NSLog(@"currentCenter_(%@)", NSStringFromCGPoint(CGPointMake(CGRectGetMidX(CGRectIntegral(self.mapView.frame)), CGRectGetMidY(CGRectIntegral(self.mapView.frame)))));
                        CGPoint currentCenter = CGPointMake(CGRectGetMidX(CGRectIntegral(self.mapView.frame)), CGRectGetMidY(CGRectIntegral(self.mapView.frame)));
                        NSLog(@"reversCenter_(%@)", NSStringFromCGPoint(CGPointMake(currentCenter.x-originCenter_.x, currentCenter.y-originCenter_.y)));
//                        translation_ = CATransform3DTranslate(translation_, (currentCenter.x-originCenter_.x)*-1.0f, (currentCenter.y-originCenter_.y)*-1.0f, 0);
                        translation_ = CATransform3DTranslate(translation_, originCenter_.x-currentCenter.x, originCenter_.y-currentCenter.y, 0);
                        CATransform3D transform = CATransform3DIdentity;
                        transform = CATransform3DConcat(CATransform3DConcat(CATransform3DConcat(scale_, rotateZaxis_), rotateXaxis_), translation_);
                        self.mapView.layer.transform = transform;
                    } completion:^(BOOL finished) {
                        NSLog(@"finalCenter_(%@)", NSStringFromCGPoint(CGPointMake(CGRectGetMidX(CGRectIntegral(self.mapView.frame)), CGRectGetMidY(CGRectIntegral(self.mapView.frame)))));
                    }];
                }
            }];
        } break;
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [sender translationInView:self];
            translation_ = CATransform3DTranslate(translation_, translation.x, translation.y, 0);
            [self applyTransformationWithAnimation:NO];
        } break;
        case UIGestureRecognizerStateBegan: {
            originCenter_ =  CGPointMake(CGRectGetMidX(CGRectIntegral(self.mapView.frame)), CGRectGetMidY(CGRectIntegral(self.mapView.frame)));
            NSLog(@"originCenter_(%@)", NSStringFromCGPoint(originCenter_));
        } break;
            
        default:
            break;
    }
//    NSLog(@"Center : %@ / frame : %@", NSStringFromCGPoint(CGPointMake(CGRectGetMidX(CGRectIntegral(self.mapView.frame)), CGRectGetMidY(CGRectIntegral(self.mapView.frame)))), NSStringFromCGRect(CGRectIntegral(self.mapView.frame)));
    [sender setTranslation:CGPointZero inView:self];
}

- (IBAction)handleRotation:(UIRotationGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        return;
    }
//    [self adjustAnchorPointForGestureRecognizer:sender];
    CGFloat angle = sender.rotation;
    rotateZaxis_ = CATransform3DRotate(rotateZaxis_, angle, 0, 0, 1);
    [self applyTransformationWithAnimation:NO];
    sender.rotation = 0.0;
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        return;
    }
//    [self adjustAnchorPointForGestureRecognizer:sender];
    float scale = (float)sender.scale;
    long compare = scale*100;
    if (currentScale_ > kMinScale && currentScale_ < kMaxScale) {
        scale_ = CATransform3DScale(scale_, scale, scale, 1);
    } else if (compare >= 100 && currentScale_ <= kMinScale) {
        scale_ = CATransform3DScale(scale_, scale, scale, 1);
    } else if (compare >= 100 && currentScale_ >= kMaxScale) {
        if (currentDegree_ <= kMaxDegree) {
            rotateXaxis_ = CATransform3DRotate(rotateXaxis_, degreesToRadians(2.0), 1, 0, 0);
            currentDegree_ = currentDegree_ + 2;
        }
    } else if (compare < 100 && currentScale_ >= kMaxScale) {
        if (currentDegree_ > kMinDegree) {
            rotateXaxis_ = CATransform3DRotate(rotateXaxis_, -degreesToRadians(2.0), 1, 0, 0);
            currentDegree_ = currentDegree_ - 2;
        } else {
            scale_ = CATransform3DScale(scale_, scale, scale, 1);
        }
    }
    
    [self applyTransformationWithAnimation:NO];
    currentScale_ = currentScale(self.mapView.layer)*10;
    sender.scale = 1.0;
}

- (IBAction)handleDoubleTap:(id)sender {
    initlog(@"");
    [self valueInitialize];
    [UIView beginAnimations:@"handleDoubleTap" context:nil];
    [UIView setAnimationDuration:0.5];
    self.mapView.layer.transform = CATransform3DIdentity;
    for (POIView *poi in self.pois) {
        poi.layer.transform = CATransform3DIdentity;
    }
    for (PolygonView *polygonView in self.polygons) {
        polygonView.textLabel.layer.transform = CATransform3DIdentity;
    }
    [UIView commitAnimations];
}

- (IBAction)handleTap:(id)sender {
    initlog(@"");
    CGPoint location = [sender locationInView:self];
    for (POIView *poi in self.pois) {
        BOOL isContains = CGRectContainsPoint(poi.frame, [self convertPoint:location toView:self.mapView]);
        if (isContains == YES) {
            NSLog(@"POI TOUCH!!!!");
            [poi setSelected:!poi.isSelected];
        }
    }
    for (PolygonView *polygonView in self.polygons) {
        BOOL isContains = CGRectContainsPoint(polygonView.frame, [self convertPoint:location toView:self.mapView]);
        if (isContains == YES) {
            NSLog(@"polygonView TOUCH!!!!");
            [polygonView setSelected:!polygonView.isSelected];
        }
    }
    
//    self.selected = !self.selected;
//    if (self.selected) {
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        animation.duration = 0.5;
//        animation.repeatCount = HUGE_VAL;
//        animation.autoreverses = YES;
//        animation.fromValue = [NSNumber numberWithFloat:1.0];
//        animation.toValue = [NSNumber numberWithFloat:1.5];
//        [self.icon.layer addAnimation:animation forKey:@"scale-layer"];
//    } else {
//        [self.icon.layer removeAllAnimations];
//    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] == YES) {
        return NO;
    }
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] == YES && [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] == YES) {
//        return NO;
//    }
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] == YES && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] == YES) {
//        return NO;
//    }
//    if ([gestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] == YES && [otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] == YES) {
//        return NO;
//    }
//    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] == YES && [otherGestureRecognizer isKindOfClass:[UIRotationGestureRecognizer class]] == YES) {
//        return NO;
//    }
    
    return YES;
}

#pragma mark - For Debug
+ (void)transformValueLog:(CALayer *)layer {
    CGFloat s = [[layer valueForKeyPath:@"transform.scale"] floatValue];
    CGFloat x = [[layer valueForKeyPath:@"transform.rotation.x"] floatValue];
    CGFloat y = [[layer valueForKeyPath:@"transform.rotation.y"] floatValue];
    CGFloat z = [[layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    NSLog(@"\n scale(%.4f) r-x(%.4f) r-y(%.4f) r-z(%.4f)", s, x, y, z);
}

@end
