//
//  ViewController.m
//  SDKSample
//
//  Created by Regina on 2015. 8. 28..
//  Copyright (c) 2015년 Regina. All rights reserved.
//
// Fixed done for s-lbs demo 1st.

#import "HomeViewController.h"
#import "NetworkDataRequester.h"
#import "AppDataManager.h"

#import <SLBSSDK/SLBSCompany.h>
#import <SLBSSDK/SLBSBrand.h>
#import <SLBSSDK/SLBSBranch.h>
#import <SLBSSDK/SLBSFloor.h>
#import <SLBSSDK/Zone.h>
#import <SLBSSDK/SLBSDataManager.h>

#import "MapViewController.h"
#import "CampaignInboxViewController.h"
#import "SLBSGroupLogViewController.h"
#import "Util.h"

#import "CampaignConditionChecker.h"
#import "IndicatorView.h"

#import "AppDelegate.h"
#import "AppDefine.h"



@interface HomeViewController ()

@property (nonatomic, strong) AppDataManager *appDataManager;

@property (nonatomic, strong) MapViewController *mapVC;

@property (nonatomic, strong) UIImageView *backgroundIV;
@property (nonatomic, strong) UIImageView *titleIV;
@property (nonatomic, strong) UIButton *showMapButton;
@property (nonatomic, strong) UIButton *showCampaignInboxButton;
//@property (nonatomic, strong) UIButton *requestFloorDataButton;
@property (nonatomic, strong) UIButton *showLogButton;
@property (nonatomic, strong) UILabel *sepLabel;
@property (nonatomic, strong) UIButton *functionCheckButton;
@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) IndicatorView *indicatorView;

// @SSG
@property (nonatomic, strong) UILabel *sepLabel2;
@property (nonatomic, strong) UIButton *showIncMapButton;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDataManager = [AppDataManager sharedInstance];
    
    [self initBackgroundImage];
    [self initTitleImage];
    [self initButtons];
    [self initIndicatorView];

    [self initIncMapButton]; //@SSG
    
    [self showIndicatorView:YES];
    [self startDataManager];
}

- (void)startDataManager {
    [[SLBSDataManager sharedInstance] setDelegate:self];
    [[SLBSDataManager sharedInstance] startMonitoring];
}

// @SSG
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize

- (void)initBackgroundImage {
//    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
//    int navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    self.backgroundIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,
                                                                  self.view.frame.size.width, self.view.frame.size.height)];
    self.backgroundIV.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:self.backgroundIV];
}

- (void)initTitleImage {
    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    UIImage *titleImage = [UIImage imageNamed:@"main_title"];
    self.titleIV = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - titleImage.size.width)/2, statusBarHeight + 100,
                                                                 titleImage.size.width, titleImage.size.height)];
    self.titleIV.image = titleImage;
    [self.view addSubview:self.titleIV];
}

- (void)initButtons {
    [self initMapButton];
    [self initCampaignInboxButton];
//    [self initFloorDataRequestingButton];
    [self initVersionLabel];
    [self initBottomButtons];
}

- (void)initMapButton {
    UIImage *mapButtonImgNor = [UIImage imageNamed:@"main_btn_1"];
    UIImage *mapButtonImgPre = [UIImage imageNamed:@"main_btn_1"];
    
    self.showMapButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - mapButtonImgNor.size.width)/2,
                                                                    self.titleIV.frame.origin.y + self.titleIV.frame.size.height + 20,
                                                                    mapButtonImgNor.size.width,
                                                                    mapButtonImgNor.size.height)];
    [self.showMapButton setImage:mapButtonImgNor forState:UIControlStateNormal];
    [self.showMapButton setImage:mapButtonImgPre forState:UIControlStateSelected];
    
    [self.showMapButton addTarget:self action:@selector(showMapButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.showMapButton];
}

