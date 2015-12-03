//
//  MapImageCache.m
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 16..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "MapImageCache.h"
#include "unistd.h"
#include "dirent.h"
#include "sys/stat.h"

@interface MapImageCacheEntry : NSObject
@property NSString* cachePath;
@end

@implementation MapImageCacheEntry
@end

@implementation MapImageCache {
    NSMutableDictionary* mImageMap;
}

bool checkAndCreateCacheDir()
{
    DIR* dir;
    //const char* CACHE_DIR = "/Library/Caches/com.ssg.platform.lbs.SampleApp";
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    const char* CACHE_DIR = [directory UTF8String];
    
    dir = opendir(CACHE_DIR);
    if ( dir == NULL ) {
        mkdir(CACHE_DIR, S_IRWXU);
        dir = opendir(CACHE_DIR);
    }
    if (dir == NULL) return false;
    
    closedir(dir);
    return true;
}

-(void) saveCacheTable
{
    if ( !checkAndCreateCacheDir() ) return;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CACHE_FILE = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"table.txt"]];
    
    //NSString* CACHE_FILE = [tableName UTF8String];
    NSFileHandle* h = [NSFileHandle fileHandleForWritingAtPath:CACHE_FILE];
    if (h == nil) {
        [[NSFileManager defaultManager] createFileAtPath:CACHE_FILE contents:nil attributes:nil];
        h = [NSFileHandle fileHandleForWritingAtPath:CACHE_FILE];
        if ( h == nil ) return;
    }
    NSEnumerator* e = [mImageMap keyEnumerator];
    NSString* url;
    while((url = [e nextObject])) {
        MapImageCacheEntry* entry = [mImageMap objectForKey:url];
        NSString* cachePath = entry.cachePath;
        
        [h writeData:[url dataUsingEncoding:NSUTF8StringEncoding]];
        [h writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [h writeData:[cachePath dataUsingEncoding:NSUTF8StringEncoding]];
        [h writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [h closeFile];
}

-(BOOL) loadCacheTable;
{
    [mImageMap removeAllObjects];
    
    if ( !checkAndCreateCacheDir() ) return NO;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *CACHE_FILE = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"table.txt"]];
    
    NSFileHandle* h = [NSFileHandle fileHandleForReadingAtPath:CACHE_FILE];
    if ( h == nil ) return NO;
    
    NSString* table = [[NSString alloc] initWithData:[h availableData] encoding:NSUTF8StringEncoding];
    NSArray* lines = [table componentsSeparatedByString:@"\n"];
    for ( int i = 0 ; i < [lines count]-1; i+= 2 ) {
        NSString* key = [lines objectAtIndex:i];
        NSString* value = [lines objectAtIndex:(i+1)];
        
        MapImageCacheEntry* entry = [[MapImageCacheEntry alloc] init];
        entry.cachePath = value;
        
        [mImageMap setObject:entry forKey:key];
    }
    [h closeFile];
    return YES;
}

- (instancetype)init {
    if ( self = [ super init ] ) {
        mImageMap = [NSMutableDictionary dictionary];
        [self loadCacheTable];
    }
    return self;
}

- (UIImage*) addCache:(NSString*)cachePath forKey:(NSString*)key
{
    @synchronized(self) {
        
        MapImageCacheEntry* entry = [[MapImageCacheEntry alloc] init];
        NSData *data = [NSData dataWithContentsOfFile:cachePath];
        if ( data == nil ) return nil;
        
        UIImage* image = [[UIImage alloc] initWithData:data scale:2.0f];
        if ( !image ) return nil;
        entry.cachePath = cachePath;
        
        [mImageMap setObject:entry forKey:key];
        [self saveCacheTable];
        
        return image;
    }
}


- (UIImage*) imageForKey:(NSString*)key
{
    @synchronized(self) {
        MapImageCacheEntry* entry = [mImageMap objectForKeyedSubscript:key];
        if( !entry ) return nil;
        
        NSData *data = [NSData dataWithContentsOfFile:entry.cachePath];
        if ( !data ) {
            [mImageMap removeObjectForKey:key];
            [self saveCacheTable];
            return nil;
        }
        UIImage* image = [[UIImage alloc] initWithData:data scale:2.0f];
        return image;
    }
}

@end
