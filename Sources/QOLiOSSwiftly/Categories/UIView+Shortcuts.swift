//
//  UIView+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 10/25/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    var heightFromBottom: CGFloat {
        get {
            return self.frame.size.height
        }
        set(value) {
            if (value < 0) {
                print("Warning: Setting height to a value < 0")
                return
            }
            let diff = height - value
            
            let newFrame = CGRect.init(x: x, y: y + diff, width: width, height: value)
            self.frame = newFrame
        }
    }
    
    func firstView(_ include:((_ view:UIView)->Bool)) -> UIView? {
        if (include(self)) {
            return self
        }
        var subItems = self.subviews
        while (subItems.count > 0) {
            for eachSubView in subItems {
                if (include(eachSubView)) {
                    return eachSubView
                }
            }
            subItems = UIView.deeper(subItems)
        }
        return nil
    }
    
    static func deeper(_ list:[UIView]) -> [UIView] {
        return list.flatMap({
            return $0.subviews
        })
    }
    
    func findAllViews(_ include:((_ view:UIView)->Bool)) -> [UIView] {
        var list:[UIView] = []
        for eachView:UIView in subviews {
            list += eachView.findAllViews(include)
        }
        if (include(self)) {
            list.append(self)
        }
        return list
    }
    
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
    
    func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint.init(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint.init(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position = self.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }
}
