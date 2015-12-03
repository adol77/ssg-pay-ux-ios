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

//@interface SLBSMapPath : NSObject
//
//@property (nonatomic, strong) NSNumber *ID;
//@property (nonatomic, strong) NSValue *position;
//
//@end

/**
 *  zone의 표시하기 위한 정보가 담겨져 있는 객체
 */
@interface SLBSMapViewZoneData : NSObject<NSCopying>

#pragma mark - common
/**
 *  해당 zone의 고유 값
 */
@property (nonatomic, strong) NSNumber *zoneID;
/**
 *  zone data의 타입, @TSSLBSSessionType 값을 참고한다.
 */
@property (nonatomic, assign) TSSLBSSessionType type;
/**
 *  해당 zone의 canter 위치 값
 */
@property (nonatomic, assign) CGPoint currentCenter;

#pragma mark - POI Zone
/**
 *  POI를 표시하기 위한 icon resource
 */
@property (nonatomic, strong) UIImage *icon;

#pragma mark - title for Store Zone
/**
 *  해당 zone의 이름
 */
@property (nonatomic, strong) NSString *name;
/**
 *  해당 zone의 BI resource
 */
@property (nonatomic, strong) UIImage *storeBI;
/**
 *  이름이나 BI를 표시하기 위한 center 값
 */
@property (nonatomic, assign) CGPoint titleCenter;
/**
 *  이름이나 BI를 표시하기 위한 영역 값.
 */
@property (nonatomic, assign) CGRect visibleFrame;
/**
 *  이름이나 BI를 회전 시켜 표시하기 위한 radian 값
 */
@property (nonatomic, assign) CGFloat angle;

#pragma mark - area for Store Zone
/**
 *  zone의 영역을 그리기 위한 영역의 꼭지점 위치. CGPoint type의 NSValue의 object의 array이다.
 */
@property (nonatomic, strong) NSArray *polygons;
/**
 *  해당 zone에 campaing이 포함되어 있는지 여부에 다한 값
 */
@property (nonatomic, assign) BOOL containedCampaign;

@end

/**
 *  map을 표시하기 위한 정보가 담겨저 있는 객체
 */
@interface SLBSMapViewData : NSObject

/**
 *  표시될 map의 고유 값
 */
@property (nonatomic, strong) NSNumber *ID;
/**
 *  표시될 지도 배경 이미지
 */
@property (nonatomic, strong) UIImage *image;
/**
 *  표시될 지도의 zone 정보 리스트. @SLBSMapViewZoneData 객체의 array 이다.
 */
@property (nonatomic, strong) NSArray *zoneList;

@end
