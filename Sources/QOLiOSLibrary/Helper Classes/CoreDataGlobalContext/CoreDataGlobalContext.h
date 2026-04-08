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

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *bgPSC;
@property (strong, nonatomic) NSString *databaseName;

+ (id)sharedInstance;
- (bool)saveContext:(NSError**)error;
- (NSString*)storePath;
- (void)clearStore;
- (NSManagedObjectContext *)mainContext;
- (NSManagedObjectContext *)backgroundContext;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

@end
