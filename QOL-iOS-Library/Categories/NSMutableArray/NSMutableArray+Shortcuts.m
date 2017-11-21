//
//  NSMutableArray+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 9/1/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSMutableArray+Shortcuts.h"

@implementation NSMutableArray (Shortcuts)

- (void)removeObjectsWithBlock:(ShouldRemoveBlock)block {
    for (NSUInteger i = 0; i < self.count; i+=1)
    {
        NSObject* eachObj = self[i];
        bool shouldRemove = block(eachObj);
        if (shouldRemove)
        {
            [self removeObjectAtIndex:i];
            i -= 1;
        }
    }
}

@end
