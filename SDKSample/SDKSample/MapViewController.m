//
//  MapViewController.m
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 4..
//  Copyright (c) 2015년 Regina. All rights reserved.
//


#import "MapViewController.h"

#import <SLBSSDK/SLBSMapManager.h>
#import <SLBSSDK/MapPathViewData.h>
#import <SLBSSDK/TSDebugLogManager.h>

#import "AppDataManager.h"
#import "MapInfoProvider.h"
#import "NetworkDataRequester.h"

#import "SLBSGroupLogViewController.h"
#import "DirectionDetailViewController.h"
#import "CampaignInboxViewController.h"
#import "SearchViewController.h"
#import "MapViewerController.h"

#import "FloorSelectionView.h"
#import "IndicatorView.h"
#import "MapDirectionView.h"

#import <SLBSSDK/SLBSFloor.h>


#import "Util.h"
#import "ColorUtil.h"
#import "AppDefine.h"



// for testing
//#import "Campaign.h"
//#import "CampaignArchiver.h"


@interface MapViewController () < MapActionDelegate, MapDirectionDelegate, MapCommandDelegate, MapDirectionButtonDelegate,
FloorSelectionDelegate, MapCommandDelegate >

@property (nonatomic, strong) AppDataManager *appDataManager;
@property (nonatomic, strong) MapInfoProvider *mapInfoProvider;

@property (nonatomic, strong) MapViewerController *mapViewerController;

@property (nonatomic, strong) IndicatorView *indicatorView;
@property (nonatomic, strong) FloorSelectionView *floorSelectionView;
@property (nonatomic, strong) MapDirectionView *mapDirectionView;

@property (nonatomic, strong) UIButton *currentPositionButton;
@property (nonatomic, strong) UIButton *floorSelectionButton;
@property (nonatomic, strong) UIButton *showLogButton;

@property (nonatomic, assign) BOOL isCurrentPositionButtonSelected;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];

    [self initController];
    [self initNavigationBar];
    [self initIndicatorView];
    [self initMapView];
    
    [self initFloorSelectionView];
    [self initCurrentPositionButton];
    [self initFloorSelectionButton];
    [self initMapDirectionView];
    [self initShowLogButton];

    NSNumber *mapId = [self.mapInfoProvider getDefaultMapId];
    [self updateMapInfo:[mapId intValue]];
}

#pragma mark - Init

- (void)initController {
    self.appDataManager = [AppDataManager sharedInstance];
    
    self.mapInfoProvider = [[MapInfoProvider alloc] init];
    self.mapInfoProvider.appDataManager = self.appDataManager;
    
    self.mapViewerController = [[MapViewerController alloc] init:self.mapInfoProvider parentView:self.view];
    self.mapViewerController.mapActionDelegate = self;
}

- (void)initMapView {
    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    int navigationBarHeight = self.navigationController.navigationBar.frame.size.height;

    CGRect frame = CGRectMake(self.view.frame.origin.x,
                              0,
                              self.view.frame.size.width,
                              self.view.frame.size.height - (statusBarHeight + navigationBarHeight));

    UIView *mapView = [self.mapViewerController createMapViewWithFrame:frame];
    [self.view addSubview:mapView];
    
    [self.mapViewerController startMapManager];
}

