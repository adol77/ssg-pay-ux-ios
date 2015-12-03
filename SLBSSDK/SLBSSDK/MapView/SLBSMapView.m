//
//  SLBSMapView.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 3..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "SLBSMapView.h"

#import "MapImageView.h"

#import "MapPOIZoneView.h"
#import "MapPolygonZoneView.h"
#import "MapPathView.h"

#import "SLBSMapViewController.h"

#pragma mark - SLBSMapView
@interface SLBSMapView () < UIGestureRecognizerDelegate > {
    SLBSTransform3Ds transforms;
    
    CGPoint originCenter_;
}

@property (nonatomic, strong) SLBSMapViewController *dataController;

@property (nonatomic, strong) MapImageView *mapView;
@property (nonatomic, strong) MapPathView *pathView;
@property (nonatomic, strong) NSMutableArray *zoneViews;

@property (nonatomic, assign) BOOL translationEffect;
@property (nonatomic, strong) NSTimer *transformTimer;

@property (nonatomic, assign) BOOL validPanGesture;
@property (nonatomic, assign) BOOL validRotateGesture;
@property (nonatomic, assign) BOOL validPinchGesture;

@property (nonatomic, strong) NSNumber *minimumScale;
@property (nonatomic, assign) double currentRotateX;

@end

@implementation SLBSMapView

@synthesize delegate;

#pragma mark - define & constant
const CGFloat kMinTranslationEffectAlpha = 0.1f;

#define degreesToRadians( degrees ) ( ( (double)degrees ) * M_PI / 180.0f )
#define radiansToDegrees( radians ) ( ( (double)radians ) * 180.0f / M_PI )
#define currentScale( layer )   [[layer valueForKeyPath:@"transform.scale"] doubleValue]
#define currentRotateX( layer ) [[layer valueForKeyPath:@"transform.rotation.x"] doubleValue]
#define currentRotateY( layer ) [[layer valueForKeyPath:@"transform.rotation.y"] doubleValue]
#define currentRotateZ( layer ) [[layer valueForKeyPath:@"transform.rotation.z"] doubleValue]
#define transformValueLog(layer) NSLog(@"\nscale(%.4f) rotation(%.4f, %.4f, %.4f) translation(%.4f, %.4f)", [[layer valueForKeyPath:@"transform.scale"] floatValue], [[layer valueForKeyPath:@"transform.rotation.x"] floatValue], [[layer valueForKeyPath:@"transform.rotation.y"] floatValue], [[layer valueForKeyPath:@"transform.rotation.z"] floatValue], [[layer valueForKeyPath:@"transform.translation.x"] floatValue], [[layer valueForKeyPath:@"transform.translation.y"] floatValue])

#pragma mark - initialize

- (instancetype)initWithFrame:(CGRect)frame controller:(SLBSMapViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(0x8C8C8C, 1.0f);
        
        self.delegate = nil;
        [self valueInitialize];
        self.translationEffect = YES;
        self.dataController = controller;
    }
    return self;
}

- (void)valueInitialize {
    transforms.rotateXaxis = transforms.rotateZaxis = transforms.translation = transforms.scale = CATransform3DIdentity;
    if (self.mapView) {
        [self updateSizeToFitMapValue];
    }
    transforms.rotateXaxis.m34 = -1.0f/2000.0f;
    self.currentRotateX = 0.0f;
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
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    singleTap.delegate = self;
//    singleTap.numberOfTapsRequired = 1;
//    [singleTap requireGestureRecognizerToFail:doubleTap];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    longPress.numberOfTapsRequired = 1;
//    longPress.numberOfTouchesRequired = 1;
    self.gestureRecognizers = @[pan, rotation, pinch, doubleTap, longPress];
    
//    doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    doubleTap.delegate = self;
//    doubleTap.numberOfTapsRequired = 2;
//    self.gestureRecognizers = @[doubleTap];
}

