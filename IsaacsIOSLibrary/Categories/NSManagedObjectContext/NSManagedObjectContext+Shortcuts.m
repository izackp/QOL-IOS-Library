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
    if (error)
        NSLog(@"Could not save context from %@: \n%@", [self description], [error description]);
}

@end
