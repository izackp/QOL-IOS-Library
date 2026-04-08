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
import Vision

public class FindFacesResult {
    public init(faces: [CIFeature], ciImage: CIImage, cgImage: CGImage) {
        self.faces = faces
        self.ciImage = ciImage
        self.cgImage = cgImage
        self.imageSize = cgImage.size()
    }
    
    public let faces:[CIFeature]
    public let ciImage:CIImage
    public let cgImage:CGImage
    public let imageSize:CGSize
}

public extension UIImage {
    
    func imageOrientationToCGIPO() -> CGImagePropertyOrientation {
        switch (self.imageOrientation) {
            case .up:
                return .up
            case .upMirrored:
                return .upMirrored
            case .down:
                return .down
            case .downMirrored:
                return .downMirrored
            case .leftMirrored:
                return .leftMirrored
            case .right:
                return .right
            case .rightMirrored:
                return .rightMirrored
            case .left:
                return .left
            default:
                return .up
        }
    }
    
    func imageOrientationToExif() -> Int {
        let value = self.imageOrientationToCGIPO()
        return Int(value.rawValue)
    }

    func imageContainsUseableFace() -> Bool {
        
        guard let result = findFaces() else { return false }
        let faces = result.faces
        let imageSize = result.imageSize
        
        let margin = imageSize.width / 13
        let fullRect = CGRect.init(origin: CGPoint.zero, size: imageSize)
        let insetRect = fullRect.insetBy(dx: margin, dy: margin)
        
        for eachFeature in faces {
            guard let face = eachFeature as? CIFaceFeature else { continue }
            
            let inBounds = insetRect.contains(face.bounds)
            let atSize = face.bounds.size.width > 150
            
            let validFace = inBounds && atSize
            if (validFace) {
                return true
            }
        }
        return false
    }
    
    func findFaces(accuracy:String = CIDetectorAccuracyLow) -> FindFacesResult? {
        if #available(iOS 11.0, *) {
            return nil//findFacesNew(accuracy: accuracy)
        } else {
            return findFaces2(accuracy: accuracy)
        }
    }
    
    //Note: low accuracy finds more faces..
    func findFaces2(accuracy:String = CIDetectorAccuracyLow) -> FindFacesResult? {
        
        guard let image = resizeAndFixOrientation(maxSize: size) else { return nil }
        
        let cgImageOrientation = image.imageOrientationToExif()
        let imageOptions =  NSDictionary(object: NSNumber(value: cgImageOrientation) as NSNumber, forKey: CIDetectorImageOrientation as NSString)
        let otherImage = image.cgImage!
        let ciImage = CIImage(cgImage: otherImage)
        if let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: accuracy, CIDetectorMinFeatureSize: 0.01]) {
            let faces = faceDetector.features(in: ciImage, options: imageOptions as? [String : AnyObject])
            print("\(faces.count) found")
            return FindFacesResult(faces: faces, ciImage: ciImage, cgImage: otherImage)
        }
        
        return nil
    }
    
    @available(iOS 11.0, *)
    func findFacesNew(accuracy:String = CIDetectorAccuracyLow) -> [CGRect] {
        guard let image = resizeAndFixOrientation(maxSize: size) else { return [] }
        let cgImageOrientation = image.imageOrientationToCGIPO()
        let otherImage = image.cgImage!
        //let ciImage = CIImage(cgImage: otherImage)
        let imageRequestHandler = VNImageRequestHandler(cgImage: otherImage,
                                                        orientation: cgImageOrientation,
                                                        options: [:])

        let rectDetectRequest = VNDetectFaceRectanglesRequest { (request:VNRequest, error:Error?) in
            if let error = error {
                print("Failed to detect rects: \(error.localizedDescription)")
                return
            }
        }
        
        #if targetEnvironment(simulator)
            rectDetectRequest.usesCPUOnly = true
        #endif
        
        do {
            try imageRequestHandler.perform([rectDetectRequest])
        } catch {
            print("Failed to detect rects: \(error.localizedDescription)")
        }
        let rectList = rectDetectRequest.results ?? []
        var boundBoxes:[CGRect] = []
        for face in rectList {
            var box = face.boundingBox
            let oldY = box.y
            box.y = 1 - (oldY + box.height)
            //box.height_ = (1 - oldY) - box.height
            boundBoxes.append(box)
        }
        return boundBoxes
    }
}

public extension UIImage {
    
    func facesAsSquareWithDimention(dimention:CGFloat, inset:CGFloat) -> [UIImage] {

        guard let result = findFaces() else { return [] }
        let faces = result.faces
        let imageSize = result.imageSize
        
        // Transform for face rectangles
        let height = imageSize.height
        var transform = CGAffineTransform.init(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 1, y: (-1 * height))
        
        var faceImages = [UIImage]()
        for eachFeature in faces {
            guard let face = eachFeature as? CIFaceFeature else { continue }
            
            let squaredSourceRect = face.bounds.getCenteredSquare().insetBy(dx: inset, dy: inset)
            
            let squareDestinationRect = CGRect(x:0, y:0, width:dimention, height: dimention)
            let squareDestinationSize = CGSize(width: dimention, height: dimention)
            
            UIGraphicsBeginImageContext(squareDestinationSize)
            defer {
                UIGraphicsEndImageContext()
            }
            
            guard let context = UIGraphicsGetCurrentContext() else { continue }
            
            let ciContext:CIContext
            if #available(iOS 9.0, *) {
                ciContext = CIContext(cgContext: context, options: nil)
            } else {
                ciContext = CIContext.init()//TODO: Probably doesnt work
            }
            
            context.concatenate(transform)

            ciContext.draw(result.ciImage, in: squareDestinationRect.applying(transform), from: squaredSourceRect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            faceImages.append(newImage!)
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



