//
//  tenantBizOffInfo.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "TenantBizOffInfo.h"

@interface TenantBizOffInfo()

@property (nonatomic, assign) NSNumber* biz_off_id;
@property (nonatomic, assign) NSNumber* tenant_id;
@property (nonatomic, assign) NSNumber* branch_id;
@property (nonatomic, assign) NSNumber* type;
@property (nonatomic, assign) NSNumber* monthly;
@property (nonatomic, assign) NSNumber* weekly;
@property (nonatomic, assign) NSNumber* off_week;
@property (nonatomic, assign) NSNumber* off_date;
@property (nonatomic, strong) NSString* off_temp;
@end

/*
 biz_off_list: [3]
 0:  {
 weekly: 2
 off_week: 7
 str_reg_date: "2015-10-13"
 str_upd_date: "2015-10-13"
 tenant_id: -1
 type: 1
 monthly: 2
 creator_id: 1
 id: 5
 off_temp: ""
 off_date: 0
 validity: 1
 editor_id: 1
 branch_id: 7
 }-
 1:  {
 weekly: 1
 off_week: 6
 str_reg_date: "2015-10-13"
 str_upd_date: "2015-10-13"
 tenant_id: -1
 type: 1
 monthly: 2
 creator_id: 1
 id: 6
 off_temp: ""
 off_date: 0
 validity: 1
 editor_id: 1
 branch_id: 7
 }-
 2:  {
 weekly: 0
 off_week: 0
 str_reg_date: "2015-10-13"
 str_upd_date: "2015-10-13"
 tenant_id: -1
 type: 2
 monthly: 0
 creator_id: 1
 id: 7
 off_temp: "2015/10/16"
 off_date: 0
 validity: 1
 editor_id: 1
 branch_id: 7
 }
 */

@implementation TenantBizOffInfo

+ (TenantBizOffInfo*)tenantBizOffInfoWithDictionary:(NSDictionary*)source {
    return [[TenantBizOffInfo alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.biz_off_id = [source objectForKey:@"id"];
        self.tenant_id = [source objectForKey:@"tenant_id"];
        self.branch_id = [source objectForKey:@"branch_id"];
        self.type = [source objectForKey:@"type"];
        self.monthly = [source objectForKey:@"monthly"];
        self.weekly = [source objectForKey:@"weekly"];
        self.off_week = [source objectForKey:@"off_week"];
        self.off_date = [source objectForKey:@"off_date"];
        self.off_temp = [source objectForKey:@"off_temp"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.biz_off_id = [aDecoder decodeObjectForKey:@"id"];
        self.tenant_id = [aDecoder decodeObjectForKey:@"tenant_id"];
        self.branch_id = [aDecoder decodeObjectForKey:@"branch_id"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.monthly = [aDecoder decodeObjectForKey:@"monthly"];
        self.weekly = [aDecoder decodeObjectForKey:@"weekly"];
        self.off_week = [aDecoder decodeObjectForKey:@"off_week"];
        self.off_date = [aDecoder decodeObjectForKey:@"off_date"];
        self.off_temp = [aDecoder decodeObjectForKey:@"off_temp"];

    }
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.biz_off_id forKey:@"id"];
    [aCoder encodeObject:self.tenant_id forKey:@"tenant_id"];
    [aCoder encodeObject:self.branch_id forKey:@"branch_id"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.monthly forKey:@"monthly"];
    [aCoder encodeObject:self.weekly forKey:@"weekly"];
    [aCoder encodeObject:self.off_week forKey:@"off_week"];
    [aCoder encodeObject:self.off_date forKey:@"off_date"];
    [aCoder encodeObject:self.off_temp forKey:@"off_temp"];
    
}

@end
