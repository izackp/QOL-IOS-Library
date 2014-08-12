//
//  DispatchHelper.m
//  IsaacsIOSLibrary
//
//  Created by Isaac on 8/11/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "DispatchHelper.h"

void dispatch_safe_main_sync(dispatch_block_t block) {
    if ([NSThread currentThread] == [NSThread mainThread])
    {
        block();
        return;
    }
    dispatch_sync(dispatch_get_main_queue(), block);
}

bool dispatch_queue_is_empty(dispatch_queue_t queue)
{
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        dispatch_group_leave(group);
    });
    
    int64_t maxWaitTime = 0.00000005 * NSEC_PER_SEC;
    bool isReady = dispatch_group_wait(group, maxWaitTime) == 0;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_release(group);
    });
    
    return isReady;
}
