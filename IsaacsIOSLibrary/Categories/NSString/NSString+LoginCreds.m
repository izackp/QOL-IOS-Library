//
//  NSString+MD5.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "NSString+LoginCreds.h"

@implementation NSString(LoginCreds)

- (BOOL)isValidEmail  {
  
  NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; //lax
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
  
  return [emailTest evaluateWithObject:self];
}

- (BOOL)isAlphanumeric
{
    NSCharacterSet *unwantedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:unwantedCharacters].location == NSNotFound);
}

@end
