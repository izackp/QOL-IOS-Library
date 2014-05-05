//
//  NSString+Formatting.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "NSString+Formatting.h"
#import "NSString+Search.h"
#import <CommonCrypto/CommonDigest.h>

NSString* const cHttpPrefix = @"http://";
NSString* const cHttpSuffix = @"/";

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

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSUInteger location = 0;
    NSUInteger length = [self length];
    unichar charBuffer[length];
    [self getCharacters:charBuffer];
    
    for (; length > 0; length--) {
        if (![characterSet characterIsMember:charBuffer[length - 1]]) {
            break;
        }
    }
    
    return [self substringWithRange:NSMakeRange(location, length - location)];
}

- (NSString*)stringByCapitalizingFirstCharacter {
    if (self.length == 0)
        return nil;
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] capitalizedString]];
}

- (NSRange)rangeOfPrefix {
    return [self rangeOfString:cHttpPrefix];
}

- (NSString*)strippedHost {
    NSString* content = [self getFirstStringInbetweenPrefix:cHttpPrefix suffix:cHttpSuffix];
    return content;
}

- (NSString*)hostSubPath {
    NSString* content = [self getFirstStringAfter:cHttpPrefix];
    if ([content containsText:cHttpSuffix])
    {
        NSString* additionalContent = [content getFirstStringAfter:cHttpSuffix];
        return additionalContent;
    }
    return nil;
}

- (NSString*)httpAddressWithSubpath {
    NSString* finalAddress = [[self httpAddress] stringByAppendingString:[self hostSubPath]];
    return finalAddress;
}

- (NSString*)httpAddress {
    NSString* host = [self strippedHost];
    NSString* formattedHost = [cHttpPrefix stringByAppendingFormat:@"%@%@", host, cHttpSuffix];
    return [formattedHost urlEncoded];
}

- (NSString*)httpAddressWithSubpathUsingBasicAuthUsername:(NSString*)username password:(NSString*)password {
    NSString* httpAddressWithAuth = [self httpAddressUsingBasicAuthUsername:username password:password];
    NSString* subPath = [self hostSubPath];
    NSString* final = [httpAddressWithAuth stringByAppendingString:[subPath urlEncoded]];
    return final;
}

- (NSString*)httpAddressUsingBasicAuthUsername:(NSString*)username password:(NSString*)password {
    return [[NSString stringWithFormat:@"%@%@:%@@%@%@", cHttpPrefix, username, password, [self strippedHost], cHttpSuffix] urlEncoded];
}

@end
