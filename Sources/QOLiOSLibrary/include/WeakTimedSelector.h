//
//  WeakTimedSelector.h
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 5/7/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeakTimedSelector : NSObject

@property (weak, nonatomic) id target; //Should be private but no other way to init in swift

- (id)initWithTarget:(id)target selector:(SEL)selector;

- (void)scheduleTimer:(NSTimeInterval)seconds;
- (void)invalidate;

@end
