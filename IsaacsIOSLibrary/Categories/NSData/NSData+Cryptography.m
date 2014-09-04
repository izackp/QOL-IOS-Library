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
    bool strIsOdd = (hexString.length % 2);
    NSAssert(!strIsOdd, @"Hex string is odd!");
    hexString = [hexString stringByReplacingOccurrencesOfString:@" " withString:@""];
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

static NSString* const cPem = @"MIIBUzANBgkqhkiG9w0BAQEFAAOCAUAAMIIBOwKCATIAqpzRrvO3We7EMi9cWYqdfb3rbdinTay+hxQ6t3dOiJLY4NITxyeIuy97yZYOojOlXS2SuJ4cCHjCeLCQO1FwOz+nynQWcBWecz2QdbHD2Kz7mNLd2qtZyEDO76rd7LaDOxRvgs9DsH9sfnCuKLKbd725xTLc7wRfJzOH9v9rTTYVXssXe7JUpTx8nV8yKnTiq3WpzBeZT4C3ZCR18GBBCh3NmSTbze9i2KipgZnOwBvhskVlweuqZ1KNIKsQgipBFuyww68RGNYaAKofMVVio4amrGpCT5MM852jpHsgJJfOUHu6md1CnvdwDPbo/PKQUI0RLb0ezE5gsPmas39QBw+DiaibUkk1aCkBxTOFqpIbjfLM2/4qA6GPcWUJxP3vmGoeCTMBLNEiPfLqVm86QzUCAwEAAQ==";

static NSString* const testKey = @"0E B1 BB 07 D9 0D 86 5E 22 6C 68 58 F8 0B 68 03 D8 6C B7 23 54 6E 0E FD 8D D1 F1 AE 68 1B 86 98 80 36 55 36 48 E8 8B 80 C6 D2 12 A4 D0 75 75 82 09 57 3D C9 D1 D4 C5 1E 54 C6 2E E5 54 88 C4 F1 00 49 DA F4 67 AC 65 96 42 61 A1 A7 D9 08 AA DD CD 28 1F 78 6E F5 DE 39 E6 E6 F9 63 68 67 61 E4 DC DC BF F0 07 49 CC CD 56 0D 11 EC 31 51 FB 6B E9 11 FB 74 A2 A5 9E A5 AB E7 18 AD 23 7B F6 B1 77 E5 9E C3 AB 8C 70 D2 AA F9 81 01 ED 8A 49 7E 92 3B E7 5C 50 8A 3A 46 84 88 F1 D0 01 7D 8D 62 B5 B7 41 35 F4 72 9B 83 2C 72 10 F0 31 AA EA CA 7B F4 B0 1D AA E7 A9 7B 7E 3F C4 45 5D 09 6E 82 E8 60 CE 8A E0 50 FF BE F2 95 79 1F F6 23 FA A8 1D D4 46 0D 22 AC 8B BD E6 B5 D4 19 3D 26 A6 43 3C B8 22 6E 75 4A 1B C4 90 18 88 C7 42 8E A9 C8 25 4E 71 D4 58 67 4C 1B 25 84 92 97 3B C9 72 F8 43 9D DE 9B 42 D1 4F 57 89 17 8A 7F 94 A4 8E E1 0E 25 FE F9 58 E1 D9 07 22 11 CB 07 E6 2E F8 9D 30 9D EA 91 9A 20 9B B8 3E 6F 9D 98 BB 9D 80 CD B5";

static NSString* const resultData = @"76 D4 5A 71 76 13 5B BE 5D 65 26 4F 68 D2 34 E4 EC C8 18 DF 83 EB 64 52 CD F3 2B 3A B9 3D F7 9B F3 15 5E 41 3C 13 C4 90 45 76 BF 08 C0 0E 5A 2F 7C 6E 6E 15 A4 0F 75 CE 16 19 A8 AF BD 3A 87 6C 3A E5 1D E1 81 C8 99 9E 60 F4 ED 72 89 2E 43 B4 FC 8A B9 02 7C 59 8D E8 8C 17 7D 47 A1 68 E0 0B 85 98 77 F7 34 D6 3D 13 A5 67 A0 13 47 60 21 A7 3F 63 12 47 AE 24 CA 08 ED 0D 45 9E FF 50 6F 38 72 C1 FB CD E6 8C 07 D3 81 A8 4C 61 B4 B1 38 17 CF B2 81 AE AE 3D C6 F8 E2 FF 1A 8F 87 37 C6 3F 7D 8B 7E CA 17 48 15 E6 87 0A AF D5 AB 32 EF 56 E4 DC 55 90 2A 8C 63 E1 9F A4 4B 78 CC F1 F4 D7 63 F3 08 E5 AA 4F 9F 4B 1E 27 B2 52 76 41 39 AE BA 25 E0 22 F5 83 73 D4 02 7D A5 C2 00 6C 3D 34 90 08 4D F8 D7 60 5C E2 31 36 E7 25 DF 21 5D 16 11 21 A0 84 AB 30 9D DA 31 27 C8 49 D8 C3 11 3C";