- (void)loadMapData {
    if(!self.zoneViews) {
        self.zoneViews = [NSMutableArray array];
    }
    
    if ([self.zoneViews count] > 0) {
        for (MapZoneView *zoneView in self.zoneViews) {
            [zoneView removeFromSuperview];
        }
        [self.zoneViews removeAllObjects];
    }
    [self valueInitialize];
    [self mapInitialize];
    [self poiInitialize];
    [self polygonInitialize];
    [self initializeScaleAndRotate];
    [self.mapView bringSubviewToFront:self.pathView];
    
    if (self.translationEffect) {
        [UIView animateWithDuration:MAP_ANIMATION_DURATION_LONG delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.mapView.alpha = 1.0f;
            for (UIView *view in self.zoneViews) {
                view.alpha = 1.0f;
            }
        } completion:nil];
    }
}

- (void)initializeScaleAndRotate {
    [self updateSizeToFitMapValue];
    [self applyTransformation];
    self.minimumScale = [NSNumber numberWithDouble:currentScale(self.mapView.layer)];
}

- (void)mapInitialize {
    if (self.pathView) {
        [self.pathView removeFromSuperview];
        self.pathView = nil;
    }
    if (self.mapView) {
        self.mapView.gestureRecognizers = nil;
        [self.mapView removeFromSuperview];
        self.mapView = nil;
    }
    self.mapView = [[MapImageView alloc] initWithController:self.dataController];
    if (self.translationEffect) {
        self.mapView.alpha = kMinTranslationEffectAlpha;
    }
    [self addSubview:self.mapView];
    self.mapView.center = CGPointIntegral(CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2));
    self.pathView = [[MapPathView alloc] initWithFrame:self.mapView.bounds];
    [self.mapView addSubview:self.pathView];
    self.pathView.dataController = self.dataController;
    [self gestureInitialize];
}

- (void)poiInitialize {
    NSArray *poiArray = self.dataController.poiZoneList;
    for (SLBSMapViewZoneData *zoneData in poiArray) {
        MapPOIZoneView *poi = [MapPOIZoneView zoneViewWithController:self.dataController zoneID:zoneData.zoneID];
        if (self.translationEffect) {
            poi.alpha = kMinTranslationEffectAlpha;
        }
        [self.mapView addSubview:poi];
        [self.zoneViews addObject:poi];
    }
}

- (void)polygonInitialize {
    NSArray *storeArray = self.dataController.storeZoneList;
    for (SLBSMapViewZoneData *zoneData in storeArray) {
        MapPolygonZoneView *zoneView = [MapPolygonZoneView zoneViewWithController:self.dataController zoneID:zoneData.zoneID];
        if (self.translationEffect) {
            zoneView.alpha = kMinTranslationEffectAlpha;
        }
        [self.mapView addSubview:zoneView];
        [self.zoneViews addObject:zoneView];
    }
}

#pragma mark - transform
- (void)applyTransformation {
    [self.mapView fulfillTransforms:&(transforms)];
    [self.pathView fulfillTransforms:&(transforms)];
    for (MapZoneView *zoneView in self.zoneViews) {
        [zoneView fulfillTransforms:&(transforms)];
    }
    if (self.transformTimer) {
        [self.transformTimer invalidate];
        self.transformTimer = nil;
    }
    self.transformTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(applyEndTransformation) userInfo:nil repeats:NO];
//    MapLog(@"current Center %@ frame %@", NSStringFromCGPoint(CGPointIntegral(self.mapView.center)), NSStringFromCGRect(CGRectIntegral(self.mapView.frame)));
}

- (void)applyEndTransformation {
    if (self.transformTimer) {
        self.transformTimer = nil;
    }
    for (MapZoneView *zoneView in self.zoneViews) {
        [zoneView didEndTransforms:&(transforms)];
    }
}

