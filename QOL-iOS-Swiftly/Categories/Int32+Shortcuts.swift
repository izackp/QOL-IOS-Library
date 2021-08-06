//
//  Int32+Shortcuts.swift
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 4/18/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation

public extension Int {
    func compare(_ other:Int) -> ComparisonResult {
        if (self > other) { return .orderedDescending }
        if (self < other) { return .orderedAscending }
        return .orderedSame
    }
    
    func isDescending(_ other:Int) -> Bool {
        return self > other
    }
    
    func isAscending(_ other:Int) -> Bool {
        return self < other
    }
    
    func toCurrency(decimalDivider:Float = 100, currencyCode:String = "USD") -> String {
        return (Float(self) / decimalDivider).toCurrency(currencyCode: currencyCode)
    }
}

public extension Int8 {
    func compare(_ other:Int8) -> ComparisonResult {
        if (self > other) { return .orderedDescending }
        if (self < other) { return .orderedAscending }
        return .orderedSame
    }
    
    func isDescending(_ other:Int8) -> Bool {
        return self > other
    }
    
    func isAscending(_ other:Int8) -> Bool {
        return self < other
    }
    
    func toCurrency(decimalDivider:Float = 100, currencyCode:String = "USD") -> String {
        return (Float(self) / decimalDivider).toCurrency(currencyCode: currencyCode)
    }
}

public extension Int16 {
    func compare(_ other:Int16) -> ComparisonResult {
        if (self > other) { return .orderedDescending }
        if (self < other) { return .orderedAscending }
        return .orderedSame
    }
    
    func isDescending(_ other:Int16) -> Bool {
        return self > other
    }
    
    func isAscending(_ other:Int16) -> Bool {
        return self < other
    }
    
    func toCurrency(decimalDivider:Float = 100, currencyCode:String = "USD") -> String {
        return (Float(self) / decimalDivider).toCurrency(currencyCode: currencyCode)
    }
}

public extension Int32 {
    func compare(_ other:Int32) -> ComparisonResult {
        if (self > other) { return .orderedDescending }
        if (self < other) { return .orderedAscending }
        return .orderedSame
    }
    
    func isDescending(_ other:Int32) -> Bool {
        return self > other
    }
    
    func isAscending(_ other:Int32) -> Bool {
        return self < other
    }
    
    func toCurrency(decimalDivider:Float = 100, currencyCode:String = "USD") -> String {
        return (Float(self) / decimalDivider).toCurrency(currencyCode: currencyCode)
    }
}

public extension Int64 {
    func compare(_ other:Int64) -> ComparisonResult {
        if (self > other) { return .orderedDescending }
        if (self < other) { return .orderedAscending }
        return .orderedSame
    }
    
    func isDescending(_ other:Int64) -> Bool {
        return self > other
    }
    
    func isAscending(_ other:Int64) -> Bool {
        return self < other
    }
    
    func toCurrency(decimalDivider:Float = 100, currencyCode:String = "USD") -> String {
        return (Float(self) / decimalDivider).toCurrency(currencyCode: currencyCode)
    }
}
