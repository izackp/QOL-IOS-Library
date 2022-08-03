//
//  CoreDataGlobalContext.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 RootContext (private queue) - saves to persistent store
 MainContext (main queue) child of RootContext - use for UI (FRC)
 WorkerContext (private queue) - child of MainContext - use for updates & inserts
 */
@class NSManagedObjectContext;
@class NSManagedObjectModel;
@class NSPersistentStoreCoordinator;

@interface CoreDataGlobalContext : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSString *databaseName;

+ (id)sharedInstance;
- (bool)saveContext:(NSError**)error;
- (NSString*)storePath;
- (void)clearStore;
- (NSManagedObjectContext *)managedObjectContext;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end