#pragma mark - event handling
- (BOOL)validatePanGesture:(UIPanGestureRecognizer *)sender {
    BOOL isContains = NO;
    CGPoint location = CGPointIntegral([sender locationInView:self]);
    CGRect mapFrame = CGRectIntegral(self.mapView.frame);
    isContains = CGRectContainsPoint(mapFrame, location);
//    MapLog(@"frame %@ location %@ isContains? %@", NSStringFromCGRect(mapFrame), NSStringFromCGPoint(location), boolstr(isContains));
    return isContains;
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)sender {
//    MapLog(@"%@", NSStringFromSelector(_cmd));
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            self.validPanGesture = [self validatePanGesture:sender];
            if (self.validPanGesture) {
                originCenter_ =  CGPointMake(CGRectGetMidX(CGRectIntegral(self.mapView.frame)), CGRectGetMidY(CGRectIntegral(self.mapView.frame)));
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (self.validPanGesture == NO) {
                return;
            }
            CGPoint translation = [sender translationInView:self];
            transforms.translation = CATransform3DTranslate(transforms.translation, translation.x, translation.y, 0);
            [self applyTransformation];
//            NSLog(@"[MapView] %@ frame %@ bounds %@", NSStringFromSelector(_cmd), NSStringFromCGRect(CGRectIntegral(self.mapView.frame)), NSStringFromCGRect(CGRectIntegral(self.mapView.bounds)));
        } break;
        case UIGestureRecognizerStateEnded: {
            if (self.validPanGesture == NO) {
                return;
            }
            CGPoint velocity = [sender velocityInView:self];
            transforms.translation = CATransform3DTranslate(transforms.translation, velocity.x*0.1, velocity.y*0.1, 0);
            [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction) animations:^{
                [self applyTransformation];
            } completion:^(BOOL finished) {
                BOOL intersects = CGRectIntersectsRect(self.mapView.frame, self.frame);
                if (intersects == NO) {
                    [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction) animations:^{
                        CGPoint currentCenter = CGPointMake(CGRectGetMidX(CGRectIntegral(self.mapView.frame)), CGRectGetMidY(CGRectIntegral(self.mapView.frame)));
                        transforms.translation = CATransform3DTranslate(transforms.translation, originCenter_.x-currentCenter.x, originCenter_.y-currentCenter.y, 0);
                        CATransform3D transform = CATransform3DIdentity;
                        transform = CATransform3DConcat(CATransform3DConcat(CATransform3DConcat(transforms.scale, transforms.rotateZaxis), transforms.rotateXaxis), transforms.translation);
                        self.mapView.layer.transform = transform;
                    } completion:^(BOOL finished) {
//                        NSLog(@"finalCenter_(%@)", NSStringFromCGPoint(CGPointMake(CGRectGetMidX(CGRectIntegral(self.mapView.frame)), CGRectGetMidY(CGRectIntegral(self.mapView.frame)))));
                    }];
                }
            }];
        } break;
        default:
            break;
    }
    [sender setTranslation:CGPointZero inView:self];
}


-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

- (BOOL)applyAnchorPoint:(UIGestureRecognizer *)sender {
    BOOL isContains = NO;
    CGRect mapFrame = CGRectIntegral(self.mapView.frame);
    NSUInteger touchs = [sender numberOfTouches];
    for (NSUInteger touchIndex = 0; touchIndex < touchs; touchIndex++) {
        CGPoint location = CGPointIntegral([sender locationOfTouch:touchIndex inView:self]);
        isContains = CGRectContainsPoint(mapFrame, location);
//        MapLog(@"frame %@ location %@ isContains? %@", NSStringFromCGRect(mapFrame), NSStringFromCGPoint(location), boolstr(isContains));
        if (isContains == NO) {
            return isContains;
        }
    }

//    CGPoint origin = CGPointIntegral(self.mapView.frame.origin);
    CGPoint newCenter = CGPointIntegral([sender locationInView:self.mapView]);
    [self setAnchorPoint:CGPointMake(newCenter.x / self.mapView.bounds.size.width, newCenter.y / self.mapView.bounds.size.height) forView:self.mapView];
//    self.mapView.layer.anchorPoint = CGPointMake(newCenter.x / self.mapView.bounds.size.width, newCenter.y / self.mapView.bounds.size.height);
//    
//    [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        CGPoint target = CGPointIntegral(self.mapView.frame.origin);
//        CGPoint translation = CGPointMake(origin.x - target.x, origin.y - target.y);
//        transforms.translation = CATransform3DTranslate(transforms.translation, translation.x, translation.y, 0);
//        [self applyTransformation];
//    } completion:nil];
    
    return YES;
}

