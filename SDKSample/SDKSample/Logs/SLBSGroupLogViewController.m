//
//  SLBSGroupLogViewController.m
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 15..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import "SLBSGroupLogViewController.h"
#import <SLBSSDK/TSDebugLogManager.h>
#import "SLBSGroupLogController.h"
#import "JCTagListView.h"
#import "ToastView.h"
#import "SLBSLogEntity+description.h"
#import <MessageUI/MessageUI.h>

@interface SLBSGroupLogViewController () < UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate >

@property (nonatomic, strong) JCTagListView *tagView;
@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *logFilePath;

@end

#define TAGVIEW_HEIGHT          34

@implementation SLBSGroupLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"SLBS-LOG";
    if ([SLBSGroupLogController sharedInstance].isStarted == NO) {
        [[SLBSGroupLogController sharedInstance] start];
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initializeBarButtonItems];
    [self initializeTagView];
    [self initializeSwitch];
    [self initializeTableView];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
//        NSLog(@"Unresolved error %@, %@ in %@", error, [error userInfo], NSStringFromSelector(_cmd));
//        exit(-1);  // Fail
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isModal {
    if([self presentingViewController])
        return YES;
    if([[self presentingViewController] presentedViewController] == self)
        return YES;
    if([[[self navigationController] presentingViewController] presentedViewController] == [self navigationController])
        return YES;
    if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}

- (void)initializeBarButtonItems
{
    if ([self isModal] == YES) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(selectorClose:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(selectorLogToFile:)];
    }
}

- (IBAction)selectorClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        TSGLog(TSLogGroupApplication, @"SLBSGroupLogViewController dismissViewController");
    }];
}

- (IBAction)selectorAction:(id)sender {

}

- (void)initializeTagView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.width = frame.size.width - 60;
    frame.size.height = TAGVIEW_HEIGHT*2;
    self.tagView = [[JCTagListView alloc] initWithFrame:frame];
    self.tagView.canSeletedTags = YES;
    self.tagView.tagCornerRadius = 10.0f;
    [self.tagView.tags addObjectsFromArray:[TSLogEntity stringsFromGroup]];
    [self.view addSubview:self.tagView];
    [self.tagView setAllSelected:NO];
    
    __weak typeof(self) weakSelf = self;
    [self.tagView setCompletionBlockWithSeleted:^(NSInteger index) {
//        NSLog(@"selected %@(%ld)", [[TSLogEntity stringsFromGroup] objectAtIndex:index], (long)index);
        if ([weakSelf.tagView.seletedTags count] == 0) {
            if (weakSelf.switchControl.on == YES) {
                weakSelf.switchControl.on = NO;
            }
        } else if ([weakSelf.tagView.seletedTags count] == [[TSLogEntity stringsFromGroup] count]) {
            if (weakSelf.switchControl.on == NO) {
                weakSelf.switchControl.on = YES;
            }
        }
        [weakSelf fetchedController];
    }];
}

- (void)initializeSwitch
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x = frame.size.width - 60;
    frame.size.width = 60;
    frame.size.height = TAGVIEW_HEIGHT*2;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    self.switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    self.switchControl.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    self.switchControl.frame = CGRectIntegral(self.switchControl.frame);
    [self.switchControl addTarget:self action:@selector(selectorSwitchChangeStatus:) forControlEvents:UIControlEventValueChanged];
    self.switchControl.on = YES;
    [view addSubview:self.switchControl];
//    NSLog(@"%@", NSStringFromCGRect(self.switchControl.frame));
}

- (IBAction)selectorSwitchChangeStatus:(id)sender {
    if (self.switchControl.on == YES) {
        [self.tagView setAllSelected:YES];
    } else {
        [self.tagView setAllUnSelected:YES];
    }
    [self fetchedController];
}

- (IBAction)selectorLogToFile:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to save the log?" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 1: {
            if (buttonIndex == 1) {
                [self logToFileWithIndicatorView:YES];
            }
        } break;
        case 2: {
            if (buttonIndex == 1) {
                [self sendEmail:self.logFilePath];
            }
        } break;
            
        default:
            break;
    }
    
}

- (void)logToFileWithIndicatorView:(BOOL)indicator {
    NSArray *fetchedLogs = [self.fetchedResultsController fetchedObjects];
    UIView *lockView;
    UIActivityIndicatorView *indicatorView;
    if (indicator) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        lockView = [[UIView alloc] initWithFrame:keyWindow.frame];
        lockView.backgroundColor = [UIColor lightGrayColor];
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicatorView.center = lockView.center;
        [lockView addSubview:indicatorView];
        [indicatorView startAnimating];
        [keyWindow addSubview:lockView];
        lockView.userInteractionEnabled = NO;
        lockView.alpha = 0.5f;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.logFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"slbelogs_ios_%@.txt", [[NSDate date] simpleString:@"yyyyMMdd_HHmmss"]]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:self.logFilePath])
            [[NSFileManager defaultManager] createFileAtPath:self.logFilePath contents:nil attributes:nil];
        NSFileHandle *logFile = [NSFileHandle fileHandleForUpdatingAtPath:self.logFilePath];
        
         for(int i = 0; i < [fetchedLogs count]; i++){
             SLBSLogEntity* entity = [fetchedLogs objectAtIndex:i];
            NSString *description = [entity descriptionForLog];
             [logFile seekToEndOfFile];
             [logFile writeData:[description dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [logFile closeFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (indicator) {
                [indicatorView stopAnimating];
                [indicatorView removeFromSuperview];
                lockView.userInteractionEnabled = YES;
                [lockView removeFromSuperview];

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send to mail?" message:[NSString stringWithFormat:@"\nSave Complete\n%@", [self.logFilePath lastPathComponent]] delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"OK", nil];
                alert.tag = 2;
                [alert show];
            }
        });
    });
}

