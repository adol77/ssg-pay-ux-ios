//
//  MapImageCache.h
//  SLBSSDK
//
//  Created by KimHeedong on 2015. 9. 16..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MapImageCache : NSObject
- (UIImage*) addCache:(NSString*)cachePath forKey:(NSString*)key;
- (UIImage*) imageForKey:(NSString*)key;
@end
