//
//  tenantBizOffInfo.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TenantBizOffInfo : NSObject <NSCoding>

+ (TenantBizOffInfo*)tenantBizOffInfoWithDictionary:(NSDictionary*)source;
- (instancetype)initWithDictionary:(NSDictionary*)source;

@property (readonly) NSNumber* biz_off_id;
@property (readonly) NSNumber* tenant_id;
@property (readonly) NSNumber* branch_id;
@property (readonly) NSNumber* type;
@property (readonly) NSNumber* monthly;
@property (readonly) NSNumber* weekly;
@property (readonly) NSNumber* off_week;
@property (readonly) NSNumber* off_date;
@property (readonly) NSString* off_temp;

@end
