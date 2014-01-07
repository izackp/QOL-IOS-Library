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
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
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
    
    #ifndef DEBUG
        options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    #endif
    
    
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


@end
