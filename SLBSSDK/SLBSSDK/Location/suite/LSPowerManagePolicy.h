//
//  LSPowerManagePolicy.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSScanMode.h"

@interface LSPowerManagePolicy : NSObject

+(instancetype)defaultPolicy;

+(instancetype)periodicPolicy;

+(instancetype)fullPolicy;

@property (readonly, nonatomic) LSScanMode scanMode;

@end

