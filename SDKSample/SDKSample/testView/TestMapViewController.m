//
//  TestMapViewController.m
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 4..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import "TestMapViewController.h"
#import "ToastView.h"
#import "AppDataManager.h"
#import "LGPlusButtonsView.h"
#import "LGDrawer.h"

#import <SLBSSDK/SLBSMapViewController.h>
#import <SLBSSDK/SLBSLocationManager.h>

@interface TestMapViewController () < SLBSMapViewControllerDelegate, SLBSLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource >

@property (nonatomic, strong) SLBSMapViewController *mapController;
@property (nonatomic, assign) BOOL isMonitoring;
@property (strong, nonatomic) LGPlusButtonsView *plusButtonsView;
@property (nonatomic, assign) NSInteger currentFloor;
@property (nonatomic, strong) SLBSMapViewData *currentMapData;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) BOOL departurePosition;
@property (nonatomic, assign) BOOL destinationPosition;

@end

@implementation TestMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MapView";
    [self initializeRightBarButton];
    
    
    NSDictionary *resource = @{kSLBSMapViewIconForDeparturePosition:[UIImage imageNamed:@"map_path_start_icon.png"],
                               kSLBSMapViewIconForDestination:[UIImage imageNamed:@"map_path_end_icon.png"],
                               kSLBSMapViewIconForCurrentPosition:[UIImage imageNamed:@"map_marker.png"],
                               kSLBSMapViewIconForPassage:[UIImage imageNamed:@"map_pass_icon.png"],
                               kSLBSMapViewIconForCampaignZone:[UIImage imageNamed:@"map_zone_campain_icon.png"],
                               kSLBSMapViewIconForDirection:[UIImage imageNamed:@"map_arrow_icon.png"]};

    
    self.mapController = [[SLBSMapViewController alloc] initWithFrame:self.view.frame resource:resource];
    self.mapController.delegate = self;

    [self.view addSubview:self.mapController.mapViewControl];
    self.currentMapData = [TestMapViewController dummyMapDataAtIndex:self.currentFloor];
    [self.mapController shouldLoadMapData:self.currentMapData];
    
    
    [self initializeMenuButton];
}

- (IBAction)selectorSearchComplete:(id)sender {
    NSLog(@"selectorSearchComplete");
    self.mapController.selectedZoneNumber = @4;
}

- (IBAction)selectorSelectComplete:(id)sender {
    NSLog(@"selectorSelectComplete");
    self.mapController.selectedZoneNumber = @11;
}

- (void)initializeRightBarButton
{
//    if (self.isMonitoring) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"stop" style:UIBarButtonItemStyleBordered target:self action:@selector(selectorStart:)];
//    } else {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStyleBordered target:self action:@selector(selectorStart:)];
//    }
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"select" style:UIBarButtonItemStyleBordered target:self action:@selector(selectorSelectComplete:)];
    if (self.presentingViewController || self.presentedViewController) {
        UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithTitle:@"닫기" style:UIBarButtonItemStylePlain target:self action:@selector(selectorDismissViewController:)];
        self.navigationItem.leftBarButtonItem = dismiss;
    }
    if (self.isMonitoring) {
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicatorView];
        [indicatorView startAnimating];
    } else {
        UIBarButtonItem *setPath = [[UIBarButtonItem alloc] initWithTitle:@"패스" style:UIBarButtonItemStylePlain target:self action:@selector(selectorSetPath:)];
        UIBarButtonItem *removePath = [[UIBarButtonItem alloc] initWithTitle:@"삭재" style:UIBarButtonItemStylePlain target:self action:@selector(selectorRemovePath:)];
//        UIBarButtonItem *departurePosition = [[UIBarButtonItem alloc] initWithTitle:@"출발지" style:UIBarButtonItemStylePlain target:self action:@selector(selectorDeparturePosition:)];
//        UIBarButtonItem *destinationPosition = [[UIBarButtonItem alloc] initWithTitle:@"도착지" style:UIBarButtonItemStylePlain target:self action:@selector(selectorDestinationPosition:)];
        self.navigationItem.rightBarButtonItems = @[/*destinationPosition, departurePosition, */removePath, setPath];
    }
}

