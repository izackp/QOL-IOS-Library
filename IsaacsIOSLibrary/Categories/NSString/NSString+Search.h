//
//  NSString+Search.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 3/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Search)

- (bool)containsText:(NSString*)text;
- (bool)containsTextIgnoreCase:(NSString*)text;

- (NSString*)getFirstStringInbetweenPrefix:(NSString*)prefix suffix:(NSString*)suffix;
- (NSString*)getFirstStringAfter:(NSString*)prefix;
- (NSString*)getFirstStringBefore:(NSString*)suffix;

- (NSString*)getFirstStringStrictInbetweenPrefix:(NSString*)prefix suffix:(NSString*)suffix;
- (NSString*)getFirstStringStrictAfter:(NSString*)prefix;
- (NSString*)getFirstStringStrictBefore:(NSString*)suffix;

@end
