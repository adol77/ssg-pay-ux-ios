//
//  SearchViewController.m
//  SDKSample
//
//  Created by Jeoungsoo on 10/3/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDataManager.h"
#import <SLBSSDK/Zone.h>

#import "CampaignInboxViewController.h"
#import "ColorUtil.h"
#import "SearchTableViewCell.h"
#import "StorePopupView.h"

// Alert View Tag
#define MAP_DIRECTION_FROM_STORE_POPUP  1
#define MAP_DIRECTION_FROM_CELL_ICON    2


@interface SearchViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, StoreCommandDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong) AppDataManager *appDataManager;

@property (nonatomic, strong) UIView *indicatorBackView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *searchResultTV;

@property (nonatomic, strong) StorePopupView *storePopupView;
@property (nonatomic, strong) NSNumber *mapDirectionZoneId;

@property (nonatomic, strong) NSNumber *cellHeight;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.appDataManager = [AppDataManager sharedInstance];

    self.view.backgroundColor = [UIColor whiteColor];

    [self revertZoneListArray];
    [self initNavigationBar];
    [self initSearchBar];
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init

- (void)initNavigationBar {
    // navigation title
    self.navigationItem.title = @"검색";
    
    // back button
    UIImage *backButtonImgNor = [UIImage imageNamed:@"nav_back_nor_btn"];
    UIImage *backButtonImgPre = [UIImage imageNamed:@"nav_back_pre_btn"];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backButtonImgNor.size.width, backButtonImgNor.size.height)];
    [backButton setImage:backButtonImgNor forState:UIControlStateNormal];
    [backButton setImage:backButtonImgPre forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    // campaign inbox button
    UIImage *inboxButtonImgNor = [UIImage imageNamed:@"nav_campaign_nor_btn"];
    UIImage *inboxButtonImgPre = [UIImage imageNamed:@"nav_campaign_pre_btn"];
    
    UIButton *inboxButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, inboxButtonImgNor.size.width, inboxButtonImgNor.size.height)];
    [inboxButton setImage:inboxButtonImgNor forState:UIControlStateNormal];
    [inboxButton setImage:inboxButtonImgPre forState:UIControlStateSelected];
    [inboxButton addTarget:self action:@selector(campaignInboxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *inboxButtonItem = [[UIBarButtonItem alloc] initWithCustomView:inboxButton];
    
    self.navigationItem.rightBarButtonItem = inboxButtonItem;
}

- (void)doBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)campaignInboxButtonClicked {
    [self dismissViewControllerAnimated:YES completion:^{
        CampaignInboxViewController *campaignVC = [[CampaignInboxViewController alloc] init];
        campaignVC.mapCommandDelegate = self.mapCommandDelegate;
        campaignVC.mapInfoProvider = self.mapInfoProvider;
        campaignVC.callerViewController = self.callerViewController;
        
        UINavigationController *campaignNavC = [[UINavigationController alloc] initWithRootViewController:campaignVC];
        [self.callerViewController presentViewController:campaignNavC animated:YES completion:nil];
   }];
}

- (void)initSearchBar {
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
//    CGFloat statusBarHeight = 0;
//    CGFloat navigationBarHeight = 0;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,
                                                                   statusBarHeight + navigationBarHeight,
                                                                   self.view.frame.size.width,
                                                                   50)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search";
    [self.view addSubview:self.searchBar];
}

- (void)initTableView {
    self.cellHeight = [NSNumber numberWithInt:70];
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
//    CGFloat statusBarHeight = 0;
//    CGFloat navigationBarHeight = 0;
    
    CGFloat tvTop = statusBarHeight + navigationBarHeight + self.searchBar.frame.size.height;

    self.searchResultTV = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                        tvTop,
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height - tvTop) style:UITableViewStylePlain];
    self.searchResultTV.backgroundColor = [ColorUtil searchBgColor];
    self.searchResultTV.separatorColor = [ColorUtil searchLineColor];

    self.searchResultTV.delegate = self;
    self.searchResultTV.dataSource = self;
    [self.view addSubview:self.searchResultTV];
}


#pragma mark - Indicator View

- (void)showIndicatorView:(BOOL)show {
    if (show==YES) {
        // indicator back view
        self.indicatorBackView = [[UIView alloc] initWithFrame:self.view.frame];
        self.indicatorBackView.backgroundColor = [ColorUtil popupBgColor];
        [self.view addSubview:self.indicatorBackView];
        
        // indicator view
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.indicatorView.center = self.indicatorBackView.center;
        [self.indicatorBackView addSubview:self.indicatorView];
    } else {
        [self.indicatorBackView removeFromSuperview];
        [self.indicatorView removeFromSuperview];
    }
}

- (void)toggleIndicatorAnimating:(BOOL)start {
    if (start==YES) {
        [self showIndicatorView:YES];
        [self.indicatorView startAnimating];
    } else {
        [self.indicatorView stopAnimating];
        [self showIndicatorView:NO];
    }
}


