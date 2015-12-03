//
//  MapRoadSource.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 24..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSSDK_MapRoadSource_h
#define SLBSSDK_MapRoadSource_h

@protocol MapRoadSource
-(int)count:(long)mapId;
-(NSArray*)roadsInMap:(int)mapId;
@end

#endif
