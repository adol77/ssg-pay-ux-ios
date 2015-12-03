//
//  MapPathViewData.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 24..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapPathViewData : NSObject

@property (readonly) long mapId;
@property (readonly) NSString* mapName;
@property (readonly) long graphId;
@property (readonly) long vertexId;
@property (readonly) NSString* vertexName;
@property (readonly) double x;
@property (readonly) double y;
@property (readonly) NSValue *position;

-(instancetype)initWithDictionary:(NSDictionary*)dictionary;
-(instancetype)initWithMapId:(long)mapId mapName:(NSString*)mapName graphId:(long)graphId vertexId:(long)vertexId vertexName:(NSString*)vertexName x:(double)x y:(double)y;
@end
