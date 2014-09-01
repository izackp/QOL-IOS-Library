//
//  NSMutableArray+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 9/1/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL(^ShouldRemoveBlock)(id object);

@interface NSMutableArray (Shortcuts)

- (void)removeObjectsWithBlock:(ShouldRemoveBlock)block;

@end
