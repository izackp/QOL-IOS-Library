//
//  NSManagedObjectContext+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSManagedObjectContext+Shortcuts.h"

@implementation NSManagedObjectContext (Shortcuts)

- (void)saveAndLogError {
    NSError* error;
    [self save:&error];
    if (error) {
        NSLog(@"Could not save context from %@: \n%@", [self description], [error description]);
        [self rollback];
        return;
    }
    [self.parentContext saveAndLogError];
}

- (NSManagedObject*)existingObjectWithIDLogError:(NSManagedObjectID*)objId {
    NSError* error;
    id obj = [self existingObjectWithID:objId error:&error];
    if (error)
    {
        NSLog(@"Pulling clip from main context failed: %@", error);
        return nil;
    }
    return obj;
}

- (NSManagedObject*)existingOrCreatedObjectWithID:(NSManagedObjectID*)objId {
    id obj = [self existingObjectWithIDLogError:objId];
    if (obj)
        return obj;
    
    obj = [self objectWithID:objId];
    return obj;
}

- (NSArray*)existingOrCreatedObjectsWithIDs:(NSArray*)objIds {
    NSMutableArray* objs = [[NSMutableArray alloc] initWithCapacity:objIds.count];
    
    for (NSManagedObjectID* eachId in objIds)
        [objs addObject:[self existingOrCreatedObjectWithID:eachId]];
    
    return objs;
}

@end
