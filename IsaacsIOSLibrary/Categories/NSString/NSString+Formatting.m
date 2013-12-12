//
//  NSString+Formatting.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "NSString+Formatting.h"
#import <CommonCrypto/CommonDigest.h>

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

@end
