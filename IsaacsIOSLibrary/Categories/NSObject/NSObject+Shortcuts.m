//
//  NSObject+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 5/16/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSObject+Shortcuts.h"
#import "objc/runtime.h"

@implementation NSObject (Shortcuts)

- (NSArray*)getAllPropertyNames {
    NSMutableArray* propertyNames = [NSMutableArray new];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if (!propName)
            continue;
        
        NSString *propertyName = [NSString stringWithUTF8String:propName];
        [propertyNames addObject:propertyName];
        
    }
    free(properties);
    
    return propertyNames;
}

- (void)invokeSelectorSafe:(SEL)selector {
    if ([self respondsToSelector:selector])
        [self invokeSelector:selector];
}

- (void)invokeSelectorSafe:(SEL)selector withObject:(NSObject*)obj {
    if ([self respondsToSelector:selector])
        [self invokeSelector:selector withObject:obj];
}

- (void)invokeSelector:(SEL)selector {
    [self invokeSelector:selector withObject:nil];
}

- (void)invokeSelector:(SEL)selector withObject:(NSObject*)obj {
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[self class] instanceMethodSignatureForSelector:selector]];
    invocation.target = self;
    invocation.selector = selector;
    if (obj != nil)
        [invocation setArgument:&obj atIndex:2];
    [invocation invoke];
}

- (NSError*)errorWithCode:(NSInteger)code andLocalizedDescription:(NSString*)desc {
    return [NSError errorWithDomain:NSStringFromClass([self class]) code:code userInfo:@{NSLocalizedDescriptionKey:desc}];
}

- (void)setAssociatedObject:(id)object key:(NSString* const)key {
    NSLog(@"Retaining %@ with key: %i", object, key);
    objc_setAssociatedObject(self, (__bridge const void *)(key), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)getAssociatedObject:(NSString* const)key {
    NSLog(@"Getting obj with key: %i", key);
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

@end
