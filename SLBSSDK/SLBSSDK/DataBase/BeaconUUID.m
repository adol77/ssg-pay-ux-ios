//
//  BeaconUUID.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 4..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "BeaconUUID.h"
#import "NSString+SafeCreation.h"

@interface BeaconUUID ()
@property (nonatomic, assign) NSNumber* company_id;
@property (nonatomic, strong) NSString* beacon_uuid;
@end

@implementation BeaconUUID

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.company_id = [source objectForKey:@"company_id"];
        NSString* beacon_uuid = [source objectForKey:@"uuid"];
        self.beacon_uuid = beacon_uuid;
    }
    return self;
}

+(BeaconUUID *)beaconUUIDWithDictionary:(NSDictionary *)source {
    return [[BeaconUUID alloc] initWithDictionary:source];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.company_id = [aDecoder decodeObjectForKey:@"company_id"];
        self.beacon_uuid = [aDecoder decodeObjectForKey:@"beacon_uuid"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.company_id forKey:@"company_id"];
    [aCoder encodeObject:self.beacon_uuid forKey:@"beacon_uuid"];

}

@end
