//
//  MsiSensorEventProtocol.h
//  MsiStepStateFinderLib
//
//  Created by ggggura on 5/7/14.
//  Copyright (c) 2014 Nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MsiSensorEventProtocol <NSObject>
-(NSInteger)getType;
-(NSString *)getXml;
@end
