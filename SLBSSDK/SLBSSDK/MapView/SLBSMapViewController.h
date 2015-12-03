//
//  SLBSMapViewController.h
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 9. 16..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLBSMapViewData.h"


/**
 *  SLBSMapViewController의 - initWithFrame:resource: 함수 호출 시 전달되는 NSDictionary에 사용하는 key 값
 */
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForCurrentPosition;//Object : UIImage
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForCampaignZone;//Object : UIImage
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForDeparturePosition;//Object : UIImage
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForDestination;//Object : UIImage
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForDirection;//Object : UIImage
FOUNDATION_EXTERN const NSString *kSLBSMapViewIconForPassage;//Object : UIImage


/**
 *  SLBSMapViewController의 - setPath:positions: 함수 호출 시 전달되는 NSDictionary애 사용되는 key 값
 */
FOUNDATION_EXTERN const NSString *kSLBSMapViewNumberOfDepartureZone;//unused....
FOUNDATION_EXTERN const NSString *kSLBSMapViewNumberOfDestinationZone;//Object : NSNumber
FOUNDATION_EXTERN const NSString *kSLBSMapViewPositionOfDeparture;//Object : NSValue
FOUNDATION_EXTERN const NSString *kSLBSMapViewPositionsOfPassage;//Object : NSValue or NSValue's array
FOUNDATION_EXTERN const NSString *kSLBSMapViewPositionOfDestination;//Object : NSValue


@class SLBSMapViewController;

/**
 *  SLBSMapViewController의 이벤트 전달 protocol. SLBSMapViewController의 이벤트를 전달 받기 위해서는 상속 받아야 한다.
 */
@protocol SLBSMapViewControllerDelegate <NSObject>

/**
 *  사용자의 long press gesture에 의해 발생한다. 사용자 long press gesture가 zone 영역에서 발생하면 SLBSMapView는 delegate 함수를 호출하여 선택 표시를 할지 물어본다.
 *
 *  @param controller 터치 이벤트가 발생한 SLBSMapView를 소유하고 있는 SLBSMapViewController 객체
 *  @param zoneID     사용자에 의해 long press gesture가 발생한 영역에 위치하는 zone의 고유 번호 값
 *
 *  @return YES를 돌려 줄 경우 SLBSMapView는 해당 zone 영역을 선택 표시 처리한다. NO값이 돌려 질 경우 해당 이벤트는 무시된다.
 */
- (BOOL)controller:(SLBSMapViewController *)controller willSelectedZone:(NSNumber *)zoneID;
/**
 *  SLBSMapView에 사용자 터치 이벤트가 발생이 되면 호출 된다. UIGestureRecognizer의 UIGestureRecognizerStateBegan 이벤트 발생 시 호출된다.
 *
 *  @param controller 터치 이벤트가 발생한 SLBSMapView를 소유하고 있는 SLBSMapViewController 객체
 */
- (void)touchedMapViewWithController:(SLBSMapViewController *)controller;

@end

/**
 *  SLBSMapView의 controller 객체.
 *  SLBSMapViewController의 함수를 이용하여 SLBSMapView를 갱신하고 데이터를 설정할 때 사용되는 객체이다.
 *  SLBSMapViewController는 단 하나의 SLBSMapView와 대응된다.
 */
@interface SLBSMapViewController : NSObject

#pragma mark - initialize
/**
 *  SLBSMapViewController 객체 초기화 함수. frame 값과 resource를 이용하여 MapView를 생성한다.
 *
 *  @param frame    생성될 MapView의 frame 값.
 *  @param resource Mapview에서 사용될 아이콘 정보.
 *
 *  @return SLBSMapViewController 객체
 */
- (instancetype)initWithFrame:(CGRect)frame resource:(NSDictionary *)resource;

/**
 *  SLBSMapViewControllerDelegate를 상속 받은 객체.
 */
@property (nonatomic, weak) id<SLBSMapViewControllerDelegate> delegate;

/**
 *  SLBSMapViewController가 생성한 SLBSMapView 객체
 *  Application에서는 이 프로퍼티를 통해서 전달 받은 UIView 객체를 다른 UIView 영역에 addSubView를 하여 map을 표시하도록 한다.
 */
@property (nonatomic, readonly) UIView *mapViewControl;

/**
 *  SLBSMapView에서 사용될 icon등의 resource가 담겨져 있는 NSDictionary 객체
 */
