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
        let newCrop = size.aspectCrop(ratio, allowBestMatch: allowBestMatch)
        return simpleCrop(newCrop, rotation:0)
    }
    
    func simpleCrop(_ crop:CGRect, rotation:Int) -> UIImage {
        if (crop == CGRect.zero || crop == CGRect.zeroOne()) {
            return self
        }
        return self.simpleCrop(topLeft: crop.origin, bottomRight: CGPoint.init(x: crop.size.width, y: crop.size.height), rotation:rotation)
    }

    func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {

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
        var rect = CGRect.init(x: round(x), y: round(y), width: round(width), height: round(height))
        rect = rect.capValueAtBounds(bounds: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let rotatedImage = imageRotatedByDegrees(CGFloat(rotation), flip:false)
        
        //NOTE: When width is not a whole number then the crop gets rounded up 1 pixel
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
    
    func sizeInDp() -> CGSize {
        let screenScale = UIScreen.main.scale
        if (scale == screenScale) {
            return size
        }
        let mul = screenScale / scale
        return CGSize.init(width: size.width * mul, height: size.height * mul)
    }
    
    func compositeBackground(_ imgBg:UIImage?) -> UIImage {
        guard let background = imgBg else { return self }
        let size = self.sizeInDp()
        let bgSize = background.sizeInDp()
        var scaledImageRect = CGRect.zero
          
        let aspectWidth = size.width / bgSize.width
        let aspectHeight = size.height / bgSize.height
        let aspectRatio = aspectHeight > aspectWidth ? aspectHeight : aspectWidth
          
        scaledImageRect.size.width = bgSize.width * aspectRatio
        scaledImageRect.size.height = bgSize.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        background.draw(in: scaledImageRect)
        self.draw(in: areaSize, blendMode: .normal, alpha: 1)

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }

    func compositeBackgroundDashboard(_ imgBg:UIImage?) -> UIImage {
        guard let background = imgBg else { return self }
        let size = self.size
        var scaledImageRect = CGRect.zero
          
        let aspectWidth = size.width / background.size.width
        let aspectHeight = size.height / background.size.height
        let aspectRatio = aspectHeight > aspectWidth ? aspectHeight : aspectWidth
          
        scaledImageRect.size.width = background.size.width * aspectRatio
        scaledImageRect.size.height = background.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0;
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0;
        
        UIGraphicsBeginImageContext(size)
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        background.draw(in: scaledImageRect)
        self.draw(in: areaSize, blendMode: .normal, alpha: 1)

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }
}
