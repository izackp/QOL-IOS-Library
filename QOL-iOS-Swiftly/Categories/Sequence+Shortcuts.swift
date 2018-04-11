//
//  Sequence+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 4/4/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation

public extension Array {
    mutating func popAtIndex(_ index:Int) -> Element {
        let element = self[index]
        self.remove(at: index)
        return element
    }
    
    func decrementAndWrapIndex(_ index:Int) -> Int {
        let result = index - 1
        if (result < 0) {
            return self.count - 1
        }
        return result
    }
    
    func incrementAndWrapIndex(_ index:Int) -> Int {
        let result = index + 1
        if (result >= self.count) {
            return 0
        }
        return result
    }
}

public extension Sequence where Element: Any {
    
    // A dictionary mapping each id to a pair
    //    ( oldIndex, newIndex )
    // where oldIndex = nil for inserted elements
    // and newIndex = nil for deleted elements.
    typealias FromToPair = (from: Int, to: Int)
    typealias DeltaIndices = (insertedIndices:[Int], deletedIndices:[Int], movedIndices:[FromToPair])
    func delta<T: Sequence>(_ other:T) -> DeltaIndices where T.Element: Any  {
        var map : [ Int: (from: Int?, to: Int?)] = [:]
        
        for (index, element) in self.enumerated() {
            let id = unsafeBitCast(element, to: Int.self)
            map[id] = (from: index, to: nil)
        }
        
        for (index, element) in other.enumerated() {
            let id = unsafeBitCast(element, to: Int.self)
            map[id] = (map[index]?.from, index)
        }
        
        // Compare:
        var insertedIndices : [Int] = []
        var deletedIndices : [Int] = []
        var movedIndices : [FromToPair] = []
        
        for pair in map.values {
            switch pair {
            case (let .some(fromIdx), let .some(toIdx)):
                movedIndices.append((from: fromIdx, to: toIdx))
            case (let .some(fromIdx), .none):
                deletedIndices.append(fromIdx)
            case (.none, let .some(toIdx)):
                insertedIndices.append(toIdx)
            default:
                fatalError("Oops") // This should not happen!
            }
        }
        
        return (insertedIndices:insertedIndices, deletedIndices:deletedIndices, movedIndices:movedIndices)
    }
    
    //NOTE: usually ordering is important when it comes to tracking insertions and deletions
    typealias DeltaIndexPaths = (inserted:[IndexPath], deleted:[IndexPath])
    func deltaIndexPaths<T: Sequence>(_ other:T) -> DeltaIndexPaths where T.Element: Any {
        let deltas = delta(other)
        let inserted = deltas.insertedIndices.map {IndexPath(row: $0, section: 0)}
        let deleted = deltas.deletedIndices.map {IndexPath(row: $0, section: 0)}
        return (inserted:inserted, deleted:deleted)
    }
    

}
