//
//  LOCLineSegment.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LOCCoordinate;

@interface LOCLineSegment : NSObject

-(instancetype)initWithStart:(LOCCoordinate*)start End:(LOCCoordinate*)end;

@property (readonly, nonatomic ) LOCCoordinate* startPoint;
@property (readonly, nonatomic ) LOCCoordinate* endPoint;

@end
