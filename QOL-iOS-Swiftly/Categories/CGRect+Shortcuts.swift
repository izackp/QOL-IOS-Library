//
//  CGRect+Shortcuts.swift
//  Capture
//
//  Created by Isaac Paul on 4/10/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension CGRect {
    
    static func zeroOne() -> CGRect {
        return CGRect.init(x: 0.0, y:0.0, width: 1.0, height: 1.0)
    }
    
    var width_: CGFloat {
        get {
            return size.width;
        }
        set(value) {
            size.width = value
        }
    }
    
    var height_: CGFloat {
        get {
            return size.height;
        }
        set(value) {
            size.height = value
        }
    }
    
    var x: CGFloat {
        get {
            return origin.x;
        }
        set(value) {
            origin.x = value
        }
    }
    
    var y: CGFloat {
        get {
            return origin.y;
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
            let diff = value - left;
            x += diff
            width_ -= diff
        }
    }
    
    var top: CGFloat {
        get {
            return y
        }
        set(value) {
            let diff = value - top;
            y += diff
            height_ -= diff
        }
    }
    
    var right: CGFloat {
        get {
            return x + width
        }
        set(value) {
            let diff = value - right;
            width_ += diff
        }
    }
    
    var bottom: CGFloat {
        get {
            return y + height
        }
        set(value) {
            let diff = value - bottom;
            height_ += diff
        }
    }
    
    func aspectRatio() -> CGFloat {
        return width / height
    }
    
    func aspectRatioInverse() -> CGFloat {
        return height / width
    }
    
    func capValueAtBounds(bounds:CGRect) -> CGRect {
        
        var rect:CGRect = self
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
}
