//
//  NSException+CallStackInfo.h
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 6/18/20.
//  Copyright © 2020 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSException (CallStackInfo)

- (NSException*)fillCallStack;

@end

NS_ASSUME_NONNULL_END
