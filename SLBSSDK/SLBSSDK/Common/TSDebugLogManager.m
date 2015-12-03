//
//  TSDebugLogManager.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "TSDebugLogManager.h"
#import "UIViewController+Utility.h"
#import "TSLogTableViewController.h"
//#import "TSBeaconInfoTabbarController.h"

#ifdef TSLOG_LOGTOFILE
#warning    TSLOG_LOGTOFILE(Create File Debug Log ON)
#endif

//http://stackoverflow.com/questions/720052/nslog-incorrect-encoding
NSString* NStringFromUTF8(NSString *str) {
#if CJK_LOG_ENABLE
#warning    2Byte Unicode Debug Log Enabled
    NSString* strT= [str stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((__bridge CFMutableStringRef)strT, NULL, transform, YES);
    
    return strT;
#else
    return str;
#endif
}


NSString *const kSLBSNotificationCreatedLogEntity = @"SLBSNotificationCreatedLogEntity";

@interface TSLogEntity ()

@property (nonatomic, assign) NSInteger aka;

@end

@implementation TSLogEntity

+ (id)logEntityWithMessage:(NSString *)message from:(id)object method:(NSString*)method line:(NSInteger)line aka:(NSInteger)aka {
    TSLogEntity *entity = [[TSLogEntity alloc] init];
    entity.className = NSStringFromClass([object class]);
    entity.codeline = line;
    entity.methodName = method;
    entity.aka = aka;
    entity.message = [NSString stringWithString:message];
    
    CGFloat width = (NSInteger)([[UIScreen mainScreen] bounds].size.width);
    UIFont *font = [UIFont systemFontOfSize:TSLOG_FONTSIZE];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc] initWithString:entity.message attributes:@{ NSFontAttributeName: font }];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    entity.cellHeight = rect.size.height+TSLOG_FONTSIZE+2;
    return entity;
}

+ (NSString*)shortStringFromType:(TSLogType)type {
    switch (type) {
        case TSLogTypeDefault:
            return @"D";
            break;
        case TSLogTypeResult:
            return @"R";
            break;
        case TSLogTypeWarning:
            return @"W";
            break;
        case TSLogTypeError:
            return @"E";
            break;
        default:
            break;
    }
    return @"U";
}

+ (NSString*)stringFromType:(TSLogType)type {
    switch (type) {
        case TSLogTypeDefault:
            return @"Default";
            break;
        case TSLogTypeResult:
            return @"Result";
            break;
        case TSLogTypeWarning:
            return @"Warning";
            break;
        case TSLogTypeError:
            return @"Error";
            break;
        default:
            break;
    }
    return @"Unknown";
}


+ (NSString*)shortStringFromGroup:(TSLogGroup)group {
    switch (group) {
        case TSLogGroupCommon:
            return @"C";
            break;
        case TSLogGroupLocation:
            return @"L";
            break;
        case TSLogGroupNetwork:
            return @"N";
            break;
        case TSLogGroupBeacon:
            return @"B";
            break;
        case TSLogGroupDevice:
            return @"D";
            break;
        case TSLogGroupCampaign:
            return @"P";
            break;
        case TSLogGroupZone:
            return @"Z";
            break;
        case TSLogGroupMap:
            return @"M";
            break;
        case TSLogGroupApplication:
            return @"A";
            break;
        case TSLogGroupStore:
            return @"S";
            break;
        default:
            break;
    }
    return @"U";
}

+ (NSString*)stringFromGroup:(TSLogGroup)group {
    switch (group) {
        case TSLogGroupCommon:
            return @"Common";
            break;
        case TSLogGroupLocation:
            return @"Location";
            break;
        case TSLogGroupNetwork:
            return @"Network";
            break;
        case TSLogGroupBeacon:
            return @"Beacon";
            break;
        case TSLogGroupDevice:
            return @"Device";
            break;
        case TSLogGroupCampaign:
            return @"Campaign";
            break;
        case TSLogGroupZone:
            return @"Zone";
            break;
        case TSLogGroupMap:
            return @"Map";
            break;
        case TSLogGroupApplication:
            return @"Application";
            break;
        case TSLogGroupStore:
            return @"Store";
            break;
        default:
            break;
    }
    return @"Unknown";
}

+ (NSArray *)stringsFromGroup {
    return @[@"Common", @"Location", @"Network", @"Beacon", @"Device", @"Campaign", @"Zone", @"Map", @"Application", @"Store"];
}

- (TSLogType)type {
    if (TSLogTypeDefault <= self.aka && self.aka <= TSLogTypeEnd) {
        return self.aka;
    }
    return -1;
}

- (TSLogGroup)group {
    if (TSLogGroupStart <= self.aka && self.aka <= TSLogGroupEnd) {
        return self.aka;
    }
    return -1;
}

@end

@implementation NSDate (simpleString)

- (NSString*)simpleString:(NSString *)format {
    if (!format) {
        format = @"yyyy-MM-dd HH:mm";
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:format];
    NSString *dateString = [dateFormat stringFromDate:self];
    return dateString;
}

