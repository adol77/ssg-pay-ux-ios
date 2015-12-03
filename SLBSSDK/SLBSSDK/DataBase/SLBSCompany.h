//
//  Company.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBSCompany : NSObject <NSCoding>

- (instancetype)initWithDictionary:(NSDictionary*)source;
+ (SLBSCompany*)companyWithDictionary:(NSDictionary*)source;

@property (nonatomic, readonly, strong) NSNumber* companyId;
@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSString *address;
@property (nonatomic, readonly, strong) NSString *desc;
@property (nonatomic, readonly, strong) NSNumber* validity;
@property (nonatomic, readonly, strong) NSString *regDate;
@property (nonatomic, readonly, strong) NSString *updDate;
@property (nonatomic, readonly, strong) NSString *url;
@property (nonatomic, readonly, strong) NSString *iconUrl;
@property (nonatomic, readonly, strong) NSString *imageUrl;
@property (nonatomic, readonly, strong) NSString *creatorId;
@property (nonatomic, readonly, strong) NSString *editorId;

@end