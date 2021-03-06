//
//  NSManagedObjectContext+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Shortcuts)

- (void)saveAndLogError;
- (NSManagedObject*)existingObjectWithIDLogError:(NSManagedObjectID*)objId;
- (NSManagedObject*)existingOrCreatedObjectWithID:(NSManagedObjectID*)objId;
- (NSArray*)existingOrCreatedObjectsWithIDs:(NSArray*)objIds;

@end
