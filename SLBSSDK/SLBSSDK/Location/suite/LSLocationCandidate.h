#pragma once

@class SLBSCoordination;

@interface LSLocationCandidate : NSObject

-(instancetype)initWithPosition:(SLBSCoordination*)position Weight:(float) weight;

@property (readonly, nonatomic) float weight;
@property (readonly, nonatomic) SLBSCoordination* position;
@end
