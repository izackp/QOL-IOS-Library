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
    
    func aspectCrop(_ ratio:CGFloat, allowBestMatch:Bool = false) -> UIImage {
        let isHorizontal = ratio > 1
        let imageIsHorizontal = size.width > size.height
        var ratioToUse = ratio
        if (allowBestMatch) {
            ratioToUse = imageIsHorizontal != isHorizontal ? (1.0 / ratio) : ratio
        }
        
        if (size.height * ratioToUse <= size.width) {
            let width = size.height * ratioToUse
            let offset = (size.width - width) * 0.5
            let newCrop = CGRect.init(x: offset/size.width, y: 0, width: (offset+width)/size.width, height: 1)
            return simpleCrop(newCrop, rotation:0)
        }
        
        let height = size.width * (1.0 / ratioToUse)
        let offset = (size.height - height) * 0.5
        let newCrop = CGRect.init(x: 0, y: offset/size.height, width: 1, height: (offset+height)/size.height)
        return simpleCrop(newCrop, rotation:0)
    }
    
    func simpleCrop(_ crop:CGRect, rotation:Int) -> UIImage {
        if (crop == CGRect.zero || crop == CGRect.zeroOne()) {
            return self
        }
        return self.simpleCrop(topLeft: crop.origin, bottomRight: CGPoint.init(x: crop.size.width, y: crop.size.height), rotation:rotation)
    }

    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {

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
        var width = bottomRight.x * imgWidth - x
        var height = bottomRight.y * imgHeight - y
        if (width < 1) {
            width = 1
        }
        if (height < 1) {
            height = 1
        }
        var rect = CGRect.init(x: x, y: y, width: width, height: height)
        rect = rect.capValueAtBounds(bounds: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
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
