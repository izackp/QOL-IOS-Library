//
//  StopWatch.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 2/24/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "StopWatch.h"
#include <mach/mach.h>
#include <mach/mach_time.h>

@interface StopWatch ()

@property (assign, nonatomic) int startTime;
@property (assign, nonatomic) int timeElapsed;
@property (assign, nonatomic) bool isRunning;
@property (assign, nonatomic) bool isPaused;

@end

@implementation StopWatch

- (void)start {
    if (self.isRunning)
        return;
    
    self.timeElapsed = 0;
    self.startTime = getUptimeInMilliseconds();
    self.isRunning = true;
}

- (void)stop {
    [self updateTimeElapsedIfRunning];
    
    self.startTime = 0;
    self.isRunning = false;
}

- (int)elapsedMilliseconds {
    [self updateTimeElapsedIfRunning];
    return self.timeElapsed;
}

- (void)restart {
    [self stop];
    [self start];
}

- (void)pause {
    if (!self.isRunning)
        return;
    
    self.isPaused = true;
    [self updateTimeElapsed];
}
- (void)unpause {
    if (!self.isPaused)
        return;
    
    self.isPaused = false;
    self.startTime = getUptimeInMilliseconds();
}

- (void)updateTimeElapsedIfRunning {
    if (!self.isRunning)
        return;
    [self updateTimeElapsed];
}

- (void)updateTimeElapsed {
    int currentTime = getUptimeInMilliseconds();
    self.timeElapsed = currentTime - self.startTime;
    self.startTime = currentTime;
}

static int getUptimeInMilliseconds()
{
    const int64_t kOneMillion = 1000 * 1000;
    static mach_timebase_info_data_t s_timebase_info;
    
    if (s_timebase_info.denom == 0) {
        (void) mach_timebase_info(&s_timebase_info);
    }
    
    // mach_absolute_time() returns billionth of seconds,
    // so divide by one million to get milliseconds
    return (int)((mach_absolute_time() * s_timebase_info.numer) / (kOneMillion * s_timebase_info.denom));
}


@end
