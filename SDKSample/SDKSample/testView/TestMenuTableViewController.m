//
//  TestMenuTableViewController.m
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 4..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import "TestMenuTableViewController.h"

@interface TestMenuTableViewController () < UITableViewDelegate, UITableViewDataSource >

@property (nonatomic, strong) NSArray *arrayTitles;
@property (nonatomic, strong) NSArray *arrayGroupTitles;
@property (nonatomic, strong) NSArray *arrayViewControllers;

@end

@implementation TestMenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"TEST MENU";
    self.arrayTitles = @[@[@"SLBS MapView",@"G1TEST1"],
                         @[@"LogView",@"G2TEST2"]
                         ];
    self.arrayGroupTitles = @[@"Map",@"Group2"];
    self.arrayViewControllers = @[@[@"TestMapViewController",@"testViewController"],
                                  @[@"SLBSGroupLogViewController",@"G2RestViewController2"]
                                  ];
    NSAssert(([self.arrayTitles count] == [self.arrayGroupTitles count]) && ([self.arrayGroupTitles count] == [self.arrayViewControllers count]), @"invalid group count!!!!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.arrayGroupTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.arrayTitles objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[self.arrayTitles objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class viewClass = NSClassFromString([[self.arrayViewControllers objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]]);
    UIViewController *viewController = [[viewClass alloc] init];
    if (self.navigationController) {
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.arrayGroupTitles objectAtIndex:section];
}

@end
