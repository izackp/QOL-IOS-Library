//
//  NSString+Formatting.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "NSString+Formatting.h"
#import <CommonCrypto/CommonDigest.h>

NSString* const cHttpPrefix = @"http://";

@implementation NSString (Formatting)

- (NSString*)urlEncoded
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)self;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, NULL,kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

- (NSString*)trimWhiteSpace
{
    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)mStr);
    
    return [mStr copy];
}

- (NSRange)rangeOfPrefix {
    return [self rangeOfString:cHttpPrefix];
}

- (NSString*)httpAddress {
    NSRange range = [self rangeOfPrefix];
    if (range.location == NSNotFound)
        return [[NSString stringWithFormat:@"%@%@", cHttpPrefix, self] urlEncoded];
    
    if (range.location == 0)
        return [self urlEncoded];
    
    return nil;
}

/*! does not work if the prefix is in the middle of the string */
- (NSString*)removeHttpPrefix {
    NSRange range = [self rangeOfPrefix];
    if (range.location != 0)
        return self;
    
    return [self substringFromIndex:cHttpPrefix.length];
}

- (NSString*)httpAddressWithBasicAuthUsername:(NSString*)username password:(NSString*)password {
    return [[NSString stringWithFormat:@"http://%@:%@@%@/", username, password, [self removeHttpPrefix]] urlEncoded];
}

@end