- (void)initNavigationBar {
    // back button
    UIImage *backButtonImgNor = [UIImage imageNamed:@"nav_back_nor_btn"];
    UIImage *backButtonImgPre = [UIImage imageNamed:@"nav_back_pre_btn"];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backButtonImgNor.size.width, backButtonImgNor.size.height)];
    [backButton setImage:backButtonImgNor forState:UIControlStateNormal];
    [backButton setImage:backButtonImgPre forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    // campaign inbox button
    UIImage *inboxButtonImgNor = [UIImage imageNamed:@"nav_campaign_nor_btn"];
    UIImage *inboxButtonImgPre = [UIImage imageNamed:@"nav_campaign_pre_btn"];
    
    UIButton *inboxButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, inboxButtonImgNor.size.width+20, inboxButtonImgNor.size.height)];
    [inboxButton setImage:inboxButtonImgNor forState:UIControlStateNormal];
    [inboxButton setImage:inboxButtonImgPre forState:UIControlStateSelected];
    [inboxButton addTarget:self action:@selector(campaignInboxButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)doBack:(id)sender {
    [self.mapViewerController stopMonitoring];
    [self.mapViewerController stopMapManager];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)campaignInboxButtonClicked:(id)sender {
    CampaignInboxViewController *campaignVC = [[CampaignInboxViewController alloc] init];
    campaignVC.callerViewController = self;
    campaignVC.mapCommandDelegate = self;
    campaignVC.mapInfoProvider = self.mapInfoProvider;
    UINavigationController *campaignNavC = [[UINavigationController alloc] initWithRootViewController:campaignVC];
    [self presentViewController:campaignNavC animated:YES completion:nil];
}

- (void)initIndicatorView {
    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    int navigationBarHeight = self.navigationController.navigationBar.frame.size.height;

    CGRect viewFrame = CGRectMake(0, 0,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height - statusBarHeight - navigationBarHeight);
    self.indicatorView = [[IndicatorView alloc] initWithFrame:viewFrame];
}

- (void)initFloorSelectionView {
    self.floorSelectionView = [[FloorSelectionView alloc] initWithFrame:self.view.frame mapInfoProvider:self.mapInfoProvider];
    self.floorSelectionView.floorSelectionDelegate = self;
}

- (void)initMapDirectionView {
    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    int navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGRect viewFrame = CGRectMake(0, 0,
                                   self.view.frame.size.width,
                                   self.view.frame.size.height - statusBarHeight - navigationBarHeight);
    self.mapDirectionView = [[MapDirectionView alloc] initWithFrame:viewFrame];
    self.mapDirectionView.mapDirectionButtonDelegate = self;
}

- (void)initCurrentPositionButton {
//    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    int navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    int statusBarHeight = 0;
    int navigationBarHeight = 0;
    
    UIImage *curPosButtonImgNor = [UIImage imageNamed:@"map_here_nor_btn"];
    self.currentPositionButton = [[UIButton alloc] initWithFrame:CGRectMake(10,
                                                                            statusBarHeight + navigationBarHeight + 10,
                                                                            curPosButtonImgNor.size.width,
                                                                            curPosButtonImgNor.size.height)];
    [self.currentPositionButton setImage:curPosButtonImgNor forState:UIControlStateNormal];
    [self.currentPositionButton addTarget:self action:@selector(currentPositionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.currentPositionButton];
}

- (void)initFloorSelectionButton {
//    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    int navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    int statusBarHeight = 0;
    int navigationBarHeight = 0;
    
    UIImage *floorSelectionButtonImgNor = [UIImage imageNamed:@"map_floor_nor_btn"];
    UIImage *floorSelectionButtonImgPre = [UIImage imageNamed:@"map_floor_pre_btn"];
    
    self.floorSelectionButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - floorSelectionButtonImgNor.size.width - 10,
                                                                           statusBarHeight + navigationBarHeight + 10,
                                                                           floorSelectionButtonImgNor.size.width,
                                                                           floorSelectionButtonImgNor.size.height)];
    self.floorSelectionButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    
    [self.floorSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.floorSelectionButton setTitleColor:[ColorUtil selectionButtonColor] forState:UIControlStateHighlighted];
    
    self.floorSelectionButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.floorSelectionButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [self.floorSelectionButton setTitleEdgeInsets:UIEdgeInsetsMake(15, 20, 0, 0)];
    
    [self.floorSelectionButton setBackgroundImage:floorSelectionButtonImgNor forState:UIControlStateNormal];
    [self.floorSelectionButton setBackgroundImage:floorSelectionButtonImgPre forState:UIControlStateSelected];
    [self.floorSelectionButton addTarget:self action:@selector(floorSelectionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.floorSelectionButton];
}

- (void)initShowLogButton {
    UIImage *showLogButtonImgNor = [UIImage imageNamed:@"log_nor_btn"];
    UIImage *showLogButtonImgPre = [UIImage imageNamed:@"log_pre_btn"];
    
    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    int navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.showLogButton = [[UIButton alloc] initWithFrame:CGRectMake(10,
                                                                    self.view.frame.size.height - 10 - showLogButtonImgNor.size.height - statusBarHeight - navigationBarHeight,
                                                                    showLogButtonImgNor.size.width,
                                                                    showLogButtonImgNor.size.height)];
    
    [self.showLogButton setImage:showLogButtonImgNor forState:UIControlStateNormal];
    [self.showLogButton setImage:showLogButtonImgPre forState:UIControlStateSelected];
    [self.showLogButton addTarget:self action:@selector(showLogVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.showLogButton];
}

#pragma mark - FloorSelectionDelegate

- (void)floorSelectedByFloorChanged:(BOOL)floorChanged {
    if (floorChanged) {
        if ([self.mapViewerController reloadMap]==NO) {
            NSLog(@"There is no current floorId...");
        }
        // 층 선택 버튼을 누르면 deselect하므로, 여기서 할 필요 없음
//        [self deselectCurrentPosition];
    }
    [self showFloorSelectionViews:NO];
}

#pragma mark - mapDirectionButtonDelegate

- (void)selectedDirectionDetailShow {
    [self startMapDirection];
    [self showDirectionDetailViewController];
}

- (void)selectedMapDirectionExit {
    [self mapCancelButtonClicked];
}


#pragma mark - Selector

- (void)mapInfoButtonClicked {
    [self showDirectionDetailViewController];
}

- (void)mapCancelButtonClicked {
    [self deselectCurrentPosition];
    [self showMapDirectionView:NO];
    
    [self.mapViewerController removeMapPath];
    
    self.navigationItem.title = [self.mapInfoProvider getCurrentBranchName];
}

- (void)changeCurrentPositionButtonImage:(BOOL)selected {
    UIImage *curPosButtonImgNor = nil;
    UIImage *curPosButtonImgPre = nil;
    
    if (selected) {
        curPosButtonImgNor = [UIImage imageNamed:@"map_here_pre"];
        curPosButtonImgPre = [UIImage imageNamed:@"map_here_pre_sel"];
    } else {
        curPosButtonImgNor = [UIImage imageNamed:@"map_here_nor_btn"];
        curPosButtonImgPre = [UIImage imageNamed:@"map_here_sel_btn"];
    }

    [self.currentPositionButton setImage:curPosButtonImgNor forState:UIControlStateNormal];
    [self.currentPositionButton setImage:curPosButtonImgPre forState:UIControlStateSelected];
}

- (void)currentPositionButtonClicked {
    if (self.isCurrentPositionButtonSelected==YES) {
        [self deselectCurrentPosition];
    } else {
        [self selectCurrentPosition];
    }
}

- (void)selectCurrentPosition {
    self.isCurrentPositionButtonSelected = YES;

    [self changeCurrentPositionButtonImage:YES];
    [self.mapViewerController currentPositionSelected:YES];
}

- (void)deselectCurrentPosition {
    self.isCurrentPositionButtonSelected = NO;
    
    [self changeCurrentPositionButtonImage:NO];
    [self.mapViewerController currentPositionSelected:NO];
}

- (void)floorSelectionButtonClicked {
    [self deselectCurrentPosition];
    [self showFloorSelectionViews:YES];
    [self.floorSelectionView updateFloorSelection];
}

#pragma mark - Show or Hide View

- (void)showFloorSelectionViews:(BOOL)show {
    if (show==YES) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.floorSelectionView];
        //        [self.view addSubview:self.floorSelectionBackView];
    } else {
        [self.floorSelectionView removeFromSuperview];
    }
}

