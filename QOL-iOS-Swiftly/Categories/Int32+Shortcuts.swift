//
//  Int32+Shortcuts.swift
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 4/18/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation

public extension Int32 {
    public func compare(_ other:Int32) -> ComparisonResult {
        if (self == other) {
            return .orderedSame
        }
        
        if (self < other) {
            return .orderedAscending
        }
        
        return .orderedDescending
    }
}
