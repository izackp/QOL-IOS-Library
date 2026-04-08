//
//  UIImage+Echo.h
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 4/24/12.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Echo)

- (UIImage *)cropAndFitInto:(CGRect)cropRect resizeForRetina:(bool)shouldResize;
- (UIImage *)cropAndFitIntoSize:(CGSize)cropSize resizeForRetina:(bool)shouldResize;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)fixOrientation;

@end
