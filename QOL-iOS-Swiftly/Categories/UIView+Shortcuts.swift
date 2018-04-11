//
//  UIView+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 10/25/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation

public extension UIView {
    
    func findAllViews<T:UIView>(withType:T.Type) -> [T] {
        var list:[T] = []
        for eachView:UIView in subviews {
            list += eachView.findAllViews(withType: withType)
        }
        if (self is T) {
            list.append(self as! T)
        }
        return list
    }
    
    func findParentView<T:UIView>(withType:T.Type) -> T? {
        var superview:UIView? = self.superview;
        while (superview != nil) {
            if (superview is T){
                return (superview as! T);
            }
            superview = superview?.superview;
        }
        return nil
    }
    
    func topViewController() -> UIViewController? { //TODO: Move
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    func isInTopViewController() -> Bool {
        let topController = topViewController()!
        if (findParentView(parent:topController.view)) {
            return true;
        }
        return false
    }
    
    func findParentView(parent:UIView) -> Bool {
        var superview:UIView? = self.superview;
        while (superview != nil) {
            if (superview == parent){
                return true;
            }
            superview = superview?.superview;
        }
        return false;
    }
    
    func safeInsets() -> UIEdgeInsets {
        var edges:UIEdgeInsets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            edges = safeAreaInsetsiOS11()
        } else {
            edges = safeAreaInsetsiOS10()
        }
        if (edges.top == 0) {
            let statusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height
            edges.top = statusBarHeight
        }
        return edges;
    }
    
    @available(iOS 11.0, *)
    func safeAreaInsetsiOS11() -> UIEdgeInsets {
        return UIApplication.shared.delegate!.window!!.safeAreaInsets;
    }
    
    func safeAreaInsetsiOS10() -> UIEdgeInsets {
        var edges:UIEdgeInsets = UIEdgeInsets.zero
        let statusBarHeight:CGFloat = UIApplication.shared.statusBarFrame.height
        edges.top = statusBarHeight
        return edges
    }
}
