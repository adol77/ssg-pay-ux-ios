//
//  SelectionController.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/5/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "SelectionController.h"

@interface SelectionController()

@end

@implementation SelectionController

- (instancetype)init:(MapInfoProvider*)mapInfoProvider {
    self = [super init];
    if (self) {
        self.appDataManager = [AppDataManager sharedInstance];
        self.mapInfoProvider = mapInfoProvider;
    }
    
    return self;
}

- (void)showCheckmarkTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath show:(BOOL)show {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (show) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        self.currentSelectedIndexPath = indexPath;
    } else {
        cell.accessoryView = nil;
    }
}

- (void)showCheckmarkTableViewWithCell:(UITableViewCell*)cell indexPath:(NSIndexPath*)indexPath show:(BOOL)show {
    if (show) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check"]];
        self.currentSelectedIndexPath = indexPath;
    } else {
        cell.accessoryView = nil;
    }
}

- (void)clearCheckmarkInTableView:(UITableView*)tableView array:(NSArray*)array {
    for (int i=0; i<array.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self showCheckmarkTableView:tableView indexPath:indexPath show:NO];
    }
}

@end
