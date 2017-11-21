//
//  WeakTimedSelector.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 5/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakTimedSelector : NSObject

- (id)initWithTarget:(id)target selector:(SEL)selector;

- (void)scheduleTimer:(NSTimeInterval)seconds;
- (void)invalidate;

@end
