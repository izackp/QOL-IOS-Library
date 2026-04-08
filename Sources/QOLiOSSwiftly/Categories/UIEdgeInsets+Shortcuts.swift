//
//  UIInset+Shortcuts.swift
//  QOL-iOS-Swiftly
//
//  Created by Isaac Paul on 4/17/19.
//  Copyright © 2019 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension UIEdgeInsets {
    func widthOffset() -> CGFloat {
        return self.left + self.right
    }
    
    func heightOffset() -> CGFloat {
        return self.top + self.bottom
    }
}
