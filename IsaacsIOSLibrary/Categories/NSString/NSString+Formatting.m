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

- (NSString*)urlEncodedAllCharacters
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)self;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, originalStringRef, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    CFRelease(originalStringRef);
    return s;
}

- (NSString*)urlEncoded
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)self;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes( NULL, originalStringRef, NULL, NULL, kCFStringEncodingUTF8 );
    CFRelease(originalStringRef);
    return s;
}

- (NSString*)urlDecode {
    return (__bridge NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef) self, CFSTR(""), kCFStringEncodingUTF8);
}

- (NSDictionary*)decodeUrlParameters {
    NSString* withoutProtocol = [self getLastStringAfter:@"://"];
    NSString* method = [withoutProtocol getFirstStringBefore:@"?"];
    NSString* parameters = [withoutProtocol getFirstStringAfter:@"?"];
    NSArray* parameterList = [parameters componentsSeparatedByString:@"&"];
    NSMutableDictionary* parameterKeyValue = [[NSMutableDictionary alloc] initWithCapacity:parameterList.count];
    for (NSString* eachParameter in parameterList)
    {
        NSArray* keyValue = [eachParameter componentsSeparatedByString:@"="];
        if (keyValue.count != 2)
            continue;
        [parameterKeyValue setObject:[keyValue[1] urlDecode] forKey:keyValue[0]];
    }
    
    [parameterKeyValue setObject:method forKey:@"method"];//TODO: hack until I implement a class
    return parameterKeyValue;
}

- (NSString*)trimWhiteSpace
{
    NSMutableString *mStr = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)mStr);
    
    return [mStr copy];
}

- (NSString*)stringWithOnlyLetters {
    NSCharacterSet *numSet = [[NSCharacterSet letterCharacterSet] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:numSet] componentsJoinedByString:@""];
}

- (NSString*)stringWithOnlyNumbers {
    NSCharacterSet* letters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return [[self componentsSeparatedByCharactersInSet:letters] componentsJoinedByString:@""];
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

- (NSString*)stringByInserting:(NSString*)insert inbetweenNumberOfCharacters:(int)numChars {
    NSArray* comps = [self componentsSeparatedByNumberOfCharacters:numChars];
    NSString* result = [comps componentsJoinedByString:insert];
    return result;
}

- (NSArray*)componentsSeparatedByNumberOfCharacters:(int)numChars {
    NSUInteger numComponents = self.length / numChars;
    double mod = fmod(self.length, numChars);
    if (numComponents == 0)
        return @[self];
    
    NSUInteger numSeperations = numComponents;
    if (mod == 0)
        numSeperations -= 1;
    
    NSMutableArray* components = [[NSMutableArray alloc] initWithCapacity:numComponents];
    for (int i = 0; i < numSeperations; i+= 1)
    {
        NSUInteger length = numChars;
        NSUInteger location = i * numChars;
        if (self.length < location + length)
            length = location - self.length;
        NSRange range = NSMakeRange(location, length);
        NSString* strComp = [self substringWithRange:range];
        [components addObject:strComp];
    }
    
    NSUInteger lastLocation = numSeperations * numChars;
    if (lastLocation < self.length)
    {
        NSRange range = NSMakeRange(lastLocation, self.length - lastLocation);
        NSString* strComp = [self substringWithRange:range];
        [components addObject:strComp];
    }
    return components;
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
    NSString* finalAddress = [[self httpAddress] stringByAppendingWeakString:[self hostSubPath]];
    return finalAddress;
}

- (NSString*)httpAddress {
    NSString* host = [self strippedHost];
    NSString* formattedHost = [cHttpPrefix stringByAppendingFormat:@"%@%@", host, cHttpSuffix];
    return [formattedHost urlEncoded];
}

- (unsigned int)port {
    NSString* ipAddr = [self strippedHost];
    NSArray* split = [ipAddr componentsSeparatedByString:@":"];
    if (split.count != 2)
        return 80;
    return [split[1] unsignedIntValue];
}

- (NSString*)httpAddressWithSubpathUsingBasicAuthUsername:(NSString*)username password:(NSString*)password {
    NSString* httpAddressWithAuth = [self httpAddressUsingBasicAuthUsername:username password:password];
    NSString* subPath = [self hostSubPath];
    NSString* final = [httpAddressWithAuth stringByAppendingWeakString:[subPath urlEncoded]];
    return final;
}

- (NSString*)httpAddressUsingBasicAuthUsername:(NSString*)username password:(NSString*)password {
    return [NSString stringWithFormat:@"%@%@:%@@%@%@", cHttpPrefix, [username urlEncodedAllCharacters], [password urlEncodedAllCharacters], [[self strippedHost] urlEncoded], cHttpSuffix];
}

- (NSString*)stringByAppendingWeakString:(NSString*)strToAppend {
    if (strToAppend == nil)
        return self;
    return [self stringByAppendingString:strToAppend];
}

@end
