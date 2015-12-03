//
//  JCTagListView.h
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JCTagListViewBlock)(NSInteger index);

@interface JCTagListView : UIView

//@property (nonatomic, strong) UIColor *tagColor;
@property (nonatomic, strong) UIColor *tagBorderColor;
@property (nonatomic, strong) UIColor *tagTextColor;
@property (nonatomic, strong) UIColor *tagBackgroundColor;
@property (nonatomic, strong) UIColor *tagSelectedBackgroundColor;

@property (nonatomic, assign) CGFloat tagCornerRadius;

@property (nonatomic, assign) BOOL canSeletedTags;

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong, readonly) NSMutableArray *seletedTags;
@property (readonly) NSArray *seletedIndices;

@property (nonatomic, strong) UICollectionView *collectionView;

- (void)setAllSelected:(BOOL)reloaded;
- (void)setAllUnSelected:(BOOL)reloaded;
- (void)setCompletionBlockWithSeleted:(JCTagListViewBlock)completionBlock;

@end