- (IBAction)selectorDismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectorStart:(id)sender {
    NSLog(@"selectorStart");
    if (self.isMonitoring) {
        [[SLBSLocationManager sharedInstance] setDelegate:nil];
        [[SLBSLocationManager sharedInstance] stopMonitoring];
    } else {
        [[SLBSLocationManager sharedInstance] setDelegate:self];
        [[SLBSLocationManager sharedInstance] startMonitoring];
    }
    self.isMonitoring = !self.isMonitoring;
    [self initializeRightBarButton];
}

- (IBAction)selectorSetPath:(id)sender {
    NSArray *paths = @[[NSValue valueWithCGPoint:CGPointMake(724, 100)],//1
                       [NSValue valueWithCGPoint:CGPointMake(724, 208)],//2
                       [NSValue valueWithCGPoint:CGPointMake(246, 208)],//3
                       [NSValue valueWithCGPoint:CGPointMake(246, 1312)],//4
                       [NSValue valueWithCGPoint:CGPointMake(446, 1312)],//4
                       [NSValue valueWithCGPoint:CGPointMake(746, 1312)],//4
                       [NSValue valueWithCGPoint:CGPointMake(985, 1312)],//4
                       [NSValue valueWithCGPoint:CGPointMake(1194, 1312)],//5
                       [NSValue valueWithCGPoint:CGPointMake(1194, 1450)],//5
                       [NSValue valueWithCGPoint:CGPointMake(1194, 1593)],//5
                       [NSValue valueWithCGPoint:CGPointMake(1194, 1708)],//6
                       [NSValue valueWithCGPoint:CGPointMake(724, 1708)],//7
                       [NSValue valueWithCGPoint:CGPointMake(724, 706)],//8
                       [NSValue valueWithCGPoint:CGPointMake(1194, 706)],//9
                       [NSValue valueWithCGPoint:CGPointMake(1194, 968)],//10
                       [NSValue valueWithCGPoint:CGPointMake(1344, 968)]];//11
    NSDictionary *positions = @{kSLBSMapViewPositionOfDeparture:[NSValue valueWithCGPoint:CGPointMake(724, 100)],
                                kSLBSMapViewPositionsOfPassage:@[[NSValue valueWithCGPoint:CGPointMake(1344, 968)]],
                                kSLBSMapViewNumberOfDestinationZone:@9};
    self.departurePosition = YES;
    self.destinationPosition = YES;
    [self.mapController setPath:paths positions:positions];
}

- (IBAction)selectorRemovePath:(id)sender {
    [self.mapController removePath];
}

- (IBAction)selectorDeparturePosition:(id)sender {
    if (self.departurePosition == NO) {
        NSDictionary *positions = @{kSLBSMapViewNumberOfDepartureZone:@8};
        [self.mapController addPositionObject:positions];
    } else {
        NSDictionary *positions = @{kSLBSMapViewNumberOfDepartureZone:[NSNull null]};
        [self.mapController addPositionObject:positions];
    }
    self.departurePosition = !self.departurePosition;
}

- (IBAction)selectorDestinationPosition:(id)sender {
    if (self.destinationPosition == NO) {
        NSDictionary *positions = @{kSLBSMapViewNumberOfDestinationZone:@9};
        [self.mapController addPositionObject:positions];
    } else {
        NSDictionary *positions = @{kSLBSMapViewNumberOfDestinationZone:[NSNull null]};
        [self.mapController addPositionObject:positions];
    }
    self.destinationPosition = !self.destinationPosition;
}

- (void)locationManager:(SLBSLocationManager *)manager onLocation:(SLBSCoordination*)location {
    CGPoint locationRaw = CGPointMake(location.x, location.y);
    [ToastView popupToastViewWithMessage:[NSString stringWithFormat:@"pushed change location %@", NSStringFromCGPoint(locationRaw)]];
    [self.mapController updateCurrentPosition:locationRaw moveCenter:YES];
}

- (BOOL)controller:(SLBSMapViewController *)controller willSelectedZone:(NSNumber *)zoneID {
    SLBSMapViewZoneData *data = [[self.currentMapData.zoneList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"zoneID == %@", zoneID]] firstObject];
    [ToastView popupToastViewWithMessage:[NSString stringWithFormat:@"selected zone %@(%@)", data.name, data.zoneID]];
    return YES;
}

