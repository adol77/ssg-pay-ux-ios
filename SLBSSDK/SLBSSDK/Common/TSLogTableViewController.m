//
//  TSLogTableViewController.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "TSLogTableViewController.h"
//#define GFDEBUG_ENABLE
#import "GFDebug.h"

@interface TSLogTableViewController ()

@property (nonatomic, assign) BOOL autoRefresh;
@property (nonatomic, strong) UIColor *oldTintColor;
@property (nonatomic, assign) NSInteger count;

@end

@implementation TSLogTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tabBarController) {
        self.title = @"LOG";
    } else {
        self.title = @"SLBS LOG";
    }
    self.autoRefresh = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectorDone:)];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(selectorRefresh:)];
    if (!self.tabBarController) {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(selectorRefresh:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[TSDebugLogManager sharedInstance] addLogObserverWithTarget:self];
    if (self.tabBarController) {
        if (self.autoRefresh) {
            self.tabBarController.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(selectorRefresh:)];
            
        } else {
            self.tabBarController.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(selectorRefresh:)];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (([self.tableView numberOfRowsInSection:([self.tableView numberOfSections] - 1)] - 1) < 0) {
        return;
    }
    NSIndexPath *scrollIndexPath =
    [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:([self.tableView numberOfSections] - 1)] - 1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[TSDebugLogManager sharedInstance] removeObserverWithTarget:self];
    if (self.tabBarController) {
        self.tabBarController.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)selectorDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectorRefresh:(id)sender {
    self.autoRefresh = !self.autoRefresh;
    UINavigationItem *navigationItem;
    if (self.tabBarController) {
        navigationItem = self.tabBarController.navigationItem;
    } else {
        navigationItem = self.navigationItem;
    }
    
    if (!self.autoRefresh) {
        //        self.oldTintColor = self.self.navigationItem.rightBarButtonItem.tintColor;
        //        self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(selectorRefresh:)];
    } else {
        //        self.navigationItem.rightBarButtonItem.tintColor = self.oldTintColor;
        [self.tableView reloadData];
        NSIndexPath *scrollIndexPath =
        [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:([self.tableView numberOfSections] - 1)] - 1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(selectorRefresh:)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.logs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((TSLogEntity*)[self.logs objectAtIndex:indexPath.row]).cellHeight+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    TSLogCell *cell = (TSLogCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[TSLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    // Configure the cell...
    cell.entity = [self.logs objectAtIndex:indexPath.row];
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ((__bridge id)context != [TSDebugLogManager sharedInstance]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    if ([keyPath isEqualToString:@"logs"]) {
        NSArray *logs = [change objectForKey:NSKeyValueChangeNewKey];
        //        GFLog(@"The logs of the TSDebugLogManager was changed. : %@", logs);
        if (logs) {
            if (self.autoRefresh) {
                //                [self.tableView reloadData];
                //                if ([logs count] != 1) {
                //                    NSLog(@"old count : %ld new count : %ld", (long)self.count, (long)[logs count]);
                //                }
                self.count = [logs count];
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:([self.logs count]-1) inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
                NSIndexPath *scrollIndexPath =
                [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:([self.tableView numberOfSections] - 1)] - 1) inSection:0];
                [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

#define USE_CIRCLE_DRARW

#ifdef USE_CIRCLE_DRARW
//http://stackoverflow.com/questions/19651664/drawing-filled-circles-with-letters-in-ios-7
@interface MELetterCircleView : UIView

@property (nonatomic, strong) NSString *text;
- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text;

@end

@interface MELetterCircleView ()

@property (nonatomic, strong) UIColor *circleColor;

@end
#endif

@interface TSLogCell ()

@property (nonatomic, strong) UILabel *typeLabel;
#ifdef USE_CIRCLE_DRARW
@property (nonatomic, strong) MELetterCircleView *circleView;
#endif
@property (nonatomic, strong) UILabel *classNameLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation TSLogCell

+ (UILabel*)labelForLogCellWithFrame:(CGRect)frame {
    UIFont *font = [UIFont systemFontOfSize:TSLOG_FONTSIZE];
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.numberOfLines = 1;
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    label.userInteractionEnabled = NO;
    
    return label;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
#ifndef USE_CIRCLE_DRARW
        self.typeLabel = [TSLogCell labelForLogCellWithFrame:CGRectMake(0, 0, self.frame.size.width/5, TSLOG_FONTSIZE+2)];
        [self addSubview:self.typeLabel];
        self.classNameLabel = [TSLogCell labelForLogCellWithFrame:CGRectMake(self.frame.size.width/5, 0, (self.frame.size.width/5)*4, TSLOG_FONTSIZE+2)];
#else
        //        self.circleView = [[MELetterCircleView alloc] initWithFrame:CGRectMake(0, 0, TSLOG_FONTSIZE+2, TSLOG_FONTSIZE+2)];
        //        [self addSubview:self.circleView];
        self.classNameLabel = [TSLogCell labelForLogCellWithFrame:CGRectMake((TSLOG_FONTSIZE+2)*2, 0, self.frame.size.width-((TSLOG_FONTSIZE+2)*2), TSLOG_FONTSIZE+2)];
#endif
        [self addSubview:self.classNameLabel];
        
        self.messageLabel = [TSLogCell labelForLogCellWithFrame:CGRectMake(0, TSLOG_FONTSIZE+2,
                                                                           self.frame.size.width, TSLOG_FONTSIZE+2)];
        self.messageLabel.numberOfLines = 0;
        //        self.messageLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.messageLabel];
    }
    return self;
}



- (void)setEntity:(TSLogEntity *)entity {
    _entity = entity;
    NSString *labelText;
    if (self.entity.type < 0) {
#ifndef USE_CIRCLE_DRARW
        labelText = [TSLogEntity stringFromGroup:self.entity.group];
#else
        labelText = [TSLogEntity shortStringFromGroup:self.entity.group];
#endif
    } else {
#ifndef USE_CIRCLE_DRARW
        labelText = [TSLogEntity stringFromType:self.entity.type];
#else
        labelText = [TSLogEntity shortStringFromType:self.entity.type];
#endif
    }

    UIColor *akaColor = [UIColor whiteColor];
    if (self.entity.type < 0) {
        switch (self.entity.group) {
            case TSLogGroupCommon:
                akaColor = [UIColor lightGrayColor];;
                break;
            case TSLogGroupBeacon:
                akaColor = [UIColor blueColor];
                break;
            case TSLogGroupLocation:
                akaColor = [UIColor greenColor];
                break;
            case TSLogGroupApplication:
                akaColor = [UIColor darkGrayColor];
                break;
            default:
                break;
        }
    } else {
        switch (self.entity.type) {
            case TSLogTypeDefault:
                akaColor = [UIColor lightGrayColor];;
                break;
            case TSLogTypeResult:
                akaColor = [UIColor brownColor];
                break;
            case TSLogTypeWarning:
                akaColor = [UIColor orangeColor];
                break;
            case TSLogTypeError:
                akaColor = [UIColor redColor];
                break;
            default:
                break;
        }
    }

#ifndef USE_CIRCLE_DRARW
    self.typeLabel.text = labelText;
    self.typeLabel.backgroundColor = [UIColor whiteColor];
    self.typeLabel.textColor = akaColor;
    if (self.entity.type == TSLogTypeError) {
        self.typeLabel.backgroundColor = [UIColor redColor];
    }
#else
    if (self.circleView) {
        [self.circleView removeFromSuperview];
        self.circleView = nil;
    }
    self.circleView = [[MELetterCircleView alloc] initWithFrame:CGRectMake(0, 0, TSLOG_FONTSIZE+2, TSLOG_FONTSIZE+2) text:labelText];
    self.circleView.backgroundColor = akaColor;
    [self addSubview:self.circleView];
#endif
    self.classNameLabel.text = [NSString stringWithFormat:@"%@ : %ld", self.entity.className, (long)self.entity.codeline];
    self.messageLabel.text = self.entity.message;
    CGRect frame = self.messageLabel.frame;
    self.messageLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, self.entity.cellHeight-TSLOG_FONTSIZE+2);
}

@end

#ifdef USE_CIRCLE_DRARW
@implementation MELetterCircleView

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    NSParameterAssert(text);
    self = [super initWithFrame:frame];
    if (self) {
        self.text = text;
    }
    return self;
}

// Override to set the circle's background color.
// The view's background will always be clear.
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    self.circleColor = backgroundColor;
    [super setBackgroundColor:[UIColor clearColor]];
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.circleColor setFill];
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), CGRectGetWidth(rect)/2, 0, 2*M_PI, YES);
    CGContextFillPath(context);
    
    [self drawSubtractedText:self.text inRect:rect inContext:context];
}

