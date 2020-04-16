//
//  NSError+URLError.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 10/22/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSError+URLError.h"
#import "NSBundle+Localizable.h"

@implementation NSError (URLError)

- (bool)isConnectionError {
    return [NSError isConnectionError:self.code];
}

+ (bool)isConnectionError:(NSInteger)code {
    
    switch (code) {
        case kCFURLErrorBadURL:
        case kCFURLErrorTimedOut:
        case kCFURLErrorUnsupportedURL:
        case kCFURLErrorCannotFindHost:
        case kCFURLErrorCannotConnectToHost:
        case kCFURLErrorNetworkConnectionLost:
        case kCFURLErrorDNSLookupFailed:
        case kCFURLErrorNotConnectedToInternet:
        case kCFURLErrorRedirectToNonExistentLocation:
        case kCFURLErrorBadServerResponse:
            return true;
            
        default:
            return false;
    }
    return false;
}

- (NSString*)connectionErrorString {
    return [NSError connectionErrorStringForCode:self.code];
}

+ (NSString*)connectionErrorStringForCode:(NSInteger)code {
    NSBundle* bundle = [NSBundle QOLBundle];
    NSString* error = [bundle localized:@"Error connecting to the server: "];
    switch (code) {
        case kCFURLErrorBadURL:
            return [NSString stringWithFormat:@"%@%@", error, @"Bad URL."];
        case kCFURLErrorTimedOut:
            return [NSString stringWithFormat:@"%@%@", error, @"Connection timed out."];
        case kCFURLErrorUnsupportedURL:
            return [NSString stringWithFormat:@"%@%@", error, @"Unsupported URL."];
        case kCFURLErrorCannotFindHost:
            return [NSString stringWithFormat:@"%@%@", error, @"Could not find host."];
        case kCFURLErrorCannotConnectToHost:
            return [NSString stringWithFormat:@"%@%@", error, @"Could not connect to host."];
        case kCFURLErrorNetworkConnectionLost:
            return [NSString stringWithFormat:@"%@%@", error, @"Network connection lost."];
        case kCFURLErrorDNSLookupFailed:
            return [NSString stringWithFormat:@"%@%@", error, @"DNS lookup failed."];
        case kCFURLErrorNotConnectedToInternet:
            return [NSString stringWithFormat:@"%@%@", error, @"Not connected to a network."];
        case kCFURLErrorRedirectToNonExistentLocation:
            return [NSString stringWithFormat:@"%@%@", error, @"Redirect to non existent location."];
        case kCFURLErrorBadServerResponse:
            return [NSString stringWithFormat:@"%@%@", error, @"Bad server response."];
            
        default:
            return nil;
    }
    
    return nil;
}

@end
