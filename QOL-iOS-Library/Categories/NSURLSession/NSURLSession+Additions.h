//
//  NSURLSession+Additions.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/22/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSession (Additions)

+ (void)startWithRequest:(NSString*)url headers:(NSDictionary*)headers success:(void (^)(NSData *data, NSHTTPURLResponse *response))success failure:(void (^)(NSError* error))failure;

+ (void)startWithJSONRequest:(NSString*)url headers:(NSDictionary*)headers success:(void (^)(NSHTTPURLResponse *response, NSDictionary* jsonData))success failure:(void (^)(NSError* error))failure;

@end
