//
//  MapPolygonZoneView.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 3..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapPolygonZoneView.h"
#import "UIView+Additions.h"
#import "MapTitleZoneView.h"
#import "MapStoreBIZoneView.h"
#import "NSString+ExtendedStringDrawFont.h"

@interface MapPolygonZoneView ()

@property (strong, nonatomic) Polygon *polygon;
@property (assign, nonatomic) CGFloat scaleFactor;

@property (nonatomic, strong) MapTitleZoneView *titleView;
@property (nonatomic, strong) MapStoreBIZoneView *storeBIView;

@property (nonatomic, strong) UIImageView *campaignIconImageView;

@end

@implementation MapPolygonZoneView

- (instancetype)initWithController:(SLBSMapViewController *)controller zoneID:(NSNumber *)zoneID
{
    self = [super initWithController:controller zoneID:zoneID];
    if (self) {
        NSArray *locations = [Location locationsWithCGPoints:self.zoneData.polygons];
        Polygon *polygon = [[Polygon alloc] initWithId:self.zoneData.zoneID name:self.zoneData.name locations:locations];
        CGRect frame = polygon.boundingBox;
        frame.origin.x = frame.origin.x-self.dataController.selectedStrokeLineWidth/2;
        frame.origin.y = frame.origin.y-self.dataController.selectedStrokeLineWidth/2;
        frame.size.width = frame.size.width+self.dataController.selectedStrokeLineWidth;
        frame.size.height = frame.size.height+self.dataController.selectedStrokeLineWidth;
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.scaleFactor = 1.0f;
        self.polygon = polygon;
        
        if (self.zoneData.storeBI == nil) {
            [self initializeTitleView];
        } else {
            [self initializeStoreBI];
        }

        if (self.zoneData.containedCampaign == YES) {
            [self initializeCampaignIcon];
        }
    }
    return self;
}


- (void)setShadow:(BOOL)enabled {
    if (enabled) {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 2);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 5.0;
    } else {
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -3);
        self.layer.shadowOpacity = 0;
        self.layer.shadowRadius = 3.0;
    }
}

- (void)initializeTitleView {
    CGRect frame = CGRectZero;
//    if ([self.zoneData.name containsString:@"레미니"] == YES) {
//        NSLog(@"%@ %@", NSStringFromSelector(_cmd), self.zoneData.name);
//    }
    if (self.zoneData.visibleFrame.size.width != 0) {
        frame = CGRectMake(self.zoneData.visibleFrame.origin.x - self.frame.origin.x, self.zoneData.visibleFrame.origin.y - self.frame.origin.y, self.zoneData.visibleFrame.size.width, self.zoneData.visibleFrame.size.height);
    } else if(self.zoneData.titleCenter.y != 0) {
        frame = [self.polygon.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.dataController.pathDestinationTitleFont} context:nil];
    } else {
        frame = self.bounds;
    }
    frame = CGRectIntegral(frame);
    self.titleView = [[MapTitleZoneView alloc] initWithFrame:frame];
    self.titleView.textColor = self.dataController.titleColor;
    if (self.zoneData.visibleFrame.size.width != 0) {
        self.titleView.textFont = [self.zoneData.name fontForSize:frame.size fontSize:self.dataController.maximumFontSize minimumFontSize:self.dataController.minimumFontSize];
    } else {
        self.titleView.textFont = self.dataController.titleFont;
        self.titleView.minimumFontScale = self.dataController.minimumFontScale;
        CGPoint center = CGPointMake(self.zoneData.titleCenter.x - (self.frame.origin.x+self.zoneData.storeBI.size.width/2.0f), self.zoneData.titleCenter.y - (self.frame.origin.y+self.zoneData.storeBI.size.height/2.0f));
        self.titleView.center = center;
    }
    
    self.titleView.title = self.polygon.name;
    self.titleView.angle = self.zoneData.angle;
    self.titleView.frame = CGRectIntegral(self.titleView.frame);
    
//    if (self.zoneData.visibleFrame.size.width != 0) {
//        NSLog(@"%@ %@ form visibleFrame (%@/%@)", NSStringFromSelector(_cmd), self.zoneData.name, NSStringFromCGRect(frame), NSStringFromCGRect(self.titleView.frame));
//        self.titleView.backgroundColor = [UIColor greenColor];
//    } else if(self.zoneData.titleCenter.y != 0) {
//        NSLog(@"%@ %@ form titleCenter (%@/%@)", NSStringFromSelector(_cmd), self.zoneData.name, NSStringFromCGRect(frame), NSStringFromCGRect(self.titleView.frame));
//        self.titleView.backgroundColor = [UIColor yellowColor];
//    } else {
//        NSLog(@"%@ %@ self.frame (%@/%@)", NSStringFromSelector(_cmd), self.zoneData.name, NSStringFromCGRect(frame), NSStringFromCGRect(self.titleView.frame));
//        self.titleView.backgroundColor = [UIColor redColor];
//    }
    [self addSubview:self.titleView];
}

