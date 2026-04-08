//
//  TimeInterval+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 3/13/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation

public extension TimeInterval {
    static let oneDay:TimeInterval = oneHour * 24
    static let oneHour:TimeInterval = oneMinute * 60
    static let oneMinute:TimeInterval = 60
}
