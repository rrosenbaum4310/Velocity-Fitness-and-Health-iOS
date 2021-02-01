//
//  LWFloatingTextField.swift
//  LynkedWorld
//
//  Created by Vishal Gohel on 11/09/18.
//  Copyright © 2018 Arusys. All rights reserved.
//

import UIKit

class LWFloatingTextField: UITextField {
    public enum FloatingDisplayStatus{
        case always
        case never
        case defaults
    }
    
    fileprivate var lblFloatPlaceholder:UILabel             = UILabel()
    fileprivate let paddingX:CGFloat                        = 5.0
    
    fileprivate let paddingHeight:CGFloat                   = 10.0
    public var dtLayer:CALayer                              = CALayer()
    public var floatPlaceholderColor:UIColor                = UIColor.black
    public var floatPlaceholderActiveColor:UIColor          = UIColor.black
    public var floatingLabelShowAnimationDuration           = 0.3
    public var floatingDisplayStatus:FloatingDisplayStatus  = .defaults
    
    @IBInspectable public var title: String = "" {
        didSet {
            //invalidateIntrinsicContentSize()
            lblFloatPlaceholder.text = placeholderFinal
        }
    }
    
    public var animateFloatPlaceholder:Bool = true
    
    public var floatPlaceholderFont = UIFont.systemFont(ofSize: 12.0){
        didSet{
            invalidateIntrinsicContentSize()
            self.lblFloatPlaceholder.font = floatPlaceholderFont
        }
    }
    
