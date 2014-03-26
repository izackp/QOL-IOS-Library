//
//  NSObject+Properties.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 3/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSObject+Properties.h"
#import "objc/runtime.h"

@implementation NSObject (Properties)

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

@end
