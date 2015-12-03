//
//  DirectionDetailViewController.m
//  SDKSample
//
//  Created by Jeoungsoo on 9/18/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import <SLBSSDK/MapPathViewData.h>

#import "DirectionDetailViewController.h"
#import "AppDataManager.h"
#import "ColorUtil.h"
#import "SLBSGroupLogViewController.h"
#import "DirectionDetailTableViewCell.h"

@interface DirectionDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *directionListTV;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *showLogButton;
@property (nonatomic, strong) NSMutableArray *directionArray;

@end

@implementation DirectionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [ColorUtil searchBgColor];
    
    [self initNavigationBar];
    [self loadDirectionArray];
    [self initDirectionTableView];
    [self initBottomButtons];
    [self initShowLogButton];
}

- (void)initShowLogButton {
    UIImage *showLogButtonImgNor = [UIImage imageNamed:@"log_nor_btn"];
    UIImage *showLogButtonImgPre = [UIImage imageNamed:@"log_pre_btn"];
    
    self.showLogButton = [[UIButton alloc] initWithFrame:CGRectMake(10,
                                                                    self.closeButton.frame.origin.y - 10 - showLogButtonImgNor.size.height,
                                                                    showLogButtonImgNor.size.width,
                                                                    showLogButtonImgNor.size.height)];
    
    [self.showLogButton setImage:showLogButtonImgNor forState:UIControlStateNormal];
    [self.showLogButton setImage:showLogButtonImgPre forState:UIControlStateSelected];
    [self.showLogButton addTarget:self action:@selector(showLogVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.showLogButton];
}

- (void)showLogVC:(id)sender {
    SLBSGroupLogViewController *viewController = [[SLBSGroupLogViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)initNavigationBar {
    self.navigationItem.title = @"길 안내";
    
    // back button
    UIImage *backButtonImgNor = [UIImage imageNamed:@"nav_back_nor_btn"];
    UIImage *backButtonImgPre = [UIImage imageNamed:@"nav_back_pre_btn"];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backButtonImgNor.size.width, backButtonImgNor.size.height)];
    [backButton setImage:backButtonImgNor forState:UIControlStateNormal];
    [backButton setImage:backButtonImgPre forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    // right
    // campaign inbox button
    UIImage *inboxButtonImgNor = [UIImage imageNamed:@"nav_campaign_nor_btn"];
    UIImage *inboxButtonImgPre = [UIImage imageNamed:@"nav_campaign_pre_btn"];
    
    UIButton *inboxButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, inboxButtonImgNor.size.width+20, inboxButtonImgNor.size.height)];
    [inboxButton setImage:inboxButtonImgNor forState:UIControlStateNormal];
    [inboxButton setImage:inboxButtonImgPre forState:UIControlStateSelected];
    [inboxButton addTarget:self action:@selector(campaignInboxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *inboxButtonItem = [[UIBarButtonItem alloc] initWithCustomView:inboxButton];
    
    // search button
    UIImage *searchButtonImgNor = [UIImage imageNamed:@"nav_search_nor_btn"];
    UIImage *searchButtonImgPre = [UIImage imageNamed:@"nav_search_per_btn"];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, searchButtonImgNor.size.width, searchButtonImgNor.size.height)];
    [searchButton setImage:searchButtonImgNor forState:UIControlStateNormal];
    [searchButton setImage:searchButtonImgPre forState:UIControlStateSelected];
    [searchButton addTarget:self action:@selector(showSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:searchButtonItem, inboxButtonItem, nil];
}

- (void)campaignInboxButtonClicked {
    CampaignInboxViewController *campaignVC = [[CampaignInboxViewController alloc] init];
    campaignVC.callerViewController = self;
    campaignVC.mapCommandDelegate = self.mapCommandDelegate;
    UINavigationController *campaignNavC = [[UINavigationController alloc] initWithRootViewController:campaignVC];
    [self presentViewController:campaignNavC animated:YES completion:nil];
}

- (void)showSearchViewController {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.callerViewController = self;
    searchVC.mapCommandDelegate = self.mapCommandDelegate;
    searchVC.mapInfoProvider = self.mapInfoProvider;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)closeButtonClicked {
    [self showTwoButtonAlertPopupWithTitle:@"길 안내를 종료 하시겠습니까?"];
}

- (void)showTwoButtonAlertPopupWithTitle:(NSString*)title {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"종료", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"종료"]) {
        [self dismissViewControllerAnimated:YES completion:^{
            [self.mapDirectionDelegate endMapDirection];
        }];
    } else if ([title isEqualToString:@"취소"]) {

    }
}

- (void)loadDirectionArray {
    self.directionArray = [NSMutableArray arrayWithArray:[AppDataManager sharedInstance].curDirectionArray];
    
    MapPathViewData *startPathData = [self.directionArray objectAtIndex:0];
    MapPathViewData *startPathDataNewly = [self convertStartPathData:startPathData];
    [self.directionArray replaceObjectAtIndex:0 withObject:startPathDataNewly];
    
    MapPathViewData *endPathData = [self.directionArray objectAtIndex:self.directionArray.count-1];
    MapPathViewData *endPathDataNewly = [self convertEndPathData:endPathData];
    [self.directionArray replaceObjectAtIndex:self.directionArray.count-1 withObject:endPathDataNewly];
}

