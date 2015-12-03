//
//  SLBSBrand.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBSBrand : NSObject

- (instancetype)initWithDictionary:(NSDictionary*)source;
+ (SLBSBrand*)brandWithDictionary:(NSDictionary*)source;

@property (nonatomic, readonly) NSNumber* brandId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *address;
@property (nonatomic, readonly) NSString *desc;
@property (nonatomic, readonly) NSNumber* validity;
@property (nonatomic, readonly) NSString *regDate;
@property (nonatomic, readonly) NSString *updDate;
@property (nonatomic, readonly) NSString *url;
@property (nonatomic, readonly) NSString *iconUrl;
@property (nonatomic, readonly) NSString *imageUrl;
@property (nonatomic, readonly) NSString *creatorId;
@property (nonatomic, readonly) NSString *editorId;

@end
