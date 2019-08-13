//
//  Array+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 11/22/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation

public extension Array {
    init(count: Int, elementCreator: @autoclosure () -> Element) {
        self = (0 ..< count).map { _ in elementCreator() }
    }
    
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
    func arrayWithIndexs(_ indexs:[Int]) -> [Element] {
        var newArray:[Element] = []
        for eachIndex in indexs {
            newArray.append(self[eachIndex])
        }
        return newArray
    }
    
    func groupByKey<Key>(_ keyForElement:(Element) -> (Key?)) -> [Key:[Element]] {
        var dic:[Key:[Element]] = [:]
        
        for eachItem in self {
            guard let key = keyForElement(eachItem) else { continue }
            var array:[Element] = dic[key] ?? []
            array.append(eachItem)
            dic[key] = array
        }
        
        return dic
    }
    
    func index<Key: Hashable>(_ selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}

public extension Sequence where Iterator.Element: Hashable {
    var uniqueElements: [Iterator.Element] {
        return Array( Set(self) )
    }
    
    func unique<T:Hashable>(by: ((Iterator.Element) -> (T))) -> [Iterator.Element] {
        var set = Set<T>()
        var arrayOrdered = [Iterator.Element]()
        for value in self {
            let byValue = by(value)
            if !set.contains(byValue) {
                set.insert(byValue)
                arrayOrdered.append(value)
            }
        }
        
        return arrayOrdered
    }
}

public extension Sequence where Iterator.Element: Equatable {
    var uniqueElementsByEq: [Iterator.Element] {
        return self.reduce([]){
            uniqueElements, element in
            
            uniqueElements.contains(element)
                ? uniqueElements
                : uniqueElements + [element]
        }
    }
}
