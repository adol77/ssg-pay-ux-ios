//
//  MapCommandProtocol.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/27/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapCommandDelegate <NSObject>

-(void)moveToStore:(NSNumber*)zoneId;
-(void)directToStore:(NSNumber*)zoneId;

@end