- (void)touchedMapViewWithController:(SLBSMapViewController *)controller {
    [ToastView popupToastViewWithMessage:@"MapView Touched!!! cancel tracking..."];
}

+ (SLBSMapViewData *)dummyMapDataAtIndex:(NSInteger)index{
    SLBSMapViewData *mapData = [[SLBSMapViewData alloc] init];
    NSArray *poiPositions;
    NSArray *polygons;
    NSMutableArray *array = [NSMutableArray array];
    if (index == 0) {
        mapData.ID = @1001;
        mapData.image = [UIImage imageNamed:@"map_ssg-1F.png"];
        
        poiPositions = @[@{@"name":@"엘레베이터북측",@"center":[NSValue valueWithCGPoint:CGPointMake(1160, 128)]},
                         @{@"name":@"유모차서비스",@"center":[NSValue valueWithCGPoint:CGPointMake(824, 146)]},
                         @{@"name":@"에스컬레이터",@"center":[NSValue valueWithCGPoint:CGPointMake(694, 510)]},
                         @{@"name":@"안내",@"center":[NSValue valueWithCGPoint:CGPointMake(534, 556)]},
                         @{@"name":@"남자화상실",@"center":[NSValue valueWithCGPoint:CGPointMake(1310, 806)]},
                         @{@"name":@"여자화장실",@"center":[NSValue valueWithCGPoint:CGPointMake(1310, 842)]},
                         @{@"name":@"엘레베이터남측",@"center":[NSValue valueWithCGPoint:CGPointMake(114, 928)]}];
        
        polygons = @[@{@"name":@"토즈",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(272, 0)],
                                     [NSValue valueWithCGPoint:CGPointMake(496, 0)],
                                     [NSValue valueWithCGPoint:CGPointMake(496, 162)],
                                     [NSValue valueWithCGPoint:CGPointMake(272, 162)]
                                     ]},
                     @{@"name":@"프라다",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(894, 740)],
                                     [NSValue valueWithCGPoint:CGPointMake(1184, 740)],
                                     [NSValue valueWithCGPoint:CGPointMake(1184, 868)],
                                     [NSValue valueWithCGPoint:CGPointMake(894, 868)]
                                     ]},
                     @{@"name":@"미우미우",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(800, 0)],
                                     [NSValue valueWithCGPoint:CGPointMake(1042, 0)],
                                     [NSValue valueWithCGPoint:CGPointMake(1042, 158)],
                                     [NSValue valueWithCGPoint:CGPointMake(872, 158)],
                                     [NSValue valueWithCGPoint:CGPointMake(870, 108)],
                                     [NSValue valueWithCGPoint:CGPointMake(800, 108)]
                                     ]},
                     @{@"name":@"키엘",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(0, 622)],
                                     [NSValue valueWithCGPoint:CGPointMake(124, 622)],
                                     [NSValue valueWithCGPoint:CGPointMake(124, 800)],
                                     [NSValue valueWithCGPoint:CGPointMake(58, 800)],
                                     [NSValue valueWithCGPoint:CGPointMake(58, 874)],
                                     [NSValue valueWithCGPoint:CGPointMake(0, 874)]
                                     ]},
                     @{@"name":@"랩시리즈",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(58, 800)],
                                     [NSValue valueWithCGPoint:CGPointMake(124, 800)],
                                     [NSValue valueWithCGPoint:CGPointMake(124, 874)],
                                     [NSValue valueWithCGPoint:CGPointMake(58, 874)]
                                     ]},
                     @{@"name":@"시세이도",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(186, 732)],
                                     [NSValue valueWithCGPoint:CGPointMake(216, 766)],
                                     [NSValue valueWithCGPoint:CGPointMake(216, 788)],
                                     [NSValue valueWithCGPoint:CGPointMake(256, 788)],
                                     [NSValue valueWithCGPoint:CGPointMake(258, 838)],
                                     [NSValue valueWithCGPoint:CGPointMake(186, 838)]
                                     ]},
                     ];
    } else {
        mapData.ID = @1002;
        mapData.image = [UIImage imageNamed:@"map_ssg_main-1F@2x"];
        
        poiPositions = @[@{@"name":@"2F엘레베이터북측",@"center":[NSValue valueWithCGPoint:CGPointMake(1560, 250)]},
                         @{@"name":@"2F유모차서비스",@"center":[NSValue valueWithCGPoint:CGPointMake(1066, 302)]},
                         @{@"name":@"2F에스컬레이터",@"center":[NSValue valueWithCGPoint:CGPointMake(962, 640)]},
                         @{@"name":@"2F안내",@"center":[NSValue valueWithCGPoint:CGPointMake(758, 850)]},
                         @{@"name":@"2F화상실",@"center":[NSValue valueWithCGPoint:CGPointMake(1740, 1130)]},
                         @{@"name":@"2F엘레베이터남측",@"center":[NSValue valueWithCGPoint:CGPointMake(182, 1320)]}];
        
        polygons = @[@{@"name":@"미우미우",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(1100, 114)],
                                     [NSValue valueWithCGPoint:CGPointMake(1410, 114)],
                                     [NSValue valueWithCGPoint:CGPointMake(1410, 322)],
                                     [NSValue valueWithCGPoint:CGPointMake(1100, 322)]
                                     ]},
                     @{@"name":@"토즈",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(410, 114)],
                                     [NSValue valueWithCGPoint:CGPointMake(638, 114)],
                                     [NSValue valueWithCGPoint:CGPointMake(638, 314)],
                                     [NSValue valueWithCGPoint:CGPointMake(410, 314)]
                                     ]},
                     @{@"name":@"프라다",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(1054, 1246)],
                                     [NSValue valueWithCGPoint:CGPointMake(1282, 1246)],
                                     [NSValue valueWithCGPoint:CGPointMake(1282, 1058)],
                                     [NSValue valueWithCGPoint:CGPointMake(1598, 1058)],
                                     [NSValue valueWithCGPoint:CGPointMake(1598, 1204)],
                                     [NSValue valueWithCGPoint:CGPointMake(1420, 1204)],
                                     [NSValue valueWithCGPoint:CGPointMake(1420, 1244)],
                                     [NSValue valueWithCGPoint:CGPointMake(1360, 1244)],
                                     [NSValue valueWithCGPoint:CGPointMake(1360, 1444)],
                                     [NSValue valueWithCGPoint:CGPointMake(1054, 1444)]
                                     ]},
                    
                     @{@"name":@"반클리프",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(70, 318)],
                                     [NSValue valueWithCGPoint:CGPointMake(134, 318)],
                                     [NSValue valueWithCGPoint:CGPointMake(134, 356)],
                                     [NSValue valueWithCGPoint:CGPointMake(208, 356)],
                                     [NSValue valueWithCGPoint:CGPointMake(208, 628)],
                                     [NSValue valueWithCGPoint:CGPointMake(42, 628)],
                                     [NSValue valueWithCGPoint:CGPointMake(42, 594)],
                                     [NSValue valueWithCGPoint:CGPointMake(70, 594)]
                                     ]},
                     @{@"name":@"헤라",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(416, 818)],
                                     [NSValue valueWithCGPoint:CGPointMake(518, 818)],
                                     [NSValue valueWithCGPoint:CGPointMake(518, 978)],
                                     [NSValue valueWithCGPoint:CGPointMake(416, 978)]
                                     ]},
                     @{@"name":@"슈 우에무라",
                       @"polygons":@[[NSValue valueWithCGPoint:CGPointMake(1072, 500)],
                                     [NSValue valueWithCGPoint:CGPointMake(1192, 500)],
                                     [NSValue valueWithCGPoint:CGPointMake(1192, 594)],
                                     [NSValue valueWithCGPoint:CGPointMake(1072, 594)]
                                     ]},
                     ];
    }
    NSInteger poiCount = [poiPositions count];
    for (NSInteger count = 0; count < poiCount; count++) {
        NSDictionary *poiData = [poiPositions objectAtIndex:count];
        SLBSMapViewZoneData *data = [[SLBSMapViewZoneData alloc] init];
        data.zoneID = [NSNumber numberWithInteger:(count+1)];
        data.name = [poiData objectForKey:@"name"];
        data.type = TSSLBSMapZoneTypePOIImage;
        data.currentCenter = [[poiData objectForKey:@"center"] CGPointValue];
        data.icon = [UIImage imageNamed:@"map_poi.png"];
        [array addObject:data];
    }
    
    NSInteger polygonCount = [polygons count];
    for (NSInteger count = 0; count < polygonCount; count++) {
        NSDictionary *polygonData = [polygons objectAtIndex:count];
        SLBSMapViewZoneData *data = [[SLBSMapViewZoneData alloc] init];
        data.zoneID = [NSNumber numberWithInteger:(count+poiCount+1)];
        if ([mapData.ID isEqualToNumber:@1001] == YES && [data.zoneID isEqualToNumber:@8] == YES) {
            data.visibleFrame = CGRectMake(30, 20, 100, 60);
            data.angle = -M_PI_2/2.0f;
            data.containedCampaign = YES;
        }
        if ([mapData.ID isEqualToNumber:@1001] == YES && [data.zoneID isEqualToNumber:@9] == YES) {
            data.storeBI = [UIImage imageNamed:@"map_bi_prada.png"];
            data.visibleFrame = CGRectMake(60, 50, 170, 28);
//            data.visibleFrame = CGRectMake(10, 10, 50, 28);
            data.angle = -M_PI_2/3.0f;
        }
        if ([data.zoneID isEqualToNumber:@9] == YES) {
            data.containedCampaign = YES;
        }
        data.name = [polygonData objectForKey:@"name"];
        data.type = TSSLBSMapZoneTypePolygon;
        data.polygons = [polygonData objectForKey:@"polygons"];
        [array addObject:data];
    }
    mapData.zoneList = array;
    return mapData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMenuButton
{
    _plusButtonsView =
    [[LGPlusButtonsView alloc] initWithView:self.view
                            numberOfButtons:3
                            showsPlusButton:YES
                              actionHandler:^(LGPlusButtonsView *plusButtonView, NSString *title, NSString *description, NSUInteger index)
     {
         NSLog(@"%@, %@, %i", title, description, (int)index);
         [_plusButtonsView hideButtonsAnimated:YES completionHandler:nil];
         switch (index) {
             case 0: {
                 [self showActionSheet];
             } break;
             case 1: {
                 if (self.isMonitoring) {
                     [_plusButtonsView setDescriptionsText:@"Start Positionning" atIndex:index+1];
                 } else {
                     [_plusButtonsView setDescriptionsText:@"Stop Positionning" atIndex:index+1];
                 }
                 [self selectorStart:nil];
             } break;
             case 2: {
                 if (self.isMonitoring) {
                     [[SLBSLocationManager sharedInstance] setDelegate:nil];
                     [[SLBSLocationManager sharedInstance] stopMonitoring];
                 }
                 if (self.currentFloor == 0) {
                     self.currentFloor = 1;
                     [_plusButtonsView setDescriptionsText:@"Change Floor 1F" atIndex:index+1];
                 } else {
                     self.currentFloor = 0;
                     [_plusButtonsView setDescriptionsText:@"Change Floor 2F" atIndex:index+1];
                 }
                 self.currentMapData = [TestMapViewController dummyMapDataAtIndex:self.currentFloor];
                 [self.mapController shouldLoadMapData:self.currentMapData];
             } break;
                 
             default:
                 break;
         }
     }
                    plusButtonActionHandler:nil];
    
    [_plusButtonsView setButtonsTitles:@[@"+", @"S", @"P", @"C"] forState:UIControlStateNormal];
    [_plusButtonsView setDescriptionsTexts:@[@"", @"Select Zone", self.isMonitoring?@"Stop Positionning":@"Start Positionning", (self.currentFloor?@"Change Floor 1F":@"Change Floor 2F")]];
    _plusButtonsView.position = LGPlusButtonsViewPositionBottomRight;
    _plusButtonsView.showWhenScrolling = YES;
    _plusButtonsView.appearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideVertical;
    _plusButtonsView.buttonsAppearingAnimationType = LGPlusButtonsAppearingAnimationTypeCrossDissolveAndSlideHorizontal;
    _plusButtonsView.plusButtonAnimationType = LGPlusButtonAnimationTypeRotate;
    [_plusButtonsView setButtonsTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_plusButtonsView setButtonsAdjustsImageWhenHighlighted:NO];
    
    [_plusButtonsView showAnimated:NO completionHandler:nil];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (!_plusButtonsView) {
        return;
    }
    BOOL isPortrait = UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    
    CGFloat shadowBlur = 3.f;
    CGFloat buttonSide = (isPortrait ? 64.f : 44.f);
    CGFloat buttonsFontSize = (isPortrait ? 30.f : 20.f);
    CGFloat plusButtonFontSize = buttonsFontSize*1.5;
    
    _plusButtonsView.contentInset = UIEdgeInsetsMake(shadowBlur, shadowBlur, shadowBlur, shadowBlur);
    [_plusButtonsView setButtonsTitleFont:[UIFont boldSystemFontOfSize:buttonsFontSize]];
    
    _plusButtonsView.plusButton.titleLabel.font = [UIFont systemFontOfSize:plusButtonFontSize];
    _plusButtonsView.plusButton.titleOffset = CGPointMake(0.f, -plusButtonFontSize*0.1);
    
    UIImage *circleImageNormal = [LGDrawer drawEllipseWithImageSize:CGSizeMake(buttonSide, buttonSide)
                                                               size:CGSizeMake(buttonSide-shadowBlur*2, buttonSide-shadowBlur*2)
                                                             offset:CGPointZero
                                                             rotate:0.f
                                                    backgroundColor:nil
                                                          fillColor:[UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f]
                                                        strokeColor:nil
                                                    strokeThickness:0.f
                                                         strokeDash:nil
                                                         strokeType:LGDrawerStrokeTypeInside
                                                        shadowColor:[UIColor colorWithWhite:0.f alpha:0.5]
                                                       shadowOffset:CGPointZero
                                                         shadowBlur:shadowBlur];
    
    UIImage *circleImageHighlighted = [LGDrawer drawEllipseWithImageSize:CGSizeMake(buttonSide, buttonSide)
                                                                    size:CGSizeMake(buttonSide-shadowBlur*2, buttonSide-shadowBlur*2)
                                                                  offset:CGPointZero
                                                                  rotate:0.f
                                                         backgroundColor:nil
                                                               fillColor:[UIColor colorWithRed:0.2 green:0.7 blue:1.f alpha:1.f]
                                                             strokeColor:nil
                                                         strokeThickness:0.f
                                                              strokeDash:nil
                                                              strokeType:LGDrawerStrokeTypeInside
                                                             shadowColor:[UIColor colorWithWhite:0.f alpha:0.5]
                                                            shadowOffset:CGPointZero
                                                              shadowBlur:shadowBlur];
    
    [_plusButtonsView setButtonsImage:circleImageNormal forState:UIControlStateNormal];
    [_plusButtonsView setButtonsImage:circleImageHighlighted forState:UIControlStateHighlighted];
    [_plusButtonsView setButtonsImage:circleImageHighlighted forState:UIControlStateHighlighted|UIControlStateSelected];
}

- (void)showActionSheet {
    if (!self.pickerView) {
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        self.pickerView.backgroundColor = [UIColor whiteColor];
        
        CGRect screen = [UIScreen mainScreen].bounds;
        screen.origin.y = screen.size.height - self.pickerView.frame.size.height;
        screen.size.height = self.pickerView.frame.size.height;
        self.pickerView.frame = screen;
    }
    [self.view addSubview:self.pickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *) pickerView numberOfRowsInComponent : (NSInteger)component{
    return [self.currentMapData.zoneList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent: (NSInteger)component{
    SLBSMapViewZoneData *zoneData = [self.currentMapData.zoneList objectAtIndex:row];
    return [NSString stringWithFormat:@"%@(%@)", zoneData.name, zoneData.zoneID];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    SLBSMapViewZoneData *zoneData = [self.currentMapData.zoneList objectAtIndex:row];
    self.mapController.selectedZoneNumber = zoneData.zoneID;
    [pickerView removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
