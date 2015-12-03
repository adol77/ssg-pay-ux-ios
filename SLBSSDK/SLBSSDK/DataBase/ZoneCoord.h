//
//  ZoneCoord.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZoneCoord : NSObject <NSCoding>

+ (ZoneCoord*)zoneCoordWithDictionary:(NSDictionary*)source;
- (instancetype)initWithDictionary:(NSDictionary*)source;

@property (nonatomic, readonly, assign) double x;
@property (nonatomic, readonly, assign) double y;
@property (nonatomic, readonly, assign) NSNumber* zone_id;
@property (nonatomic, readonly, assign) NSNumber* coord_id;
@property (nonatomic, readonly, assign) NSNumber* order;

@end
