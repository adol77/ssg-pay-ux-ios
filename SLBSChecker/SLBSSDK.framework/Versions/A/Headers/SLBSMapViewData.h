//
//  SLBSMapViewData.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 10. 15..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TSSLBSSessionType) {
    TSSLBSMapZoneTypeUnknown = 0,
    TSSLBSMapZoneTypePolygon,
    TSSLBSMapZoneTypePOIImage,
};

@interface SLBSMapPath : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSValue *position;

@end

@interface SLBSMapViewZoneData : NSObject<NSCopying>

#pragma mark - common
@property (nonatomic, strong) NSNumber *zoneID;
@property (nonatomic, assign) TSSLBSSessionType type;
@property (nonatomic, assign) CGPoint currentCenter;

#pragma mark - POI Zone
@property (nonatomic, strong) UIImage *icon;

#pragma mark - title for Store Zone
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *storeBI;
@property (nonatomic, assign) CGPoint titleCenter;
@property (nonatomic, assign) CGRect visibleFrame;
@property (nonatomic, assign) CGFloat angle;

#pragma mark - area for Store Zone
@property (nonatomic, strong) NSArray *polygons;
@property (nonatomic, assign) BOOL containedCampaign;

@end

@interface SLBSMapViewData : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *zoneList;

@end
