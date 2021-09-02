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
    if ([NSError isConnectionError:self.code]) {
        return true;
    }
    if ([[self localizedDescription] isEqualToString:@"An SSL error has occurred and a secure connection to the server cannot be made."]) {
        return true;
    }
    
    return false;
}

/// Errors that occur that depends on the user's connection or errors that resolve themselves with time or user intervention (connect to wifi).
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
        case kCFURLErrorSecureConnectionFailed:
        case kCFNetServiceErrorTimeout:
        case kCFNetServiceErrorDNSServiceFailure:
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
    if ([NSError isConnectionError:code]) {
        return [NSError userErrorStringForCode:code];
    }
    
    return nil;
}

+ (NSString*)userErrorStringForCode:(NSInteger)code {
    NSBundle* bundle = [NSBundle QOLBundle];
    NSString* error = [bundle localized:@"Error connecting to the server: "];
    NSString* errorDesc = [NSError errorStringForCode:code];
    if (errorDesc != nil) {
        return [NSString stringWithFormat:@"%@%@", error, @"Could not connect to host."];
    }
    
    return nil;
}

+ (NSString*)errorStringForCode:(NSInteger)code {
    switch (code) {
        case kCFHostErrorHostNotFound:
            return @"Host not found.";
        case kCFHostErrorUnknown:
            return @"Host error unknown.";
            
        // SOCKS errors
        case kCFSOCKSErrorUnknownClientVersion:
            return @"Unknown client version (SOCKS).";
        case kCFSOCKSErrorUnsupportedServerVersion:
            return @"Unsupported Server Version (SOCKS).";
            
        // SOCKS4-specific errors
        case kCFSOCKS4ErrorRequestFailed:
            return @"Request failed (SOCKS4).";
        case kCFSOCKS4ErrorIdentdFailed:
            return @"Identd failed (SOCKS4).";
        case kCFSOCKS4ErrorIdConflict:
            return @"Id conflict (SOCKS4).";
        case kCFSOCKS4ErrorUnknownStatusCode:
            return @"Unknown status code (SOCKS4).";
            
        // SOCKS5-specific errors
        case kCFSOCKS5ErrorBadState:
            return @"Bad state (SOCKS5).";
        case kCFSOCKS5ErrorBadResponseAddr:
            return @"Bad response address (SOCKS5).";
        case kCFSOCKS5ErrorBadCredentials:
            return @"Bad credentials (SOCKS5).";
        case kCFSOCKS5ErrorUnsupportedNegotiationMethod:
            return @"Unspported negotiation methods (SOCKS5).";
        case kCFSOCKS5ErrorNoAcceptableMethod:
            return @"No acceptable method (SOCKS5).";
            
        // FTP errors;
        case kCFFTPErrorUnexpectedStatusCode:
            return @"Unexpected status code (FTP).";
            
        // HTTP errors
        case kCFErrorHTTPAuthenticationTypeUnsupported:
            return @"HTTP authentication type unsupported.";
        case kCFErrorHTTPBadCredentials:
            return @"HTTP bad credentials.";
        case kCFErrorHTTPConnectionLost:
            return @"HTTP connection lost.";
        case kCFErrorHTTPParseFailure:
            return @"HTTP parse failed.";
        case kCFErrorHTTPRedirectionLoopDetected:
            return @"HTTP redirection loop detected.";
        case kCFErrorHTTPBadURL:
            return @"HTTP Bad URL.";
        case kCFErrorHTTPProxyConnectionFailure:
            return @"HTTP proxy connection failure.";
        case kCFErrorHTTPBadProxyCredentials:
            return @"HTTP Bad proxy credentials.";
        case kCFErrorPACFileError:
            return @"PAC file error.";
        case kCFErrorPACFileAuth:
            return @"PAC file auth error.";
        case kCFErrorHTTPSProxyConnectionFailure:
            return @"HTTPS proxy connection failure.";
        case kCFStreamErrorHTTPSProxyFailureUnexpectedResponseToCONNECTMethod:
            return @"HTTPS Proxy connection failure with unexpected response to CONNECT method.";
            
        // Error codes for CFURLConnection and CFURLProtocol
        case kCFURLErrorBackgroundSessionInUseByAnotherProcess:
            return @"Background session in use by another process (URL)";
        case kCFURLErrorBackgroundSessionWasDisconnected:
            return @"Background sessions was disconnected (URL)";
        case kCFURLErrorUnknown:
            return @"Error Unknown (URL)";
        case kCFURLErrorCancelled:
            return @"URL Cancelled";
        case kCFURLErrorBadURL:
            return @"Bad URL";
        case kCFURLErrorTimedOut:
            return @"Connection timed out.";
        case kCFURLErrorUnsupportedURL:
            return @"Unsupported URL.";
        case kCFURLErrorCannotFindHost:
            return @"Could not find host.";
        case kCFURLErrorCannotConnectToHost:
            return @"Could not connect to host.";
        case kCFURLErrorNetworkConnectionLost:
            return @"Network connection lost.";
        case kCFURLErrorDNSLookupFailed:
            return @"DNS lookup failed.";
        case kCFURLErrorHTTPTooManyRedirects:
            return @"Too many redirects.";
        case kCFURLErrorResourceUnavailable:
            return @"Resource unavailable (URL).";
        case kCFURLErrorNotConnectedToInternet:
            return @"Not connected to the internet.";
        case kCFURLErrorRedirectToNonExistentLocation:
            return @"Redirect to non existent location.";
        case kCFURLErrorBadServerResponse:
            return @"Bad server response.";
        case kCFURLErrorUserCancelledAuthentication:
            return @"User cancelled authentication.";
        case kCFURLErrorUserAuthenticationRequired:
            return @"User authentication required.";
        case kCFURLErrorZeroByteResource:
            return @"Zero byte resource.";
        case kCFURLErrorCannotDecodeRawData:
            return @"Can not decode raw data.";
        case kCFURLErrorCannotDecodeContentData:
            return @"Can not decode content data.";
        case kCFURLErrorCannotParseResponse:
            return @"Can not parse response.";
        case kCFURLErrorInternationalRoamingOff:
            return @"International roaming off.";
        case kCFURLErrorCallIsActive:
            return @"Call is active.";
        case kCFURLErrorDataNotAllowed:
            return @"Data not allowed.";
        case kCFURLErrorRequestBodyStreamExhausted:
            return @"Request body stream exhausted.";
        case kCFURLErrorAppTransportSecurityRequiresSecureConnection:
            return @"App transport security requires secure connection.";
        case kCFURLErrorFileDoesNotExist:
            return @"File does not exist.";
        case kCFURLErrorFileIsDirectory:
            return @"File is a directory.";
        case kCFURLErrorNoPermissionsToReadFile:
            return @"No permissions to read file.";
        case kCFURLErrorDataLengthExceedsMaximum:
            return @"Data length exceeds the maximum.";
        case kCFURLErrorFileOutsideSafeArea:
            return @"The file is outside of the safe area.";
            
        // SSL errors
        case kCFURLErrorSecureConnectionFailed:
            return @"Secure connection failed.";
        case kCFURLErrorServerCertificateHasBadDate:
            return @"Server certification has bad date.";
        case kCFURLErrorServerCertificateUntrusted:
            return @"Server certification is untrusted.";
        case kCFURLErrorServerCertificateHasUnknownRoot:
            return @"Server certification has unknown root.";
        case kCFURLErrorServerCertificateNotYetValid:
            return @"Server certification is not yet valid.";
        case kCFURLErrorClientCertificateRejected:
            return @"Client certification was rejected.";
        case kCFURLErrorClientCertificateRequired:
            return @"Client certification is required.";
        case kCFURLErrorCannotLoadFromNetwork:
            return @"Can not load from network.";
            
        // Download and file I/O errors
        case kCFURLErrorCannotCreateFile:
            return @"Can not create file.";
        case kCFURLErrorCannotOpenFile:
            return @"Can not open file.";
        case kCFURLErrorCannotCloseFile:
            return @"Can not close file.";
        case kCFURLErrorCannotWriteToFile:
            return @"Can not write to file.";
        case kCFURLErrorCannotRemoveFile:
            return @"Can not remove file.";
        case kCFURLErrorCannotMoveFile:
            return @"Can not move file.";
        case kCFURLErrorDownloadDecodingFailedMidStream:
            return @"Dowload decoding failed midstream.";
        case kCFURLErrorDownloadDecodingFailedToComplete:
            return @"Download decoding failed to complete.";
            
        // Cookie errors
        case kCFHTTPCookieCannotParseCookieFile:
            return @"Cannot parse cookie file.";
            
        // Errors originating from CFNetServices
        case kCFNetServiceErrorUnknown:
            return @"Error unknown (CFNetServices).";
        case kCFNetServiceErrorCollision:
            return @"Error collision (CFNetServices).";
        case kCFNetServiceErrorNotFound:
            return @"Service not found (CFNetServices).";
        case kCFNetServiceErrorInProgress:
            return @"Service in progress (CFNetServices).";
        case kCFNetServiceErrorBadArgument:
            return @"Bad argument (CFNetServices).";
        case kCFNetServiceErrorCancel:
            return @"Canceled (CFNetServices).";
        case kCFNetServiceErrorInvalid:
            return @"Invalid (CFNetServices).";
        case kCFNetServiceErrorTimeout:
            return @"Has timed out (CFNetServices).";
        case kCFNetServiceErrorDNSServiceFailure:
            return @"DNS failed (CFNetServices).";
            
        default:
            return nil;
    }
}

@end
