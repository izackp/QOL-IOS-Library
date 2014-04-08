//
//  NSDate+Compare.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "NSDate+Compare.h"
#import "NSDate+Shortcuts.h"

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
    NSDate* thisDate = [self today];
    NSDate* todaysDate = [[NSDate date] today];
    
    return [thisDate isEqualToDate:todaysDate];
}

- (bool)isYesterday {
   NSDate* todaysDate = [[NSDate date] today];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* offsetComp = [[NSDateComponents alloc] init];
    offsetComp.day = -1;
    NSDate* yesterday = [cal dateByAddingComponents:offsetComp toDate:todaysDate options:0];
    
     NSDate* thisDate = [self today];
    return [thisDate isEqualToDate:yesterday];
}

- (NSInteger)daysSince:(NSDate*)other {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:other
                                                          toDate:self
                                                         options:0];
    return [components day];
}

- (NSInteger)yearsSince:(NSDate*)other {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSYearCalendarUnit
                                                        fromDate:other
                                                          toDate:self
                                                         options:0];
    return [components year];
}

@end
