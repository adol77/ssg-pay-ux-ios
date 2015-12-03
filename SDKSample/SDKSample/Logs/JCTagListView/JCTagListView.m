//
//  JCTagListView.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagListView.h"
#import "JCTagCell.h"
#import "JCCollectionViewTagFlowLayout.h"

@interface JCTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) JCTagListViewBlock seletedBlock;
@property (nonatomic, strong) NSMutableArray *seletedIndicesArray;

@end

@implementation JCTagListView

static NSString * const reuseIdentifier = @"tagListViewItemId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setup
{
    _seletedTags = [NSMutableArray array];
    self.seletedIndicesArray = [NSMutableArray array];
    
    self.tags = [NSMutableArray array];
    
//    self.tagColor = [UIColor darkGrayColor];
    self.tagBorderColor = [UIColor darkGrayColor];
    self.tagTextColor = [UIColor darkGrayColor];
    self.tagBackgroundColor = [UIColor whiteColor];
    self.tagSelectedBackgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];

    self.tagCornerRadius = 10.0f;
    
    JCCollectionViewTagFlowLayout *layout = [[JCCollectionViewTagFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self addSubview:self.collectionView];
}

- (void)setAllSelected:(BOOL)reloaded {
    [_seletedTags removeAllObjects];
    [_seletedTags addObjectsFromArray:self.tags];
    
    [self.seletedIndicesArray removeAllObjects];
    for (NSInteger index = 0; index < [self.tags count]; index++) {
        [self.seletedIndicesArray addObject:[NSNumber numberWithInteger:index]];
    }
    if (reloaded) {
        [self.collectionView reloadData];
    }
}

- (void)setAllUnSelected:(BOOL)reloaded {
    [_seletedTags removeAllObjects];
    [self.seletedIndicesArray removeAllObjects];
    if (reloaded) {
        [self.collectionView reloadData];
    }
}

- (void)setCompletionBlockWithSeleted:(JCTagListViewBlock)completionBlock
{
    self.seletedBlock = completionBlock;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
    
    return CGSizeMake(frame.size.width + 8.0f, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if ([self.seletedIndicesArray containsObject:[NSNumber numberWithInteger:indexPath.item]]) {
        cell.backgroundColor = self.tagSelectedBackgroundColor;
    } else {
        cell.backgroundColor = self.tagBackgroundColor;
    }

    cell.layer.borderColor = self.tagBorderColor.CGColor;
    cell.layer.cornerRadius = self.tagCornerRadius;
    cell.titleLabel.text = self.tags[indexPath.item];
    cell.titleLabel.textColor = self.tagTextColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canSeletedTags) {
        JCTagCell *cell = (JCTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if ([_seletedTags containsObject:self.tags[indexPath.item]]) {
            cell.backgroundColor = self.tagBackgroundColor;
            
            [_seletedTags removeObject:self.tags[indexPath.item]];
            [self.seletedIndicesArray removeObject:[NSNumber numberWithInteger:indexPath.item]];
        }
        else {
            cell.backgroundColor = self.tagSelectedBackgroundColor;
            
            [_seletedTags addObject:self.tags[indexPath.item]];
            [self.seletedIndicesArray addObject:[NSNumber numberWithInteger:indexPath.item]];
        }
    }
    
    if (self.seletedBlock) {
        self.seletedBlock(indexPath.item);
    }
}

- (NSArray *)seletedIndices {
    return [NSArray arrayWithArray:self.seletedIndicesArray];
}

@end
