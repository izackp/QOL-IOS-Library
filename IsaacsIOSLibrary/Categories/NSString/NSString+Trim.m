//
//  NSString+MD5.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Trim)

- (NSString*)trimWhiteSpace
{
    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)mStr);
    
    return [mStr copy];
}

@end
