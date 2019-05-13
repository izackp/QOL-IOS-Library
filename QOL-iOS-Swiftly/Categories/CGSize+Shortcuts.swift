//
//  CGSize+Shortcuts.swift
//  QOL-iOS-Swiftly
//
//  Created by Isaac Paul on 1/21/19.
//  Copyright © 2019 Isaac Paul. All rights reserved.
//

import Foundation

public extension CGSize {
    func aspectFitScale(_ toSize:CGSize) -> CGFloat {
        let scaleByWidth = toSize.width / CGFloat(width)
        let scaleByHeight = toSize.height / CGFloat(height)
        
        let finalScale = CGFloat.minimum(scaleByWidth, scaleByHeight)
        return finalScale
    }
    
    func aspectFitInto(_ other:CGSize) -> CGSize {
        let scale = aspectFitScale(other)
        return CGSize(width:width*scale, height:height*scale)
    }
    
    func aspectFitNoUpscale(_ toSize:CGSize) -> CGSize? {
        let shouldResize = (width > toSize.width || height > toSize.height)
        if (shouldResize) {
            return aspectFitInto(toSize)
        }
        return nil
    }
    
    func inverse() -> CGSize {
        return CGSize(width:height, height:width)
    }
    
    func aspectRatio() -> CGFloat {
        return width / height
    }
    
    func aspectCrop(_ ratio:CGFloat, allowBestMatch:Bool = false) -> CGRect {
        let isHorizontal = ratio > 1
        let imageIsHorizontal = self.width > self.height
        var ratioToUse = ratio
        if (allowBestMatch) {
            ratioToUse = imageIsHorizontal != isHorizontal ? (1.0 / ratio) : ratio
        }
        
        if (self.height * ratioToUse <= self.width) {
            let width = self.height * ratioToUse
            let offset = (self.width - width) * 0.5
            let newCrop = CGRect.init(x: offset/self.width, y: 0, width: (offset+width)/self.width, height: 1)
            return newCrop
        }
        
        let height = self.width * (1.0 / ratioToUse)
        let offset = (self.height - height) * 0.5
        let newCrop = CGRect.init(x: 0, y: offset/self.height, width: 1, height: (offset+height)/self.height)
        return newCrop
    }
}