- (IBAction)handleRotation:(UIRotationGestureRecognizer *)sender {
//    MapLog(@"%@", NSStringFromSelector(_cmd));
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            self.validRotateGesture = [self applyAnchorPoint:sender];
        } break;
        case UIGestureRecognizerStateEnded: {
            
        } break;
        case UIGestureRecognizerStateChanged: {
            if (self.validRotateGesture) {
                CGFloat angle = sender.rotation;
                transforms.rotateZaxis = CATransform3DRotate(transforms.rotateZaxis, angle, 0, 0, 1);
                [self applyTransformation];
//                NSLog(@"[MapView] %@ frame %@ bounds %@", NSStringFromSelector(_cmd), NSStringFromCGRect(CGRectIntegral(self.mapView.frame)), NSStringFromCGRect(CGRectIntegral(self.mapView.bounds)));
                sender.rotation = 0.0;
            }
        }
        default: {
        } break;
    }
}

- (IBAction)handlePinch:(UIPinchGestureRecognizer *)sender {
//    MapLog(@"%@", NSStringFromSelector(_cmd));
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            self.validPinchGesture = [self applyAnchorPoint:sender];
        } break;
        case UIGestureRecognizerStateEnded: {
            
        } break;
        case UIGestureRecognizerStateChanged: {
            if (self.validPinchGesture == NO) {
                return;
            }
            double scale = sender.scale;
            NSComparisonResult result = [[NSNumber numberWithDouble:sender.scale] compare:[NSNumber numberWithDouble:1.0f]];
            if (result == NSOrderedDescending) {
                if ([self isMaxScaled] == NO) {
                    transforms.scale = CATransform3DScale(transforms.scale, scale, scale, 1);
                }
                
                {
//                    NSNumber *originScale = [NSNumber numberWithDouble:1.8f * 0.55];
//                    NSNumber *currentScale = [NSNumber numberWithDouble:currentScale(self.mapView.layer)];
//                    if ([originScale compare:currentScale] == NSOrderedAscending) {
                        if ([self isMaxRotateX] == NO) {
                            transforms.rotateXaxis = CATransform3DRotate(transforms.rotateXaxis, degreesToRadians(0.4f), 1, 0, 0);
                            self.currentRotateX = self.currentRotateX + 0.4f;
                        }
//                    }
                }
            } else if (result == NSOrderedAscending) {
                if ([self isMinScaled] == NO) {
                    transforms.scale = CATransform3DScale(transforms.scale, scale, scale, 1);
                }
                
                if ([self isMinRotateX] == NO) {
                    transforms.rotateXaxis = CATransform3DRotate(transforms.rotateXaxis, degreesToRadians(-0.4f), 1, 0, 0);
                    self.currentRotateX = self.currentRotateX - 0.4f;
                }
            }

            
//            long compare = scale*100;
//            if (currentScale_ > kMinScale && currentScale_ < kMaxScale) {
//                transforms.scale = CATransform3DScale(transforms.scale, scale, scale, 1);
//            } else if (compare >= 100 && currentScale_ <= kMinScale) {
//                transforms.scale = CATransform3DScale(transforms.scale, scale, scale, 1);
//            } else if (compare >= 100 && currentScale_ >= kMaxScale) {
//                if (currentDegree_ <= kMaxDegree) {
//                    transforms.rotateXaxis = CATransform3DRotate(transforms.rotateXaxis, degreesToRadians(2.0), 1, 0, 0);
//                    currentDegree_ = currentDegree_ + 2;
//                }
//            } else if (compare < 100 && currentScale_ >= kMaxScale) {
//                if (currentDegree_ > kMinDegree) {
//                    transforms.rotateXaxis = CATransform3DRotate(transforms.rotateXaxis, -degreesToRadians(2.0), 1, 0, 0);
//                    currentDegree_ = currentDegree_ - 2;
//                } else {
//                    transforms.scale = CATransform3DScale(transforms.scale, scale, scale, 1);
//                }
//            }
            
            [self applyTransformation];
//            NSLog(@"[MapView] %@ frame %@ bounds %@", NSStringFromSelector(_cmd), NSStringFromCGRect(CGRectIntegral(self.mapView.frame)), NSStringFromCGRect(CGRectIntegral(self.mapView.bounds)));
            sender.scale = 1.0;
        } break;
        default: {
        } break;
    }
}