@property (nonatomic, readonly) NSDictionary *resources;
/**
 *  SLBSMapView에서 사용될 icon등의 resource를 추가하는 함수. 이 함수가 호출되면 기존에 있던 resource가 교체되거나 추가된다.
 *
 *  @param resource 신규로 추가 또는 교체를 원하는 resource의 key와 UIimage object가 담겨져 있는 dictionary 객체
 */
- (void)addResourceObject:(NSDictionary *)resource;

/**
 *  새로운 map 데이터를 로딩하기 위해 호출하는 함수.
 *  이 험수가 호출되면 기존 정보는 모두 초기화 되고 새로 전달되는 map 데이터를 이용하여 초기 화면을 완성 시킨다.
 *
 *  @param 보여질 data map 이미지와 zone 데이터들이 담겨져 있는 객체
 */
- (void)shouldLoadMapData:(SLBSMapViewData *)data;

/**
 *  표시되고 있는 map의 고유 번호 값
 */
@property (nonatomic, strong) NSNumber *mapID;
/**
 *  표시되고 있는 map의 기본 이미지 데이터
 */
@property (nonatomic, strong) UIImage *mapImage;

//- (void)setZones:(NSArray *)zones;
/**
 *  표시되고 있는 map의 SLBSMapViewZoneData 객체의 array
 *  - shouldLoadMapData:에서 전달된 객체이다.
 */
@property (nonatomic, readonly) NSArray *zones;

/**
 *  표시되고 있는 SLBSMapViewZoneData 객체 중 전달되는 id 값에 해당하는 객체를 돌려준다
 *
 *  @param zoneID 전달받고 싶은 zone의 고유 번호 값
 *
 *  @return 전달된 zoneid에 의해 검색된 SLBSMapViewZoneData 객체
 */
- (SLBSMapViewZoneData *)zoneDataAtID:(NSNumber *)zoneID;

/**
 *  SLBSMapViewZoneData 리스트 중 poi 표시 형식의 SLBSMapViewZoneData 리스트
 */
@property (readonly) NSArray *poiZoneList;
/**
 *  SLBSMapViewZoneData 리스트 중 polygon 표시 형식의 SLBSMapViewZoneData 리스트
 */
@property (readonly) NSArray *storeZoneList;

//#pragma mark - transform
//@property (readonly) SLBSTransform3Ds *transforms;

#pragma mark - path
/**
 *  map 위에 경로 및 기타 위치 정보를 표시하기 위한 함수
 *
 *  @param path      경로 위치 정보인 CGPoint 값이 담겨져 있는 NSValue object의 array
 *  @param positions 출발지, 목적지, 경유지, 목적 zone 표시 정보가 담겨져 있는 dictionary
 */
- (void)setPath:(NSArray *)path positions:(NSDictionary *)positions;
/**
 *  map에 표시되어 있는 경로를 지운다.
 */
- (void)removePath;
/**
 *  표시되고 있는 경로의 정보들. CGPoint type의 NSValue array이다.
 */
@property (nonatomic, readonly) NSArray *paths;
/**
 *  표시되고 있는 위치 정보들, 출발지, 목적지, 경유지, 목적 zone
 */
@property (nonatomic, readonly) NSDictionary *positions;
/**
 *  위치 정보를 추가하기 위한 함수. 이 함수가 호출되면 기존에 있던 위치 정보가 교체되거나 추가된다.
 *
 *  @param object 신규로 추가 또는 교체를 원하는 위치 정보의 key와 NSValue 또는 NSArray object가 담겨져 있는 dictionary 객체
 */
- (void)addPositionObject:(NSDictionary *)object;

/**
 *  경로로 그려질 선의 두께. 기본값은 6 이다.
 */
@property (nonatomic, assign) CGFloat pathLineWidth;
/**
 *  경로로 그려질 선의 색상. 기본값은 20% alpha인 whiteColor 이다.
 */
@property (nonatomic, strong) UIColor *pathStrokeColor;

#pragma mark - departure/destination in path
/**
 *  출발지 위치 정보
 */
@property (nonatomic, readonly) NSValue *departurePosition;
/**
 *  목적지 위치 정보
 */
@property (nonatomic, readonly) NSValue *destinationPosition;
/**
 *  경유지 위치 정보들, NSValue object의 array이다.
 */
@property (nonatomic, readonly) NSArray *passagePositions;
/**
 *  출발지를 표시하기 위한 icon resource
 */
@property (nonatomic, readonly) UIImage *pathDepartureIcon;
/**
 *  목적지를 표시하기 위한 icon resource
 */
@property (nonatomic, readonly) UIImage *pathDestinationIcon;
/**
 *  경로의 방향을 표시하기 위한 icon resource
 */