- (void)showLogVC:(id)sender {
    SLBSGroupLogViewController *viewController = [[SLBSGroupLogViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)showSearchViewController {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.callerViewController = self;
    searchVC.mapCommandDelegate = self;
    searchVC.mapInfoProvider = self.mapInfoProvider;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)showMapDirectionView:(BOOL)show {
    if (show) {
        if ([self.mapDirectionView superview]!=nil) {
            return;
        }
        [self.view addSubview:self.mapDirectionView];
        [self moveShowLogButtonUp];
    } else {
        if ([self.mapDirectionView superview]==nil) {
            return;
        }
        [self.mapDirectionView removeFromSuperview];
        [self moveShowLogButtonDown];
    }
}

- (void)moveShowLogButtonUp {
    UIImage *showLogButtonImgNor = [UIImage imageNamed:@"log_nor_btn"];
    self.showLogButton.frame = CGRectMake(self.showLogButton.frame.origin.x,
                                          self.view.frame.size.height - 10 - showLogButtonImgNor.size.height - 60,
                                          self.showLogButton.frame.size.width,
                                          self.showLogButton.frame.size.height);
}

- (void)moveShowLogButtonDown {
    UIImage *showLogButtonImgNor = [UIImage imageNamed:@"log_nor_btn"];
    self.showLogButton.frame = CGRectMake(self.showLogButton.frame.origin.x,
                                          self.view.frame.size.height - 10 - showLogButtonImgNor.size.height,
                                          self.showLogButton.frame.size.width,
                                          self.showLogButton.frame.size.height);
}

- (void)showIndicatorView:(BOOL)show {
    if (show==YES) {
        if ([self.indicatorView superview]!=nil) {
            return;
        }
        [self.view addSubview:self.indicatorView];
        [self.indicatorView startAnimating];
    } else {
        if ([self.indicatorView superview]==nil) {
            return;
        }
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
    }
}

- (void)showDirectionDetailViewController {
    DirectionDetailViewController *directionVC = [[DirectionDetailViewController alloc] init];
    directionVC.mapDirectionDelegate = self;
    directionVC.mapInfoProvider = self.mapInfoProvider;
    
    directionVC.mapCommandDelegate = self;  // for searchviewcontroller and campaigninboxviewcontroller
    
    UINavigationController *directionNavC = [[UINavigationController alloc] initWithRootViewController:directionVC];
    [self presentViewController:directionNavC animated:YES completion:nil];
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    // parent가 nil이면, back으로 돌아갈때임
    if (parent==nil) {
        [self.mapViewerController stopMonitoring];
        [self.mapViewerController stopMapManager];
    }
}

#pragma mark - MapActionDelegate

- (void)beginPathFindingAction {
    [self showIndicatorView:YES];
}

- (void)endPathFindingAction:(BOOL)isSuccess {
    if (isSuccess) {
        [self startMapDirection];
        [self showDirectionDetailViewController];
    }
    
    [self showIndicatorView:NO];
}

- (void)beginMapLoadingAction {
    [self showIndicatorView:YES];
}

- (void)endMapLoadingAction:(SLBSMapViewData*)mapData isSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        // update navigation title
        self.navigationItem.title = [self.mapInfoProvider getCurrentBranchName];
        
        // update current loaded branch, floor, map id
        [self updateMapInfo:[mapData.ID intValue]];
    } else {
        [self updateFloorButton];
    }
    
    // hide indicator
    [self showIndicatorView:NO];
}

