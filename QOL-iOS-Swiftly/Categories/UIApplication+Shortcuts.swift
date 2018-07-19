//
//  UIApplication+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 3/22/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension UIApplication {
    func openURLExt(_ urlStr:String) {
        let url = URL(string: urlStr)
        if (url == nil) {
            return
        }
        if #available(iOS 10.0, *) {
            open(url!, options: [:], completionHandler: nil)
        } else {
            openURL(url!)
        }
    }
}
