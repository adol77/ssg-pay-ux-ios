//
//  tenantBizTimeInfo.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "TenantBizTimeInfo.h"

@interface TenantBizTimeInfo()
@property (nonatomic, strong) NSNumber* biz_time_id;
@property (nonatomic, strong) NSNumber* tenant_id;
@property (nonatomic, strong) NSNumber* branch_id;
@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, strong) NSNumber* biz_time_type;
@property (nonatomic, strong) NSString* open;
@property (nonatomic, strong) NSString* close;
@property (nonatomic, strong) NSNumber* weekly;
@property (nonatomic, strong) NSString* biz_time_temp;

@end

/*
 biz_time_list: [2]
 0:  {
 id: 3
 open: "09:00"
 str_reg_date: "2015-10-13"
 str_upd_date: "2015-10-13"
 validity: 1
 biz_time_type: 1
 tenant_id: -1
 editor_id: 1
 biz_time_temp: ""
 type: 1
 creator_id: 1
 branch_id: 7
 close: "18:00"
 }-
 1:  {
 id: 4
 open: ""
 str_reg_date: "2015-10-13"
 str_upd_date: "2015-10-13"
 validity: 1
 biz_time_type: -1
 tenant_id: -1
 editor_id: 1
 biz_time_temp: "오늘 09:00 ~ 10:00"
 type: 2
 creator_id: 1
 branch_id: 7
 close: ""
 }
 */

@implementation TenantBizTimeInfo

+ (TenantBizTimeInfo*)tenantBizTimeInfoWithDictionary:(NSDictionary*)source {
    return [[TenantBizTimeInfo alloc] initWithDictionary:source];
}

- (instancetype)initWithDictionary:(NSDictionary *)source {
    self = [super init];
    if(self) {
        self.biz_time_id = [source objectForKey:@"id"];
        self.tenant_id = [source objectForKey:@"tenant_id"];
        self.branch_id = [source objectForKey:@"branch_id"];
        self.type = [source objectForKey:@"type"];
        self.biz_time_type = [source objectForKey:@"biz_time_type"];
        self.weekly = [source objectForKey:@"weekly"];
        self.open = [source objectForKey:@"open"];
        self.close = [source objectForKey:@"close"];
        self.biz_time_temp = [source objectForKey:@"biz_time_temp"];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if(self) {
        self.biz_time_id = [aDecoder decodeObjectForKey:@"id"];
        self.tenant_id = [aDecoder decodeObjectForKey:@"tenant_id"];
        self.branch_id = [aDecoder decodeObjectForKey:@"branch_id"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.biz_time_type = [aDecoder decodeObjectForKey:@"biz_time_type"];
        self.weekly = [aDecoder decodeObjectForKey:@"weekly"];
        self.open = [aDecoder decodeObjectForKey:@"open"];
        self.close = [aDecoder decodeObjectForKey:@"close"];
        self.biz_time_temp = [aDecoder decodeObjectForKey:@"biz_time_temp"];
        
    }
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.biz_time_id forKey:@"id"];
    [aCoder encodeObject:self.tenant_id forKey:@"tenant_id"];
    [aCoder encodeObject:self.branch_id forKey:@"branch_id"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.biz_time_type forKey:@"biz_time_type"];
    [aCoder encodeObject:self.weekly forKey:@"weekly"];
    [aCoder encodeObject:self.open forKey:@"open"];
    [aCoder encodeObject:self.close forKey:@"close"];
    [aCoder encodeObject:self.biz_time_temp forKey:@"biz_time_temp"];
    
}

@end
