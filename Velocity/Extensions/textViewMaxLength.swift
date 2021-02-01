//
//  textViewMaxLength.swift
//  ServSearch
//
//  Created by Vishal Gohel on 9/4/17.
//  Copyright © 2017 Vishal Gohel. All rights reserved.
//

import UIKit

private var kAssociationKeyMaxLength: Int = 0

extension UITextView {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            //addTarget(self, action: #selector(self.checkMaxLength), for: .editingChanged)
            NotificationCenter.default.addObserver(self, selector: #selector(self.textDidChangeHandler(notification:)), name: UITextView.textDidChangeNotification, object: nil)
        }
    }
    
    @objc func textDidChangeHandler(notification: Notification) {
        checkMaxLength(textField: self)
    }
    
    fileprivate func checkMaxLength(textField: UITextView) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        text = String(prospectiveText[..<maxCharIndex])
        //text = prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }

    
}