@property (nonatomic, readonly) UIImage *pathDirectionIcon;
/**
 *  경유지를 표시하기 위한 icon resource
 */
@property (nonatomic, readonly) UIImage *pathPassageIcon;
/**
 *  경로 방향 표시 이미지의 사이 간격 값. 기본값은 25 이다.
 */
@property (nonatomic, assign)   CGFloat pathDirectionIconInterval;
/**
 *  출발 zone 영역 고유 번호 값
 */
@property (nonatomic, readonly) NSNumber *departureZoneNumber;
/**
 *  도작 zone 영역 고유 번호 값
 */
@property (nonatomic, readonly) NSNumber *destinationZoneNumber;

#pragma mark - user location
/**
 *  현제 위치를 표시하기 위한 icon resource
 */
@property (nonatomic, readonly) UIImage *currentLocationIcon;
/**
 *  현재 위치 표시를 갱신하기 위한 함수. 함수를 호출하면
 *
 *  @param position 현재 위치를 표시하기 위한 값
 *  @param move     map의 중심까지 이동할 것인지에 대한 인자. YES일 경우 map view의 center 표시 위치가 자동으로 변경 된다.
 */
- (void)updateCurrentPosition:(CGPoint)position moveCenter:(BOOL)move;

#pragma mark - selected zone display
/**
 *  현재 선택되어 있는 zone의 고유 번호
 */
@property (nonatomic, strong) NSNumber *selectedZoneNumber;
/**
 *  선택된 zone의 영역을 표시하는 선의 색상. 기본값은 #982424 이다.
 */
@property (nonatomic, strong) UIColor *selectedStrokeColor;
/**
 *  선택된 zone의 영역을 표시하는 선의 두께. 기본값은 4이다.
 */
@property (nonatomic, assign) CGFloat selectedStrokeLineWidth;

#pragma mark - campaing zone display
/**
 *  campaign이 포함되어 있는 zone을 표시하기 위한 icon resource
 */
@property (nonatomic, readonly) UIImage *campaignZoneIcon;
/**
 *  campaing이 포함되어 있는 zone을 표시하기 위한 선의 색상, 기본값은 #37a07c 이다.
 */
@property (nonatomic, strong) UIColor *campaignStrokeColor;
/**
 *  campaing이 포함되어 있는 zone을 표시하기 위한 선의 두께. 기본값은 2 이다.
 */
@property (nonatomic, assign) CGFloat campaignStrokeLineWidth;

#pragma mark - title for zone display
/**
 *  title 글자 축소 시 최소한으로 줄여질 scale 값, 기본값은 0.2 이다.
 */
@property (nonatomic, assign) CGFloat minimumFontScale;
/**
 *  title 글자 축소 시 최소한으로 줄여질 font 크기 값. maximumFontSize에 minimumFontScale 값이 조합된 값이 기본값으로 설정된다.
 */
@property (nonatomic, assign) CGFloat minimumFontSize;
/**
 *  title 글자 표시할 때 기본적으로 표시될 font의 size 값. 기본값은 19 이다.(레티나 기준이므로 원래의 기준값은 38이다.)
 */
@property (nonatomic, assign) CGFloat maximumFontSize;
/**
 *  zone의 이름을 표시하기 위한 텍스트의 font
 */
@property (nonatomic, strong) UIFont *titleFont;
/**
 *  출발 zone의 이름을 표시하기 위한 텍스트의 font
 */
@property (nonatomic, strong) UIFont *pathDepartureTitleFont;
/**
 *  도착 zone의 이름을 표시하기 위한 텍스트의 font
 */
@property (nonatomic, strong) UIFont *pathDestinationTitleFont;


/**
 *  zone title을 표시할 때의 color 값. 기본값은 whiteColor 이다.
 */
@property (nonatomic, strong) UIColor *titleColor;
/**
 *  출발지 zone title을 표시할 때의 color 값. 기본값은 yellowColor 이다.
 */
@property (nonatomic, strong) UIColor *pathDepartureTitleColor;
/**
 *  목적지 zone title을 표시할 때의 color 값. 기본값은 yellowColor 이다.
 */
@property (nonatomic, strong) UIColor *pathDestinationTitleColor;


////////////////////old interface
//#pragma mark - basic data
//- (void)setPaths:(NSArray *)paths DEPRECATED_MSG_ATTRIBUTE("Replaced by setPath:positions: method");
//- (void)setPaths:(NSArray*)paths departurePosition:(NSValue *)departure destinationPosition:(NSValue *)destination DEPRECATED_MSG_ATTRIBUTE("Replaced by setPath:positions: method");

@end