- (void)initializeTableView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.y = TAGVIEW_HEIGHT*2;
    frame.size.height = frame.size.height - frame.origin.y - 64;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
}

- (void)sendEmail:(NSString *)attachmentPath {
    NSString *emailTitle = @"[SLBS] Send LOG from iOS";
    NSString *messageBody = @"Send SLBS LOG File";
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc addAttachmentData:[NSData dataWithContentsOfFile:attachmentPath] mimeType:@"text/plain" fileName:[attachmentPath lastPathComponent]];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *resultString = @"";
    switch (result)
    {
        case MFMailComposeResultCancelled:
            resultString = @"Mail cancelled";
            break;
        case MFMailComposeResultSaved:
            resultString = @"Mail saved";
            break;
        case MFMailComposeResultSent:
            resultString = @"Mail sent completed";
            break;
        case MFMailComposeResultFailed:
            resultString = [NSString stringWithFormat:@"Mail sent failure: %@", [error localizedDescription]];
            break;
        default:
            resultString = @"Unknown error";
            break;
    }
    
    // Close the Mail Interface
    [controller dismissViewControllerAnimated:YES completion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:resultString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

#pragma mark - tableView
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    [NSFetchedResultsController deleteCacheWithName:@"SLBSLogEntity"];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"SLBSLogEntity" inManagedObjectContext:[SLBSGroupLogController sharedInstance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setPredicate:[self groupPredicate]];

    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[SLBSGroupLogController sharedInstance].managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"SLBSLogEntity"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (NSPredicate *)groupPredicate {
    NSPredicate *predicate = nil;
    if ([self.tagView.seletedIndices count] > 0) {
        NSMutableArray *predicates = [NSMutableArray array];
        for (NSNumber *indexObject in self.tagView.seletedIndices) {
            NSNumber *group = [NSNumber numberWithInteger:([indexObject integerValue] + TSLogGroupCommon)];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group == %@", group];
            [predicates addObject:predicate];
        }
        predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"group == %@", [NSNumber numberWithInteger:NSIntegerMin]];
    }
//    NSLog(@"predicate %@", predicate);
    return predicate;
}

- (void)fetchedController {
    [self.fetchedResultsController.fetchRequest setPredicate:[self groupPredicate]];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = [[self.fetchedResultsController sections] count];
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSInteger numberOfRowsInSection = [sectionInfo numberOfObjects];
    return numberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:[indexPath section]];
    NSInteger numberOfRowsInSection = [sectionInfo numberOfObjects];
    if (numberOfRowsInSection == 0) {
        return 0.01f;
    }

    SLBSLogEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CGFloat heightForRow = nearbyintf([entity.cellHeight floatValue]) + (TSLOG_FONTSIZE+2)*2;
    return heightForRow;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"LOGS";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SLBSLogEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ((SLBSLogCell *)cell).entity = entity;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SLBSLogCell *cell = (SLBSLogCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[SLBSLogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end

@interface SLBSLogCell ()

@property (nonatomic, strong) UILabel *groupLabel;
@property (nonatomic, strong) UILabel *classNameLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation SLBSLogCell

+ (UILabel*)labelForLogCellWithFrame:(CGRect)frame fontSize:(CGFloat)size {
    UIFont *font = [UIFont systemFontOfSize:size];//TSLOG_FONTSIZE
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
        self.groupLabel = [SLBSLogCell labelForLogCellWithFrame:CGRectMake(5, 5, [UIScreen mainScreen].bounds.size.width, TSLOG_FONTSIZE+2) fontSize:TSLOG_FONTSIZE];
        [self addSubview:self.groupLabel];
        self.classNameLabel = [SLBSLogCell labelForLogCellWithFrame:CGRectMake(5, 5+TSLOG_FONTSIZE+2, [UIScreen mainScreen].bounds.size.width, TSLOG_FONTSIZE+2) fontSize:TSLOG_FONTSIZE-2];
        [self addSubview:self.classNameLabel];
        self.messageLabel = [SLBSLogCell labelForLogCellWithFrame:CGRectMake(5, 5+(TSLOG_FONTSIZE+2)*2, [UIScreen mainScreen].bounds.size.width, TSLOG_FONTSIZE+2) fontSize:TSLOG_FONTSIZE];
        self.messageLabel.numberOfLines = 0;
        [self addSubview:self.messageLabel];
    }
    return self;
}

- (void)setEntity:(SLBSLogEntity *)entity {
    _entity = entity;
    self.groupLabel.text = [NSString stringWithFormat:@"TAG (%@)", [TSLogEntity stringFromGroup:[self.entity.group integerValue]]];
//    self.groupLabel.backgroundColor = [UIColor redColor];
    self.classNameLabel.text = [NSString stringWithFormat:@"[%@](%@)", self.entity.selectorName, self.entity.codeline];
    self.messageLabel.text = self.entity.message;
    CGRect frame = self.messageLabel.frame;
    self.messageLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, [self.entity.cellHeight floatValue]-TSLOG_FONTSIZE+2);
}

@end
