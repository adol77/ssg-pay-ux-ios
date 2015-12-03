//
//  CampaignInboxViewController.m
//  SDKSample
//
//  Created by Jeoungsoo on 9/18/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "CampaignInboxViewController.h"
#import "CampaignArchiver.h"
#import "AppDefine.h"
#import "NetworkDataRequester.h"
#import "ColorUtil.h"
#import "AppDelegate.h"
#import "AppDataManager.h"
#import "SLBSGroupLogViewController.h"
#import "SearchViewController.h"
#import "CampaignInboxTableViewCell.h"

#import "Util.h"

#define ALERT_VIEW_TAG_MAP_DIRECTION    1
#define ALERT_VIEW_TAG_CAMPAIGN_DELETE  2


@interface CampaignInboxViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, StoreCommandDelegate>

@property (nonatomic, strong) UIView *campaignPopupBackView;
@property (nonatomic, strong) UITableView *campaignInboxTV;

@property (nonatomic, strong) NSNumber *cellHeight;
@property (nonatomic, strong) UIButton *showLogButton;

@property (nonatomic, strong) AppDataManager *appDataManager;

@property (nonatomic, strong) NSNumber *mapDirectionZoneId;
@property (nonatomic, strong) Campaign *campaignForMapDirection;


@end

@implementation CampaignInboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.appDataManager = [AppDataManager sharedInstance];

    [self initNavigationBar];
    [self initCampaignInboxTableView];
    [self initShowLogButton];
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
    [self.showLogButton addTarget:self action:@selector(showLogVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.showLogButton];
}

- (void)showLogVC {
    SLBSGroupLogViewController *viewController = [[SLBSGroupLogViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)initNavigationBar {
    self.navigationItem.title = @"캠페인 수신함";
    
    // back button
    UIImage *backButtonImgNor = [UIImage imageNamed:@"nav_back_nor_btn"];
    UIImage *backButtonImgPre = [UIImage imageNamed:@"nav_back_pre_btn"];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backButtonImgNor.size.width, backButtonImgNor.size.height)];
    [backButton setImage:backButtonImgNor forState:UIControlStateNormal];
    [backButton setImage:backButtonImgPre forState:UIControlStateSelected];
    [backButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;

    // search button
    UIImage *searchButtonImgNor = [UIImage imageNamed:@"nav_search_nor_btn"];
    UIImage *searchButtonImgPre = [UIImage imageNamed:@"nav_search_per_btn"];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, searchButtonImgNor.size.width, searchButtonImgNor.size.height)];
    [searchButton setImage:searchButtonImgNor forState:UIControlStateNormal];
    [searchButton setImage:searchButtonImgPre forState:UIControlStateSelected];
    [searchButton addTarget:self action:@selector(showSearchViewController) forControlEvents:UIControlEventTouchUpInside];
    
    // search button long press
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showCampaignRemoveAllPopup:)];
    [searchButton addGestureRecognizer:longPress];
    
    
    UIBarButtonItem *searchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchButtonItem;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)showSearchViewController {
#ifdef CAMPAIGN_TEST
    [self testCampaignAdd:44];
    [self testCampaignAdd:45];
    [self testCampaignAdd:46];
#else
#endif
    
    [self dismissViewControllerAnimated:YES completion:^{
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.mapCommandDelegate = self.mapCommandDelegate;
        searchVC.mapInfoProvider = self.mapInfoProvider;
        searchVC.callerViewController = self.callerViewController;
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:searchVC];
        [self.callerViewController presentViewController:navigationController animated:YES completion:nil];
    }];
}

- (void)showCampaignRemoveAllPopup:(UILongPressGestureRecognizer*)recognizer {
    if (recognizer.state==UIGestureRecognizerStateBegan) {
        [self showTwoButtonAlertPopupWithTitle:@"캠페인을 모두 삭제하시겠습니까?" tag:ALERT_VIEW_TAG_CAMPAIGN_DELETE];
    }
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
        if (alertView.tag==ALERT_VIEW_TAG_CAMPAIGN_DELETE) {
            BOOL ret = [CampaignArchiver removeAllCampaignFile];
            if (ret==NO) {
                [Util showAlertPopupWithTitle:@"캠페인을 삭제할 수 없습니다"];
            } else {
                self.appDataManager.campaignArray = [NSMutableArray array];
                [Util showAlertPopupWithTitle:@"캠페인을 삭제하였습니다"];
                [self.campaignInboxTV reloadData];
            }
        } else if (alertView.tag==ALERT_VIEW_TAG_MAP_DIRECTION) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.mapCommandDelegate directToStore:self.mapDirectionZoneId];
                
                // @SSG
                if ([self.campaignForMapDirection.type intValue] == 3) { //for parking
                    [self.appDataManager.campaignArray removeObject:self.campaignForMapDirection];
                }
                //
            }];
        }
    } else if ([title isEqualToString:@"취소"]) {
        
    }
}


