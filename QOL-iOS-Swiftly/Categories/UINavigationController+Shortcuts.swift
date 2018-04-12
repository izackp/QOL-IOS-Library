//
//  UINavigationController+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 4/3/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension UINavigationController {
    func pushViewControllerList(_ controllers:[UIViewController], animated:Bool) {
        let newSetOfControllers = viewControllers + controllers
        setViewControllers(newSetOfControllers, animated: animated)
    }
    
    func replaceViewController(_ controller:UIViewController, animated:Bool, animateForward:Bool = true) {
        if (viewControllers.last == nil) {
            print("Warning: Trying to replace view controller with no view controller to replace")
            return
        }
        if (animateForward) {
            let newSetOfControllers = Array(viewControllers[0..<viewControllers.count-1]) + [controller]
            setViewControllers(newSetOfControllers, animated: animated)
        } else {
            let newSetOfControllers = Array(viewControllers[0..<viewControllers.count-1]) + [controller, viewControllers.last!]
            setViewControllers(newSetOfControllers, animated: false)
            popViewController(animated: animated)
        }
    }
}
