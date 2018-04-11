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
    
    func simpleCrop(_ crop:CGRect) -> UIImage {
        if (crop == CGRect.zero || crop == CGRect.zeroOne()) {
            return self
        }
        return self.simpleCrop(topLeft: crop.origin, bottomRight: CGPoint.init(x: crop.size.width, y: crop.size.height))
    }
    
    func simpleCrop(topLeft:CGPoint, bottomRight:CGPoint) -> UIImage {
        let x = topLeft.x * size.width
        let y = topLeft.y * size.height
        let width = bottomRight.x * size.width - x
        let height = bottomRight.y * size.height - y
        let rect = CGRect.init(x: x, y: y, width: width, height: height)
        
        let imageRef:CGImage = self.cgImage!.cropping(to: rect)!
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
