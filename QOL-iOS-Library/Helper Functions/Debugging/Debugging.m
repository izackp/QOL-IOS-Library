//
//  Debugging.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 8/12/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "Debugging.h"

void breakpoint(BOOL condition)
{
    breakpointComment(condition, @"");
}

void breakpointComment(BOOL condition, NSString *comment)
{
    if (!condition)
        return;

    NSLog(@"BreakPoint: %@", comment); // SET BREAKPOINT ON THIS LINE
}