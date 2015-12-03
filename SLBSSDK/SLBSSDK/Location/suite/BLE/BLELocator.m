//
//  BLELocator.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 8. 27..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "BLELocator.h"
//#import "LOCCoordinate.h"
#import "LSLocationCandidate.h"
#import "BLEBeaconSession.h"
#import "BLEBeaconInfo.h"
#import "BeaconDataManager.h"
#import "SLBSCoordination.h"
#import "SLBSKitDefine.h"
#import "TSDebugLogManager.h"

#define MINIMUN_CANDIDATE_COUNT (3)

@interface BLELocator()
-(NSMutableArray*)buildCandidates:(NSArray*)session;
-(int)findMajorMap:(NSArray*)candidates;
-(void)removeLocation:(NSMutableArray*)candidates NotIn:(int)map;
-(float)calcWeight:(float)rssi;
@property NSMutableArray* coordinationList;
@end


@implementation BLELocator

@synthesize beaconLocationSource, sessionSource, listener;



-(void)tick:(long)currentTimeInMillis
{
    if ( listener == nil || beaconLocationSource == nil || sessionSource == nil ) return;
    
    NSArray* sessions = [sessionSource strongestBeaconScans:10];
    if ( sessions == nil ) return;
    if( sessions.count == 0 ) return;
    
    NSMutableArray* candidates = [self buildCandidates:sessions];
    int majorMapId = [self findMajorMap:candidates];
    [self removeLocation:candidates NotIn:majorMapId];
    if ( candidates.count < MINIMUN_CANDIDATE_COUNT ) return;

    [listener findLocation:candidates];
}


-(NSMutableArray*)buildCandidates:(NSArray*)session
{
    NSMutableArray* retArr = [NSMutableArray arrayWithCapacity:session.count];
    
    for (id o in session) {
        const BLEBeaconSession* s = o;
        SLBSCoordination* c = [beaconLocationSource findBeaconLocation:s.beaconInfo];
        float w = [self calcWeight:s.avgRssi];
        LSLocationCandidate* lc = [[LSLocationCandidate alloc] initWithPosition:c Weight:w];
        [retArr addObject:lc];
        
        TSGLog(TSLogGroupLocation, @"candidate x:%f, y:%f w:%f(%f)",
               c.x, c.y, w, s.avgRssi);
        NSLog(@"candidate %d: x:%f, y:%f w:%f(%f)", s.beaconInfo.minor,
              c.x, c.y, w, s.avgRssi);

    }
    return retArr;
}

static int incrCount(NSMutableDictionary* dict, int key)
{
    NSNumber* k = [NSNumber numberWithInt:key];
    NSNumber* o = [dict objectForKey:k];
    int newVal = o.intValue + 1;
    NSNumber* n = [NSNumber numberWithInt:newVal];
    [dict setObject:n forKey:k];
    return newVal;
}

-(int)findMajorMap:(NSArray*)candidates
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    int max = 0;
    int majorMap = 0;
    
    for (id o in candidates) {
        const LSLocationCandidate* c = o;
        const int m = [c.position.floorID intValue];
        int n = incrCount(dict, m);
        if ( n > max ) {
            max = n;
            majorMap = m;
        }
    }
    return majorMap;
}

-(void)removeLocation:(NSMutableArray*)candidates NotIn:(int)map
{
    NSPredicate* predicate = [NSPredicate predicateWithBlock:^BOOL(id o, NSDictionary* bindings){
        const LSLocationCandidate* c = o;
        return ( [c.position.floorID intValue] == map );
    }];
    
    [candidates filterUsingPredicate:predicate];
    
}

-(float)calcWeight:(float)rssi
{
    if ( rssi >= -70.f ) return (rssi + 70.f) * 20.f + 130.f;
    if ( rssi >= -75.f ) return (rssi + 75.f) * 12.f + 70.f;
    if ( rssi >= -80.f ) return (rssi + 80.f) * 8.f + 30.f;
    if ( rssi >= -85.f ) return (rssi + 85.f) * 4.f + 10.f;
    if ( rssi >= -90.f ) return (rssi + 90.f) * 2.f;
    return 0.f;
}

- (SLBSCoordination *)findBeaconLocation:(BLEBeaconInfo *)beacon {
    if(self.coordinationList == nil)
        self.coordinationList = [NSMutableArray array];
    
    Beacon* searchBeacon = [[BeaconDataManager sharedInstance] beaconForUUID:beacon.uuid major:[NSNumber numberWithInt:beacon.major] minor:[NSNumber numberWithInt:beacon.minor]];

    SLBSCoordination* coordination;
    
    if(self.coordinationList.count > 0) {
        NSArray* fetchResults = [self.coordinationList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"companyID == %@ and branchID == %@ and floorID == %@ and mapID == %@ and x == %f and y == %f", searchBeacon.loc_company_id, searchBeacon.loc_branch_id, searchBeacon.loc_floor_id, searchBeacon.loc_map_id, searchBeacon.loc_x, searchBeacon.loc_y]];
        
        
        if(fetchResults.count > 0) {
            coordination = [fetchResults objectAtIndex:0];
            return coordination;
        }
    }
       
   
        coordination = [[SLBSCoordination alloc] init];
        
        coordination.companyID = searchBeacon.loc_company_id;
        coordination.branchID = searchBeacon.loc_branch_id;
        coordination.floorID = searchBeacon.loc_floor_id;
        coordination.mapID = searchBeacon.loc_map_id;
        coordination.x = searchBeacon.loc_x;
        coordination.y = searchBeacon.loc_y;
        coordination.type = SLBSCoordBeacon;
        
        [self.coordinationList addObject:coordination];
        
        return coordination;

    
  }

@end
