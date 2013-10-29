//
//  UIImage+Echo.m
//  IsaacsIOSLibrary
//
//  Created by IsaacPaul on 4/24/12.
//  Copyright (c) 2013 Isaac Paul. All rights reserved.
//

#import "UIImage+Echo.h"
#import "UIImage+Resize.h"

#define radians(degrees) (degrees * M_PI/180)

static bool isRetina = false;
static bool isSetup = false;

static inline CGSize swapWidthAndHeight(CGSize size)
{
    CGFloat swap = size.width;
    
    size.width  = size.height;
    size.height = swap;
    
    return size;
}

@implementation UIImage (Echo)

+ (void)setUpIfNeeded {
    if (isSetup == false)
    {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) {
            isRetina = true;
        } else {
            isRetina = false;
        }
        isSetup = true;
    }
}

- (UIImage *)cropAndFitInto:(CGRect)cropRect resizeForRetina:(bool)shouldResize {
    return [self cropAndFitIntoSize:cropRect.size resizeForRetina:shouldResize];
}

- (UIImage *)cropAndFitIntoSize:(CGSize)cropSize resizeForRetina:(bool)shouldResize {
    [UIImage setUpIfNeeded];
    
    if (isRetina && shouldResize)
    {
        cropSize.width *= 2;
        cropSize.height *= 2;
    }
    UIImage* newImage = nil;
    @autoreleasepool {
        //resize/crop
        newImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:cropSize interpolationQuality:kCGInterpolationHigh];
        newImage = [newImage imageAtRect:CGRectMake((newImage.size.width - cropSize.width) * 0.5f, (newImage.size.height - cropSize.height) * 0.5f, cropSize.width, cropSize.height)];
    }
    return newImage;
}


- (UIImage *)imageAtRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
