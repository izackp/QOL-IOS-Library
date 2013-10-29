//
//  NSDate+Compare.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "NSDate+Compare.h"

@implementation NSDate (Compare)

- (bool)isBeforeDate:(NSDate*)otherDate {
    if([self compare:otherDate] == NSOrderedAscending)
        return true;
    return false;
}

- (bool)isAfterDate:(NSDate*)otherDate {
    if([self compare:otherDate] == NSOrderedDescending)
        return true;
    return false;
}

@end