- (void)doSelectCurrentPosition:(BOOL)select {
    if (select) {
        [self selectCurrentPosition];
    } else {
        [self deselectCurrentPosition];
    }
}

- (void)updateMapInfo:(int)mapId {
    SLBSFloor *floor = [self.mapInfoProvider getFloorByMapId:mapId];
    
    self.mapInfoProvider.currentBranchId = floor.branchId;
    self.mapInfoProvider.currentFloorId = floor.floorId;
    self.mapInfoProvider.currentMapId = [NSNumber numberWithInt:mapId];
    [self.floorSelectionButton setTitle:floor.name forState:UIControlStateNormal];
}

- (void)updateFloorButton {
    SLBSFloor *floor = [self.mapInfoProvider getCurrentFloor];
    [self.floorSelectionButton setTitle:floor.name forState:UIControlStateNormal];
}


#pragma mark - map direction

-(void)startMapDirection {
    [self showMapDirectionView:NO];
    [self showMapDirectionView:YES];
    
    // update navigation title
//    MapPathViewData *startPathData = [self.appDataManager.curDirectionArray objectAtIndex:0];
    MapPathViewData *endPathData = [self.appDataManager.curDirectionArray objectAtIndex:self.appDataManager.curDirectionArray.count - 1];
    
    NSString *removedStr = [endPathData.vertexName stringByReplacingOccurrencesOfString:@" 인근" withString:@""];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ 길안내", removedStr];
}

-(void)endMapDirection {
    [self mapCancelButtonClicked];
}

#pragma mark - MapCommandDelegate, InboxMapCommandDelegate

-(void)moveToStore:(NSNumber*)zoneId {
    [self deselectCurrentPosition];
    [self.mapViewerController moveToStore:zoneId];
}

-(void)directToStore:(NSNumber*)zoneId {
    [self.mapViewerController directToStore:zoneId];
}

#pragma mark - Campaign Test

//- (void)testShowCampaignPopup:(int)campaignId {
//    NetworkDataRequester *requester = [NetworkDataRequester sharedInstance];
//    [requester requestCampaignInfo:^(NSArray *campaignArray) {
//        if (campaignArray!=nil) {
//            for (int i=0; i<campaignArray.count; i++) {
//                Campaign *campaign = [campaignArray objectAtIndex:i];
//                NSString *campaignImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_IP_HEAD, campaign.imageUrl];
//
//                [CampaignArchiver archiveCampaign:campaign campaignId:campaignId];
//
//                [self showCampaignPopupViewWithImageUrl:campaignImageUrl title:campaign.title desc:campaign.desc];
//            }
//        } else {
//            TSGLog(TSLogGroupApplication, @"No Campaign Info!!!");
//        }
//    } campaignId:campaignId];
//}

#pragma mark - System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