+ (void)testPublicKeyAsData {
    
    uint8_t data[] = "hziwh44vw:CozB[5=Y}fy#&-TSqtWLoPs";
    NSData* testData = [NSData dataWithBytes:&data length:sizeof(data)];
    NSData* testKeyData = [testKey dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSString* pem = [self addLineBreaksToPEMData:cPem];
    //pem = [NSString stringWithFormat:@"%@%@%@", @"-----BEGIN PUBLIC KEY-----\n", pem, @"\n-----END PUBLIC KEY-----"];
    NSData* publicKey = [[NSData alloc] initWithBase64EncodedString:cPem options:0];
    //publicKey = [publicKey stripPublicKeyHeader];
    
    //NSData* publicKeyData = [[NSData dataWithHexString:testKey] generatePEM];
    //SecKeyRef publicKeyApple = [publicKey publicKeyAppleMethod];
    SecKeyRef publicKeyRef = [publicKey publicKeyMethod2];
    
    SecPadding padding = kSecPaddingPKCS1;
    NSData* encryptedData = [testKeyData rsaDecryptWithKey:publicKeyRef andPadding:padding];
    NSString* result = [NSString stringWithUTF8String:[encryptedData bytes]];
    NSData* expectedData = [NSData dataWithHexString:resultData];;
    
    NSAssert([encryptedData isEqualToData:expectedData], @"rsa encryption failed");
}

- (NSData*)generatePEM {
    NSString* base64Data = [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength | NSDataBase64EncodingEndLineWithLineFeed];
    //NSString* content = [NSData addLineBreaksToPEMData:base64Data];//you suppose
    NSString* pem = [NSString stringWithFormat:@"%@%@%@", @"-----BEGIN PUBLIC KEY-----\n", base64Data, @"\n-----END PUBLIC KEY-----"];
    return [pem dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString*)addLineBreaksToPEMData:(NSString*)pemData {
    NSString* lineBroke = [pemData stringByInserting:@"\n" inbetweenNumberOfCharacters:64];
    return lineBroke;
}

//Untested
- (SecKeyRef)publicKey {
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

//Untested; Taken From Apple Example
- (SecKeyRef)publicKeyAppleMethod {
    OSStatus errorCheck = noErr;
    SecKeyRef peerKeyRef = NULL;
    CFTypeRef persistPeer = NULL;
    NSData* publicKey = self;//[self stripPublicKeyHeader];
    
    NSMutableDictionary * peerPublicKeyAttr = [NSMutableDictionary new];
    
    [peerPublicKeyAttr setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    [peerPublicKeyAttr setObject:(__bridge id)kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
    [peerPublicKeyAttr setObject:publicKey forKey:(__bridge id)kSecValueData];
    
    errorCheck = SecItemAdd((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&persistPeer);
    
    [peerPublicKeyAttr removeObjectForKey:(__bridge id)kSecValueData];
    [peerPublicKeyAttr setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
    errorCheck = SecItemCopyMatching((__bridge CFDictionaryRef) peerPublicKeyAttr, (CFTypeRef *)&peerKeyRef);
    
    return peerKeyRef;
}

- (SecKeyRef)publicKeyMethod2
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
    unsigned int len = [self length];
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
    if (errorCheck == noErr && publicKey != NULL && privateKey != NULL)
    {
        NSLog(@"Successful");
        pair.publicKey = publicKey;
        pair.privateKey = privateKey;
    }
    
    return pair;
}

@end
