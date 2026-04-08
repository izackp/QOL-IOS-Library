//
//  NSURLCredential+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 8/20/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSURLCredential+Shortcuts.h"

@implementation NSURLCredential (Shortcuts)

+ (NSURLCredential*)credentialForCertData:(NSData*)certData hostName:(NSString*)hostname {
    CFDataRef certDataRef = (__bridge CFDataRef)certData;
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, certDataRef);
    
    SecCertificateRef certs[1] = { cert };
    CFArrayRef array = CFArrayCreate(NULL, (const void **) certs, 1, NULL);
    SecTrustRef trust;
    SecPolicyRef SSLPolicy = SecPolicyCreateSSL(true, (__bridge CFStringRef)hostname);
    OSStatus result = SecTrustCreateWithCertificates(array, SSLPolicy, &trust);
    CFRelease(array);
    CFRelease(SSLPolicy);
    if (result != errSecSuccess) {
        return nil;
    }
    
    return [self credentialForTrustCustom:trust];
}

+ (NSURLCredential*)credentialForTrustCustom:(SecTrustRef)trust {
    SecTrustResultType trustResult;
    if (trust == NULL)
        assert(false);
    
//    OSStatus err = SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef) [CredentialsManager sharedManager].trustedAnchors);
//    if (err != noErr)
//        assert(false);
    
    OSStatus err = SecTrustSetAnchorCertificatesOnly(trust, false);
    if (err != noErr)
        assert(false);
    
    err = SecTrustEvaluate(trust, &trustResult);
    if (err != noErr)
        assert(false);
    
    if (trustResult == kSecTrustResultRecoverableTrustFailure){
        
        CFDataRef errDataRef = SecTrustCopyExceptions(trust);
        SecTrustSetExceptions(trust, errDataRef); //TODO: Doesn't make a lot of sence to copy expections then re-set them?
        CFRelease(errDataRef);
        err = SecTrustEvaluate(trust, &trustResult);
    }
    
    if (err != noErr)
        assert(false);
    
    if ((trustResult != kSecTrustResultProceed) && (trustResult != kSecTrustResultUnspecified))
        assert(false);
    
    NSURLCredential* credential = [NSURLCredential credentialForTrust:trust];
    assert(credential != nil);
    
    return credential;
}

@end
