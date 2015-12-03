//
//  ViewController.m
//  SLBSChecker
//
//  Created by Jeoungsoo on 11/4/15.
//  Copyright © 2015 Nemustech. All rights reserved.
//

#import "MainViewController.h"
#import <SLBSSDK/SLBSDataManager.h>

@interface MainViewController () <SLBSDataManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *checkerTV;
@property (nonatomic, strong) NSNumber *cellHeight;

@property (nonatomic, strong) NSArray *checkerListArray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
    [self initTableView];
    
    self.checkerListArray = [[NSMutableArray alloc] initWithObjects:
                             @"기능 검증 1",
                             @"기능 검증 2",
                             @"기능 검증 3",
                             @"기능 검증 4",
                             @"기능 검증 5",
                             nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavigationBar {
    self.navigationItem.title = @"기능 검증";
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)initTableView {
//    self.cellHeight = [NSNumber numberWithInt:70];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat tvTop = statusBarHeight + navigationBarHeight;
    
    self.checkerTV = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height - tvTop) style:UITableViewStylePlain];
    self.checkerTV.delegate = self;
    self.checkerTV.dataSource = self;
    [self.view addSubview:self.checkerTV];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.checkerListArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self.cellHeight intValue];
//}

static NSString *CHECKER_CELL_IDENTIFIER = @"checkerCellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHECKER_CELL_IDENTIFIER];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHECKER_CELL_IDENTIFIER];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [self.checkerListArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)startDataManager {
    [[SLBSDataManager sharedInstance] setDelegate:self];
    [[SLBSDataManager sharedInstance] startMonitoring];
}

- (void)onServiceReady {
    [[SLBSDataManager sharedInstance] setUserAccountName:@"test"];
    [[SLBSDataManager sharedInstance] setLocationAgreement:YES];
}

@end
