//
//  Polygon.h
//  indoornowMapviewSample
//
//  Created by Lee muhyeon on 2015. 8. 20..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Location.h"

@interface Polygon : NSObject

@property (strong, nonatomic) NSNumber *pid;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *locations;

- (instancetype)initWithId:(NSNumber *)pid
                      name:(NSString *)name
                 locations:(NSArray *)locations;

/**
 * Return true if the given point is contained inside the polygon.
 * See: http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
 * @param location The Location to check
 * @return YES if the location is inside the polygon, NO otherwise
 *
 */
- (BOOL)contains:(Location *)location;

- (CGRect)boundingBox;

@end