- (void)initCampaignInboxButton {
//    UIImage *campButtonImgNor = [UIImage imageNamed:@"main_campaign_nor_btn"];
//    UIImage *campButtonImgPre = [UIImage imageNamed:@"main_campaign_pre_btn"];
//    
//    self.showCampaignInboxButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - campButtonImgNor.size.width)/2,
//                                                                    self.showMapButton.frame.origin.y + self.showMapButton.frame.size.height + 20,
//                                                                    campButtonImgNor.size.width,
//                                                                    campButtonImgNor.size.height)];
//    
//    [self.showCampaignInboxButton setImage:campButtonImgNor forState:UIControlStateNormal];
//    [self.showCampaignInboxButton setImage:campButtonImgPre forState:UIControlStateSelected];
//    
//    [self.showCampaignInboxButton addTarget:self action:@selector(showCampaignInboxButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//
//    [self.view addSubview:self.showCampaignInboxButton];
}

- (void)initVersionLabel {
    // version
    NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    
    self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 120,
                                                                  self.view.frame.size.height - 40,
                                                                  80, 50)];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", version];
    self.versionLabel.font = [UIFont systemFontOfSize:12];
    self.versionLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.versionLabel];
    
    // separator label
    self.sepLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.versionLabel.frame.origin.x + 70,
                                                              self.versionLabel.frame.origin.y ,
                                                              20, 50)];
    self.sepLabel.text = @" | ";
    self.sepLabel.textAlignment = NSTextAlignmentCenter;
    self.sepLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.sepLabel];
}

- (void)initBottomButtons {
    // show log button
    self.showLogButton = [[UIButton alloc] initWithFrame:CGRectMake(self.sepLabel.frame.origin.x + 10 ,
                                                                    self.versionLabel.frame.origin.y,
                                                                    80, 50)];
    [self.showLogButton setTitle:@"로그보기" forState:UIControlStateNormal];
    self.showLogButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.showLogButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showLogButton addTarget:self action:@selector(showLogButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.showLogButton];

    // separator label
    self.sepLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.showLogButton.frame.origin.x + 70,
                                                               self.versionLabel.frame.origin.y,
                                                               20, 50)];
    self.sepLabel2.text = @" | ";
    self.sepLabel2.textAlignment = NSTextAlignmentCenter;
    self.sepLabel2.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.sepLabel2];
    
    // function check button
    self.functionCheckButton = [[UIButton alloc] initWithFrame:CGRectMake(self.sepLabel2.frame.origin.x + 10,
                                                                          self.versionLabel.frame.origin.y,
                                                                          80, 50)];
    [self.functionCheckButton setTitle:@"기능검증" forState:UIControlStateNormal];
    self.functionCheckButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.functionCheckButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.functionCheckButton addTarget:self action:@selector(functionCheckButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.functionCheckButton];
    

}

- (void)initIndicatorView {
    self.indicatorView = [[IndicatorView alloc] initWithFrame:self.view.frame];
}


//- (void)initFloorDataRequestingButton {
//    int viewWidth = self.view.frame.size.width;
//    int viewHeight = self.view.frame.size.height;
//    
//    float buttonWidth = 200;
//    float buttonHeight = 50;
//    
//    float addNotiButtonLeft = (viewWidth - buttonWidth)/2;
//    float addNotiButtonTop = viewHeight - 70 - 50 - 10;
//    
//    self.requestFloorDataButton = [[UIButton alloc] initWithFrame:CGRectMake(addNotiButtonLeft, addNotiButtonTop, buttonWidth, buttonHeight)];
//    [self.requestFloorDataButton setTitle:@"FLOOR 정보요청" forState:UIControlStateNormal];
//    [self.requestFloorDataButton addTarget:self action:@selector(loadFloorInfo) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.requestFloorDataButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.requestFloorDataButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//    
//    self.requestFloorDataButton.enabled = NO;
//    
//    [self.view addSubview:self.requestFloorDataButton];
//}

