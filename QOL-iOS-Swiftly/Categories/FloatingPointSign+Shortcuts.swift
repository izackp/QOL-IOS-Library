//
//  FloatingPointSign+Shortcuts.swift
//  QOL-iOS-Swiftly
//
//  Created by Isaac Paul on 9/11/19.
//  Copyright © 2019 Isaac Paul. All rights reserved.
//

import Foundation

extension FloatingPointSign {
    func flip() -> FloatingPointSign {
        return (self == .minus) ? .plus : .minus
    }
}
