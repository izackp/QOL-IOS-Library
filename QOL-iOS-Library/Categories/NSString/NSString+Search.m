//
//  NSString+Search.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 3/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSString+Search.h"

@implementation NSString (Search)

- (bool)containsText:(NSString*)text {
    if (text == nil)
        return false;
    if ([self rangeOfString:text].location != NSNotFound)
        return true;
    return false;
}

- (bool)containsTextIgnoreCase:(NSString*)text {
    return [[self lowercaseString] containsText:[text lowercaseString]];
}

- (NSString*)getFirstStringInbetweenPrefix:(NSString*)prefix suffix:(NSString*)suffix {
    NSString* string = [self getFirstStringAfter:prefix];
    string = [string getFirstStringBefore:suffix];
    return string;
}

- (NSString*)getFirstStringAfter:(NSString*)prefix {
    NSRange rangeOfPrefix = [self rangeOfString:prefix];
    if (rangeOfPrefix.location == NSNotFound)
        return self;
    
    return [self substringFromIndex:rangeOfPrefix.location + rangeOfPrefix.length];
}

- (NSString*)getLastStringAfter:(NSString*)prefix {
    NSRange rangeOfPrefix = [self rangeOfString:prefix options:NSBackwardsSearch];
    if (rangeOfPrefix.location == NSNotFound)
        return self;
    
    return [self substringFromIndex:rangeOfPrefix.location + rangeOfPrefix.length];
}

- (NSString*)getFirstStringBefore:(NSString*)suffix {
    NSRange rangeOfSuffix = [self rangeOfString:suffix];
    if (rangeOfSuffix.location == NSNotFound)
        return self;
    
    return [self substringToIndex:rangeOfSuffix.location];
}

- (NSString*)getFirstStringStrictInbetweenPrefix:(NSString*)prefix suffix:(NSString*)suffix {
    NSString* string = [self getFirstStringStrictAfter:prefix];
    string = [string getFirstStringStrictBefore:suffix];
    return string;
}

- (NSString*)getFirstStringStrictAfter:(NSString*)prefix {
    NSRange rangeOfPrefix = [self rangeOfString:prefix];
    if (rangeOfPrefix.location == NSNotFound)
        return nil;
    
    return [self substringFromIndex:rangeOfPrefix.location + rangeOfPrefix.length];
}

- (NSString*)getFirstStringStrictBefore:(NSString*)suffix {
    NSRange rangeOfSuffix = [self rangeOfString:suffix];
    if (rangeOfSuffix.location == NSNotFound)
        return nil;
    
    return [self substringToIndex:rangeOfSuffix.location];
}

@end
