//
//  UICollectionView+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 1/17/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension UICollectionView {
    func indexOfMostVisibleCell() -> Int {
        let visibleCells = self.visibleCells
        let contentOffsetX = contentOffset.x
        let visibleRight = width + contentOffsetX
        
        var indexOfMostVisibleCell:Int = -1
        var currentSize:CGFloat = 0
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            let x = cell.x
            let right = cell.right
            var width = cell.width
            if (x < contentOffsetX) {
                width -= contentOffsetX - x
            }
            if (right > visibleRight) {
                width -= right - visibleRight
            }
            if (width > currentSize) {
                currentSize = width
                indexOfMostVisibleCell = i
            }
        }
        if (indexOfMostVisibleCell == -1) {
            return -1
        }
        let visibleRow = indexPathsForVisibleItems[indexOfMostVisibleCell].row
        return visibleRow
    }
}
