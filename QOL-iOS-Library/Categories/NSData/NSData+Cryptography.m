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
#import "NSString+Formatting.h"


@implementation NSData (Cryptography)

- (NSData*)sha1 {
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    bool successful = CC_SHA1([self bytes], (CC_LONG)[self length], digest);
    if (!successful)
        return nil;
    
    return [NSData dataWithBytes:&digest length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString*)hexString {
    NSUInteger numBytes = [self length];
    NSMutableString *hexDigest = [[NSMutableString alloc] initWithCapacity:numBytes];
    uint8_t* bytes = (uint8_t*)[self bytes];
    
    for (NSUInteger i = 0; i < numBytes; i++)
        [hexDigest appendFormat:@"%02x", bytes[i]];
    
    return hexDigest;
}

+ (NSData*)dataWithHexString:(NSString*)hexString {
    hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
    bool strIsOdd = (hexString.length % 2);
    NSAssert(!strIsOdd, @"Hex string is odd!");
    NSMutableData *bytes = [[NSMutableData alloc] init];
    
    for (int i = 0; i < [hexString length] * 0.5f; i++) {
        char byte_chars[3] = {'\0','\0','\0'};
        byte_chars[0] = [hexString characterAtIndex:i*2];
        byte_chars[1] = [hexString characterAtIndex:i*2+1];
        unsigned char whole_byte = strtol(byte_chars, NULL, 16);
        [bytes appendBytes:&whole_byte length:1];
    }
    return bytes;
}

//#warning Buffer Size is Arbitrary
const static size_t CIPHER_BUFFER_SIZE = 1024;
- (NSData*)rsaEncryptWithKey:(SecKeyRef)publicKey andPadding:(SecPadding)padding {
    
    NSUInteger dataSize = [self length];
    uint8_t* data = (uint8_t*)[self bytes];
    
    size_t maxDataSize = SecKeyGetBlockSize(publicKey);
    if (padding == kSecPaddingPKCS1)
        maxDataSize -= 11;
    
    if (dataSize > maxDataSize)
    {
        NSLog(@"rsaEncryptWithKey: Data to encrypt is too big");
        return nil;
    }
    
    size_t cipherDataSize = CIPHER_BUFFER_SIZE;
    uint8_t* cipherBuffer = (uint8_t *)calloc(CIPHER_BUFFER_SIZE, sizeof(uint8_t));
    OSStatus status = SecKeyEncrypt(publicKey, padding, data, dataSize, &cipherBuffer[0], &cipherDataSize);
    
    if (status == noErr)
    {
        NSData* data = [NSData dataWithBytes:cipherBuffer length:cipherDataSize];
        free(cipherBuffer);
        return data;
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

//Example type is: PUBLIC KEY
- (NSData*)generatePEMWithType:(NSString*)type {
    NSString* base64Data = [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength | NSDataBase64EncodingEndLineWithLineFeed];
    NSString* beginHeader = [NSString stringWithFormat:@"-----BEGIN %@-----\n", type];
    NSString* endHeader = [NSString stringWithFormat:@"\n-----END %@-----", type];
    NSString* pem = [NSString stringWithFormat:@"%@%@%@", beginHeader, base64Data, endHeader];
    return [pem dataUsingEncoding:NSUTF8StringEncoding];
}

//Untested
- (SecKeyRef)publicKeyViaCertData {
    NSData* publicKey = self;
    SecCertificateRef cert = SecCertificateCreateWithData (kCFAllocatorDefault, (__bridge CFDataRef)(publicKey));
    CFArrayRef certs = CFArrayCreate(kCFAllocatorDefault, (const void **) &cert, 1, NULL);
    
    SecTrustRef trust;
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustCreateWithCertificates(certs, policy, &trust);
    SecTrustResultType trustResult;
    SecTrustEvaluate(trust, &trustResult);
    SecKeyRef pub_key_leaf = SecTrustCopyPublicKey(trust);
    return pub_key_leaf;
}

- (SecKeyRef)publicKeyFromDerData
{
    NSString* tag = @"dummy";
    NSData* d_key = [self stripPublicKeyHeader];
    if (d_key == nil)
        return NULL;
    
    NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
    
    // Delete any old lingering key with the same tag
    NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
    [publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
    [publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
    SecItemDelete((__bridge CFDictionaryRef)publicKey);
    
    CFTypeRef persistKey = nil;
    
    // Add persistent version of the key to system keychain
    [publicKey setObject:d_key forKey:(__bridge id)kSecValueData];
    [publicKey setObject:(__bridge id)kSecAttrKeyClassPublic forKey:(__bridge id)kSecAttrKeyClass];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnPersistentRef];
    
    OSStatus secStatus = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
    if (persistKey != nil) CFRelease(persistKey);
    
    if ((secStatus != noErr) && (secStatus != errSecDuplicateItem))
        return NULL;
    
    // Now fetch the SecKeyRef version of the key
    SecKeyRef keyRef = nil;
    
    [publicKey removeObjectForKey:(__bridge id)kSecValueData];
    [publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
    [publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef
     ];
    [publicKey setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    secStatus = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *) &keyRef);
    
    if (keyRef == nil)
        return NULL;
    
    return keyRef;
}

- (NSData *)stripPublicKeyHeader
{
    // Skip ASN.1 public key header
    NSUInteger len = [self length];
    if (!len)
        return nil;
    
    unsigned char *c_key = (unsigned char *)[self bytes];
    unsigned int  idx    = 0;
    
    if (c_key[idx++] != 0x30)
        return nil;
    
    if (c_key[idx] > 0x80)
        idx += c_key[idx] - 0x80 + 1;
    else
        idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] = {0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00};
    if (memcmp(&c_key[idx], seqiod, 15))
        return nil;
    
    idx += 15;
    
    if (c_key[idx++] != 0x03)
        return nil;
    
    if (c_key[idx] > 0x80)
        idx += c_key[idx] - 0x80 + 1;
    else
        idx++;
    
    if (c_key[idx++] != '\0')
        return nil;
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
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
    pair.publicKey = publicKey;
    pair.privateKey = privateKey;
    
    if (errorCheck == noErr && publicKey != NULL && privateKey != NULL)
    {
        NSLog(@"Successful Generating KeyPair");
    }
    
    return pair;
}

@end
