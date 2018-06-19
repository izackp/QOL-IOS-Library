//
//  UIImageFixedOrientationExtension.swift
//  PhotoDay
//
//  Created by Scott Ahten on 7/13/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    class func imageForName(imageName: String?) -> UIImage? {
        if (imageName == nil) {
            return nil
        }
        
        if (imageName == "") {
            return nil
        }
        
        return UIImage.init(named: imageName!)
    }
    
    func simpleCrop(_ crop:CGRect, rotation:Int) -> UIImage {
        if (crop == CGRect.zero || crop == CGRect.zeroOne()) {
            return self
        }
        return self.simpleCrop(topLeft: crop.origin, bottomRight: CGPoint.init(x: crop.size.width, y: crop.size.height), rotation:rotation)
    }
    /*
    func rotate(_ angle:Int) -> CGImage {
        let imgWidth = size.width
        let imgHeight = size.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        
        let targetWidth = imgWidth
        let targetHeight = imgHeight
        let bytesPerRow = bytesPerPixel * Int(targetWidth)
        let bitsPerComponent = 8
        
        let context = CGBitmap
        
        -(void) rotate90Degree:(CGImageRef) cgImageRef
        {
            int cgImageWidth = (int)CGImageGetWidth(cgImageRef);
            int cgImageHeight = (int)CGImageGetHeight(cgImageRef);
            
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            NSUInteger bytesPerPixel = 4;
            
            int targetWidth = cgImageHeight;
            int targetHeight = cgImageWidth;
            
            NSUInteger bytesPerRow = bytesPerPixel * targetWidth;
            NSUInteger bitsPerComponent = 8;
            
            CGContextRef context = CGBitmapContextCreate(nil, targetWidth, targetHeight,
                                                         bitsPerComponent, bytesPerRow, colorSpace,
                                                         kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
            
            CGContextRotateCTM (context, -M_PI_2);
            CGContextTranslateCTM(context, -(int)targetHeight, 0);
            
            CGContextDrawImage(context, CGRectMake(0, 0, cgImageWidth, cgImageHeight), cgImageRef);
        }
    }*/
    
    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        /*
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / .pi)
        }*/
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * .pi
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()!
        
        bitmap.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        bitmap.rotate(by: degreesToRadians(degrees))
        
        // Now, draw the rotated/scaled image into the context
        var yFlip = CGFloat(1.0)
        
        if (flip) {
            yFlip = CGFloat(-1.0)
        }
        
        bitmap.scaleBy(x: yFlip, y: -1.0)
        let image = self.cgImage!
        bitmap.draw(image, in: CGRect.init(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func simpleCrop(topLeft:CGPoint, bottomRight:CGPoint, rotation:Int) -> UIImage {
        var imgWidth = size.width
        var imgHeight = size.height
        if rotation == 90 || rotation == 270 {
            imgWidth = size.height
            imgHeight = size.width
        }
        let x = topLeft.x * imgWidth
        let y = topLeft.y * imgHeight
        let width = bottomRight.x * imgWidth - x
        let height = bottomRight.y * imgHeight - y
        let rect = CGRect.init(x: x, y: y, width: width, height: height)
        let rotatedImage = imageRotatedByDegrees(CGFloat(rotation), flip:false)
        
        let imageRef:CGImage = rotatedImage.cgImage!.cropping(to: rect)!
        let result:UIImage = UIImage.init(cgImage:imageRef, scale: self.scale, orientation: self.imageOrientation)
        return result
    }
    
    func fixedOrientation() -> UIImage {
        
        if imageOrientation == .up {
            return self
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case .up, .upMirrored:
            break
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        }
        
        let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0, space: (self.cgImage?.colorSpace)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            break
        default:
            ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            break
        }
        
        let cgImage: CGImage = ctx.makeImage()!
        
        return UIImage(cgImage: cgImage)
    }
}
