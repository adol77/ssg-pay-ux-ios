//
//  BeaconUUID.h
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 4..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconUUID : NSObject <NSCoding>

+ (BeaconUUID*)beaconUUIDWithDictionary:(NSDictionary*)source;
- (instancetype)initWithDictionary:(NSDictionary*)source;

@property (nonatomic, readonly, assign) NSNumber* company_id;
@property (nonatomic, readonly, strong) NSString* beacon_uuid;

@end
