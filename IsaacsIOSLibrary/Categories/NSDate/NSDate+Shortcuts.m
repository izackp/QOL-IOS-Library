//
//  NSDate+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 2/12/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "NSDate+Shortcuts.h"

@implementation NSDate (Shortcuts)

- (NSDate*)tomorrow {
    NSDate* today = [self today];
    return [today dateOffsettedByDays:1];
}

- (NSDate*)yesterday {
    NSDate* today = [self today];
    return [today dateOffsettedByDays:-1];
}

- (NSDate*)dateOffsettedByDays:(int)days {
    NSDate* today = [self today];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* offsetComp = [[NSDateComponents alloc] init];
    offsetComp.day = days;
    NSDate* result = [cal dateByAddingComponents:offsetComp toDate:today options:0];
    return result;
}

- (NSDate*)today {
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