- (IBAction)handleDoubleTap:(id)sender {
//    MapLog(@"%@", NSStringFromSelector(_cmd));
    [UIView animateWithDuration:MAP_ANIMATION_DURATION_HARFLONG delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        [self valueInitialize];
        self.mapView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [self.mapView fulfillTransforms:&(transforms)];
        [self.pathView fulfillTransforms:&(transforms)];
        for (MapZoneView *zoneView in self.zoneViews) {
            [zoneView fulfillTransforms:&(transforms)];
        }
        if (self.transformTimer) {
            [self.transformTimer invalidate];
            self.transformTimer = nil;
        }
        for (MapZoneView *zoneView in self.zoneViews) {
            [zoneView resetTransforms:&(transforms)];
        }
    } completion:^(BOOL finished) {
        MapLog(@"current Center %@ frame %@", NSStringFromCGPoint(CGPointIntegral(self.mapView.center)), NSStringFromCGRect(CGRectIntegral(self.mapView.frame)));
        self.minimumScale = [NSNumber numberWithDouble:currentScale(self.mapView.layer)];
        self.currentRotateX = 0.0f;
    }];
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender { }

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender {
//    MapLog(@"%@", NSStringFromSelector(_cmd));
    CGPoint location = [sender locationInView:self];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            for (MapZoneView *zoneView in self.zoneViews) {
                BOOL isContains = [zoneView contains:[self convertPoint:location toView:self.mapView]];
                if (isContains == YES) {
                    if ([self.dataController.selectedZoneNumber isEqualToNumber:zoneView.zoneID] == YES) {
                        self.dataController.selectedZoneNumber = nil;
                    } else {
                        if (self.delegate && [self.delegate respondsToSelector:@selector(mapView:willSelectedZone:)]) {
                            BOOL select = [self.delegate mapView:self willSelectedZone:zoneView.zoneID];
                            if (select) {
                                self.dataController.selectedZoneNumber = zoneView.zoneID;
                            }
                        }
                    }
                    break;
                }
            }
        } break;
        case UIGestureRecognizerStateChanged: {

        } break;
        case UIGestureRecognizerStateEnded: {

        } break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] == YES) {
//        MapLog(@"otherGestureRecognizer, %@", NSStringFromClass([otherGestureRecognizer class]));
        return NO;
    }
    return YES;
}

- (void)selectedZone:(NSNumber *)zoneNumber {
    MapZoneView *zoneView = [self mapZoneViewAtZoneID:zoneNumber];
    if (zoneView) {
        zoneView.selected = YES;
        CGPoint newCenter = [self convertPoint:zoneView.center fromView:self.mapView];
        CGPoint currentCenter = self.mapView.center;
        CGPoint translation = CGPointMake((currentCenter.x - newCenter.x), (currentCenter.y - newCenter.y));
        transforms.translation = CATransform3DTranslate(transforms.translation, translation.x, translation.y, 0);
        [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [self applyTransformation];
        } completion:nil];
    }
}

- (void)unselectedZone:(NSNumber *)zoneNumber {
    MapZoneView *zoneView = [self mapZoneViewAtZoneID:zoneNumber];
    if (zoneView) {
        zoneView.selected = NO;
    }
}

