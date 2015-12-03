//
//  SLBSMapViewData.m
//  SLBSSDK
//
//  Created by Lee muhyeon on 2015. 10. 15..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "SLBSMapViewData.h"

@implementation SLBSMapViewData


@end


@implementation SLBSMapViewZoneData

- (id)copyWithZone:(NSZone *)zone {
    SLBSMapViewZoneData* o = [[SLBSMapViewZoneData alloc] init];
    o.zoneID = self.zoneID;
    o.name = self.name;
    o.type = self.type;
    o.currentCenter = self.currentCenter;
    o.icon = self.icon;
    o.polygons = self.polygons;
    return o;
}

@end