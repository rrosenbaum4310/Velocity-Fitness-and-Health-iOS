//
//  VFHTextField.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/03/19.
//

import UIKit

@IBDesignable
class VFHTextField: UITextField {

    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: sidePadding, dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    // properties..
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var enableTitle : Bool = false
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: Int = 1 {
        didSet {
            layer.borderWidth = CGFloat(borderWidth)
        }
    }
    @IBInspectable var placeHolderColor: UIColor = UIColor.gray {
        
        didSet {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
    
    @IBInspectable public var sidePadding: CGFloat = 0 {
        didSet {
            let padding = UIView(frame: CGRect(x: 0, y: 0, width: sidePadding, height: sidePadding))
            
            leftViewMode = UITextField.ViewMode.always
            leftView = padding
            
            rightViewMode = UITextField.ViewMode.always
            rightView = padding
        }
    }
    
    
    func setup() {
        borderStyle = UITextField.BorderStyle.none
        layer.borderWidth = CGFloat(borderWidth)
        layer.borderColor = borderColor.cgColor
        placeHolderColor = UIColor.white
    }

}
