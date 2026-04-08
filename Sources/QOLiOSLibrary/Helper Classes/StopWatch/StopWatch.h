//
//  StopWatch.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 2/24/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! Used to keep track of time elapsed in milliseconds @todo untested */
@interface StopWatch : NSObject

- (void)start;
- (void)stop;
- (int)elapsedMilliseconds;
- (void)restart;
- (void)pause;
- (void)unpause;

@end
