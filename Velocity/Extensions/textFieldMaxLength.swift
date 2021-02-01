//
//  textFieldMaxLength.swift
//  ServSearch
//
//  Created by Vishal Gohel on 8/29/17.
//  Copyright © 2017 Vishal Gohel. All rights reserved.
//

import Foundation
import UIKit

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
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
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        
        text = String(prospectiveText[..<maxCharIndex])
        
        //text = prospectiveText.substring(to: maxCharIndex) //String(prospectiveText.prefix(maxLength)) //prospectiveText.substring(to: maxCharIndex)
        selectedTextRange = selection
    }
}
