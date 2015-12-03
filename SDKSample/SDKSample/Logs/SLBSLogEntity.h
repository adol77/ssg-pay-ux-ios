//
//  SLBSLogEntity.h
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 15..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SLBSLogEntity : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * occurClass;
@property (nonatomic, retain) NSNumber * codeline;
@property (nonatomic, retain) NSString * selectorName;
@property (nonatomic, retain) NSNumber * group;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * reserved1;
@property (nonatomic, retain) NSString * reserved2;
@property (nonatomic, retain) NSNumber * cellHeight;

@end
