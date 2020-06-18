//
//  NSException+CallStackInfo.m
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 6/18/20.
//  Copyright © 2020 Isaac Paul. All rights reserved.
//

#import "NSException+CallStackInfo.h"

@implementation NSException (CallStackInfo)

- (NSException*)fillCallStack {
    @try {
        [self raise];
    }
    @catch (NSException *exception) {
        return exception;
    }
    return self;
}

@end
