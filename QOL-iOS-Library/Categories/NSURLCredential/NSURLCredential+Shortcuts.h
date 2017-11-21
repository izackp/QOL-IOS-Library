//
//  NSURLCredential+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by Isaac on 8/20/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLCredential (Shortcuts)

+ (NSURLCredential*)credentialForCertData:(NSData*)certData hostName:(NSString*)hostname;
+ (NSURLCredential*)credentialForTrustCustom:(SecTrustRef)trust;

@end
