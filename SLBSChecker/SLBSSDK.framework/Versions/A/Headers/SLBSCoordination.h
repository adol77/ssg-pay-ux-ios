//
//  SLBSCoordination.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SLBSCoordType) {
    SLBSCoordBeacon = 0,
    SLBSCoordGPS,
};

@class SLBSCoordination;
@interface SLBSCoordination : NSObject

@property (nonatomic, assign) NSNumber* companyID;
@property (nonatomic, assign) NSNumber* branchID;
@property (nonatomic, assign) NSNumber* floorID;
@property (nonatomic, assign) NSNumber* mapID;
@property (nonatomic, assign) NSNumber* type; //ble, geofence
@property (nonatomic) double x;
@property (nonatomic) double y;

- (instancetype)initWithCoordination:(SLBSCoordination*)coordination X:(double)x Y:(double)y;

@end
