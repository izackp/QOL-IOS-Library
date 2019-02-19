//
//  String+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 11/8/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation

public extension String {
    
    func stringWithDigitsOnly() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    static func notEmpty(_ str:String?) -> Bool {
        return str?.count ?? 0 > 0
    }
    
    static func empty(_ str:String?) -> Bool {
        return str?.count ?? 0 == 0
    }
    
    func withMinLength(_ minLength:Int = 1) -> String? {
        if (count < minLength) {
            return nil
        }
        return self
    }
    
    func isValidPhone() -> Bool {
        let phoneCount = self.count
        let result = (phoneCount > 9
            && phoneCount < 13)
        return result
    }
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    /*
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return String(self[Range(start ..< end)])
    }*/
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substringSafe(to: Int) -> String {
        if (self.count == 0) {
            return ""
        }
        
        let toFinal = (to > self.count) ? self.count : to
        let toIndex = index(from: toFinal)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func trimWhiteSpace() -> String {
        let set = NSCharacterSet.whitespaces
        let result = self.trimmingCharacters(in: set)
        return result
    }
    
    func containsAny(_ list:[String]) -> Bool {
        for eachItem in list {
            if (contains(eachItem)) {
                return true
            }
        }
        return false
    }
    
    static func joinComponents(_ list:[String?], by:String = "") -> String? {
        let components = NSMutableArray.init(capacity: list.count)
        for eachStr in list {
            if String.notEmpty(eachStr){
                components.add(eachStr!)
            }
        }
        if (components.count == 0) {
            return nil
        }
        let result = components.componentsJoined(by: by)
        return result
    }
}
