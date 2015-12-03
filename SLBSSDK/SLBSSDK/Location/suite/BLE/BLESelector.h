//
//  BLESelector.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLELocationExaminer.h"

/**
 * LOCLocationCandidate 들 근거로 최종위치를 산출한다.
 * 현재 방식은 가중 합을 구하는 것.
 */
@interface BLESelector : NSObject<BLELocationExaminer>

-(void)findLocation:(NSArray*)candidateList;
@property (weak) id<BLELocationExaminerListener> listener;

@end
