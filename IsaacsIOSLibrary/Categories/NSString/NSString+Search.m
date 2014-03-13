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
    if ([self rangeOfString:text].location != NSNotFound)
        return true;
    return false;
}

- (bool)containsTextIgnoreCase:(NSString*)text {
    return [[self lowercaseString] containsText:[text lowercaseString]];
}

@end
