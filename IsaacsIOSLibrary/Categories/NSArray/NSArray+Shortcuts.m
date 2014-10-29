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

//Why use a predicate when I can have a category :P
- (NSArray*)matchingObjects:(NSObject*)objectToMatch {
    NSMutableArray* mutArr = [NSMutableArray new];
    for (NSObject* eachObj in self)
    {
        if ([eachObj isEqual:objectToMatch])
            [mutArr addObject:eachObj];
    }
    return mutArr;
}

- (id)safeObjectAtIndex:(NSInteger)index {
    if (index >= [self count])
        return nil;
    if (index < 0)
        return nil;
    return self[index];
}

@end
