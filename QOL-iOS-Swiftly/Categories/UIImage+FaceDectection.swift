//
//  UIImage+FaceDectection.swift
//  PhotoDay
//
//  Created by Scott Ahten on 7/18/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

public enum FaceDetectionError: Error {
    case noFacesFound
    case unqualifiedFaces
    case recognitionFailed(reason: String)
    case spellNotKnownToWitch
}

public extension UIImage {

    //TODO: Should be cleaned up...
    func imageContainsUseableFace() -> Bool {
        
        guard let image = resizeAndFixOrientation(maxSize: size) else { return false }
        
        var cgImageOrientation = 0
        
        switch image.imageOrientation {
        case .up:
            cgImageOrientation = 1
            
        case .down:
            cgImageOrientation = 3
            
        case .left:
            cgImageOrientation = 8
            
        case .right:
            cgImageOrientation = 6
            
        default:
            cgImageOrientation = 0
        }
        
        var foundFace = false
        
        // Transform for face rectangles
        let height = image.size.height
        var transform = CGAffineTransform.init(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: (-1 * height))
        
        let margin = image.size.width / 13
        let fullRect = CGRect.init(origin: CGPoint.zero, size: image.size)
        let insetRect = fullRect.insetBy(dx: margin, dy: margin)
        
        let imageOptions =  NSDictionary(object: NSNumber(value: cgImageOrientation) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
        let personciImage = CIImage(cgImage: image.cgImage!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        if let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy) {
            
            let faces = faceDetector.features(in: personciImage, options: imageOptions as? [String : AnyObject])
            
            print("\(faces.count) found")
            
            for (_, feature) in faces.enumerated() {
                
                let face = feature as! CIFaceFeature
                
                let inBounds = insetRect.contains(face.bounds)
                let atSize = face.bounds.size.width > 150
                
//                // draw a text string
//                UIGraphicsBeginImageContext(image.size)
//                
//                image.draw(at: CGPoint.zero)
//                
//                UIColor.red.setStroke()
//                UIRectFrame(insetRect)
//                
//                UIColor.green.setStroke()
//                UIRectFrame(face.bounds.applying(transform))
//                
//                let newImage = UIGraphicsGetImageFromCurrentImageContext()
//                UIGraphicsEndImageContext()
                
                let validFace = inBounds && atSize
                
                if (validFace) {
                    
                    foundFace = true
                    break
                }
                
            }
        }
        
        return foundFace
    }
}

public extension UIImage {
    
    func facesAsSquareWithDimention(dimention:CGFloat) -> [UIImage] {
        
        guard let image = resizeAndFixOrientation(maxSize: size) else { return [] }
        
        var cgImageOrientation = 0
        
        switch image.imageOrientation {
        case .up:
            cgImageOrientation = 1
            
        case .down:
            cgImageOrientation = 3
            
        case .left:
            cgImageOrientation = 8
            
        case .right:
            cgImageOrientation = 6
            
        default:
            cgImageOrientation = 0
        }
        
        // Transform for face rectangles
        let height = image.size.height
        var transform = CGAffineTransform.init(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 1, y: (-1 * height))
        
        let imageOptions =  NSDictionary(object: NSNumber(value: cgImageOrientation) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
        let personciImage = CIImage(cgImage: image.cgImage!)
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyLow]
        
        var faceImages = [UIImage]()
        
        if let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy) {
            
            let faces = faceDetector.features(in: personciImage, options: imageOptions as? [String : AnyObject])
            
            print("\(faces.count) found")
            
            for (_, feature) in faces.enumerated() {
                
                let face = feature as! CIFaceFeature
                
                let squaredSourceRect = face.bounds.getCenteredSquare().insetBy(dx: 10, dy: 10)
                
                let squareDestinationRect = CGRect(x:0, y:0, width:dimention, height: dimention)
                let squareDestinationSize = CGSize(width: dimention, height: dimention)
                
                UIGraphicsBeginImageContext(squareDestinationSize)
                
                let context = UIGraphicsGetCurrentContext()
                
                var ciContext:CIContext? = nil
                if #available(iOS 9.0, *) {
                    ciContext = CIContext(cgContext: context!, options: nil)
                } else {
                    ciContext = CIContext.init()//TODO: Probably doesnt work
                }
                context!.concatenate(transform);

                ciContext?.draw(personciImage, in: squareDestinationRect.applying(transform), from: squaredSourceRect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                faceImages.append(newImage!)
            }
        }
        
        return faceImages
    }
    
}

public extension CGRect {

    func getCenteredSquare() -> CGRect
    {
        let width = self.width;
        let height = self.height;
        let minX = self.minX;
        let minY = self.minY;
        var square :CGRect
        
        if (width > height) {
            
            square = CGRect(x: minX + (width - height) / 2.0, y: minY, width: height, height: height)
            
        } else {
            square = CGRect(x: minX, y: minY + (height - width) / 2.0, width: width, height: width)
        }
        
        return square;
    }
}