#pragma mark - Search Delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self resetSearchBar];
    [self revertZoneListArray];
    [self.searchResultTV reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)resetSearchBar {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = @"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    NSLog(@"textDidChange() searchText=%@", searchText);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    self.appDataManager.zoneListSearchArray = [NSMutableArray arrayWithArray:[self.appDataManager.zoneListArray filteredArrayUsingPredicate:predicate]];
    [self.searchResultTV reloadData];
}

- (void)revertZoneListArray {
    self.appDataManager.zoneListSearchArray = self.appDataManager.zoneListArray;
}

- (void)moveToStoreFromCell:(int)index {
    Zone *zone = [self.appDataManager.zoneListSearchArray objectAtIndex:index];
    
    [self resetSearchBar];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mapCommandDelegate moveToStore:zone.zone_id];
    }];
}

- (void)directToStoreFromCell:(int)index {
    Zone *zone = [self.appDataManager.zoneListSearchArray objectAtIndex:index];
    self.mapDirectionZoneId = zone.zone_id;
    
    // zone.name을 임시로 사용. 원래는 tenant_name이 맞음
    NSString *displayTenantName = zone.name;
//    NSString *displayTenantName = zone.tenant_name;
    if (displayTenantName==nil || displayTenantName.length <= 0) {
        displayTenantName = @"매장";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@(으)로 길안내를 시작 하시겠습니까?", displayTenantName];
    [self showTwoButtonAlertPopupWithTitle:title tag:(int)MAP_DIRECTION_FROM_CELL_ICON];
}

- (void)directToStoreFromStorePopup:(NSNumber*)zoneId {
    [self resetSearchBar];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mapCommandDelegate directToStore:zoneId];
    }];
}

#pragma mark - Store Popup

- (void)showStorePopupWithZone:(Zone*)zone zoneArrayIndex:(int)zoneArrayIndex {
    if ([self.storePopupView superview]!=nil) {
        [self.storePopupView removeFromSuperview];
    }
    
    SLBSFloor *floor = [self.mapInfoProvider getFloorByMapId:[zone.map_id intValue]];
    self.storePopupView = [[StorePopupView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                           zone:zone floor:floor];
    [self.storePopupView.storeDirectButton addTarget:self
                                              action:@selector(storePopupMapDirectionClicked:)
                                    forControlEvents:UIControlEventTouchUpInside];
    [self.storePopupView.storeCloseButton addTarget:self
                                             action:@selector(storePopupCloseButtonClicked)
                                   forControlEvents:UIControlEventTouchUpInside];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.storePopupView];
}

- (void)storePopupMapDirectionClicked:(id)sender {
    UIButton *storeDirectionButton = (UIButton*)sender;

    NSNumber *zoneId = [NSNumber numberWithInt:(int)storeDirectionButton.tag];
    Zone *zone = [self.mapInfoProvider getZoneByZoneId:zoneId];
    
    self.mapDirectionZoneId = zoneId;
    
    // zone.name을 임시로 사용. 원래는 tenant_name이 맞음
    NSString *tenantName = zone.name;
//    NSString *tenantName = zone.tenant_name;
    if (tenantName==nil || tenantName.length <= 0) {
        tenantName = @"매장";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@(으)로 길안내를 시작 하시겠습니까?", tenantName];
    [self showTwoButtonAlertPopupWithTitle:title tag:MAP_DIRECTION_FROM_STORE_POPUP];
}

- (void)storePopupCloseButtonClicked {
    [self.storePopupView removeFromSuperview];
}

- (void)showTwoButtonAlertPopupWithTitle:(NSString*)title tag:(int)tag {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"취소"
                                              otherButtonTitles:@"확인", nil];
    alertView.tag = tag;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"확인"]) {
        if (alertView.tag==MAP_DIRECTION_FROM_CELL_ICON) {
            [self resetSearchBar];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.mapCommandDelegate directToStore:self.mapDirectionZoneId];
            }];
        } else if (alertView.tag==MAP_DIRECTION_FROM_STORE_POPUP) {
            [self directToStoreFromStorePopup:self.mapDirectionZoneId];
            [self.storePopupView removeFromSuperview];
        }
    } else if ([title isEqualToString:@"취소"]) {
        
    }
}


#pragma mark - Search TableView and Floor TableView Delegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appDataManager.zoneListSearchArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeight intValue];
}

static NSString *SEARCH_CELL_IDENTIFIER = @"searchCellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Zone *zone = [self.appDataManager.zoneListSearchArray objectAtIndex:(int)indexPath.row];
    
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_CELL_IDENTIFIER];
    if (cell==nil) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SEARCH_CELL_IDENTIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storeCommandDelegate = self;
    }
    
    // set index
    cell.arrayIndex = [NSNumber numberWithInt:(int)indexPath.row];
    
    // update text
    [cell updateSearchName:zone.name];

    NSString *branchName = [self.mapInfoProvider getBranchNameByBranchId:zone.store_branch_id];
    [cell updateSearchNameDesc:branchName];
    
    [cell updateCampaignIconWithCount:[zone.campaign_count intValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    
    Zone *zone = [self.appDataManager.zoneListSearchArray objectAtIndex:(int)indexPath.row];
    [self showStorePopupWithZone:zone zoneArrayIndex:(int)indexPath.row];
}


@end
