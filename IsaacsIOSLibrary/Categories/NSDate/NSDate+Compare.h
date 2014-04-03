//
//  NSDate+Compare.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 10/29/13.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Compare)

- (bool)isBeforeDate:(NSDate*)otherDate;
- (bool)isAfterDate:(NSDate*)otherDate;
- (bool)isToday;
- (bool)isYesterday;
- (NSInteger)daysSince:(NSDate*)other;

@end