- (void)hiddenPath:(BOOL)hidden {
    self.pathView.hidden = hidden;
}

- (void)showPath:(BOOL)show {
    if (show) {
        [self.mapView bringSubviewToFront:self.pathView];
        self.pathView.alpha = 0.3f;
        if (self.dataController.departureZoneNumber) {
            MapZoneView *zoneView = [self mapZoneViewAtZoneID:self.dataController.departureZoneNumber];
            zoneView.departureZone = YES;
        }
        if (self.dataController.destinationZoneNumber) {
            MapZoneView *zoneView = [self mapZoneViewAtZoneID:self.dataController.destinationZoneNumber];
            zoneView.destinationZone = YES;
        }
        [self.pathView fulfillTransforms:&transforms];
        [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [self.pathView showPath:YES];
            self.pathView.alpha = 1.0f;
        } completion:nil];
    } else {
        if (self.dataController.departureZoneNumber) {
            MapZoneView *zoneView = [self mapZoneViewAtZoneID:self.dataController.departureZoneNumber];
            zoneView.departureZone = NO;
        }
        if (self.dataController.destinationZoneNumber) {
            MapZoneView *zoneView = [self mapZoneViewAtZoneID:self.dataController.destinationZoneNumber];
            zoneView.destinationZone = NO;
        }
        [self.pathView showPath:NO];
    }
}

- (void)updatetDepartureZone {
    if (self.dataController.departureZoneNumber) {
        MapPolygonZoneView *zoneView = (MapPolygonZoneView *)[self mapZoneViewAtZoneID:self.dataController.departureZoneNumber];
        if (zoneView && [zoneView respondsToSelector:@selector(setDepartureZone:)]) {
            zoneView.departureZone = YES;
        }
    } else {
        MapZoneView *zoneView = nil;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"departureZone == %@", [NSNumber numberWithBool:YES]];
        NSArray *filteredZoneViews = [self.zoneViews filteredArrayUsingPredicate:predicate];
        if ([filteredZoneViews count] > 0) {
            zoneView = [filteredZoneViews firstObject];
        }
        zoneView.departureZone = NO;
    }
}

- (void)updateDestinationZone {
    if (self.dataController.destinationZoneNumber) {
        MapPolygonZoneView *zoneView = (MapPolygonZoneView *)[self mapZoneViewAtZoneID:self.dataController.destinationZoneNumber];
        if ([zoneView respondsToSelector:@selector(setDestinationZone:)]) {
            zoneView.destinationZone = YES;
        }
    } else {
        MapZoneView *zoneView = nil;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"destinationZone == %@", [NSNumber numberWithBool:YES]];
        NSArray *filteredZoneViews = [self.zoneViews filteredArrayUsingPredicate:predicate];
        if ([filteredZoneViews count] > 0) {
            zoneView = [filteredZoneViews firstObject];
        }
        zoneView.destinationZone = NO;
    }
}

- (void)updateSizeToFitMapValue {
    CGFloat initializeScaleH = 1.0f;
    CGFloat initializeScaleV = 1.0f;
    if (self.mapView.mapSize.width > self.mapView.mapSize.height) {
        transforms.rotateZaxis = CATransform3DRotate(CATransform3DIdentity, -M_PI_2, 0, 0, 1);
        
        initializeScaleH = self.frame.size.width / self.mapView.mapSize.height;
        initializeScaleV = self.frame.size.height / self.mapView.mapSize.width;
    } else {
        initializeScaleH = self.frame.size.width / self.mapView.mapSize.width;
        initializeScaleV = self.frame.size.height / self.mapView.mapSize.height;
    }
    
    CGFloat initializeScale = 1.0f;
    if (initializeScaleV > initializeScaleH) {
        initializeScale = initializeScaleH;
    } else {
        initializeScale = initializeScaleV;
    }
    transforms.scale = CATransform3DScale(CATransform3DIdentity, initializeScale, initializeScale, 1);
}

