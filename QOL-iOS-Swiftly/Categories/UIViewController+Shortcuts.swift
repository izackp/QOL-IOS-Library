//
//  UIViewController+Shortcuts.swift
//  QOL-iOS-Swiftly
//
//  Created by Isaac Paul on 4/11/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func stylizeNavBar() {//To be flat
        guard let navController:UINavigationController = self.navigationController else { return }
        let navigationBar:UINavigationBar = navController.navigationBar
        navController.setNavigationBarHidden(false, animated: true)
        navigationBar.barTintColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    public func customBarButtonWithText(target:Any?, text:String, action:Selector) -> UIButton {
        let button:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(text, for: UIControl.State.normal)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        let width:CGFloat = ((button.titleLabel!.attributedText!.width(withConstrainedHeight: 44)) + 4.0)
        button.frame = CGRect.init(origin: CGPoint.zero, size: CGSize(width:width, height:44))
        return button
    }
    
    public func customBarButton(target:Any?, imageName:String, action:Selector) -> UIButton {
        let image:UIImage = UIImage.init(named: imageName)! //TODO: Check for missing image
        let button:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        button.setTitle(nil, for: UIControl.State.normal)
        button.setImage(image, for: UIControl.State.normal)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        button.frame = CGRect.init(origin: CGPoint.zero, size: image.size)
        button.height = 44
        button.contentMode = .center
        return button
    }
    
    public func findBackButton() -> UIButton? {
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
    
    public func makeNavigationTransparent() {
        let navController = navigationController!
        let navBar = navController.navigationBar
        navBar.setBackgroundImage(UIImage.init(), for: UIBarMetrics.default)
        navBar.shadowImage = UIImage.init()
        navBar.isTranslucent = true
        navController.view.backgroundColor = UIColor.clear
        navBar.backgroundColor = UIColor.clear
    }
    
    public func showMessage(_ message:String, title:String?, _ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: handler)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    public func showActionSheet(_ actions:[UIAlertAction], title:String? = nil, message:String? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        for eachAction in actions {
            alertController.addAction(eachAction)
        }
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
                popoverController.sourceView = self.view
                popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            }
        }
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    public func showActionSheetStyled(_ actions:[UIAlertAction], sourceView:UIView, permittedArrowDirections:UIPopoverArrowDirection) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for eachAction in actions {
            alertController.addAction(eachAction)
        }
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = sourceView
                popoverController.sourceRect = sourceView.bounds
                popoverController.permittedArrowDirections = permittedArrowDirections
            }
        }
        self.present(alertController, animated: true, completion: nil)
        return alertController
    }
    
    @objc @IBAction open func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc @IBAction open func tapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc @IBAction open func variableTapBack() {
        let numVCs:Int = navigationController?.viewControllers.count ?? 0
        if (isModal() && numVCs < 2) {
            tapClose()
        } else {
            var vcList = self.navigationController?.viewControllers ?? []
            let _ = vcList.popLast()
            
            self.navigationController?.setViewControllers(vcList, animated: true)
        }
    }

    public func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    public func loadViewIfNeededAnyiOS() {
        if #available(iOS 9, *) {
            loadViewIfNeeded()
        } else {
            // _ = self.view works but some Swift compiler genius could optimize what seems like a noop out
            // hence this perversion from this recipe http://stackoverflow.com/questions/17279604/clean-way-to-force-view-to-load-subviews-early
            view.alpha = 1
        }
    }
}
