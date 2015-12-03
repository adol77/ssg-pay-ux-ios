//
//  LOCCooridnate.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOCCoordinate : NSObject

@property (readonly, nonatomic) int mapId;
@property (readonly, nonatomic) double X;
@property (readonly, nonatomic) double Y;

-(instancetype)initWithMap:(int) map X:(double)x Y:(double)y;
-(BOOL)equal:(LOCCoordinate*)pos;

@end
