//
//  UIDevice+SystemVersion.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 2/25/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIDevice+SystemVersion.h"

@implementation UIDevice (SystemVersion)

- (bool)isIOS6OrLower {
    return [self isSystemVersionLessThan:@"7.0"];
}

- (bool)isSystemVersionLessThan:(NSString*)version {
    NSString *currSysVer = [self systemVersion];
    return ([currSysVer compare:version options:NSNumericSearch] == NSOrderedAscending);
}

- (bool)isSystemVersionEqualOrGreaterThan:(NSString*)version {
    NSString *currSysVer = [self systemVersion];
    return ([currSysVer compare:version options:NSNumericSearch] != NSOrderedAscending);
}

@end
