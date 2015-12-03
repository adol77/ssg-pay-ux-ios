//
//  MapDirectionView.h
//  SDKSample
//
//  Created by Jeoungsoo on 10/15/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MapDirectionButtonDelegate <NSObject>

- (void)selectedDirectionDetailShow;
- (void)selectedMapDirectionExit;

@end

@interface MapDirectionView : UIView

@property (nonatomic, strong) id<MapDirectionButtonDelegate> mapDirectionButtonDelegate;

@end