    public var paddingYFloatLabel:CGFloat = 3.0{
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var paddingYErrorLabel:CGFloat = 3.0{
        didSet{ invalidateIntrinsicContentSize() }
    }
    
    public var borderColor:UIColor = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0){
        didSet{ dtLayer.borderColor = borderColor.cgColor }
    }
    public var rightImage:UIImage? = nil {
        didSet{
            if rightImage != nil {
                let viRight = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: self.bounds.height))
                viRight.image = rightImage
                viRight.contentMode = .scaleAspectFit
                viRight.tag = 5001
                if viRight.bounds.size.width > (rightImage?.size.width)! && viRight.bounds.size.height > (rightImage?.size.height)! {
                    viRight.contentMode = .center
                }
                viRight.contentMode = .center
                self.rightView = viRight
                self.rightViewMode = .always
            } else {
                
            }
        }
    }
    
    public var canShowBorder:Bool = true {
        didSet{ dtLayer.isHidden = !canShowBorder }
    }
    
    public var placeholderColor:UIColor?{
        didSet{
            guard let color = placeholderColor else { return }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSAttributedString.Key.foregroundColor:color])
        }
    }
    
    fileprivate var x:CGFloat {
        
        if let leftView = leftView {
            return leftView.frame.origin.x + leftView.bounds.size.width + paddingX
        }
        
        return paddingX
    }
    
    fileprivate var fontHeight:CGFloat{
        return ceil(font!.lineHeight)
    }
    fileprivate var dtLayerHeight:CGFloat{
        return bounds.height
    }
    fileprivate var floatLabelWidth:CGFloat{
        
        var width = bounds.size.width
        
        if let leftViewWidth = leftView?.bounds.size.width{
            width -= leftViewWidth
        }
        
        if let rightViewWidth = rightView?.bounds.size.width {
            width -= rightViewWidth
        }
        
        return width - (self.x * 2)
    }
    fileprivate var placeholderFinal: String {
        //if let attributed = attributedPlaceholder { return attributed.string }
        return title.count > 0 ? title : (placeholder ?? " ")
    }
    
    fileprivate var isFloatLabelShowing:Bool = false
    
    override public var borderStyle: UITextField.BorderStyle{
        didSet{
            guard borderStyle != oldValue else { return }
            borderStyle = .none
        }
    }
    public override var text: String?{
        didSet {
            
        }
    }
    
    override public var placeholder: String?{
        didSet {
            guard let color = placeholderColor else {
                lblFloatPlaceholder.text = placeholderFinal
                return
            }
            attributedPlaceholder = NSAttributedString(string: placeholderFinal,
                                                       attributes: [NSAttributedString.Key.foregroundColor:color])
        }
    }
    
    override public var attributedPlaceholder: NSAttributedString?{
        didSet {
            lblFloatPlaceholder.text = placeholderFinal
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        
        dtLayer.cornerRadius        = 4.5
        dtLayer.borderWidth         = 0.5
        dtLayer.borderColor         = borderColor.cgColor
        dtLayer.backgroundColor     = UIColor.white.cgColor
        
        floatPlaceholderColor       = UIColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        floatPlaceholderActiveColor = tintColor
        lblFloatPlaceholder.frame   = CGRect.zero
        lblFloatPlaceholder.alpha   = 0.0
        lblFloatPlaceholder.font    = floatPlaceholderFont
        lblFloatPlaceholder.text    = placeholderFinal
        lblFloatPlaceholder.backgroundColor = UIColor.white
        
        addSubview(lblFloatPlaceholder)
        //        addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        
        layer.insertSublayer(dtLayer, at: 0)
    }
    
    fileprivate func showFloatingLabel(_ animated:Bool) {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 1.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.lblFloatPlaceholder.frame.origin.x,
                                                    y:-(self.lblFloatPlaceholder.bounds.size.height / 2),//self.paddingYFloatLabel,
                width: self.lblFloatPlaceholder.bounds.size.width,
                height: self.lblFloatPlaceholder.bounds.size.height)
            
        }
        
        if animated && animateFloatPlaceholder {
            UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                           delay: 0.0,
                           options: [.beginFromCurrentState,.curveEaseOut],
                           animations: animations){ status in
                            DispatchQueue.main.async {
                                self.layoutIfNeeded()
                            }
            }
        }else{
            animations()
        }
    }
    
    fileprivate func hideFlotingLabel(_ animated:Bool) {
        
        let animations:(()->()) = {
            self.lblFloatPlaceholder.alpha = 0.0
            self.lblFloatPlaceholder.frame = CGRect(x: self.lblFloatPlaceholder.frame.origin.x,
                                                    y: self.lblFloatPlaceholder.font.lineHeight,
                                                    width: self.lblFloatPlaceholder.bounds.size.width,
                                                    height: self.lblFloatPlaceholder.bounds.size.height)
            self.lblFloatPlaceholder.transform = CGAffineTransform.identity
        }
        
        if animated && animateFloatPlaceholder {
            UIView.animate(withDuration: floatingLabelShowAnimationDuration,
                           delay: 0.0,
                           options: [.beginFromCurrentState,.curveEaseOut],
                           animations: animations){ status in
                            DispatchQueue.main.async {
                                self.layoutIfNeeded()
                            }
            }
        }else{
            animations()
        }
    }
    
    fileprivate func insetRectForEmptyBounds(rect:CGRect) -> CGRect{
        
        return CGRect(x: x, y: 0, width: rect.width - paddingX, height: rect.height)
    }
    
    fileprivate func insetRectForBounds(rect:CGRect) -> CGRect {
        
        guard let placeholderText = lblFloatPlaceholder.text,!placeholderText.isEmptyStr  else {
            return insetRectForEmptyBounds(rect: rect)
        }
        
        if floatingDisplayStatus == .never {
            return insetRectForEmptyBounds(rect: rect)
        }else{
            
            if let text = text,text.isEmptyStr && floatingDisplayStatus == .defaults {
                return insetRectForEmptyBounds(rect: rect)
            }else{
                let topInset = paddingYFloatLabel + lblFloatPlaceholder.bounds.size.height + (paddingHeight / 2.0)
                let textOriginalY = (rect.height - fontHeight) / 2.0
                let textY = topInset - textOriginalY
                //ceil(textY)
                return CGRect(x: x, y: rect.origin.y + 2 , width: rect.size.width - paddingX, height: rect.height)
            }
        }
    }
    override public var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        
        let textFieldIntrinsicContentSize = super.intrinsicContentSize
        
        return CGSize(width: textFieldIntrinsicContentSize.width,
                      height: textFieldIntrinsicContentSize.height + paddingYFloatLabel + paddingHeight) //textFieldIntrinsicContentSize.height + paddingYFloatLabel + lblFloatPlaceholder.bounds.size.height + paddingHeight)
        
    }
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return insetRectForBounds(rect: rect)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return insetRectForBounds(rect: rect)
    }
    
    fileprivate func insetForSideView(forBounds bounds: CGRect) -> CGRect{
        var rect = bounds
        rect.origin.y = 0
        rect.size.height = dtLayerHeight
        return rect
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return insetForSideView(forBounds: rect)
    }
    
    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.clearButtonRect(forBounds: bounds)
        rect.origin.y = (dtLayerHeight - rect.size.height) / 2
        return rect
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        dtLayer.frame = CGRect(x: bounds.origin.x,
                               y: bounds.origin.y,
                               width: bounds.width,
                               height: dtLayerHeight)
        CATransaction.commit()
        
        let floatingLabelSize = lblFloatPlaceholder.sizeThatFits(lblFloatPlaceholder.superview!.bounds.size)
        
        lblFloatPlaceholder.frame = CGRect(x: x, y: lblFloatPlaceholder.frame.origin.y,
                                           width: floatingLabelSize.width,
                                           height: floatingLabelSize.height)
        
        lblFloatPlaceholder.textColor = isFirstResponder ? floatPlaceholderActiveColor : floatPlaceholderColor
        
        switch floatingDisplayStatus {
        case .never:
            hideFlotingLabel(isFirstResponder)
        case .always:
            showFloatingLabel(isFirstResponder)
        default:
            if let enteredText = text,!enteredText.isEmptyStr{
                showFloatingLabel(isFirstResponder)
            }else{
                hideFlotingLabel(isFirstResponder)
            }
        }
    }
    
}
