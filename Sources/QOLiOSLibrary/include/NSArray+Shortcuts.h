//
//  NSArray+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Shortcuts)

- (NSArray*)arrayByExtractingProperty:(NSString*)key;
- (NSArray*)matchingObjects:(NSObject*)objectToMatch;

- (id)safeObjectAtIndex:(NSInteger)index;

@end
