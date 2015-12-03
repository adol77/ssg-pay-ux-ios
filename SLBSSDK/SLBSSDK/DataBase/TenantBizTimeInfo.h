//
//  tenantBizTimeInfo.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenantBizTimeInfo : NSObject

+ (TenantBizTimeInfo*)tenantBizTimeInfoWithDictionary:(NSDictionary*)source;
- (instancetype)initWithDictionary:(NSDictionary*)source;

@property (readonly) NSNumber* biz_time_id;
@property (readonly) NSNumber* tenant_id;
@property (readonly) NSNumber* branch_id;
@property (readonly) NSNumber* type;
@property (readonly) NSNumber* biz_time_type;
@property (readonly) NSString* open;
@property (readonly) NSString* close;
@property (readonly) NSNumber* weekly;
@property (readonly) NSString* biz_time_temp;

@end
