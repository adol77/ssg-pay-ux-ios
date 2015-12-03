//
//  Campaign.m
//  SDKSample
//
//  Created by Jeoungsoo on 9/23/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "Campaign.h"

@interface Campaign()

@end


@implementation Campaign


+ (Campaign*)campaignWithDictionary:(NSDictionary*)source {
    return [[Campaign alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.title =         [source objectForKey:@"title"];
        self.imageUrl =      [source objectForKey:@"image_url"];
        self.desc =          [source objectForKey:@"description"];
        self.type =          [source objectForKey:@"type"];
        
//        self.campaignId =    [source objectForKey:@"campaign_id"];
//        self.loiteringTime = [source objectForKey:@"loitering_time"];
//        self.receivedCount = [source objectForKey:@"received_count"];
//        
//        self.receivedTime = [source objectForKey:@"received_time"];
//        self.zoneId =         [source objectForKey:@"zone_id"];
//        self.zoneType =      [source objectForKey:@"zone_type"];
//        self.imageFilePath  = [source objectForKey:@"image_file_path"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        self.title =        [aDecoder decodeObjectForKey:@"title"];
        self.imageUrl =     [aDecoder decodeObjectForKey:@"image_url"];
        self.desc =         [aDecoder decodeObjectForKey:@"description"];
        self.type =         [aDecoder decodeObjectForKey:@"type"];
        
        self.campaignId =   [aDecoder decodeObjectForKey:@"campaign_id"];
        self.loiteringTime = [aDecoder decodeObjectForKey:@"loitering_time"];
        self.receivedCount = [aDecoder decodeObjectForKey:@"received_count"];
        
        self.receivedTime = [aDecoder decodeObjectForKey:@"received_time"];
        self.zoneId = [aDecoder decodeObjectForKey:@"zone_id"];
        self.zoneType = [aDecoder decodeObjectForKey:@"zone_type"];
        self.imageFilePath = [aDecoder decodeObjectForKey:@"image_file_path"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title     forKey:@"title"];
    [aCoder encodeObject:self.imageUrl  forKey:@"image_url"];
    [aCoder encodeObject:self.desc      forKey:@"description"];
    [aCoder encodeObject:self.type      forKey:@"type"];
    
    [aCoder encodeObject:self.campaignId       forKey:@"campaign_id"];
    [aCoder encodeObject:self.loiteringTime      forKey:@"loitering_time"];
    [aCoder encodeObject:self.receivedCount      forKey:@"received_count"];
    
    [aCoder encodeObject:self.receivedTime      forKey:@"received_time"];
    [aCoder encodeObject:self.zoneId      forKey:@"zone_id"];
    [aCoder encodeObject:self.zoneType      forKey:@"zone_type"];
    [aCoder encodeObject:self.imageFilePath      forKey:@"image_file_path"];
}


@end
