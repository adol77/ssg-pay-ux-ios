//
//  SLBSFloor.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLBSFloor : NSObject
- (instancetype)initWithDictionary:(NSDictionary*)source;
+ (SLBSFloor*)floorWithDictionary:(NSDictionary*)source;

@property (nonatomic, readonly) NSNumber* floorId;
@property (nonatomic, readonly) NSNumber* mapId;
@property (nonatomic, readonly) NSNumber* companyId;
@property (nonatomic, readonly) NSNumber* brandId;
@property (nonatomic, readonly) NSNumber* branchId;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *desc;
@property (nonatomic, readonly) NSNumber* validity;
@property (nonatomic, readonly) NSString *regDate;
@property (nonatomic, readonly) NSString *updDate;
@property (nonatomic, readonly) NSString *creatorId;
@property (nonatomic, readonly) NSString *editorId;

@end
