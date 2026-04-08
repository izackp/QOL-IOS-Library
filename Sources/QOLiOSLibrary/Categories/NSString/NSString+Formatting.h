//
//  NSString+Formatting.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface NSString (Formatting)

- (NSString*)urlEncodedAllCharacters;
- (NSString*)urlEncoded;
- (NSString*)urlDecode;
- (NSDictionary*)decodeUrlParameters;
- (NSString*)trimWhiteSpace;
- (NSString*)stringWithOnlyLetters;
- (NSString*)stringWithOnlyNumbers;
- (NSString*)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString*)stringByCapitalizingFirstCharacter;
- (NSString*)stringByInserting:(NSString*)insert inbetweenNumberOfCharacters:(int)numChars;
- (NSArray*)componentsSeparatedByNumberOfCharacters:(int)numChars;

- (NSString*)stringByAppendingWeakString:(NSString*)strToAppend;

/*! returns the string in http address format: http://string/ . Supports strings that already include the 'http://' and '/'. This method will truncate anything after the final '/'*/
- (NSString*)httpAddress;

/*! returns the port. Defaults to 80 if none found*/
- (NSInteger)port;

/*! This method will retain the subpath */
- (NSString*)httpAddressWithSubpath;

/*! returns the string in http address format with basic auth creds embeded: http://username:password@string/ */
- (NSString*)httpAddressUsingBasicAuthUsername:(NSString*)username password:(NSString*)password;

/*! This method will retain the subpath */
- (NSString*)httpAddressWithSubpathUsingBasicAuthUsername:(NSString*)username password:(NSString*)password;

@end
