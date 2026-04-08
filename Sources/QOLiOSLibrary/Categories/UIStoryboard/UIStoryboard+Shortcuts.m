//
//  UIStoryboard+Shortcuts.m
//  IsaacsIOSLibrary
//
//  Created by Isaac Paul on 4/3/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import "UIStoryboard+Shortcuts.h"
#import "NSObject+Shortcuts.h"

@implementation UIStoryboard (Shortcuts)

- (id)instantiateViewControllerWithClass:(Class)theClass {
    return [self instantiateViewControllerWithIdentifier:[theClass classNameWithoutModule]];//TODO: Not sure if this will give use the right name.. Class vs DesiredType
}

@end
