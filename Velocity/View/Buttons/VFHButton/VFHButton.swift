//
//  VFHButton.swift
//
//
//  Created by Macbook on 23/11/17.
//  Copyright © 2017 Arusys. All rights reserved.
//

import UIKit

// @IBDesignable
class VFHButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setup()
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            setup()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setup()
        }
    }
    
    
    @IBInspectable var shadowRadius: CGFloat = 10 {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            setup()
        }
    }
    
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = CGFloat(borderWidth)

        if isShadow {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = false
            let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = 0.3
            //            layer.borderWidth = 1
            //            layer.borderColor = UIColor(hex: "7EB4C0").cgColor
            // Emphasize the shadow on the bottom and right sides of the cell
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowPath = shadowPath.cgPath
        }
        
        
        
    }
}
