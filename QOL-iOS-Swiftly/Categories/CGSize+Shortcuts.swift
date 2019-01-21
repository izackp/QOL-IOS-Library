//
//  CGSize+Shortcuts.swift
//  QOL-iOS-Swiftly
//
//  Created by Isaac Paul on 1/21/19.
//  Copyright © 2019 Isaac Paul. All rights reserved.
//

import Foundation

public extension CGSize {
    public func aspectFitScale(_ toSize:CGSize) -> CGFloat {
        let scaleByWidth = toSize.width / CGFloat(width)
        let scaleByHeight = toSize.height / CGFloat(height)
        
        let finalScale = CGFloat.minimum(scaleByWidth, scaleByHeight)
        return finalScale
    }
    
    public func aspectFitInto(_ other:CGSize) -> CGSize {
        let scale = aspectFitScale(other)
        return CGSize(width:width*scale, height:height*scale)
    }
    
    public func aspectFitNoUpscale(_ toSize:CGSize) -> CGSize? {
        let shouldResize = (width > toSize.width || height > toSize.height)
        if (shouldResize) {
            return aspectFitInto(toSize)
        }
        return nil
    }
}
