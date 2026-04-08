//
//  CoreDataGlobalContext.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "CoreDataGlobalContext.h"
#import <CoreData/CoreData.h>
#import "UIAlertView+Shortcuts.h"

@implementation CoreDataGlobalContext

@synthesize mainObjectContext = _mainObjectContext;
@synthesize backgroundObjectContext = _backgroundObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize bgPSC = _bgPSC;

+ (id)sharedInstance {
    static CoreDataGlobalContext* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (bool)saveContext:(NSError**)error
{
    NSManagedObjectContext *managedObjectContext = self.mainObjectContext;
    if (managedObjectContext == nil) {
        NSLog(@"WARNING! NO MANAGED OBJECT CONTEXT");
        return false;
    }
    
    if (![managedObjectContext hasChanges])
        return true;
    
    bool success = [managedObjectContext save:error];
    if (!success && error != nil) {
        
        NSLog(@"Unresolved error %@, %@", *error, [*error userInfo]);
        return false;
    }
    return true;
}

- (void)clearStore {
    NSPersistentStoreCoordinator *storeCoordinator = [self persistentStoreCoordinator];
    NSPersistentStore *store = [[storeCoordinator persistentStores] lastObject];
    NSError *error;
    NSURL *storeURL = store.URL;
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _mainObjectContext = nil;
    _backgroundObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    _bgPSC = nil;
    [self persistentStoreCoordinator];
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)mainContext
{
    if ([NSThread currentThread] != [NSThread mainThread])
    {
        NSLog(@"Warning accessing managed object context on BG thread");
    }
    
    if (_mainObjectContext != nil) {
        return _mainObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _mainObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainObjectContext.persistentStoreCoordinator = coordinator;
        _mainObjectContext.mergePolicy = NSRollbackMergePolicy;
    }
    return _mainObjectContext;
}

- (NSManagedObjectContext *)backgroundContext
{
    if (_backgroundObjectContext != nil) {
        return _backgroundObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self bgPSC];
    if (coordinator != nil) {
        _backgroundObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _backgroundObjectContext.persistentStoreCoordinator = coordinator;
        _backgroundObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:_backgroundObjectContext];
    }
    return _backgroundObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Capture" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
        return _persistentStoreCoordinator;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![self setPersistenceStore:_persistentStoreCoordinator])
        _persistentStoreCoordinator = nil;

    return _persistentStoreCoordinator;
}

- (NSPersistentStoreCoordinator *)bgPSC
{
    if (_bgPSC != nil)
        return _bgPSC;
    
    _bgPSC = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![self setPersistenceStore:_bgPSC])
        _bgPSC = nil;

    return _bgPSC;
}

const static int cMaxTries = 2;

- (bool)setPersistenceStore:(NSPersistentStoreCoordinator *)coordinator {
    if (coordinator == nil)
        return false;
    
    NSURL *storeURL             = [self storeUrl];
    NSError *error              = nil;
    NSDictionary* options       = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    
    bool hasPersistentStore = false;
    int numTries = 0;
    while (!hasPersistentStore && numTries < cMaxTries) { //true && false = false
        
        hasPersistentStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        
        if (!hasPersistentStore) {
            NSLog(@"REMOVING STORE - Unresolved error %@ , %@", error, [error userInfo]);
            
            //[[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        }
    }
    
    if (!hasPersistentStore)
    {
        [UIAlertView showMessage:@"There has been a problem creating a database to store data in."];
        return false;
    }
    
    return true;
}

- (void)contextDidSave:(NSNotification *)notification {
    NSManagedObjectContext *sender = notification.object;
    if (sender == self.mainContext) {
        return;
    }
    
    [self.mainContext performBlock:^{
        [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

#pragma mark - Application's Documents directory
- (NSURL *)sqlRootUrl {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL*)storeUrl {
    NSString* dbName = [NSString stringWithFormat:@"%@.sqlite", self.databaseName];
    NSURL *storeURL = [[self sqlRootUrl] URLByAppendingPathComponent:dbName];
    return storeURL;
}

- (NSString*)storePath {
    return [self storeUrl].path;
}

@end