- (void)initializeStoreBI {
//    NSLog(@"StoreBI:%@ zone center %@ titleCenter %@ angle %.2f", self.zoneData.name, NSStringFromCGPoint(self.zoneData.currentCenter), NSStringFromCGPoint(self.zoneData.titleCenter), self.zoneData.angle);
    self.storeBIView = [[MapStoreBIZoneView alloc] initWithFrame:CGRectZero];
    self.storeBIView.BI = self.zoneData.storeBI;
    self.storeBIView.angle = self.zoneData.angle;
    if (self.zoneData.titleCenter.y != 0) {
        CGPoint center = CGPointMake(self.zoneData.titleCenter.x - (self.frame.origin.x+self.zoneData.storeBI.size.width/2.0f), self.zoneData.titleCenter.y - (self.frame.origin.y+self.zoneData.storeBI.size.height/2.0f));
        self.storeBIView.center = center;
    }/* else if (self.zoneData.visibleFrame.size.width != 0) {
        CGRect frame = CGRectMake(self.zoneData.visibleFrame.origin.x - self.frame.origin.x, self.zoneData.visibleFrame.origin.y - self.frame.origin.y, self.zoneData.visibleFrame.size.width, self.zoneData.visibleFrame.size.height);
        self.storeBIView.frame = frame;
        self.storeBIView.bgColor = [UIColor greenColor];
    } */else {
        self.storeBIView.frame = CGRectMake(0,0,self.zoneData.storeBI.size.width,self.zoneData.storeBI.size.height);
        self.storeBIView.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    }
    [self addSubview:self.storeBIView];
}

- (void)initializeCampaignIcon {
    if (self.dataController.campaignZoneIcon == nil) {
//        NSLog(@"not exist campaignZoneIcon!!!!!!!!!!!!!!!");
        return;
    }
    Location *locationForMaxX = [self.polygon.locations objectAtIndex:0];
    for (int idx = 1; idx < [self.polygon.locations count]; idx++) {
        Location *location = [self.polygon.locations objectAtIndex:idx];
        if ((location.x > locationForMaxX.x) && (location.y <= locationForMaxX.y)) {
            locationForMaxX = location;
        }
    }
    self.campaignIconImageView = [[UIImageView alloc] initWithImage:self.dataController.campaignZoneIcon];
    CGPoint translatedPoint = [self translateInView:CGPointMake(locationForMaxX.x, locationForMaxX.y)];
    self.campaignIconImageView.center = translatedPoint;
    [self addSubview:self.campaignIconImageView];
}

- (void)drawRect:(CGRect)rect
{
    if (self.selected == YES) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, self.dataController.selectedStrokeColor.CGColor);
        CGContextSetLineWidth(context, self.dataController.selectedStrokeLineWidth);
        
//        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        
        CGContextBeginPath(context);
        
        for (int idx = 0; idx < [self.polygon.locations count]; idx++) {
            Location *location = [self.polygon.locations objectAtIndex:idx];
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
        
        CGContextClosePath(context);
        
        CGContextDrawPath(context, kCGPathStroke);
    } else if (self.zoneData.containedCampaign == YES) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetStrokeColorWithColor(context, self.dataController.campaignStrokeColor.CGColor);
        CGContextSetLineWidth(context, self.dataController.campaignStrokeLineWidth);
        
//        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        
        CGContextBeginPath(context);
        
        for (int idx = 0; idx < [self.polygon.locations count]; idx++) {
            Location *location = [self.polygon.locations objectAtIndex:idx];
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
        
        CGContextClosePath(context);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
}

- (BOOL)contains:(CGPoint)location {
    BOOL isContains = [self.polygon contains:[Location locationWithCGPoint:location]];
    return isContains;
}

- (void)setSelected:(BOOL)selected {
    if (self.selected == selected) {
        return;
    }
    super.selected = selected;
    [self setNeedsDisplay];
}

- (void)fulfillTransforms:(SLBSTransform3Ds *)transforms {
    if (self.titleView) {
        [self.titleView fulfillTransforms:transforms];
    } else {
        [self.storeBIView fulfillTransforms:transforms];
    }
    self.campaignIconImageView.layer.transform = CATransform3DInvert(transforms->rotateZaxis);
}

- (void)didEndTransforms:(SLBSTransform3Ds *)transforms {
    if (self.titleView) {
        [self.titleView didEndTransforms:transforms];
    } else {
        [self.storeBIView didEndTransforms:transforms];
    }
}

- (void)resetTransforms:(SLBSTransform3Ds *)transforms {
    if (self.titleView) {
        [self.titleView resetTransforms:transforms];
    } else {
        [self.storeBIView resetTransforms:transforms];
    }
    self.campaignIconImageView.layer.transform = CATransform3DIdentity;
}

- (CGFloat)selectedRadius {
    return M_PI_4;
}

- (void)setDepartureZone:(BOOL)departureZone {
    if (super.departureZone == departureZone) {
        return;
    }
    super.departureZone = departureZone;
    if (self.departureZone == YES) {
        if (self.titleView) {
            self.titleView.textColor = self.dataController.pathDepartureTitleColor;
//            self.titleView.textFont = self.dataController.pathDepartureTitleFont;
        } else {
            [self.storeBIView fillColor:self.dataController.pathDepartureTitleColor];
        }
    } else {
        if (self.titleView) {
            self.titleView.textColor = self.dataController.titleColor;
//            self.titleView.textFont = self.dataController.titleFont;
        } else {
            [self.storeBIView fillColor:nil];
        }
    }
}

- (void)setDestinationZone:(BOOL)destinationZone {
    if (super.destinationZone == destinationZone) {
        return;
    }
    super.destinationZone = destinationZone;
    
    if (self.destinationZone == YES) {
        if (self.titleView) {
            self.titleView.textColor = self.dataController.pathDestinationTitleColor;
//            self.titleView.textFont = self.dataController.pathDestinationTitleFont;
        } else {
            [self.storeBIView fillColor:self.dataController.pathDestinationTitleColor];
        }
    } else {
        if (self.titleView) {
            self.titleView.textColor = self.dataController.titleColor;
//            self.titleView.textFont = self.dataController.titleFont;
        } else {
            [self.storeBIView fillColor:nil];
        }
    }
}


@end
