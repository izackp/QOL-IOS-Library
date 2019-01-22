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
        guard let imageName = imageName else { return nil }
        
        if (imageName == "") {
            return nil
        }
        
        return UIImage.init(named: imageName)
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
        let width = bottomRight.x * imgWidth - x
        let height = bottomRight.y * imgHeight - y
        let rect = CGRect.init(x: x, y: y, width: width, height: height)
        let rotatedImage = imageRotatedByDegrees(CGFloat(rotation), flip:false)
        
        let imageRef:CGImage = rotatedImage.cgImage!.cropping(to: rect)!
        let result:UIImage = UIImage.init(cgImage:imageRef, scale: self.scale, orientation: self.imageOrientation)
        return result
    }
    
    func resizeAndFixOrientation(maxSize: CGSize) -> UIImage? {
        let finalSize = size.aspectFitNoUpscale(maxSize) ?? size
        
        let newHeight = finalSize.height
        let newWidth = finalSize.width
        UIGraphicsBeginImageContextWithOptions(finalSize, false, self.scale)
        draw(in: CGRect.init(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
