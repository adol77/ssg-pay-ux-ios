//
//  Company.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "SLBSCompany.h"

@interface SLBSCompany()

@property (nonatomic, strong) NSNumber* companyId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber* validity;
@property (nonatomic, strong) NSString *regDate;
@property (nonatomic, strong) NSString *updDate;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *creatorId;
@property (nonatomic, strong) NSString *editorId;

@end

@implementation SLBSCompany

+ (NSArray *)companysWithSources:(NSArray *)sources {
    if (sources && ([sources count] > 0)) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *source in sources) {
            SLBSCompany *entity = [SLBSCompany companyWithDictionary:source];
            if (entity) {
                [array addObject:array];
            }
        }
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

+ (SLBSCompany*)companyWithDictionary:(NSDictionary*)source {
    return [[SLBSCompany alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.companyId =    [source objectForKey:@"id"];
        self.name =         [source objectForKey:@"name"];
        self.address =      [source objectForKey:@"address"];
        self.desc =         [source objectForKey:@"description"];
        self.validity =     [source objectForKey:@"validity"];
        self.regDate =      [source objectForKey:@"str_reg_date"];
        self.updDate =      [source objectForKey:@"str_upd_date"];
        self.url =          [source objectForKey:@"url"];
        self.iconUrl =      [source objectForKey:@"icon_url"];
        self.imageUrl =     [source objectForKey:@"image_url"];
        self.creatorId =    [source objectForKey:@"creator_id"];
        self.editorId =     [source objectForKey:@"editor_id"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        self.companyId =    [aDecoder decodeObjectForKey:@"id"];
        self.name =         [aDecoder decodeObjectForKey:@"name"];
        self.address =      [aDecoder decodeObjectForKey:@"address"];
        self.desc =         [aDecoder decodeObjectForKey:@"description"];
        self.validity =     [aDecoder decodeObjectForKey:@"validity"];
        self.regDate =      [aDecoder decodeObjectForKey:@"str_reg_date"];
        self.updDate =      [aDecoder decodeObjectForKey:@"str_upd_date"];
        self.url =          [aDecoder decodeObjectForKey:@"url"];
        self.iconUrl =      [aDecoder decodeObjectForKey:@"icon_url"];
        self.imageUrl =     [aDecoder decodeObjectForKey:@"image_url"];
        self.creatorId =    [aDecoder decodeObjectForKey:@"creator_id"];
        self.editorId =     [aDecoder decodeObjectForKey:@"editor_id"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.companyId forKey:@"id"];
    [aCoder encodeObject:self.name      forKey:@"name"];
    [aCoder encodeObject:self.address   forKey:@"address"];
    [aCoder encodeObject:self.desc      forKey:@"description"];
    [aCoder encodeObject:self.validity  forKey:@"validity"];
    [aCoder encodeObject:self.regDate   forKey:@"str_reg_date"];
    [aCoder encodeObject:self.updDate   forKey:@"str_upd_date"];
    [aCoder encodeObject:self.url       forKey:@"url"];
    [aCoder encodeObject:self.iconUrl   forKey:@"icon_url"];
    [aCoder encodeObject:self.imageUrl  forKey:@"image_url"];
    [aCoder encodeObject:self.creatorId forKey:@"creator_id"];
    [aCoder encodeObject:self.editorId  forKey:@"editor_id"];
}


@end
