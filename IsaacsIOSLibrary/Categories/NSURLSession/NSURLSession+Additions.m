//
//  NSURLSession+Additions.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/22/15.
//  Copyright (c) 2015 Isaac Paul. All rights reserved.
//

#import "NSURLSession+Additions.h"
#import "NSObject+Shortcuts.h"

@implementation NSURLSession (Additions)

+ (void)startWithRequest:(NSString*)url headers:(NSDictionary*)headers success:(void (^)(NSData *data, NSHTTPURLResponse *response))success failure:(void (^)(NSError* error))failure {
    NSURLSession* session = [NSURLSession sharedSession];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    for (NSString* eachKey in [headers allKeys]) {
        [request setValue:headers[eachKey] forHTTPHeaderField:eachKey];
    }
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                    return;
                }
            }
            
            if ([response isKindOfClass:NSHTTPURLResponse.class] == false) {
                if (failure) {
                    failure([self errorWithCode:0 andLocalizedDescription:@"Non HTTP Response"]);
                }
                return;
            }
            
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if (success) {
                success(data, httpResponse);
            }
        });
    }];
    [dataTask resume];
}

+ (void)startWithJSONRequest:(NSString*)url headers:(NSDictionary*)headers success:(void (^)(NSHTTPURLResponse *response, NSDictionary* jsonData))success failure:(void (^)(NSError* error))failure {
    [self startWithRequest:url headers:headers success:^(NSData *data, NSHTTPURLResponse *response) {
        NSError* deserializeErr;
        NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&deserializeErr];
        if (success) {
            success(response, jsonData);
        }
    } failure:failure];
}
@end