- (MapPathViewData*)convertStartPathData:(MapPathViewData*)startPathData {
    NSString *startVertexName = [NSString stringWithFormat:@"%@에서 출발", startPathData.vertexName];
    MapPathViewData *startPathDataNewly = [[MapPathViewData alloc] initWithMapId:startPathData.mapId
                                                                         mapName:startPathData.mapName
                                                                         graphId:startPathData.graphId
                                                                        vertexId:startPathData.vertexId
                                                                      vertexName:startVertexName
                                                                               x:startPathData.x
                                                                               y:startPathData.y];
    return startPathDataNewly;
}

- (MapPathViewData*)convertEndPathData:(MapPathViewData*)endPathData {
    NSString *removedStr = [endPathData.vertexName stringByReplacingOccurrencesOfString:@" 인근" withString:@""];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 길안내", removedStr];
    
    NSString *endVertexName = [NSString stringWithFormat:@"%@에 도착", removedStr];
    MapPathViewData *endPathDataNewly = [[MapPathViewData alloc] initWithMapId:endPathData.mapId
                                                                         mapName:endPathData.mapName
                                                                         graphId:endPathData.graphId
                                                                        vertexId:endPathData.vertexId
                                                                      vertexName:endVertexName
                                                                               x:endPathData.x
                                                                               y:endPathData.y];
    return endPathDataNewly;
}

- (void)initDirectionTableView {
    UIImage *closeButtonImgNor = [UIImage imageNamed:@"map_find_close_nor_btn"];
    self.directionListTV = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.view.frame.size.width,
                                                                     self.view.frame.size.height - (closeButtonImgNor.size.height+9)) style:UITableViewStylePlain];
    
    self.directionListTV.backgroundColor = [ColorUtil searchBgColor];
    self.directionListTV.separatorColor = [ColorUtil searchLineColor];

    self.directionListTV.delegate = self;
    self.directionListTV.dataSource = self;
    
    [self.view addSubview:self.directionListTV];
}

- (void)initBottomButtons {
    // close
    UIImage *closeButtonImgNor = [UIImage imageNamed:@"map_find_close_nor_btn"];
    UIImage *closeButtonImgPre = [UIImage imageNamed:@"map_find_close_pre_btn"];

    
    CGFloat buttonWidth = (self.view.frame.size.width - (9*2) - 6) / 2;
    CGFloat buttonHeight = closeButtonImgNor.size.height;
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(9,
                                                                  self.view.frame.size.height - (buttonHeight + 9),
                                                                  buttonWidth, buttonHeight)];
    
    UIImage *closeButtonBackImgNor = [UIImage imageNamed:@"map_find_bg_nor_btn"];
    UIImage *closeButtonBackImgPre = [UIImage imageNamed:@"map_find_bg_pre_btn"];
    UIImage *closeButtonBackImgNorStretched = [closeButtonBackImgNor resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    UIImage *closeButtonBackImgPreStretched = [closeButtonBackImgPre resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    
    [self.closeButton setBackgroundImage:closeButtonBackImgNorStretched forState:UIControlStateNormal];
    [self.closeButton setBackgroundImage:closeButtonBackImgPreStretched forState:UIControlStateSelected];
 
    [self.closeButton setImage:closeButtonImgNor forState:UIControlStateNormal];
    [self.closeButton setImage:closeButtonImgPre forState:UIControlStateSelected];
    
    self.closeButton.contentMode = UIViewContentModeCenter;
    [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.closeButton];
    
    // start
    UIImage *startButtonImgNor = [UIImage imageNamed:@"map_find_map_nor_btn"];
    UIImage *startButtonImgPre = [UIImage imageNamed:@"map_find_map_pre_btn"];

    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x + 3,
                                                                  self.view.frame.size.height - (buttonHeight + 9),
                                                                  buttonWidth, buttonHeight)];
    
    UIImage *startButtonBackImgNor = [UIImage imageNamed:@"map_find_bg_nor_btn"];
    UIImage *startButtonBackImgPre = [UIImage imageNamed:@"map_find_bg_pre_btn"];
    UIImage *startButtonBackImgNorStretched = [startButtonBackImgNor resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    UIImage *startButtonBackImgPreStretched = [startButtonBackImgPre resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
    
    [self.startButton setBackgroundImage:startButtonBackImgNorStretched forState:UIControlStateNormal];
    [self.startButton setBackgroundImage:startButtonBackImgPreStretched forState:UIControlStateSelected];
    
    [self.startButton setImage:startButtonImgNor forState:UIControlStateNormal];
    [self.startButton setImage:startButtonImgPre forState:UIControlStateSelected];
    self.startButton.contentMode = UIViewContentModeCenter;
    [self.startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.startButton];
}

- (void)startButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mapDirectionDelegate startMapDirection];
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.directionArray!=nil) {
        return self.directionArray.count;
    }
    
    return 0;
}

static NSString *DIRECTION_TV_IDENTIFIER = @"directionTableCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DirectionDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DIRECTION_TV_IDENTIFIER];
    if (cell==nil) {
        cell = [[DirectionDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:DIRECTION_TV_IDENTIFIER
                                                       parentFrame:self.view.frame];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // update floor
    MapPathViewData *pathData = [self.directionArray objectAtIndex:indexPath.row];
    SLBSFloor *floor = [self.mapInfoProvider getFloorByMapId:(int)pathData.mapId];
    NSString *branchName = [self.mapInfoProvider getBranchNameByBranchId:floor.branchId];
    
    [cell updateFloorName:floor.name branchName:branchName];
    
    // update desc and icon
    if ((int)indexPath.row==0) {
        [cell updateStartIconDesc:pathData.vertexName];
    } else if((int)indexPath.row==self.directionArray.count-1) {
        [cell updateEndIconDesc:pathData.vertexName];
    } else {
        [cell updateDesc:pathData.vertexName];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
