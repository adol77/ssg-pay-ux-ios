//
//  BLELocationExaminer.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#pragma once

@class SLBSCoordination;

@protocol BLELocationExaminerListener
-(void)onLocationSelected:(SLBSCoordination*)coordinate;
@end

@protocol BLELocationExaminer
-(void)findLocation:(NSArray*)candidateList;
@end
