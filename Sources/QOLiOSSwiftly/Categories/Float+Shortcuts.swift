//
//  Float+Shortcuts.swift
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 4/24/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation

/*public protocol AlmostEquatable {
    static func ==~(lhs: Self, rhs: Self) -> Bool
}*/

public protocol EquatableWithinEpsilon: Strideable {
    static var Epsilon: Self.Stride { get }
}

extension Float: EquatableWithinEpsilon {
    public static let Epsilon: Float.Stride = 1e-8
}

extension CGFloat: EquatableWithinEpsilon {
    public static let Epsilon: CGFloat.Stride = 1e-8
}

extension Double: EquatableWithinEpsilon {
    public static let Epsilon: Double.Stride = 1e-16
}

private func almostEqual(_ lhs: Double, _ rhs: Double, epsilon: Double.Stride) -> Bool {
    return abs(lhs - rhs) <= epsilon
}

private func almostEqual(_ lhs: Float, _ rhs: Float, epsilon: Float.Stride) -> Bool {
    return abs(lhs - rhs) <= epsilon
}

private func almostEqual(_ lhs: CGFloat, _ rhs: CGFloat, epsilon: CGFloat.Stride) -> Bool {
    return abs(lhs - rhs) <= epsilon
}

/** Almost-equality of floating point types. */
infix operator ==~ : ComparisonPrecedence
public func ==~(lhs: Double, rhs: Double) -> Bool {
    return almostEqual(lhs, rhs, epsilon: Double.Epsilon)
}

public func ==~(lhs: Float, rhs: Float) -> Bool {
    return almostEqual(lhs, rhs, epsilon: Float.Epsilon)
}

public func ==~(lhs: CGFloat, rhs: CGFloat) -> Bool {
    return almostEqual(lhs, rhs, epsilon: CGFloat.Epsilon)
}

/** Inverse almost-equality for any AlmostEquatable. */
infix operator !==~ : ComparisonPrecedence
public func !==~(lhs: Double, rhs: Double) -> Bool {
    return !(lhs ==~ rhs)
}

public func !==~(lhs: Float, rhs: Float) -> Bool {
    return !(lhs ==~ rhs)
}

public func !==~(lhs: CGFloat, rhs: CGFloat) -> Bool {
    return !(lhs ==~ rhs)
}


extension Double {
    public func roundToInt(_ rule: FloatingPointRoundingRule = .toNearestOrEven) -> Int? {
        let rounded = self.rounded(rule)
        if rounded <= Double(Int.min) + Double.Epsilon {
            return Int.min
        }
        
        if rounded >= Double(Int.max) - Double.Epsilon {
            return Int.max
        }
        
        return Int(rounded)
    }
}

extension Float {
    public func roundToInt(_ rule: FloatingPointRoundingRule = .toNearestOrEven) -> Int? {
        let rounded = self.rounded(rule)
        if rounded <= Float(Int.min) + Float.Epsilon {
            return Int.min
        }
        
        if rounded >= Float(Int.max) - Float.Epsilon {
            return Int.max
        }
        
        return Int(rounded)
    }
    
    public func toCurrency(currencyCode:String = "USD") -> String {
        var localeComponents: [String: String] = [NSLocale.Key.currencyCode.rawValue: currencyCode]
        localeComponents[NSLocale.Key.languageCode.rawValue] = NSLocale.preferredLanguages.first
        let localeID = NSLocale.localeIdentifier(fromComponents: localeComponents)
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: localeID)
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension CGFloat {
    public func roundToInt(_ rule: FloatingPointRoundingRule = .toNearestOrEven) -> Int? {
        let rounded = self.rounded(rule)
        if rounded <= CGFloat(Int.min) + CGFloat.Epsilon {
            return Int.min
        }
        
        if rounded >= CGFloat(Int.max) - CGFloat.Epsilon {
            return Int.max
        }
        
        return Int(rounded)
    }
}
