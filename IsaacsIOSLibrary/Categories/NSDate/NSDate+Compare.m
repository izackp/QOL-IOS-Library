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

- (bool)isToday {
    NSDate* thisDate = [self dateYMD];
    NSDate* todaysDate = [[NSDate date] dateYMD];
    
    return [thisDate isEqualToDate:todaysDate];
}

- (bool)isYesterday {
    NSDate* thisDate = [self dateYMD];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* offsetComp = [[NSDateComponents alloc] init];
    offsetComp.day = -1;
    NSDate* yesterday = [cal dateByAddingComponents:offsetComp toDate:thisDate options:0];
    
    return [thisDate isEqualToDate:yesterday];
}

- (NSDate*)dateYMD {
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* ymdComps = [self componentsYMD];
    return [cal dateFromComponents:ymdComps];
}

- (NSDateComponents*)componentsYMD {
    NSCalendar* cal = [NSCalendar currentCalendar];
    return [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
}

- (NSDateComponents*)componentsOfTimeSinceDate:(NSDate*)date {
    NSCalendar* cal = [NSCalendar currentCalendar];
    return [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date toDate:self options:0];
}

@end
