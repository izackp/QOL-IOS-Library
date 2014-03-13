//
//  NSString+Formatting.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

@interface NSString (Formatting)

- (NSString*)urlEncoded;
- (NSString*)trimWhiteSpace;
- (NSString*)httpAddress;
- (NSString*)httpAddressWithBasicAuthUsername:(NSString*)username password:(NSString*)password;

@end
