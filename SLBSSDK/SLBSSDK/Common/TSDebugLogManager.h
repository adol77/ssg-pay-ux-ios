//
//  TSDebugLogManager.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define TSLOG_FONTSIZE          12
#define TSLOG_LOGTOFILE

#define TSGLOG_IN_THREAD        0

typedef NS_ENUM(NSInteger, TSLogType) {
//    TSLogUnknown     = -1,
    TSLogTypeDefault = 0,
    TSLogTypeResult,
    TSLogTypeWarning,
    TSLogTypeError,
    TSLogTypeEnd = 99,
};

typedef NS_ENUM(NSInteger, TSLogGroup) {
    TSLogGroupStart = TSLogTypeEnd + 1,
//    TSLogGroupError,
    //SDK
    TSLogGroupCommon,
    TSLogGroupLocation,
    TSLogGroupNetwork,
    TSLogGroupBeacon,
    TSLogGroupDevice,
    TSLogGroupCampaign,
    TSLogGroupZone,
    //Map
    TSLogGroupMap,
    //Application
    TSLogGroupApplication,
    TSLogGroupStore,
    TSLogGroupEnd = 199,
};

FOUNDATION_EXPORT NSString *const kSLBSNotificationCreatedLogEntity;

@interface TSLogEntity : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, assign) NSInteger codeline;
@property (nonatomic, strong) NSString *methodName;
@property (readonly) TSLogType type;
@property (readonly) TSLogGroup group;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) CGFloat cellHeight;

+ (id)logEntityWithMessage:(NSString*)message from:(id)object method:(NSString*)method line:(NSInteger)line aka:(NSInteger)aka;
+ (NSString*)shortStringFromType:(TSLogType)type;
+ (NSString*)stringFromType:(TSLogType)type;
+ (NSString*)shortStringFromGroup:(TSLogGroup)group;
+ (NSString*)stringFromGroup:(TSLogGroup)group;
+ (NSArray *)stringsFromGroup;

@end

@interface TSDebugLogManager : NSObject

+ (TSDebugLogManager*) sharedInstance;
- (void)addLog:(NSString*)message from:(id)object method:(const char*)function line:(long)line logType:(TSLogType)type;
- (void)addLog:(NSString*)message from:(id)object method:(const char*)function line:(long)line logGroup:(TSLogGroup)group;
- (void)showLogViewController;
- (void)showStatusViewController;

@property (nonatomic, strong) NSMutableArray *logs;
@property (nonatomic, assign) BOOL logToConsole;
- (void)finish;

#pragma mark - KVO
- (void)addLogObserverWithTarget:(id)target;
- (void)removeObserverWithTarget:(id)target;

// Convenience accessor
- (NSArray *)currentLogs;

// For KVC compliance, publicly declared for readability
- (void)insertObject:(id)object inLogsAtIndex:(NSUInteger)index;
- (void)removeObjectFromLogsAtIndex:(NSUInteger)index;
- (id)objectInLogsAtIndex:(NSUInteger)index;
- (NSArray *)logsAtIndexes:(NSIndexSet *)indexes;
- (NSUInteger)countOfLogs;

@end

@interface NSDate (simpleString)

- (NSString*)simpleString:(NSString *)format;
+ (id) dateWithString:(NSString*)dateString formatter:(NSString *)formatting;//@"yyyy-MM-dd HH:mm:ss"

@end

#ifdef DEBUG
#define USE_TSDEBUG
#else
//    #define USE_TSDEBUG_EXTERNAL
//    #define USE_NSDEBUG
#endif

#define errortype(type) [TSLogEntity stringFromType:type]
#define loggroup(group) [TSLogEntity stringFromGroup:group]
#define resultstr(success)  success?@"success":@"fail"
#define boolstr(boolValue)  boolValue?@"YES":@"NO"


#if defined(USE_TSDEBUG)

