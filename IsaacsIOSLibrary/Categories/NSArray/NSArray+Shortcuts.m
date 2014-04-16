//
//  NSArray+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSArray+Shortcuts.h"

@implementation NSArray (Shortcuts)

- (NSArray*)arrayByExtractingProperty:(NSString*)key {
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (NSObject* eachObj in self)
    {
        id value = [eachObj valueForKey:key];
        if (value == nil)
            return nil;
        [array addObject:value];
    }
    
    return array;
}

@end