- (MapZoneView *)mapZoneViewAtZoneID:(NSNumber *)zoneid {
    MapZoneView *zoneView = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"zoneID == %@", zoneid];
    NSArray *filteredZoneViews = [self.zoneViews filteredArrayUsingPredicate:predicate];
    if ([filteredZoneViews count] > 0) {
        zoneView = [filteredZoneViews firstObject];
    }
    return zoneView;
}

- (void)updateCurrentPosition:(CGPoint)position moveCenter:(BOOL)move {
    [self.pathView setCurrentPosition:position];
    
    if (move) {
        CGPoint newCenter = [self convertPoint:position fromView:self.mapView];
        CGPoint currentCenter = self.mapView.center;
        CGPoint translation = CGPointMake((currentCenter.x - newCenter.x), (currentCenter.y - newCenter.y));
        transforms.translation = CATransform3DTranslate(transforms.translation, translation.x, translation.y, 0);
        [UIView animateWithDuration:MAP_ANIMATION_DURATION_MIDDLE delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            [self applyTransformation];
        } completion:nil];
    }
}

- (void)hiddenCurrentPosition:(BOOL)hidden {
    self.pathView.currentPositionView.hidden = hidden;
}


- (BOOL)isMaxScaled {
    NSNumber *maxScale = [NSNumber numberWithDouble:1.8f];
    NSNumber *currentScale = [NSNumber numberWithDouble:currentScale(self.mapView.layer)];
    if ([maxScale compare:currentScale] == NSOrderedDescending) {
        NSLog(@"[MapView] isMaxScaled NO | maxScale %@ currentScale %@", maxScale, currentScale);
        return NO;
    }
    return YES;
}

- (BOOL)isMinScaled {
    NSNumber *minScale = self.minimumScale;
    NSNumber *currentScale = [NSNumber numberWithDouble:currentScale(self.mapView.layer)];
    if ([minScale compare:currentScale] == NSOrderedAscending) {
//        NSLog(@"[MapView] isMinScaled NO | maxScale %@ currentScale %@", minScale, currentScale);
        return NO;
    }
    return YES;
}

- (BOOL)isMaxRotateX {
    NSNumber *maxRotateX = [NSNumber numberWithDouble:40.0f];
    NSNumber *currentRotateX = [NSNumber numberWithDouble:self.currentRotateX];
//    NSNumber *currentRotateX = [NSNumber numberWithDouble:currentRotateX(self.mapView.layer)];
    if ([maxRotateX compare:currentRotateX] == NSOrderedDescending) {
        NSLog(@"[MapView] isMaxRotateX NO | maxRotateX %@ currentRotateX %@", maxRotateX, currentRotateX);
        return NO;
    }
//    NSNumber *currentRotateXRadian = [NSNumber numberWithDouble:currentRotateX(self.mapView.layer)];
//    NSLog(@"[MapView] isMaxRotateX YES %@ currentRotateX %@(%@)", maxRotateX, currentRotateX, currentRotateXRadian);
    return YES;
}

- (BOOL)isMinRotateX {
    NSNumber *minRotateX = [NSNumber numberWithDouble:0.0f];
    NSNumber *currentRotateX = [NSNumber numberWithDouble:self.currentRotateX];
//    NSNumber *currentRotateX = [NSNumber numberWithDouble:currentRotateX(self.mapView.layer)];
    if ([minRotateX compare:currentRotateX] == NSOrderedAscending) {
//        NSLog(@"[MapView] isMinRotateX NO | minRotateX %@ currentRotateX %@", minRotateX, currentRotateX);
        return NO;
    }
//    NSNumber *currentRotateXRadian = [NSNumber numberWithDouble:currentRotateX(self.mapView.layer)];
//    NSLog(@"[MapView] isMinRotateX YES %@ currentRotateX %@(%@)", minRotateX, currentRotateX, currentRotateXRadian);
    return YES;
}

@end
