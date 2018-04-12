//
//  UIViewController+Shortcuts.swift
//  QOL-iOS-Swiftly
//
//  Created by Isaac Paul on 4/11/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    func stylizeNavBar() {//To be flat
        let navController:UINavigationController = self.navigationController!
        let navigationBar:UINavigationBar = navController.navigationBar
        navController.setNavigationBarHidden(false, animated: true)
        navigationBar.barTintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    func customBarButtonWithText(target:Any?, text:String, action:Selector) -> UIButton {
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.setTitle(text, for: UIControlState.normal)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        let width:CGFloat = ((button.titleLabel!.attributedText!.width(withConstrainedHeight: 44)) + 4.0)
        button.frame = CGRect.init(origin: CGPoint.zero, size: CGSize(width:width, height:44))
        return button
    }
    
    func customBarButton(target:Any?, imageName:String, action:Selector) -> UIButton {
        let image:UIImage = UIImage.init(named: imageName)! //TODO: Check for missing image
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.setTitle(nil, for: UIControlState.normal)
        button.setImage(image, for: UIControlState.normal)
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        button.frame = CGRect.init(origin: CGPoint.zero, size: image.size)
        button.height = 44
        button.contentMode = .center
        return button
    }
    
    func findBackButton() -> UIButton? {
        if (self.navigationController == nil) {
            return nil
        }
        let backItem = navigationItem.leftBarButtonItem
        if (backItem == nil) {
            return nil
        }
        
        let button = backItem!.customView as? UIButton
        return button
    }
    
    func makeNavigationTransparent() {
        let navController = navigationController!
        let navBar = navController.navigationBar
        navBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage.init()
        navBar.isTranslucent = true
        navController.view.backgroundColor = UIColor.clear
        navBar.backgroundColor = UIColor.clear
    }
    
    func showMessage(_ message:String, title:String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    @objc @IBAction func tapBack() {
        self.navigationController?.popViewController(animated: true);
    }
    
    @objc @IBAction func tapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    func loadViewIfNeededAnyiOS() {
        if #available(iOS 9, *) {
            loadViewIfNeeded()
        } else {
            // _ = self.view works but some Swift compiler genius could optimize what seems like a noop out
            // hence this perversion from this recipe http://stackoverflow.com/questions/17279604/clean-way-to-force-view-to-load-subviews-early
            view.alpha = 1
        }
    }
}
