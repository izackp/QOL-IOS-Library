//
//  NSData+Cryptography.h
//  IsaacsIOSLibrary
//
//  Created by Isaac on 8/18/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Cryptography)

- (NSString*)sha1;
- (NSData*)rsaEncryptWithKey:(SecKeyRef)publicKey andPadding:(SecPadding)padding;
- (NSData*)rsaDecryptWithKey:(SecKeyRef)privateKey andPadding:(SecPadding)padding;

/*! @attention will be moved into a seperate class*/
typedef struct {
    SecKeyRef publicKey;
    SecKeyRef privateKey;
} KeyPair;

+ (KeyPair)generateKeyPair:(NSUInteger)keySize;
- (SecKeyRef)publicKey;
- (SecKeyRef)publicKeyAppleMethod;
+ (void)testAsymmetricEncryptionAndDecryption;

@end