+ (id) dateWithString:(NSString*)dateString formatter:(NSString *)formatting {//@"yyyy-MM-dd HH:mm:ss"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatting];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}

@end

@interface TSDebugLogManager ()

#ifdef TSLOG_LOGTOFILE
@property (nonatomic, strong) NSFileHandle *logFile;
#endif

@end

@implementation TSDebugLogManager

#pragma mark - Singletons & initialized
+ (TSDebugLogManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static TSDebugLogManager *sharedManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedManager = [[TSDebugLogManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.logs = [[NSMutableArray alloc] init];
        self.logToConsole = NO;
        
#ifdef TSLOG_LOGTOFILE
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"indebug_%@.txt", [[NSDate date] simpleString:@"yyyy_MM_dd_HH_mm"]]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
            [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
        self.logFile = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
#endif
    }
    return self;
}

- (void)addLog:(NSString*)message from:(id)object method:(const char*)function line:(long)line logType:(TSLogType)type {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *method = nil;
        if (function) {
            method = [NSString stringWithUTF8String:function];;
        }
        TSLogEntity *entity = [TSLogEntity logEntityWithMessage:message from:object method:method line:line aka:type];
        //    [self.logs addObject: entity ];
        //    if ([self countOfLogs] > 500) {
        //        [self removeObjectFromLogsAtIndex:0];
        //    }
        [self addLogEntity:entity];
        if (self.logToConsole) {
            if (method) {
                NSLog(@"{\n Class\t: %@ line : %ld\n Method\t: %@\n Type\t: %@\n message: %@\n}", \
                      NSStringFromClass([object class]), line, method, errortype(type), NStringFromUTF8(message));
            } else {
                NSLog(@"{\n Class\t: %@ line : %ld\n Type\t: %@\n message: %@\n}", \
                      NSStringFromClass([object class]), line, errortype(type), NStringFromUTF8(message));
            }
        }
        
#ifdef TSLOG_LOGTOFILE
        if (self.logFile) {
            NSString *logContent = [NSString stringWithFormat:@"{\n Class\t: %@ line : %ld\n Type\t: %@\n message: %@\n}\n", \
                                    NSStringFromClass([object class]), line, errortype(type), message];
            [self.logFile seekToEndOfFile];
            [self.logFile writeData:[logContent dataUsingEncoding:NSUTF8StringEncoding]];
        }
#endif
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
//    });
}

- (void)addLog:(NSString*)message from:(id)object method:(const char*)function line:(long)line logGroup:(TSLogGroup)group {
#if TSGLOG_IN_THREAD
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#endif
        NSString *method = nil;
        if (function) {
            method = [NSString stringWithUTF8String:function];;
        }
        TSLogEntity *entity = [TSLogEntity logEntityWithMessage:message from:object method:method line:line aka:group];
        [self addLogEntity:entity];
        if (self.logToConsole) {
            if (method) {
                NSLog(@"{\n Class\t: %@ line : %ld\n Method\t: %@\n Group\t: %@\n message: %@\n}", \
                      NSStringFromClass([object class]), line, method, loggroup(group), NStringFromUTF8(message));
            } else {
                NSLog(@"{\n Class\t: %@ line : %ld\n Group\t: %@\n message: %@\n}", \
                      NSStringFromClass([object class]), line, loggroup(group), NStringFromUTF8(message));
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kSLBSNotificationCreatedLogEntity object:entity];
        
#ifdef TSLOG_LOGTOFILE
        if (self.logFile) {
            NSString *logContent = [NSString stringWithFormat:@"{\n Class\t: %@ line : %ld\n Group\t: %@\n message: %@\n}\n", \
                                    NSStringFromClass([object class]), line, loggroup(group), message];
            [self.logFile seekToEndOfFile];
            [self.logFile writeData:[logContent dataUsingEncoding:NSUTF8StringEncoding]];
        }
#endif
#if TSGLOG_IN_THREAD
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
    });
#endif
}

- (void)showLogViewController {
    UIViewController *topVC = [UIViewController currentViewController];
    TSLogTableViewController *logVC = [[TSLogTableViewController alloc] initWithStyle:UITableViewStylePlain];
    logVC.logs = self.logs;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:logVC];
    [topVC presentViewController:nav animated:YES completion:nil];
}

- (void)showStatusViewController {
//    UIViewController *topVC = [UIViewController currentViewController];
//  TSBeaconInfoTabbarController *infoVC = [[TSBeaconInfoTabbarController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:infoVC];
//    [topVC presentViewController:nav animated:YES completion:nil];
}

- (void)finish {
#ifdef TSLOG_LOGTOFILE
    [self.logFile closeFile];
    self.logFile = nil;
#endif
}

#pragma mark - For KVO
- (void)addLogObserverWithTarget:(id)target {
    [self addObserver:target forKeyPath:@"logs" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:(__bridge void*)self];
}

- (void)removeObserverWithTarget:(id)target {
    [self removeObserver:target forKeyPath:@"logs" context:(__bridge void*)self];
}

//  Just a convenience method
- (NSArray *)currentLogs {
    return [self logsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [self countOfLogs])]];
}

//  These methods enable KVC compliance
- (void)addLogEntity:(TSLogEntity *)entity {
    [self insertObject:entity inLogsAtIndex:[_logs count]];
}

- (void)insertObject:(id)object inLogsAtIndex:(NSUInteger)index {
    self.logs[index] = object;
}

- (void)removeObjectFromLogsAtIndex:(NSUInteger)index {
    [self.logs removeObjectAtIndex:index];
}

- (id)objectInLogsAtIndex:(NSUInteger)index {
    return self.logs[index];
}

- (NSArray *)logsAtIndexes:(NSIndexSet *)indexes {
    return [self.logs objectsAtIndexes:indexes];
}

- (NSUInteger)countOfLogs {
    return [self.logs count];
}

@end

