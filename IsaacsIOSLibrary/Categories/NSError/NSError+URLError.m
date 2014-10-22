//
//  NSError+URLError.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 10/22/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSError+URLError.h"

@implementation NSError (URLError)

- (bool)isConnectionError {
    return [NSError isConnectionError:self.code];
}

+ (bool)isConnectionError:(NSInteger)code {
    if (code == kCFURLErrorCannotFindHost)
        return true;
    
    if (code == kCFURLErrorCannotConnectToHost)
        return true;
    
    if (code == kCFURLErrorNetworkConnectionLost)
        return true;
    
    if (code == kCFURLErrorDNSLookupFailed)
        return true;
    
    if (code == kCFURLErrorNotConnectedToInternet)
        return true;
    
    if (code == kCFURLErrorTimedOut)
        return true;
    
    return false;
}

- (NSString*)connectionErrorString {
    return [NSError connectionErrorStringForCode:self.code];
}

+ (NSString*)connectionErrorStringForCode:(NSInteger)code {
    if (code == kCFURLErrorCannotFindHost)
        return @"Error connecting to the server: Could not find host.";
    
    if (code == kCFURLErrorCannotConnectToHost)
        return @"Error connecting to the server: Could not connect to host.";
    
    if (code == kCFURLErrorNetworkConnectionLost)
        return @"Error connecting to the server: Network Connection Lost.";
    
    if (code == kCFURLErrorDNSLookupFailed)
        return @"Error connecting to the server: DNS Lookup Failed.";
    
    if (code == kCFURLErrorNotConnectedToInternet)
        return @"Error connecting to the server: Not connected to a network.";
    
    if (code == kCFURLErrorTimedOut)
        return @"Error connecting to the server: Connection timed out.";
    
    return nil;
}

@end
