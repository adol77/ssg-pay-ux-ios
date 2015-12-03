//
//  Campaign.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/23/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Campaign : NSObject <NSCoding>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *type;   // 1 : 캠페인 팝업, 7 : 웰컴 팝업

@property (nonatomic, strong) NSNumber *campaignId;     // 캠페인 id
@property (nonatomic, strong) NSNumber *loiteringTime;  // type이 dwell일 경우, 분 단위(count로 체크)
@property (nonatomic, strong) NSNumber *receivedCount;  // 캠페인 기간내 고객당 campaign이 발행되는 최대 count
@property (readonly) NSArray *offWeeks;             // 캠페인 off 주 (ex. 1주, 2/4주)
@property (readonly) NSNumber *offDayOfWeeks;       // 캠페인 off 요일 (1: 일, 2: 월, 3:화, 4:수, 5:목, 6:금, 7:토)
@property (readonly) NSNumber *interval;            // attribute_type 테이블 조
                                                    // category: 710, child_id 1: 1회
                                                    // category: 710, child_id 2: 1일 1회
                                                    // category: 710, child_id 3: 3시간 1회
                                                    // category: 710, child_id 4: 6시간 1회
@property (nonatomic, strong) NSDate *receivedTime;  // Campaign을 받은 시간
@property (nonatomic, strong) NSNumber *zoneId;   // Campaign수신함에서 매장이동,길안내 아이콘을 위해 사용
@property (nonatomic, strong) NSNumber *zoneType;   // Campaign수신함에서 매장이동,길안내 아이콘을 표시할지 말지 결정하기 위해 사용

@property (nonatomic, strong) NSString *imageFilePath;

- (instancetype)initWithDictionary:(NSDictionary*)source;
+ (Campaign*)campaignWithDictionary:(NSDictionary*)source;

@end
