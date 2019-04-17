//
//  UIScreen.swift
//  QOL-iOS-Library
//
//  Created by Isaac Paul on 5/31/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation

public extension UIScreen {
    
    func screenSize() -> CGRect {
        return screenSizeForOrientation(.portrait)
    }
    
    func screenSizeForOrientation(_ orientation:UIInterfaceOrientation) -> CGRect {
        let size = bounds.size
        var flip = orientation.isLandscape
        if #available(iOS 8.0, *) {
            let currentOrientation = UIApplication.shared.statusBarOrientation
            flip = currentOrientation.isLandscape != orientation.isLandscape
        }
        return flip ? CGRect.init(x: 0, y: 0, width: size.height, height: size.width) : bounds
    }
}
