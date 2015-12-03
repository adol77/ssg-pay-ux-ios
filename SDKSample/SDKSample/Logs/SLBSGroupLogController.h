//
//  SLBSGroupLogController.h
//  SDKSample
//
//  Created by Lee muhyeon on 2015. 9. 15..
//  Copyright (c) 2015년 Regina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SLBSGroupLogController : NSObject

@property (readonly) NSDate *startDate;

+ (instancetype)sharedInstance;
- (void)start;
- (void)stop;
@property (readonly) BOOL isStarted;

#pragma mark - Core Data stack
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
