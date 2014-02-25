//
//  UIDevice+SystemVersion.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 2/25/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (SystemVersion)

- (bool)isIOS6OrLower;
- (bool)isSystemVersionLessThan:(NSString*)version;
- (bool)isSystemVersionEqualOrGreaterThan:(NSString*)version;

@end
