//
//  UILabel+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 11/15/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation

public extension UILabel {
    func setBold(_ value:Bool) {
        let pointSize:CGFloat? = font?.pointSize
        if (value) {
            font = UIFont.boldSystemFont(ofSize: pointSize!)
        } else {
            font = UIFont.systemFont(ofSize: pointSize!)
        }
    }
}
