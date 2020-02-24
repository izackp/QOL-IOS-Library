//
//  CGPoint+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 11/10/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension CGPoint {
    static let mid:CGPoint = CGPoint(x: 0.5, y: 0.5)
    func flipValues() -> CGPoint {
        return CGPoint.init(x: y, y: x)
    }
    
    func toDp() -> CGPoint {
        let scale = UIScreen.main.scale
        let xx = x / scale
        let yy = y / scale
        return CGPoint(x: xx, y: yy)
    }
    
    static func + (left : CGPoint, right : CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func - (left : CGPoint, right : CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}
