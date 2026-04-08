//
//  UIViewController+Shortcuts.h
//  IsaacsIOSLibrary
//
//  Created by Isaac on 9/26/14.
//  Copyright (c) 2014 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Shortcuts)

/*! @return true if the viewcontroller is on screen */
- (BOOL)isVisible;

/*! searches up the heirachy for a viewcontroller with the specified class */
- (UIViewController*)findVCInHeirachyWithClass:(Class)vcClass;

@end
