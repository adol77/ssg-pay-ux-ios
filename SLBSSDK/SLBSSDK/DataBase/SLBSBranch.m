//
//  SLBSBranch.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "SLBSBranch.h"
#import "TenantBizOffInfo.h"
#import "TenantBizTimeInfo.h"

@interface SLBSBranch()

@property (nonatomic, strong) NSNumber* branchId;
@property (nonatomic, strong) NSNumber* companyId;
@property (nonatomic, strong) NSNumber* brandId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSNumber* active;   // 1: 영업중, 2: 공사중
@property (nonatomic, strong) NSString* brandName;
@property (nonatomic, strong) NSString* companyName;
@property (nonatomic, strong) NSNumber* default_floor_id;
@property (nonatomic, strong) NSNumber* rootbranch_id;
@property (nonatomic, strong) NSArray* branch_biz_off_list;
@property (nonatomic, strong) NSArray* branch_biz_time_list;

@end

@implementation SLBSBranch

+ (NSArray *)branchsWithSources:(NSArray *)sources {
    if (sources && ([sources count] > 0)) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *source in sources) {
            SLBSBranch *entity = [SLBSBranch branchWithDictionary:source];
            if (entity) {
                [array addObject:array];
            }
        }
        return [NSArray arrayWithArray:array];
    }
    return nil;
}

+ (SLBSBranch*)branchWithDictionary:(NSDictionary*)source {
    return [[SLBSBranch alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.branchId =     [source objectForKey:@"id"];
        self.companyId =    [source objectForKey:@"company_id"];
        self.brandId =      [source objectForKey:@"brand_id"];
        self.name =         [source objectForKey:@"name"];
        self.address =      [source objectForKey:@"address"];
        self.desc =         [source objectForKey:@"description"];
        self.imageUrl =     [source objectForKey:@"image_url"];
        self.iconUrl =      [source objectForKey:@"icon_url"];
        self.active =       [source objectForKey:@"active"];
        self.brandName =    [source objectForKey:@"brand_name"];
        self.companyName =  [source objectForKey:@"company_name"];
        self.default_floor_id = [source objectForKey:@"default_floor_id"];
        self.rootbranch_id = [source objectForKey:@"rootbranch_id"];
        
        NSArray* tenantBizOffList = [source objectForKey:@"biz_off_list"];
        NSMutableArray* bizoffArray = [NSMutableArray array];
        for(NSDictionary* bizOffDic in tenantBizOffList) {
            TenantBizOffInfo* tenantOffInfo = [TenantBizOffInfo tenantBizOffInfoWithDictionary:bizOffDic];
            [bizoffArray addObject:tenantOffInfo];
        }
        self.branch_biz_off_list = [bizoffArray copy];
        
        NSArray* tenantBizTimeList = [source objectForKey:@"biz_time_list"];
        NSMutableArray* bizTimeArray = [NSMutableArray array];
        for(NSDictionary* bizTimeDic in tenantBizTimeList) {
            TenantBizTimeInfo* tenantTimeInfo = [TenantBizTimeInfo tenantBizTimeInfoWithDictionary:bizTimeDic];
            [bizTimeArray addObject:tenantTimeInfo];
        }
        self.branch_biz_time_list = [bizTimeArray copy];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self) {
        self.branchId =     [aDecoder decodeObjectForKey:@"id"];
        self.companyId =    [aDecoder decodeObjectForKey:@"company_id"];
        self.brandId =      [aDecoder decodeObjectForKey:@"brand_id"];
        self.name =         [aDecoder decodeObjectForKey:@"name"];
        self.address =      [aDecoder decodeObjectForKey:@"address"];
        self.desc =         [aDecoder decodeObjectForKey:@"description"];
        self.imageUrl =     [aDecoder decodeObjectForKey:@"image_url"];
        self.iconUrl =      [aDecoder decodeObjectForKey:@"icon_url"];
        self.active =       [aDecoder decodeObjectForKey:@"active"];
        self.brandName =    [aDecoder decodeObjectForKey:@"brand_name"];
        self.companyName =  [aDecoder decodeObjectForKey:@"company_name"];
        self.default_floor_id = [aDecoder decodeObjectForKey:@"default_floor_id"];
        self.rootbranch_id = [aDecoder decodeObjectForKey:@"rootbranch_id"];
        self.branch_biz_off_list = [aDecoder decodeObjectForKey:@"biz_off_list"];
        self.branch_biz_time_list = [aDecoder decodeObjectForKey:@"biz_time_list"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.branchId forKey:@"id"];
    [aCoder encodeObject:self.companyId      forKey:@"company_id"];
    [aCoder encodeObject:self.brandId   forKey:@"brand_id"];
    [aCoder encodeObject:self.name      forKey:@"name"];
    [aCoder encodeObject:self.address  forKey:@"address"];
    [aCoder encodeObject:self.desc   forKey:@"description"];
    [aCoder encodeObject:self.imageUrl  forKey:@"image_url"];
    [aCoder encodeObject:self.iconUrl   forKey:@"icon_url"];
    [aCoder encodeObject:self.active   forKey:@"active"];
    [aCoder encodeObject:self.brandName      forKey:@"brand_name"];
    [aCoder encodeObject:self.companyName  forKey:@"company_name"];
    [aCoder encodeObject:self.default_floor_id   forKey:@"default_floor_id"];
    [aCoder encodeObject:self.rootbranch_id  forKey:@"rootbranch_id"];
    [aCoder encodeObject:self.branch_biz_off_list   forKey:@"biz_off_list"];
    [aCoder encodeObject:self.branch_biz_time_list   forKey:@"biz_time_list"];
}
@end

