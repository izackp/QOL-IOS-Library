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
