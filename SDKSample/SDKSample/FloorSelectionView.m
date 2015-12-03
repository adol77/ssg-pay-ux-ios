//
//  FloorSelectionView.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/15/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "FloorSelectionView.h"

#import "ColorUtil.h"
#import "BranchSelectionController.h"
#import "FloorSelectionController.h"

@interface FloorSelectionView () <UIGestureRecognizerDelegate, BranchSelectionDelegate >

@property (nonatomic, strong) MapInfoProvider *mapInfoProvider;

@property (nonatomic, strong) BranchSelectionController *branchSelectionController;
@property (nonatomic, strong) FloorSelectionController *floorSelectionController;

@property (nonatomic, strong) UIView *floorSelectionBackView;
@property (nonatomic, strong) UIView *floorSelectionMainView;
@property (nonatomic, strong) UITableView *branchSelectionTV;
@property (nonatomic, strong) UITableView *floorSelectionTV;
@property (nonatomic, strong) UIButton *floorSelectionDoneButton;

@end

@implementation FloorSelectionView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame mapInfoProvider:(MapInfoProvider*)mapInfoProvider {
    self = [super initWithFrame:frame];
    if (self) {
        self.mapInfoProvider = mapInfoProvider;
        
        self.branchSelectionController = [[BranchSelectionController alloc] init:self.mapInfoProvider];
        self.branchSelectionController.branchSelectionDelegate = self;
        self.floorSelectionController = [[FloorSelectionController alloc] init:self.mapInfoProvider];
        
        self.floorSelectionBackView = [[UIView alloc] initWithFrame:frame];
        self.floorSelectionBackView.backgroundColor = [ColorUtil popupBgColor];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        [self.floorSelectionBackView addGestureRecognizer:singleTap];
        
        CGFloat redGapHeight = 5;
        CGFloat branchTitleHeight = 45;
        CGFloat branchTVHeight = 120;
        CGFloat floorTitleHeight = 45;
        CGFloat floorTVHeight = 200;
        CGFloat selectButtonHeight = 50;
        
        int mainViewWidth = frame.size.width - 40;
        int mainViewHeight = (redGapHeight + branchTitleHeight + branchTVHeight +
                              redGapHeight + floorTitleHeight + floorTVHeight +
                              selectButtonHeight);
        
        self.floorSelectionMainView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - mainViewWidth)/2,
                                                                               (frame.size.height - mainViewHeight)/2,
                                                                               mainViewWidth, mainViewHeight)];
        self.floorSelectionMainView.backgroundColor = [ColorUtil mainRedColor];
        [self.floorSelectionBackView addSubview:self.floorSelectionMainView];
        
        // branch title
        UIView *branchTitleBackView = [[UIView alloc] initWithFrame:CGRectMake(0, redGapHeight, mainViewWidth, branchTitleHeight)];
        branchTitleBackView.backgroundColor = [UIColor whiteColor];
        [self.floorSelectionMainView addSubview:branchTitleBackView];
        
        UILabel *branchTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, mainViewWidth - 15, branchTitleHeight-1)];
        branchTitleLabel.text = @"건물 선택";
        branchTitleLabel.textColor = [ColorUtil mainRedColor];
        branchTitleLabel.font = [UIFont systemFontOfSize:20];
        branchTitleLabel.backgroundColor = [UIColor whiteColor];
        [branchTitleBackView addSubview:branchTitleLabel];
        
        UIView *branchLineView = [[UIView alloc] initWithFrame:CGRectMake(15, branchTitleLabel.frame.size.height,
                                                                   mainViewWidth - 15, 1)];
        branchLineView.backgroundColor = [ColorUtil floorLine2Color];
        [branchTitleBackView addSubview:branchLineView];
        
        // branch
        self.branchSelectionTV = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                               branchTitleBackView.frame.origin.y + branchTitleBackView.frame.size.height,
                                                                               mainViewWidth, branchTVHeight) style:UITableViewStylePlain];
        self.branchSelectionTV.separatorColor = [ColorUtil floorLineColor];
        self.branchSelectionTV.backgroundColor = [UIColor whiteColor];
        self.branchSelectionTV.delegate = self.branchSelectionController;
        self.branchSelectionTV.dataSource = self.branchSelectionController;
        
        [self.floorSelectionMainView addSubview:self.branchSelectionTV];
        
        // floor title
        UIView *floorTitleBackView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                              self.branchSelectionTV.frame.origin.y + self.branchSelectionTV.frame.size.height + 5,
                                                                              mainViewWidth - 10, floorTitleHeight)];
        floorTitleBackView.backgroundColor = [UIColor whiteColor];
        [self.floorSelectionMainView addSubview:floorTitleBackView];
        
        UILabel *floorTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,
                                                                             0,
                                                                             mainViewWidth - 15, floorTitleHeight-1)];
        floorTitleLabel.text = @"층 선택";
        floorTitleLabel.textColor = [ColorUtil mainRedColor];
        floorTitleLabel.font = [UIFont systemFontOfSize:20];
        floorTitleLabel.backgroundColor = [UIColor whiteColor];
        [floorTitleBackView addSubview:floorTitleLabel];
        
        UIView *floorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, floorTitleLabel.frame.size.height,
                                                                          mainViewWidth - 15, 1)];
        floorLineView.backgroundColor = [ColorUtil floorLine2Color];
        [floorTitleBackView addSubview:floorLineView];
        
        
        // floor
        self.floorSelectionTV = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                              floorTitleBackView.frame.origin.y + floorTitleBackView.frame.size.height,
                                                                              mainViewWidth, floorTVHeight)];
        self.floorSelectionTV.separatorColor = [ColorUtil floorLineColor];
        self.floorSelectionTV.delegate = self.floorSelectionController;
        self.floorSelectionTV.dataSource = self.floorSelectionController;
        
        [self.floorSelectionMainView addSubview:self.floorSelectionTV];
        
        // selection done button
        self.floorSelectionDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                                   self.floorSelectionTV.frame.origin.y + self.floorSelectionTV.frame.size.height,
                                                                                   mainViewWidth, selectButtonHeight)];
        self.floorSelectionDoneButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.floorSelectionDoneButton setTitle:@"선택" forState:UIControlStateNormal];
        [self.floorSelectionDoneButton addTarget:self action:@selector(floorSelectionDoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.floorSelectionDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.floorSelectionDoneButton setTitleColor:[ColorUtil selectionButtonColor] forState:UIControlStateHighlighted];
        
        UIImage *buttonBackImgNor = [UIImage imageNamed:@"popup_nor_btn_bg"];
        UIImage *buttonBackImgPre = [UIImage imageNamed:@"popup_pre_btn_bg"];
        UIImage *buttonBackImgNorStretched = [buttonBackImgNor resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        UIImage *buttonBackImgPreStretched = [buttonBackImgPre resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        
        [self.floorSelectionDoneButton setBackgroundImage:buttonBackImgNorStretched forState:UIControlStateNormal];
        [self.floorSelectionDoneButton setBackgroundImage:buttonBackImgPreStretched forState:UIControlStateSelected];
        
        [self.floorSelectionMainView addSubview:self.floorSelectionDoneButton];
        
        [self addSubview:self.floorSelectionBackView];
    }
    
    return self;
}

- (void)updateFloorSelection {
    // select branch
    int currentBranchSelectRow = [self.mapInfoProvider getCurrentBranchArrayIndex];
    if (currentBranchSelectRow!=-1) {
        [self selectBranchWithSelectRow:currentBranchSelectRow];
        [self.mapInfoProvider refreshCurrentFloorArray:[self.mapInfoProvider.currentBranchId intValue]];
        
        // select floor
        int currentFloorSelectRow = [self.mapInfoProvider getCurrentFloorArrayIndex];
        if (currentFloorSelectRow!=-1) {
            [self selectFloorWithSelectRow:currentFloorSelectRow];
        }
    }
}

#pragma mark - Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:touch.view];
    CGPoint cPoint = [touch.view convertPoint:point toView:self.floorSelectionBackView];
//    NSLog(@"view %@ point %@ mainFrame %@ cPoint %@", touch.view, NSStringFromCGPoint(point), NSStringFromCGRect(self.floorSelectionMainView.frame), NSStringFromCGPoint(cPoint));
    BOOL isInContains = CGRectContainsPoint(self.floorSelectionMainView.frame, cPoint);
    return !isInContains;
    
//    NSLog(@"gestureRecognizer() touchPoint = %@, mainView rect=%@", NSStringFromCGPoint(point), NSStringFromCGRect(self.floorSelectionMainView.frame));
//    UIView *view = [self.floorSelectionBackView hitTest:[touch locationInView:self.floorSelectionBackView] withEvent:nil];
//    
//    if ([view isDescendantOfView:(self.floorSelectionDoneButton)]) {
//        NSLog(@"gestureRecognizer() floorSelectionDoneButton selected!!!");
//        return YES;
//    }
//    
//    if ([view isDescendantOfView:(self.floorSelectionMainView)]) {
//        return NO;
//    }
//
//    // self.floorSelectionDoneButton if조건에 걸리지 않을 경우가 있음.
//    NSLog(@"gestureRecognizer() floorSelectionDoneButton NOT selected!!!");
//    [self floorSelectionChanged:NO];
//    return YES;
}