- (void)drawSubtractedText:(NSString *)text inRect:(CGRect)rect inContext:(CGContextRef)context {
    CGContextSaveGState(context);
    
    // Magic blend mode
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    
    CGFloat pointSize =
    [self optimumFontSizeForFont:[UIFont boldSystemFontOfSize:100.f]
                          inRect:rect
                        withText:text];
    
    UIFont *font = [UIFont boldSystemFontOfSize:pointSize];
    
    // Move drawing start point for centering label.
    CGContextTranslateCTM(context, 0,
                          (CGRectGetMidY(rect) - (font.lineHeight/2)));
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(rect), font.lineHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label.layer drawInContext:context];
    
    // Restore the state of other drawing operations
    CGContextRestoreGState(context);
}

-(CGFloat)optimumFontSizeForFont:(UIFont *)font inRect:(CGRect)rect
                        withText:(NSString *)text {
    // For current font point size, calculate points per pixel
    CGFloat pointsPerPixel = font.lineHeight / font.pointSize;
    
    // Scale up point size for the height of the label.
    // This represents the optimum size of a single letter.
    CGFloat desiredPointSize = rect.size.height * pointsPerPixel;
    
    if ([text length] == 1) {
        // In the case of a single letter, we need to scale back a bit
        //  to take into account the circle curve.
        // We could calculate the inner square of the circle,
        // but this is a good approximation.
        desiredPointSize = .80*desiredPointSize;
    } else {
        // More than a single letter. Let's make room for more.
        desiredPointSize = desiredPointSize / [text length];
    }
    
    return desiredPointSize;
}
@end
#endif