#ifdef CAMPAIGN_TEST
// for debugging
- (void)testCampaignAdd:(int)campaignId {
    NetworkDataRequester *requester = [NetworkDataRequester sharedInstance];
    [requester requestCampaignInfo:^(NSArray *campaignArray) {
        if (campaignArray!=nil) {
            for (int i=0; i<campaignArray.count; i++) {
                Campaign *campaign = [campaignArray objectAtIndex:i];
                //                NSString *campaignImageUrl = [NSString stringWithFormat:@"%@%@", SERVER_IP_HEAD, campaign.imageUrl];
                campaign.zoneType = [NSNumber numberWithInt:4];
                
                [CampaignArchiver archiveCampaign:campaign campaignId:campaignId];
                
                //                [self showCampaignPopupViewWithImageUrl:campaignImageUrl title:campaign.title desc:campaign.desc];
            }
        } else {
            NSLog(@"No Campaign Info!!!");
        }
    } campaignId:campaignId];
}
#else
#endif

- (void)initCampaignInboxTableView {
    self.cellHeight = [NSNumber numberWithInt:70];
    
    self.campaignInboxTV = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.campaignInboxTV.backgroundColor = [ColorUtil searchBgColor];
    self.campaignInboxTV.separatorColor = [ColorUtil searchLineColor];

    self.campaignInboxTV.delegate = self;
    self.campaignInboxTV.dataSource = self;
    
    [self.view addSubview:self.campaignInboxTV];
}

- (void)closeButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeight intValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.appDataManager.campaignArray!=nil) {
        return self.appDataManager.campaignArray.count;
    }
    
    return 0;
}

static NSString *CAMPAIGN_INBOX_IDENTIFIER = @"campaignInboxCellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CampaignInboxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CAMPAIGN_INBOX_IDENTIFIER];
    if (cell==nil) {
        cell = [[CampaignInboxTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CAMPAIGN_INBOX_IDENTIFIER];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.storeCommandDelegate = self;
    }
    
    // set index
    cell.arrayIndex = [NSNumber numberWithInt:(int)indexPath.row];
    
    Campaign *campaign = [self.appDataManager.campaignArray objectAtIndex:(int)indexPath.row];
    [cell updateTitle:campaign.title];
    
    if ([campaign.zoneType intValue]!=ZONE_TYPE_STORE) {
        [cell updateAllIconDisplay:YES];
    } else {
        [cell updateAllIconDisplay:NO];
    }

    // @SSG
    if ([campaign.type intValue] == 3) { //for parking
        [cell updateMoveToIconDisplay:YES];
        [cell updateDirectToIconDisplay:NO];
        [cell updateSeparatorIconDisplay:NO];
        
        [cell updateTitle:[NSString stringWithFormat:@"주차위치 %@", campaign.title]];
    }
    //

    return cell;
}

- (void)moveToStoreFromCell:(int)index {
    Campaign *campaign = [self.appDataManager.campaignArray objectAtIndex:index];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.mapCommandDelegate moveToStore:campaign.zoneId];
    }];
}

- (void)directToStoreFromCell:(int)index {
    Campaign *campaign = [self.appDataManager.campaignArray objectAtIndex:index];
    self.mapDirectionZoneId = campaign.zoneId;
    self.campaignForMapDirection = campaign;
    
    NSString *campaignTitle = campaign.title;
    if (campaignTitle==nil || campaignTitle.length <= 0) {
        campaignTitle = @"캠페인";
    }
    NSString *title = [NSString stringWithFormat:@"%@(으)로 길안내를 시작 하시겠습니까?", campaignTitle];
    [self showTwoButtonAlertPopupWithTitle:title tag:ALERT_VIEW_TAG_MAP_DIRECTION];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Campaign *campaign = [self.appDataManager.campaignArray objectAtIndex:(int)indexPath.row];

    // @SSG
    if ([campaign.type intValue] == 3) { //for parking
        return;
    }
    //

    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate showCampaignPopupViewWithCampaign:campaign];
}

- (void)hideCampaignPopupView {
    [_campaignPopupBackView removeFromSuperview];
}

- (void)campaignCloseButtonClicked {
    [self hideCampaignPopupView];
}

@end
