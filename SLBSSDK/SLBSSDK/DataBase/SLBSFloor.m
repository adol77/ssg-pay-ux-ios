//
//  SLBSFloor.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "SLBSFloor.h"

@interface SLBSFloor()

@property (nonatomic, strong) NSNumber* floorId;
@property (nonatomic, strong) NSNumber* mapId;
@property (nonatomic, strong) NSNumber* companyId;
@property (nonatomic, strong) NSNumber* brandId;
@property (nonatomic, strong) NSNumber* branchId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber* validity;
@property (nonatomic, strong) NSString *regDate;
@property (nonatomic, strong) NSString *updDate;
@property (nonatomic, strong) NSString *creatorId;
@property (nonatomic, strong) NSString *editorId;
@property (nonatomic, strong) NSNumber *orderIndex;

@end

@implementation SLBSFloor

+ (NSArray *)floorsWithSources:(NSArray *)sources {
    if (sources && ([sources count] > 0)) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *source in sources) {
            SLBSFloor *entity = [SLBSFloor floorWithDictionary:source];
            if (entity) {
                [array addObject:array];
            }
        }
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

+ (SLBSFloor*)floorWithDictionary:(NSDictionary*)source {
    return [[SLBSFloor alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.floorId =      [source objectForKey:@"id"];
        self.mapId =        [source objectForKey:@"map_id"];
        self.companyId =    [source objectForKey:@"company_id"];
        self.brandId =      [source objectForKey:@"brand_id"];
        self.branchId =     [source objectForKey:@"branch_id"];
        self.name =         [source objectForKey:@"name"];
        self.desc =         [source objectForKey:@"description"];
        self.validity =     [source objectForKey:@"validity"];
        self.regDate =      [source objectForKey:@"str_reg_date"];
        self.updDate =      [source objectForKey:@"str_upd_date"];
        self.creatorId =    [source objectForKey:@"creator_id"];
        self.editorId =     [source objectForKey:@"editor_id"];
        self.orderIndex =     [source objectForKey:@"order_index"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        self.floorId =      [aDecoder decodeObjectForKey:@"id"];
        self.mapId =        [aDecoder decodeObjectForKey:@"map_id"];
        self.companyId =    [aDecoder decodeObjectForKey:@"company_id"];
        self.brandId =      [aDecoder decodeObjectForKey:@"brand_id"];
        self.branchId =     [aDecoder decodeObjectForKey:@"branch_id"];
        self.name =         [aDecoder decodeObjectForKey:@"name"];
        self.desc =         [aDecoder decodeObjectForKey:@"description"];
        self.validity =     [aDecoder decodeObjectForKey:@"validity"];
        self.regDate =      [aDecoder decodeObjectForKey:@"str_reg_date"];
        self.updDate =      [aDecoder decodeObjectForKey:@"str_upd_date"];
        self.creatorId =    [aDecoder decodeObjectForKey:@"creator_id"];
        self.editorId =     [aDecoder decodeObjectForKey:@"editor_id"];
        self.orderIndex =     [aDecoder decodeObjectForKey:@"order_index"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.floorId forKey:@"id"];
    [aCoder encodeObject:self.mapId forKey:@"map_id"];
    [aCoder encodeObject:self.companyId forKey:@"company_id"];
    [aCoder encodeObject:self.brandId forKey:@"brand_id"];
    [aCoder encodeObject:self.branchId forKey:@"branch_id"];
    [aCoder encodeObject:self.name      forKey:@"name"];
    [aCoder encodeObject:self.desc      forKey:@"description"];
    [aCoder encodeObject:self.validity  forKey:@"validity"];
    [aCoder encodeObject:self.regDate   forKey:@"str_reg_date"];
    [aCoder encodeObject:self.updDate   forKey:@"str_upd_date"];
    [aCoder encodeObject:self.creatorId forKey:@"creator_id"];
    [aCoder encodeObject:self.editorId  forKey:@"editor_id"];
    [aCoder encodeObject:self.orderIndex  forKey:@"order_index"];
}


@end
