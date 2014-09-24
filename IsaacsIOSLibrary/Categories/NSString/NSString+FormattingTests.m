//
//  NSString+FormattingTests.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 9/24/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+Formatting.h"

@interface NSString_FormattingTests : XCTestCase

@end

@implementation NSString_FormattingTests

- (void)testHttpUrlFormatting {
    // This is an example of a functional test case.
    [self tryHost:@"192.168.0.1"];
    [self tryHost:@"192.168.0.1:8080"];
    [self tryHost:@"facebook.com"];
    [self tryHost:@"facebook.com:8080"];
}

//Integration test more than unit test
- (void)tryHost:(NSString*)host {
    NSString* hostWithSlash = [self appendEndingSlash:host];
    NSString* hostWithHttpProtocol = [NSString stringWithFormat:@"http://%@", host];
    NSString* hostWithHttpsProtocol = [NSString stringWithFormat:@"https://%@", host];
    NSString* hostWithHttpProtocolSlash = [NSString stringWithFormat:@"http://%@/", host];
    NSString* hostWithHttpsProtocolSlash = [NSString stringWithFormat:@"https://%@/", host];
    NSString* hostWithSubPath = [NSString stringWithFormat:@"%@/hello/world", host];
    NSString* hostWithSubPathSlash = [NSString stringWithFormat:@"%@/hello/world/", host];
    NSString* hostWithUrlEncodedSubPath = [NSString stringWithFormat:@"%@/hel lo/wor&ld/", host];
    NSString* hostWithUrlEncodedSubPathSlash = [NSString stringWithFormat:@"%@/hel lo/wor&ld/", host];
    NSString* hostWithSubPathAndHttp = [NSString stringWithFormat:@"%@/hello/world", hostWithHttpProtocol];
    NSString* hostWithSubPathSlashAndHttp = [NSString stringWithFormat:@"%@/hello/world/", hostWithHttpProtocol];
    NSString* hostWithUrlEncodedSubPathAndHttp = [NSString stringWithFormat:@"%@/hel lo/wor&ld/", hostWithHttpProtocol];
    NSString* hostWithUrlEncodedSubPathSlashAndHttp = [NSString stringWithFormat:@"%@/hel lo/wor&ld/", hostWithHttpProtocol];
    NSString* hostWithSubPathAndHttps = [NSString stringWithFormat:@"%@/hello/world", hostWithHttpsProtocol];
    NSString* hostWithSubPathSlashAndHttps = [NSString stringWithFormat:@"%@/hello/world/", hostWithHttpsProtocol];
    NSString* hostWithUrlEncodedSubPathAndHttps = [NSString stringWithFormat:@"%@/hel lo/wor&ld/", hostWithHttpsProtocol];
    NSString* hostWithUrlEncodedSubPathSlashAndHttps = [NSString stringWithFormat:@"%@/hel lo/wor&ld/", hostWithHttpsProtocol];
    
    NSString* expectedResult = [NSString stringWithFormat:@"http://%@/", host];
    NSString* expectedResultHttps = [NSString stringWithFormat:@"https://%@/", host];
    XCTAssertEqualObjects([host httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithSlash httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithHttpProtocol httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithHttpsProtocol httpAddress], expectedResultHttps);
    XCTAssertEqualObjects([hostWithHttpProtocolSlash httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithHttpsProtocolSlash httpAddress], expectedResultHttps);
    XCTAssertEqualObjects([hostWithSubPath httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithSubPathSlash httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPath httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathSlash httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithSubPathAndHttp httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithSubPathSlashAndHttp httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathAndHttp httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathSlashAndHttp httpAddress], expectedResult);
    XCTAssertEqualObjects([hostWithSubPathAndHttps httpAddress], expectedResultHttps);
    XCTAssertEqualObjects([hostWithSubPathSlashAndHttps httpAddress], expectedResultHttps);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathAndHttps httpAddress], expectedResultHttps);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathSlashAndHttps httpAddress], expectedResultHttps);
    
    NSString* expectedResultSubPath = [expectedResult stringByAppendingString:@"hello/world/"];
    NSString* expectedResultSubPathURLEncoded = [expectedResult stringByAppendingString:@"hel%20lo/wor&ld/"];
    NSString* expectedResultSubPathAndHttps = [expectedResultHttps stringByAppendingString:@"hello/world/"];
    NSString* expectedResultSubPathURLEncodedAndHttps = [expectedResultHttps stringByAppendingString:@"hel%20lo/wor&ld/"];
    
    XCTAssertEqualObjects([host httpAddressWithSubpath], expectedResult);
    XCTAssertEqualObjects([hostWithSlash httpAddressWithSubpath], expectedResult);
    XCTAssertEqualObjects([hostWithHttpProtocol httpAddressWithSubpath], expectedResult);
    XCTAssertEqualObjects([hostWithHttpsProtocol httpAddressWithSubpath], expectedResultHttps);
    XCTAssertEqualObjects([hostWithHttpProtocolSlash httpAddressWithSubpath], expectedResult);
    XCTAssertEqualObjects([hostWithHttpsProtocolSlash httpAddressWithSubpath], expectedResultHttps);
    
    XCTAssertEqualObjects([hostWithSubPath httpAddressWithSubpath], expectedResultSubPath);
    XCTAssertEqualObjects([hostWithSubPathSlash httpAddressWithSubpath], expectedResultSubPath);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPath httpAddressWithSubpath], expectedResultSubPathURLEncoded);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathSlash httpAddressWithSubpath], expectedResultSubPathURLEncoded);
    XCTAssertEqualObjects([hostWithSubPathAndHttp httpAddressWithSubpath], expectedResultSubPath);
    XCTAssertEqualObjects([hostWithSubPathSlashAndHttp httpAddressWithSubpath], expectedResultSubPath);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathAndHttp httpAddressWithSubpath], expectedResultSubPathURLEncoded);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathSlashAndHttp httpAddressWithSubpath], expectedResultSubPathURLEncoded);
    XCTAssertEqualObjects([hostWithSubPathAndHttps httpAddressWithSubpath], expectedResultSubPathAndHttps);
    XCTAssertEqualObjects([hostWithSubPathSlashAndHttps httpAddressWithSubpath], expectedResultSubPathAndHttps);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathAndHttps httpAddressWithSubpath], expectedResultSubPathURLEncodedAndHttps);
    XCTAssertEqualObjects([hostWithUrlEncodedSubPathSlashAndHttps httpAddressWithSubpath], expectedResultSubPathURLEncodedAndHttps);
}

- (NSString*)appendPort:(NSString*)host {
    return [host stringByAppendingString:@":8080"];
}

- (NSString*)appendEndingSlash:(NSString*)host {
    return [host stringByAppendingString:@"/"];
}
@end
