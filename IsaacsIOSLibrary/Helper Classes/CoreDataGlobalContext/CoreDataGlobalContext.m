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
    
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:error]) {
        
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

//We're storing the object context in thread local storage.. which is a design that Apple is moving away from. So we should update this to not do that.
- (NSManagedObjectContext *)managedObjectContext
{
    if ([NSThread currentThread] != [NSThread mainThread])
        return nil;
    
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
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:self.databaseName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    
    if (![self addPersistentStore])
        _persistentStoreCoordinator = nil;
    else
    {
        NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
        [dc addObserver:self
               selector:@selector(storesWillChange:)
                   name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                 object:_persistentStoreCoordinator];
        
        [dc addObserver:self
               selector:@selector(storesDidChange:)
                   name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                 object:_persistentStoreCoordinator];
        
        [dc addObserver:self
               selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
                   name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                 object:_persistentStoreCoordinator];
    }

    return _persistentStoreCoordinator;
}

const static int cMaxTries = 2;

- (bool)addPersistentStore {
    if (_persistentStoreCoordinator == nil) {
        return false;
    }
    
    NSString* dbName = [NSString stringWithFormat:@"%@.sqlite", self.databaseName];
    NSURL *storeURL             = [[self sqlRootUrl] URLByAppendingPathComponent:dbName];
    NSError *error              = nil;
    NSDictionary* options       = nil;
    
    options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES, NSPersistentStoreUbiquitousContentNameKey : @"iCloudStore"};
    
    
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

#pragma mark - iCloud callbacks
- (void)persistentStoreDidImportUbiquitousContentChanges:(NSNotification*)note
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@", note.userInfo.description);
    
    NSManagedObjectContext *moc = self.managedObjectContext;
    [moc performBlock:^{
        [moc mergeChangesFromContextDidSaveNotification:note];
        NSNotification *refreshNotification = [NSNotification notificationWithName:@"iCloudContentUpdate" object:self userInfo:[note userInfo]];
        [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
        
    }];
}

// Subscribe to NSPersistentStoreCoordinatorStoresWillChangeNotification
// most likely to be called if the user enables / disables iCloud
// (either globally, or just for your app) or if the user changes
// iCloud accounts.
- (void)storesWillChange:(NSNotification *)note {
    NSManagedObjectContext *moc = self.managedObjectContext;
    [moc performBlockAndWait:^{
        NSError *error = nil;
        if ([moc hasChanges]) {
            [moc save:&error];
        }
        
        [moc reset];
    }];
    
    // now reset your UI to be prepared for a totally different
}

// Subscribe to NSPersistentStoreCoordinatorStoresDidChangeNotification
- (void)storesDidChange:(NSNotification *)note {
    NSLog(@"storesDidChange called - >>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    
    // Check type of transition
    NSNumber *type = [note.userInfo objectForKey:NSPersistentStoreUbiquitousTransitionTypeKey];
    
    NSLog(@" userInfo is %@", note.userInfo);
    NSLog(@" transition type is %@", type);
    
    if (type.intValue == NSPersistentStoreUbiquitousTransitionTypeInitialImportCompleted) {
        
        NSLog(@" transition type is NSPersistentStoreUbiquitousTransitionTypeInitialImportCompleted");
        
    } else if (type.intValue == NSPersistentStoreUbiquitousTransitionTypeAccountAdded) {
        NSLog(@" transition type is NSPersistentStoreUbiquitousTransitionTypeAccountAdded");
    } else if (type.intValue == NSPersistentStoreUbiquitousTransitionTypeAccountRemoved) {
        NSLog(@" transition type is NSPersistentStoreUbiquitousTransitionTypeAccountRemoved");
    } else if (type.intValue == NSPersistentStoreUbiquitousTransitionTypeContentRemoved) {
        NSLog(@" transition type is NSPersistentStoreUbiquitousTransitionTypeContentRemoved");
    }
    
    if (type.intValue == NSPersistentStoreUbiquitousTransitionTypeContentRemoved)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
            _managedObjectContext = nil;
            NSLog(@"iCloud store was removed! Wait for empty store");
        }];
    }
    
    [self.managedObjectContext performBlock:^{
        
        [self.managedObjectContext saveAndLogError];
    }];
}

@end
