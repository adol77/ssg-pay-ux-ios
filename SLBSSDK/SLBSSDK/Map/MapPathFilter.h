//
//  MapPathFilter.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 10. 2..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapPathViewData.h"

NSArray* MapPathFilter(NSArray* mapPathViewDataArray);

double calcMapPathDir(MapPathViewData* p1, MapPathViewData* p2);