//
//  UITextView.swift
//  QOL-iOS-Swiftly
//
//  Created by Isaac Paul on 4/17/18.
//  Copyright © 2018 Isaac Paul. All rights reserved.
//

import Foundation

public extension UITextField {
    func textNonNil() -> String {
        return text ?? ""
    }
    
    func trimText() {
        text = text?.trimWhiteSpace()
    }
}

public extension UITextView {
    
    //Will only work if the textview is set to be scrollable
    func measureHeight(lineHeight: CGFloat) -> CGFloat {
        let height = contentSize.height
        let insets:CGFloat = self.textContainerInset.top + self.textContainerInset.bottom
        return height + insets
    }
    
    class func buildLabelLike(frame:CGRect) -> UITextView {
        let textView = UITextView.init(frame: frame)
        textView.isScrollEnabled = false
        textView.showsHorizontalScrollIndicator = false
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        return textView
    }
    
    func textNonNil() -> String {
        return text ?? ""
    }
    
    func resizeToFitText() {
        height = 2
        layoutManager.allowsNonContiguousLayout = false
        height = measureHeight(lineHeight:22)//todo: hardcoded
    }
    
    func resizeToFitTextMethod5(simulatedFont:UIFont? = nil) {
        height = 2
        layoutManager.allowsNonContiguousLayout = false
        var fontToUse = font
        if (simulatedFont != nil) {
            fontToUse = simulatedFont
        }
        let newHeight = UITextView.height(forWidth: width - textContainerInset.left - textContainerInset.right, text: text, font: fontToUse, edgeInsets: UIEdgeInsets.zero, numberOfLines: 100)
        let insets:CGFloat = self.textContainerInset.top + self.textContainerInset.bottom
        height = newHeight + insets
    }
}

