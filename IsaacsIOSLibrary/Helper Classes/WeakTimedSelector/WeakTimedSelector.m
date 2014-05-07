//
//  WeakTimedSelector.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 5/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "WeakTimedSelector.h"
#import "NSDate+Shortcuts.h"

@interface WeakTimedSelector ()

@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL selector;
@property (strong, nonatomic) NSTimer* timer;

@end

@implementation WeakTimedSelector

+ (id)buildWithTarget:(id)target selector:(SEL)selector {
    
    return [[self alloc] initWithTarget:target selector:selector];
}

- (id)initWithTarget:(id)target selector:(SEL)selector{
    if (self = [super init])
    {
        _target = target;
        _selector = selector;
    }
    return self;
}

- (void)scheduleTimer:(NSTimeInterval)seconds {
    if (![self isRunning])
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(fire) userInfo:nil repeats:false];
        return;
    }
    
    NSDate* date = [NSDate date];
    NSDate* newFireDate = [date dateOffsettedBySeconds:seconds];
    [self.timer setFireDate:newFireDate];
}

- (void)fire {
    [self invalidate];
    id strongTarget = self.target;
    bool targetNotNil = (strongTarget != nil);
    bool targetRespondsToSelector = [strongTarget respondsToSelector:self.selector];
    if (targetNotNil && targetRespondsToSelector)
    {
        IMP imp = [strongTarget methodForSelector:self.selector];
        void (*func)(id, SEL) = (void *)imp;
        func(strongTarget, self.selector);
    }
}

- (bool)isRunning {
    return (self.timer != nil);
}

- (void)invalidate {
    [self.timer invalidate];
    self.timer = nil;
}

@end
