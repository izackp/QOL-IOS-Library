//
//  CGRect+Shortcuts.swift
//  Capture
//
//  Created by Isaac Paul on 4/10/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension CGPoint {
    func add(_ other:CGPoint) -> CGPoint {
        return CGPoint.init(x: x + other.x, y: y + other.y)
    }
    
    func subtract(_ other:CGPoint) -> CGPoint {
        return CGPoint.init(x: x - other.x, y: y - other.y)
    }
}

public extension CGRect {
    
    static func zeroOne() -> CGRect {
        return CGRect.init(x: 0.0, y:0.0, width: 1.0, height: 1.0)
    }
    
    var width_: CGFloat {
        get {
            return size.width
        }
        set(value) {
            size.width = value
        }
    }
    
    var height_: CGFloat {
        get {
            return size.height
        }
        set(value) {
            size.height = value
        }
    }
    
    var x: CGFloat {
        get {
            return origin.x
        }
        set(value) {
            origin.x = value
        }
    }
    
    var y: CGFloat {
        get {
            return origin.y
        }
        set(value) {
            origin.y = value
        }
    }
    
    var left: CGFloat {
        get {
            return x
        }
        set(value) {
            let diff = value - left
            x += diff
            width_ -= diff
        }
    }
    
    var top: CGFloat {
        get {
            return y
        }
        set(value) {
            let diff = value - top
            y += diff
            height_ -= diff
        }
    }
    
    var right: CGFloat {
        get {
            return x + width
        }
        set(value) {
            let diff = value - right
            width_ += diff
        }
    }
    
    var bottom: CGFloat {
        get {
            return y + height
        }
        set(value) {
            let diff = value - bottom
            height_ += diff
        }
    }
    
    var rightAnchored: CGFloat {
        get {
            return right
        }
        set(value) {
            let diff = value - right
            x += diff
        }
    }
    
    var bottomAnchored: CGFloat {
        get {
            return bottom
        }
        set(value) {
            let diff = value - bottom
            y += diff
        }
    }
    
    var center: CGPoint {
        get {
            return CGPoint.init(x: x + width * 0.5, y: y + height * 0.5)
        }
        set (value) {
            origin = CGPoint.init(x: value.x - width * 0.5, y: value.y - height * 0.5)
        }
    }
    
    func aspectRatio() -> CGFloat {
        return size.aspectRatio()
    }
    
    func aspectRatioInverse() -> CGFloat {
        return height / width
    }
    
    func aspectCrop(_ ratio:CGFloat, allowBestMatch:Bool = false) -> CGRect {
        return size.aspectCrop(ratio, allowBestMatch: allowBestMatch)
    }
    
    func capValueAtBounds(bounds:CGRect) -> CGRect {
        
        var rect:CGRect = self
        
        if (width > bounds.width) {
            rect.width_ = bounds.width
        }
        
        if (height > bounds.height) {
            rect.height_ = bounds.height
        }
        
        if (x < bounds.x) {
            rect.left = bounds.x
        }
        
        if (y < bounds.y) {
            rect.top = bounds.y
        }
        
        if (right > bounds.width) {
            rect.right = bounds.width
        }
        
        if (bottom > bounds.height) {
            rect.bottom = bounds.height
        }
        
        return rect
    }
    
    func roundedRect() -> CGRect {
        var rect:CGRect = self
        
        rect.x = round(rect.x)
        rect.y = round(rect.y)
        rect.width_ = round(rect.width_)
        rect.height_ = round(rect.height_)
        
        return rect
    }
    
    func toDp() -> CGRect {
        let scale = UIScreen.main.scale
        let xx = x / scale
        let yy = y / scale
        let ww = width / scale
        let hh = height / scale
        return CGRect.init(x: xx, y: yy, width: ww, height: hh)
    }
    
    static func + ( left : CGRect , right : CGRect) -> CGRect {
        return CGRect(x: left.x + right.x, y: left.y + right.y, width: left.width + right.width, height: left.height + right.height)
    }
    
    static func * ( left : CGRect , right : CGFloat) -> CGRect {
        return CGRect(x: left.x * right, y: left.y * right, width: left.width * right, height: left.height * right)
    }
    
    static func / ( left : CGRect , right : CGFloat) -> CGRect {
        return CGRect(x: left.x / right, y: left.y / right, width: left.width / right, height: left.height / right)
    }
}
