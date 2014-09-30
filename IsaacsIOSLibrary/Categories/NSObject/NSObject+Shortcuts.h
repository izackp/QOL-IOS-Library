//
//  NSObject+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 5/16/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Shortcuts)

- (NSArray*)getAllPropertyNames;

- (void)invokeSelectorSafe:(SEL)selector;
- (void)invokeSelectorSafe:(SEL)selector withObject:(NSObject*)obj;
- (void)invokeSelector:(SEL)selector;
- (void)invokeSelector:(SEL)selector withObject:(NSObject*)obj;

- (NSError*)errorWithCode:(NSInteger)code andLocalizedDescription:(NSString*)desc;

- (void)setAssociatedObject:(id)object key:(NSString* const)key;
- (id)getAssociatedObject:(NSString* const)key;

@end
