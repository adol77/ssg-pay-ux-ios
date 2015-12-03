//
//  FloorSelectionController.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/5/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "FloorSelectionController.h"
#import "MapInfoProvider.h"
#import "ColorUtil.h"
#import "AppDefine.h"

@interface FloorSelectionController()

@end


@implementation FloorSelectionController

- (instancetype)init:(MapInfoProvider*)mapInfoProvider {
    self = [super init:mapInfoProvider];
    if (self) {
    }
    
    return self;
}

#pragma mark - Floor TableView Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mapInfoProvider.selectedFloorArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

static NSString *floorSelectionCellId = @"floorSelectionCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:floorSelectionCellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:floorSelectionCellId];
        cell.textLabel.font = [UIFont systemFontOfSize:19];
        cell.textLabel.textColor = [ColorUtil floorTextColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
    }
    
    SLBSFloor *floor = [self.mapInfoProvider.selectedFloorArray objectAtIndex:indexPath.row];
    [cell setTag:[floor.branchId intValue]];
    cell.textLabel.text = floor.desc;
    cell.accessoryView = nil;
    
    NSLog(@"### FloorSelectionController self.currentSelectedIndexPath.row=%d", (int)self.currentSelectedIndexPath.row);
    
    if (indexPath.row==self.currentSelectedIndexPath.row) {
        [self showCheckmarkTableViewWithCell:cell indexPath:indexPath show:YES];
    } else {
        [self showCheckmarkTableViewWithCell:cell indexPath:indexPath show:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.mapInfoProvider.tempSelectedFloorArrayIndex = [NSNumber numberWithInt:(int)indexPath.row];
    
    //        [self.mapInfoProvider updateCurrentBranchIdByBranchIndex:(int)indexPath.row];
    
//    NSNumber *branchId = [self.mapInfoProvider getBranchIdByBranchArrayIndex:(int)indexPath.row];
//    [self.mapInfoProvider refreshCurrentFloorArray:[branchId intValue]];
//    [tableView reloadData];
    
    [self clearCheckmarkInTableView:tableView array:self.mapInfoProvider.selectedFloorArray];
    [self showCheckmarkTableView:tableView indexPath:indexPath show:YES];

}


@end
