//
//  SLBSGroupLogController.m
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 15..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import "SLBSGroupLogController.h"
#import <SLBSSDK/TSDebugLogManager.h>
#import "SLBSLogEntity.h"

@interface SLBSGroupLogController () {
#if TSGLOG_IN_THREAD
    dispatch_queue_t log_queue;
#endif
}

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) BOOL isStarted;

@end

@implementation SLBSGroupLogController

+ (instancetype)sharedInstance {
    static dispatch_once_t oncePredicate;
    static id sSharedInstance = nil;
    dispatch_once(&oncePredicate, ^{
        sSharedInstance = [[self alloc] init];
    });
    return sSharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startDate = [NSDate date];
    }
    return self;
}

- (void)start {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectorForCreatedLogEntity:) name:kSLBSNotificationCreatedLogEntity object:nil];
#if TSGLOG_IN_THREAD
    log_queue = dispatch_queue_create("com.ssg.slbssdk.grouplog", NULL);
#endif
}

- (void)stop {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSLBSNotificationCreatedLogEntity object:nil];
    self.isStarted = NO;
#if TSGLOG_IN_THREAD
    log_queue = nil;
#endif
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ssg.temp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"slbslogs" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"slbslogs.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
#if TSGLOG_IN_THREAD
#warning TSGLOG_IN_THREAD
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
#else
#warning TSGLOG_NOTUSING_THREAD
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
#endif
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Notification

- (void)selectorForCreatedLogEntity:(NSNotification *)notification {
//    NSLog(@"%@ - %@", NSStringFromSelector(_cmd), notification);
#if TSGLOG_IN_THREAD
    dispatch_async(log_queue, ^{
        [self.managedObjectContext performBlock:^{
#endif
            SLBSLogEntity *newEntity = (SLBSLogEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"SLBSLogEntity" inManagedObjectContext:self.managedObjectContext];
            TSLogEntity *logEntity = notification.object;
            
            newEntity.date = [NSDate date];
            newEntity.occurClass = logEntity.className;
            newEntity.codeline = [NSNumber numberWithInteger:logEntity.codeline];
            newEntity.selectorName = logEntity.methodName;
            newEntity.group = [NSNumber numberWithInteger:logEntity.group];
            newEntity.message = logEntity.message;
            newEntity.cellHeight = [NSNumber numberWithFloat:logEntity.cellHeight];
#if TSGLOG_IN_THREAD
        }];
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
    });
#endif
}

@end