#define TSLog(s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:__PRETTY_FUNCTION__ line:__LINE__ logType:TSLogTypeDefault]
#define TSRLog(s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:__PRETTY_FUNCTION__ line:__LINE__ logType:TSLogTypeResult]
#define TSWLog(s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:__PRETTY_FUNCTION__ line:__LINE__ logType:TSLogTypeWarning]
#define TSELog(s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:__PRETTY_FUNCTION__ line:__LINE__ logType:TSLogTypeError]
#define TSSLog(success, s, ...) \
[[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:__PRETTY_FUNCTION__ line:__LINE__ logType:(success)?TSLogTypeResult:TSLogTypeError]

/**
 *  log 관리자에 Group 형식의 로그를 남긴다.
 *
 *  @param group    저장할 로그의 group 형식, TSLogGroup enum type 값을 사용한다.
 *  @param s        저장할 로그의 문자열, format 형식을 지원한다.
 *  @param ...      format 문자열에 출력할 콤마로 분리된 입력 리스트
 */
#define TSGLog(group, s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:__PRETTY_FUNCTION__ line:__LINE__ logGroup:(group)]

#else

#define TSLog(s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:NULL line:__LINE__ logType:TSLogTypeDefault]
#define TSRLog(s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:NULL line:__LINE__ logType:TSLogTypeResult]
#define TSWLog(s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:NULL line:__LINE__ logType:TSLogTypeWarning]
#define TSELog(s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:NULL line:__LINE__ logType:TSLogTypeError]
#define TSSLog(success, s, ...) \
[[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:NULL line:__LINE__ logType:(success)?TSLogTypeResult:TSLogTypeError]

#define TSGLog(group, s, ...) [[TSDebugLogManager sharedInstance] addLog:[NSString stringWithFormat:(s), ##__VA_ARGS__] from:self method:NULL line:__LINE__ logGroup:(group)]

#endif

#if defined(USE_TSDEBUG)
//#warning    USE_TSDEBUG(Console debuglog ON)

#define TSCLog(s, ...) \
NSLog(@"{\n Class\t: %@ line : %d\n Method\t: %s\n Type\t: %@\n message: %@\n}", \
(NSStringFromClass([self class])), (__LINE__), (__PRETTY_FUNCTION__), errortype(TSLogTypeDefault), ([NSString stringWithFormat:(s), ##__VA_ARGS__]))

#define TSCRLog(s, ...) \
NSLog(@"{\n Class\t: %@ line : %d\n Method\t: %s\n Type\t: %@\n message: %@\n}", \
(NSStringFromClass([self class])), (__LINE__), (__PRETTY_FUNCTION__), errortype(TSLogTypeResult), ([NSString stringWithFormat:(s), ##__VA_ARGS__]))

#define TSCWLog(s, ...) \
NSLog(@"{\n Class\t: %@ line : %d\n Method\t: %s\n Type\t: %@\n message: %@\n}", \
(NSStringFromClass([self class])), (__LINE__), (__PRETTY_FUNCTION__), errortype(TSLogTypeWarning), ([NSString stringWithFormat:(s), ##__VA_ARGS__]))

#define TSCELog(s, ...) \
NSLog(@"{\n Class\t: %@ line : %d\n Method\t: %s\n Type\t: %@\n message: %@\n}", \
(NSStringFromClass([self class])), (__LINE__), (__PRETTY_FUNCTION__), errortype(TSLogTypeError), ([NSString stringWithFormat:(s), ##__VA_ARGS__]))

#elif defined(USE_TSDEBUG_EXTERNAL)
#warning    USE_TSDEBUG_EXTERNAL(Mode ON)

#define TSCLog(s, ...) \
NSLog(@"{\n Class\t: %@ line : %d\n Type\t: %@\n message: %@\n}", \
(NSStringFromClass([self class])), (__LINE__), errortype(TSLogTypeDefault), ([NSString stringWithFormat:(s), ##__VA_ARGS__]))

#define TSCRLog(s, ...) \
NSLog(@"{\n Class\t: %@ line : %d\n Type\t: %@\n message: %@\n}", \
(NSStringFromClass([self class])), (__LINE__), errortype(TSLogTypeResult), ([NSString stringWithFormat:(s), ##__VA_ARGS__]))

#define TSCWLog(s, ...) \
NSLog(@"{\n Class\t: %@ line : %d\n Type\t: %@\n message: %@\n}", \
(NSStringFromClass([self class])), (__LINE__), errortype(TSLogTypeWarning), ([NSString stringWithFormat:(s), ##__VA_ARGS__]))

#define TSCELog(s, ...) \
NSLog(@"{\n Class\t: %@ line : %d\n Type\t: %@\n message: %@\n}", \
(NSStringFromClass([self class])), (__LINE__), errortype(TSLogTypeError), ([NSString stringWithFormat:(s), ##__VA_ARGS__]))

#elif defined(USE_NSDEBUG)
#warning    USE_NSDEBUG(Mode ON)

#define TSCLog      NSLog
#define TSCRLog     NSLog
#define TSCWLog     NSLog
#define TSCELog     NSLog

#else

#define TSCLog(s, ...)
#define TSCRLog(s, ...)
#define TSCWLog(s, ...)
#define TSCELog(s, ...)

#endif

#ifdef DEBUG
//    #define DEBUG_METHOD_IO
#if defined(DEBUG_METHOD_IO)
#warning    DEBUG_METHOD_IO(Mode ON)
#define TSMI()    NSLog(@"\n>>> Entering Method %s", __PRETTY_FUNCTION__)
#else
#define TSMI()    void()
#endif
#endif

#if ENABLE_NSLOG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...) { }
#endif
