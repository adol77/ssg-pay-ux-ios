#import <Foundation/Foundation.h>
#import "LSLocationCandidate.h"
#import "SLBSCoordination.h"

@implementation LSLocationCandidate
@synthesize weight, position;

-(instancetype)initWithPosition:(SLBSCoordination*)_position Weight:(float) _weight
{
    if ( self = [super init ]) {
        weight = _weight;
        position = _position;
    }
    return self;
}
@end
