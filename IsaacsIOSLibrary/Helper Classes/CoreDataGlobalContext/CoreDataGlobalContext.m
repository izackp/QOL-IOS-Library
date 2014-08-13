//
//  CoreDataGlobalContext.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "CoreDataGlobalContext.h"
#import <CoreData/CoreData.h>
#import "NSManagedObjectContext+Shortcuts.h"
#import "UIAlertView+Shortcuts.h"

@implementation CoreDataGlobalContext

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

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
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
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
    _managedObjectContext = nil;
    _managedObjectModel = nil;
    _persistentStoreCoordinator = nil;
    [self persistentStoreCoordinator];
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext
{
    if ([NSThread currentThread] != [NSThread mainThread])
    {
        NSLog(@"Warning accessing managed object context on BG thread");
    }
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
        _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil)
        return _managedObjectModel;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.databaseName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
        return _persistentStoreCoordinator;
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![self addPersistentStore])
        _persistentStoreCoordinator = nil;

    return _persistentStoreCoordinator;
}

const static int cMaxTries = 2;

- (bool)addPersistentStore {
    if (_persistentStoreCoordinator == nil)
        return false;
    
    NSURL *storeURL             = [self storeUrl];
    NSError *error              = nil;
    NSDictionary* options       = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    
    bool hasPersistentStore = false;
    int numTries = 0;
    while (!hasPersistentStore && numTries < cMaxTries) { //true && false = false
        
        hasPersistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        
        if (!hasPersistentStore) {
            NSLog(@"REMOVING STORE - Unresolved error %@ , %@", error, [error userInfo]);
            
            [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        }
    }
    
    if (!hasPersistentStore)
    {
        [UIAlertView showMessage:@"There has been a problem creating a database to store data in."];
        return false;
    }
    
    return true;
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
