//
//  NSDate+FuzzyTime.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "NSDate+FuzzyTime.h"

@implementation NSDate (FuzzyTime)

static const double SECOND  = 1;
static const double MINUTE  = 60 * SECOND;
static const double HOUR    = 60 * MINUTE;
static const double DAY     = 24 * HOUR;
static const double MONTH   = 30 * DAY;
static const double YEAR    = 12 * MONTH;

- (NSString*)fuzzyTime {

    NSString *time = nil;
    NSTimeInterval delta = [[NSDate date] timeIntervalSinceDate:self];
    
    if (delta < 0)
    {
        time = @"not yet";
    }
    else if (delta < 2 * SECOND)
    {
        time = @"one second ago";
    }
    else if (delta < MINUTE)
    {
            time = [NSString stringWithFormat:@"%1.0f seconds ago", delta];
    }
    else if (delta < 2 * MINUTE)
    {
        time = @"a minute ago";
    }
    else if (delta < HOUR)
    {
        time = [NSString stringWithFormat:@"%1.0f minutes ago", (delta/MINUTE)];
    }
    else if (delta < 2 * HOUR)
    {
        time = @"an hour ago";
    }
    else if (delta < DAY)
    {        
        time = [NSString stringWithFormat:@"%1.0f hours ago", (delta/HOUR)];
    }
    else if (delta < 2 * DAY)
    {
        time = @"yesterday";
    }
    else if (delta < MONTH)
    {
        time = [NSString stringWithFormat:@"%1.0f days ago", (delta/DAY)];
    }
    else if (delta < 2 * MONTH)
    {
        time = @"one month ago";
    }
    else if (delta < YEAR)
    {
        time = [NSString stringWithFormat:@"%1.0f months ago", delta/MONTH];
    }
    else if (delta < 2 * YEAR)
    {
        time = @"one year ago";
    }
    else
    {
        time = [NSString stringWithFormat:@"%1.0f years ago", delta/YEAR];
    }
    
    return time;
}

@end
