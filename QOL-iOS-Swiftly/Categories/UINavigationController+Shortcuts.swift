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
    
    func pushVCFromBottomHack(_ viewController:UIViewController) {
        let container = UIView.init(frame: view.frame)
        container.layer.cornerRadius = view.layer.cornerRadius
        container.clipsToBounds = true
        view.superview?.insertSubview(container, aboveSubview: view)
        
        let initialImg = view.generateImage()
        let initialImgView = UIImageView.init(image: initialImg!)
        initialImgView.frame = container.bounds
        container.addSubview(initialImgView)
        pushViewController(viewController, animated: false)
        
        let finalImg = view.generateImage()
        let finalImgView = UIImageView.init(image: finalImg!)
        finalImgView.frame = container.bounds
        finalImgView.y = initialImgView.bottom
        container.addSubview(finalImgView)
        UIView.animate(withDuration: 0.25, animations: {
            finalImgView.y = initialImgView.y
        }) { (complete:Bool) in
            container.removeFromSuperview()
        }
    }
    
    func popVCFromTopHack() {
        let container = UIView.init(frame: view.frame)
        container.layer.cornerRadius = view.layer.cornerRadius
        container.clipsToBounds = true
        view.superview?.insertSubview(container, aboveSubview: view)
        
        let initialImg = view.generateImage()
        let initialImgView = UIImageView.init(image: initialImg!)
        initialImgView.frame = container.bounds
        initialImgView.layer.cornerRadius = view.layer.cornerRadius
        initialImgView.clipsToBounds = true
        container.addSubview(initialImgView)
        popViewController(animated: false)
        
        let finalImg = view.generateImage()
        let finalImgView = UIImageView.init(image: finalImg!)
        finalImgView.frame = container.bounds
        container.insertSubview(finalImgView, belowSubview: initialImgView)
        
        UIView.animate(withDuration: 0.25, animations: {
            initialImgView.y = finalImgView.bottom
        }) { (complete:Bool) in
            container.removeFromSuperview()
        }
    }
    
    func popToVCHack(_ vcClass:AnyClass) {
        guard let vc = findVC(with: vcClass) else { return }
        
        let container = UIView.init(frame: view.frame)
        container.layer.cornerRadius = view.layer.cornerRadius
        container.clipsToBounds = true
        view.superview?.insertSubview(container, aboveSubview: view)
        
        let initialImg = view.generateImage()
        let initialImgView = UIImageView.init(image: initialImg!)
        initialImgView.frame = container.bounds
        initialImgView.layer.cornerRadius = view.layer.cornerRadius
        initialImgView.clipsToBounds = true
        container.addSubview(initialImgView)
        
        var vcList:[UIViewController] = []
        for eachVC in viewControllers {
            vcList.append(eachVC)
            if (eachVC == vc) {
                break
            }
        }
        setViewControllers(vcList, animated: false)
        
        let finalImg = view.generateImage()
        let finalImgView = UIImageView.init(image: finalImg!)
        finalImgView.frame = container.bounds
        container.insertSubview(finalImgView, belowSubview: initialImgView)
        
        UIView.animate(withDuration: 0.25, animations: {
            initialImgView.y = finalImgView.bottom
        }) { (complete:Bool) in
            container.removeFromSuperview()
        }
    }
    
    func popVCFromRightHack(_ toRoot:Bool = false, _ hiddenNav:Bool = true) {
        let container = UIView.init(frame: view.frame)
        container.layer.cornerRadius = view.layer.cornerRadius
        container.clipsToBounds = true
        view.superview?.insertSubview(container, aboveSubview: view)
        
        let initialImg = view.generateImage()
        let initialImgView = UIImageView.init(image: initialImg!)
        initialImgView.frame = container.bounds
        initialImgView.layer.cornerRadius = view.layer.cornerRadius
        initialImgView.clipsToBounds = true
        container.addSubview(initialImgView)
        if (toRoot) {
            setViewControllers([viewControllers[0]], animated: true)
        } else {
            popViewController(animated: false)
        }
        if (hiddenNav) {
            setNavigationBarHidden(true, animated: false)
        }
        
        let finalImg = view.generateImage()
        let finalImgView = UIImageView.init(image: finalImg!)
        finalImgView.frame = container.bounds
        container.insertSubview(finalImgView, belowSubview: initialImgView)
        
        UIView.animate(withDuration: 0.25, animations: {
            initialImgView.x = finalImgView.right
        }) { (complete:Bool) in
            container.removeFromSuperview()
        }
    }
}
