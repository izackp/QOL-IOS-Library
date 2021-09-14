//
//  Collection+Shortcuts.swift
//  QOL-iOS-Swiftly
//
//  Created by Isaac Paul on 8/24/21.
//  Copyright © 2021 Isaac Paul. All rights reserved.
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    func inBounds(_ index: Index) -> Bool {
        return indices.contains(index)
    }
}

public extension Array {
    func inBounds(_ index:Int) -> Bool {
        return index >= 0 && index < endIndex
    }
}

public extension Array where Element: ExpressibleByNilLiteral {
    subscript(safe index: Int) -> Element? {
        get {
            if index < 0 || index >= endIndex {
                return nil
            }

            return self[index]
        }

        set(newValue) {
            if index >= endIndex {
                self.append(contentsOf: Array(repeating: nil, count: index - endIndex + 1))
            }

            self[index] = newValue ?? nil
        }
    }
}
