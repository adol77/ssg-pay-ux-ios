//
//  StoreCommandProtocol.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/28/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreCommandDelegate <NSObject>

-(void)moveToStoreFromCell:(int)index;
-(void)directToStoreFromCell:(int)index;

@end