- (void)handleSingleTap:(id)sender {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self floorSelectionChanged:NO];
}

#pragma mark - Selector

- (void)floorSelectionDoneButtonClicked {
    [self floorSelectionChanged:YES];
}

- (void)floorSelectionChanged:(BOOL)changed {
    // get selected branchId
    NSNumber *selectedBranchId = [self.mapInfoProvider getBranchIdByBranchArrayIndex:
                                  [self.mapInfoProvider.tempSelectedBranchArrayIndex intValue]];
    NSNumber *selectedFloorId = [self.mapInfoProvider getFloorIdByFloorArrayIndex:
                                 [self.mapInfoProvider.tempSelectedFloorArrayIndex intValue]];
    
//    NSLog(@"### floorSelectionDoneButtonClicked() selectedBranchId=%d", [selectedBranchId intValue]);
//    NSLog(@"### floorSelectionDoneButtonClicked() tempSelectedBranchArrayIndex=%d", [self.mapInfoProvider.tempSelectedBranchArrayIndex intValue]);
//    
//    NSLog(@"### floorSelectionDoneButtonClicked() selectedFloorIndex=%d", [selectedFloorId intValue]);
//    NSLog(@"### floorSelectionDoneButtonClicked() tempSelectedFloorArrayIndex=%d", [self.mapInfoProvider.tempSelectedFloorArrayIndex intValue]);
    
    // return if branch and floor id is same
    if ([selectedBranchId intValue]==[self.mapInfoProvider.currentBranchId intValue] &&
        [self.mapInfoProvider.currentFloorId intValue]==[selectedFloorId intValue]) {
        [self.floorSelectionDelegate floorSelectedByFloorChanged:NO];
        
        return;
    }
    
    // update current branch and floor id
    self.mapInfoProvider.currentBranchId = selectedBranchId;
    self.mapInfoProvider.currentFloorId = selectedFloorId;
    
    [self.floorSelectionDelegate floorSelectedByFloorChanged:changed];
}

#pragma mark - BranchSelectionDelegate

- (void)reloadFloorData {
    [self.floorSelectionController clearCheckmarkInTableView:self.floorSelectionTV array:self.mapInfoProvider.selectedFloorArray];
    [self.floorSelectionTV reloadData];
    [self selectFloorWithSelectRow:0];
}

- (NSIndexPath*)selectBranchWithSelectRow:(int)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.branchSelectionTV selectRowAtIndexPath:indexPath
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
    [self.branchSelectionController tableView:self.branchSelectionTV didSelectRowAtIndexPath:indexPath];
    
    return indexPath;
}

- (NSIndexPath*)selectFloorWithSelectRow:(int)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.floorSelectionTV selectRowAtIndexPath:indexPath
                           animated:YES
                     scrollPosition:UITableViewScrollPositionNone];
    [self.floorSelectionController tableView:self.floorSelectionTV didSelectRowAtIndexPath:indexPath];
    
    return indexPath;
}


@end
