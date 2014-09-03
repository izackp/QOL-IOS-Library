//
//  NSData+Cryptography.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 8/18/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSData+Cryptography.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <Security/Security.h>

@implementation NSData (Cryptography)

- (NSString*)sha1 {
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    bool successful = CC_SHA1([self bytes], (CC_LONG)[self length], digest);
    if (!successful)
        return nil;

    NSMutableString *hexDigest = [[NSMutableString alloc] init];
    for(NSUInteger i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ )
    {
        [hexDigest appendFormat:@"%02x", digest[i]];
    }
    return hexDigest;
}

#warning Buffer Size is Arbitrary
const static size_t CIPHER_BUFFER_SIZE = 1024;
- (NSData*)rsaEncryptWithKey:(SecKeyRef)publicKey andPadding:(SecPadding)padding {
    
    NSUInteger dataSize = [self length];
    uint8_t* data = (uint8_t*)[self bytes];
    
    int maxDataSize = SecKeyGetBlockSize(publicKey);
    if (padding == kSecPaddingPKCS1)
        maxDataSize -= 11;
    
    NSAssert(dataSize <= maxDataSize, @"Data to encrypt is too big");
    
    size_t cipherDataSize = CIPHER_BUFFER_SIZE;
    uint8_t* cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    OSStatus status = SecKeyEncrypt(publicKey, padding, data, dataSize, &cipherBuffer[0], &cipherDataSize);
    
    if (status == noErr)
    {
        free(cipherBuffer);
        return [NSData dataWithBytes:cipherBuffer length:cipherDataSize];
    }
    
    free(cipherBuffer);
    return nil;
}

- (NSData*)rsaDecryptWithKey:(SecKeyRef)privateKey andPadding:(SecPadding)padding {

    NSUInteger dataSize = [self length];
    uint8_t* encryptedData = (uint8_t*)[self bytes];
    
    size_t plainDataSize = CIPHER_BUFFER_SIZE;
    uint8_t* plainData = (uint8_t *)calloc(plainDataSize, sizeof(uint8_t));
    
    OSStatus status = SecKeyDecrypt(privateKey, padding, &encryptedData[0], dataSize, &plainData[0], &plainDataSize);
    if (status == noErr)
    {
        size_t finalSize = plainDataSize;
        NSData* finalData = [NSData dataWithBytes:plainData length:finalSize];
        free(plainData);
        return finalData;
    }
    
    free(plainData);
    return nil;
}

+ (void)testAsymmetricEncryptionAndDecryption {
    
    NSString* testString = @"This is a test demo for RSA Implementation";
    NSData* testData = [NSData dataWithBytes:[testString UTF8String] length:testString.length];
    
    KeyPair keyPair = [self generateKeyPair:512];
    SecPadding padding = kSecPaddingPKCS1;
    NSData* encryptedData = [testData rsaEncryptWithKey:keyPair.publicKey andPadding:padding];
    NSData* decryptedData = [encryptedData rsaDecryptWithKey:keyPair.privateKey andPadding:padding];
    
    NSString* decryptedString = [NSString stringWithUTF8String:[decryptedData bytes]];
    NSLog(@"decrypted data: %@", decryptedString);
    
    NSAssert([testString isEqualToString:decryptedString], @"rsa encryption failed");
}

+ (void)testPublicKeyAsData {
    
    uint8_t data[] = "salt+password";
    NSData* testData = [NSData dataWithBytes:&data length:13];
    
    uint8_t publicKey[] = "inputHere";
    NSData* publicKeyData = [NSData dataWithBytes:&publicKey length:9];
    SecKeyRef publicKeyRef = [publicKeyData publicKey];
    
    SecPadding padding = kSecPaddingPKCS1;
    NSData* encryptedData = [testData rsaEncryptWithKey:publicKeyRef andPadding:padding];
    NSData* expectedData = nil;
    
    NSAssert([encryptedData isEqualToData:expectedData], @"rsa encryption failed");
}

//Untested
- (SecKeyRef)publicKey {
    SecCertificateRef cert = SecCertificateCreateWithData (kCFAllocatorDefault, (__bridge CFDataRef)(self));
    CFArrayRef certs = CFArrayCreate(kCFAllocatorDefault, (const void **) &cert, 1, NULL);
    
    SecTrustRef trust;
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustCreateWithCertificates(certs, policy, &trust);
    SecTrustResultType trustResult;
    SecTrustEvaluate(trust, &trustResult);
    SecKeyRef pub_key_leaf = SecTrustCopyPublicKey(trust);
    return pub_key_leaf;
}

//Untested; Taken From Apple Example
- (SecKeyRef)publicKeyAppleMethod {
    OSStatus errorCheck = noErr;
    SecKeyRef peerKeyRef = NULL;
    CFTypeRef persistPeer = NULL;
    
    NSMutableDictionary * peerPublicKeyAttr = [NSMutableDictionary new];
    
    [peerPublicKeyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [peerPublicKeyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [peerPublicKeyAttr setObject:self forKey:(__bridge id)kSecValueData];
    [peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
    
    errorCheck = SecItemAdd((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&persistPeer);
    
    [peerPublicKeyAttr removeObjectForKey:(__bridge id)kSecValueData];
    [peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    errorCheck = SecItemCopyMatching((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&peerKeyRef);
    
    return peerKeyRef;
}

- (SecKeyRef)privateKeyWithPassword:(NSString*)password {
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    [options setObject:password forKey:(__bridge id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    OSStatus securityError = SecPKCS12Import((__bridge CFDataRef) self, (__bridge CFDictionaryRef)options, &items);
    
    SecKeyRef privateKeyRef = NULL;
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp = (SecIdentityRef)CFDictionaryGetValue(identityDict, kSecImportItemIdentity);
        
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr)
            privateKeyRef = NULL;
    }
    
    CFRelease(items);
    return privateKeyRef;
}

+ (NSDictionary*)keyPairAttributes:(NSUInteger)keySize {
    NSMutableDictionary * privateKeyAttr = [NSMutableDictionary new];
    NSMutableDictionary * publicKeyAttr  = [NSMutableDictionary new];
    NSMutableDictionary * keyPairAttr    = [NSMutableDictionary new];
    
    // Set top level dictionary for the keypair.
    [keyPairAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [keyPairAttr setObject:[NSNumber numberWithUnsignedInteger:keySize] forKey:(__bridge id)kSecAttrKeySizeInBits];
    
    // Set attributes to top level dictionary.
    [keyPairAttr setObject:privateKeyAttr forKey:(__bridge id)kSecPrivateKeyAttrs];
    [keyPairAttr setObject:publicKeyAttr forKey:(__bridge id)kSecPublicKeyAttrs];
    return keyPairAttr;
}

+ (KeyPair)generateKeyPair:(NSUInteger)keySize {
    NSDictionary* keyPairAttr = [self keyPairAttributes:keySize];

    SecKeyRef publicKey = nil;
    SecKeyRef privateKey = nil;
    OSStatus errorCheck = SecKeyGeneratePair((__bridge CFDictionaryRef)keyPairAttr, &publicKey, &privateKey);

    KeyPair pair;
    if (errorCheck == noErr && publicKey != NULL && privateKey != NULL)
    {
        NSLog(@"Successful");
        pair.publicKey = publicKey;
        pair.privateKey = privateKey;
    }
    
    return pair;
}

@end
