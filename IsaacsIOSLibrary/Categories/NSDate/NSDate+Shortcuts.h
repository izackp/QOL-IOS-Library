//
//  NSDate+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 2/12/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Shortcuts)

- (NSDate*)tomorrow;
- (NSDate*)yesterday;
- (NSDate*)today;

/*! Truncates minutes, hours, seconds, ects before offsetting the date*/
- (NSDate*)dateOffsettedByDays:(int)days;

/*! Does not truncate the date */
- (NSDate*)dateOffsettedBySeconds:(NSTimeInterval)seconds;


- (NSDateComponents*)componentsYMDHMS;
- (NSDateComponents*)componentsOfTimeSinceDate:(NSDate*)date;

@end
