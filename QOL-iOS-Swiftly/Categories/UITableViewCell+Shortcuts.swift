//
//  UITableViewCell+Shortcuts.swift
//  PhotoDay
//
//  Created by Isaac Paul on 12/11/17.
//  Copyright © 2017 Isaac Paul. All rights reserved.
//

import Foundation
import UIKit

public extension UITableViewCell {
    func getEditControl() -> UIView? {
        for eachView in self.subviews {
            if (eachView == self.contentView) {
                continue
            }
            if (eachView.width >= self.width) {
                continue
            }
            return eachView
        }
        return nil
    }
    
    class func createWithView(_ view:UIView) -> UITableViewCell {
        let cell = UITableViewCell.init(frame: view.frame)
        cell.backgroundView?.backgroundColor = UIColor.clear
        view.width = cell.contentView.width
        cell.contentView.height = view.height
        cell.contentView.addSubview(view)
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }
}
