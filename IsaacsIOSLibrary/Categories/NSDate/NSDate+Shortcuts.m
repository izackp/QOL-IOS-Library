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

- (NSDate*)dateOffsettedBySeconds:(int)seconds {
    NSDate* dateYMDS = [self dateYMDS];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* offsetComp = [[NSDateComponents alloc] init];
    offsetComp.second = seconds;
    NSDate* result = [cal dateByAddingComponents:offsetComp toDate:dateYMDS options:0];
    return result;
}

- (NSDate*)today {
    return [self dateYMD];
}

- (NSDate*)dateYMD {
    NSDateComponents* ymdComps = [self componentsYMD];
    return [NSDate dateUsingComponents:ymdComps];
}

- (NSDate*)dateYMDS {
    NSDateComponents* ymdComps = [self componentsYMDS];
    return [NSDate dateUsingComponents:ymdComps];
}

+ (NSDate*)dateUsingComponents:(NSDateComponents*)components {
    NSCalendar* cal = [NSCalendar currentCalendar];
    return [cal dateFromComponents:components];
}

- (NSDateComponents*)componentsYMD {
    NSCalendar* cal = [NSCalendar currentCalendar];
    return [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
}

- (NSDateComponents*)componentsYMDS {
    NSCalendar* cal = [NSCalendar currentCalendar];
    return [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitSecond) fromDate:self];
}

- (NSDateComponents*)componentsOfTimeSinceDate:(NSDate*)date {
    NSCalendar* cal = [NSCalendar currentCalendar];
    return [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date toDate:self options:0];
}

@end