- (void)functionCheckButtonClicked {
    
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

#pragma mark - Floor Info

- (void)loadFloorInfo {
    [self loadCompanyInfo];
}

- (void)loadCompanyInfo {
    [[SLBSDataManager sharedInstance] requestCompanyListWithBlock:^(NSArray* companyList, NSInteger resultCode) {
        if(companyList != nil) {
            self.appDataManager.companyArray = companyList;
            
            TSGLog(TSLogGroupApplication, @"Company Info Loaded!!!");
            
            if (companyList.count > 0) {
#ifdef USE_NEW_ADDR_ARCH
                [self loadBrandInfoByCompanyId:DEFAULT_COMPANY_ID];
#else
                SLBSCompany *company = [companyList objectAtIndex:0];
                [self loadBrandInfoByCompanyId:[company.companyId intValue]];
#endif
            } else {
                [self showIndicatorView:NO];
                TSGLog(TSLogGroupApplication, @"No Company Info!!!");
                [Util showAlertPopupWithTitle:@"회사 정보가 없습니다!!!"];
            }
        }
        else {
            [self showIndicatorView:NO];
            TSGLog(TSLogGroupApplication, @"Request Company Failed!!!");
            [Util showAlertPopupWithTitle:@"회사 정보 요청에 실패하였습니다!!!"];
        }
    }];
}

- (void)loadBrandInfoByCompanyId:(int)companyId {
    [[SLBSDataManager sharedInstance] requestBrandListWithCompanyId:companyId block:^(NSArray* brandList, NSInteger resultCode) {
        if (brandList!=nil) {
            self.appDataManager.brandArray = brandList;

            TSGLog(TSLogGroupApplication, @"Brand Info Loaded!!!");
            
            // get first brand
            if (brandList.count > 0) {
                SLBSBrand *brand = [brandList objectAtIndex:0];
                [self loadBranchInfoByCompanyId:companyId brandId:[brand.brandId intValue]];
            } else {
                [self showIndicatorView:NO];
                TSGLog(TSLogGroupApplication, @"No Company Info!!!");
                [Util showAlertPopupWithTitle:@"브랜드 정보가 없습니다!!!"];
            }
        } else {
            [self showIndicatorView:NO];
            TSGLog(TSLogGroupApplication, @"Request Company Failed!!!");
            [Util showAlertPopupWithTitle:@"브랜드 정보 요청에 실패하였습니다!!!"];
        }
    }];
}

- (void)loadBranchInfoByCompanyId:(int)companyId brandId:(int)brandId {
    [[SLBSDataManager sharedInstance] requestBranchListWithCompanyId:companyId brandId:brandId branchId:-1 block:^(NSArray *branchArray, NSInteger resultCode) {
        if (branchArray!=nil) {
            self.appDataManager.branchArray = branchArray;

            TSGLog(TSLogGroupApplication, @"Branch Info Loaded!!!");
            
            // get first branch
            if (branchArray.count > 0) {
                SLBSBranch *branch = [branchArray objectAtIndex:0];
                [self loadBranchInfoByCompanyId:-1 brandId:-1 branchId:[branch.branchId intValue]];
            } else {
                [self showIndicatorView:NO];
                TSGLog(TSLogGroupApplication, @"No Branch Info!!!");
                [Util showAlertPopupWithTitle:@"브랜치 정보가 없습니다!!!"];
            }
        } else {
            [self showIndicatorView:NO];
            TSGLog(TSLogGroupApplication, @"Request Branch Failed!!!");
            [Util showAlertPopupWithTitle:@"브랜치 정보 요청에 실패하였습니다!!!"];
        }
    }];
}

// 인접한 branch 정보를 얻어오기
- (void)loadBranchInfoByCompanyId:(int)companyId brandId:(int)brandId branchId:(int)branchId {
    [[SLBSDataManager sharedInstance] requestBranchListWithCompanyId:companyId brandId:brandId branchId:branchId block:^(NSArray *branchArray, NSInteger resultCode) {
        if (branchArray!=nil) {
            self.appDataManager.branchArray = branchArray;
            
            TSGLog(TSLogGroupApplication, @"인접한 Branch Info Loaded!!!");
            
            // get first branch
            if (branchArray.count > 0) {
                SLBSBranch *branch = [branchArray objectAtIndex:0];
                [self loadFloorInfoByCompanyId:companyId brandId:brandId branchId:[branch.branchId intValue]];
            } else {
                [self showIndicatorView:NO];
                TSGLog(TSLogGroupApplication, @"No Branch Info!!!");
                [Util showAlertPopupWithTitle:@"브랜치 정보가 없습니다!!!"];
            }
        } else {
            [self showIndicatorView:NO];
            TSGLog(TSLogGroupApplication, @"Request Branch Failed!!!");
            [Util showAlertPopupWithTitle:@"브랜치 정보 요청에 실패하였습니다!!!"];
        }
    }];
}

- (void)loadFloorInfoByCompanyId:(int)companyId brandId:(int)brandId branchId:(int)branchId {
    [[SLBSDataManager sharedInstance] requestFloorListWithCompanyId:companyId brandId:brandId branchId:branchId block:^(NSArray *floorArray, NSInteger resultCode) {
        if (floorArray!=nil) {
            self.appDataManager.floorArray = floorArray;
            
            TSGLog(TSLogGroupApplication, @"Floor Info Loaded!!!");
            
            if (floorArray.count > 0) {
                [self loadZoneList];
            } else {
                TSGLog(TSLogGroupApplication, @"No Branch Info!!!");
                [Util showAlertPopupWithTitle:@"층 정보가 없습니다!!!"];
            }
        } else {
            [self showIndicatorView:NO];
            TSGLog(TSLogGroupApplication, @"Request Branch Failed!!!");
            [Util showAlertPopupWithTitle:@"층 정보 요청에 실패하였습니다!!!"];
        }
    }];
}

- (void)loadZoneList {
    // first floor
#ifdef USE_NEW_ADDR_ARCH
    SLBSBranch* branch;
    for (int i=0; i<self.appDataManager.branchArray.count; i++) {
        SLBSBranch *searchbranch = [self.appDataManager.branchArray objectAtIndex:i];
        if ([searchbranch.branchId intValue]==DEFAULT_BRANCH_ID) {
            branch = searchbranch;
            break;
        }
    }
#else
    SLBSBranch *branch = [self.appDataManager.branchArray objectAtIndex:0];
#endif
    [[SLBSDataManager sharedInstance] requestZoneListWithBranchID:branch.branchId block:^(NSArray *zoneListArray, NSInteger resultCode) {
        self.appDataManager.zoneListArray = [NSMutableArray array];
        for (int i=0; i<zoneListArray.count; i++) {
            Zone *zone = [zoneListArray objectAtIndex:i];
            int zoneType = [[zone type] intValue];
            //By regina 2015-11-06
            //POI까지 같이 하니 화장실, 공조실 등 검색과 상관없는 Zone 들이 나와 Store만 하도록 수정
            //Android는 Store만 Filtering 하고 있음.
            if (zoneType==ZONE_TYPE_STORE /*|| zoneType==ZONE_TYPE_POI*/) {
                NSLog(@"Zone Type:%@, Zone ID:%d, Zone Name:%@", zone.type, [zone.zone_id intValue], zone.name);
                [self.appDataManager.zoneListArray addObject:zone];
            }
        }
        
        self.appDataManager.zoneListSearchArray = [NSMutableArray arrayWithArray:self.appDataManager.zoneListArray];
        [self initMapView];
        [self showIndicatorView:NO];
        
        TSGLog(TSLogGroupApplication, @"Zone Info Loaded!!!");
    }];
}

- (void)showAlertPopup:(id)sender {
    [Util showAlertPopupWithTitle:@"캠페인 1"];
}

#pragma mark - Selector

- (void)showLogButtonClicked {
    SLBSGroupLogViewController *viewController = [[SLBSGroupLogViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)showFunctionButtonClicked {
    
}

- (void)showMapButtonClicked {
//    [Util addLocalNotificationWithBody:@"샤넬 캠페인을 수신하였습니다." totBadgeNo:1 campaignId:[NSNumber numberWithInt:44]];

    [self showIndicatorView:YES];
    [self loadFloorInfo:SHINSEGAE_DEPARTMENT_STORE];
}

- (void)showCampaignInboxButtonClicked {
//    CampaignInboxViewController *campaignVC = [[CampaignInboxViewController alloc] init];
//    UINavigationController *campaignNavC = [[UINavigationController alloc] initWithRootViewController:campaignVC];
//    [self presentViewController:campaignNavC animated:YES completion:nil];
}

- (IBAction)showLog:(id)sender {
    SLBSGroupLogViewController *viewController = [[SLBSGroupLogViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:^{
    }];
}

- (void)locationManager:(SLBSLocationManager *)manager onLocation:(SLBSCoordination*)location {
    TSLog(@"%s onLocation x: %f y:%f", __PRETTY_FUNCTION__, location.x, location.y);
}

- (void)onServiceReady {
    [[SLBSDataManager sharedInstance] setUserAccountName:@"test"];
    [[SLBSDataManager sharedInstance] setLocationAgreement:YES];
    
    // @SSG
    //[self loadFloorInfo];
    [self showIndicatorView:NO];
    //
}

#pragma mark - @SSG

//////////////////
// @SSG added

- (void)loadFloorInfo:(int)companyID {
    [self loadCompanyInfo:companyID];
}

- (void)loadCompanyInfo:(int)companyID {
    [[SLBSDataManager sharedInstance] requestCompanyListWithBlock:^(NSArray* companyList, NSInteger resultCode) {
        if(companyList != nil) {
            self.appDataManager.companyArray = companyList;

            TSGLog(TSLogGroupApplication, @"Company Info Loaded!!!");

            if (companyList.count > 0) {
                for (SLBSCompany *company in companyList) {
                    if ([company.companyId intValue] == companyID) {
                        [self loadBrandInfoByCompanyId:companyID];
                        break;
                    }
                }
            } else {
                [self showIndicatorView:NO];
                TSGLog(TSLogGroupApplication, @"No Company Info!!!");
                [Util showAlertPopupWithTitle:@"회사 정보가 없습니다!!!"];
            }
        }
        else {
            [self showIndicatorView:NO];
            TSGLog(TSLogGroupApplication, @"Request Company Failed!!!");
            [Util showAlertPopupWithTitle:@"회사 정보 요청에 실패하였습니다!!!"];
        }
    }];
}

- (void)initIncMapButton {
    UIImage *mapButtonImgNor = [UIImage imageNamed:@"main_btn_2"];
    UIImage *mapButtonImgPre = [UIImage imageNamed:@"main_btn_2"];

    self.showIncMapButton = [[UIButton alloc] initWithFrame:CGRectMake(self.showMapButton.frame.origin.x,
                                                                       self.showMapButton.frame.origin.y + self.showMapButton.frame.size.height + 20,
                                                                       mapButtonImgNor.size.width,
                                                                       mapButtonImgNor.size.height)];
    [self.showIncMapButton setImage:mapButtonImgNor forState:UIControlStateNormal];
    [self.showIncMapButton setImage:mapButtonImgPre forState:UIControlStateSelected];

    [self.showIncMapButton addTarget:self action:@selector(showIncMapButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.showIncMapButton];
}

- (void)showIncMapButtonClicked {
    //    [Util addLocalNotificationWithBody:@"샤넬 캠페인을 수신하였습니다." totBadgeNo:1 campaignId:[NSNumber numberWithInt:44]];
    [self showIndicatorView:YES];
    [self loadFloorInfo:SHINSEGAE_INC];

}

-(void)initMapView {
    self.mapVC = [[MapViewController alloc] init];
    UINavigationController *mapNavC = [[UINavigationController alloc] initWithRootViewController:self.mapVC];
    [self presentViewController:mapNavC animated:YES completion:nil];
}
//

@end
