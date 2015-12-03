//
//  BranchSelectionController.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/5/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "BranchSelectionController.h"
#import "AppDataManager.h"
#import <SLBSSDK/SLBSBranch.h>
#import "ColorUtil.h"


@interface BranchSelectionController() 

@property (nonatomic, strong) NSIndexPath *oldIndexPath;

@end


@implementation BranchSelectionController

- (instancetype)init:(MapInfoProvider*)mapInfoProvider {
    self = [super init:mapInfoProvider];
    if (self) {
    }
    
    return self;
}

#pragma mark - Branch TableView Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appDataManager.branchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

static NSString *branchSelectionCellId = @"branchSelectionCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:branchSelectionCellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:branchSelectionCellId];
        cell.textLabel.font = [UIFont systemFontOfSize:19];
        cell.textLabel.textColor = [ColorUtil floorTextColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SLBSBranch *branch = [self.appDataManager.branchArray objectAtIndex:indexPath.row];
    [cell setTag:[branch.branchId intValue]];
    cell.textLabel.text = branch.name;

    if (indexPath.row==self.currentSelectedIndexPath.row) {
        [self showCheckmarkTableViewWithCell:cell indexPath:indexPath show:YES];
    } else {
        [self showCheckmarkTableViewWithCell:cell indexPath:indexPath show:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.mapInfoProvider.tempSelectedBranchArrayIndex = [NSNumber numberWithInt:(int)indexPath.row];
    
    //        [self.mapInfoProvider updateCurrentBranchIdByBranchIndex:(int)indexPath.row];
    
    NSNumber *branchId = [self.mapInfoProvider getBranchIdByBranchArrayIndex:(int)indexPath.row];
    [self.mapInfoProvider refreshCurrentFloorArray:[branchId intValue]];
    
    // update branch checkmark
    [self clearCheckmarkInTableView:tableView array:self.appDataManager.branchArray];
    [self showCheckmarkTableView:tableView indexPath:indexPath show:YES];
    
    // update floor checkmark
    [self clearCheckmarkInTableView:tableView array:self.mapInfoProvider.selectedFloorArray];
    [self showCheckmarkTableView:tableView indexPath:indexPath show:YES];

    [self.branchSelectionDelegate reloadFloorData];
}

@end
