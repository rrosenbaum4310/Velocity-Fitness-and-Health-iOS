//
//  LWAvatarImageView.swift
//  LynkedWorld
//
//  Created by Macbook on 23/11/17.
//  Copyright © 2017 Arusys. All rights reserved.
//

import UIKit

//@IBDesignable
class LWAvatarImageView: UIImageView {

    @IBInspectable var roundness: CGFloat = 2 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blue {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable var background: UIColor = UIColor.clear {
        didSet{
            setNeedsLayout()
        }
    }
    @IBInspectable var fontSize: CGFloat = 20 {
        didSet {
            manageTextLayer()
        }
    }
    
    @IBInspectable var fontColor: UIColor = UIColor.white {
        didSet {
            manageTextLayer()
        }
    }
    
    @IBInspectable var text: String = "" {
        didSet{
           manageTextLayer()
        }
    }
    
    func manageTextLayer() {
        if text.removeWhiteSpace().count > 0 {
            if let _ = textLayer.superlayer {
                textLayer.removeFromSuperlayer()
            }
            textLayer.frame = self.bounds
            
            // 3

            
            let myAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: fontSize)! , // font
                NSAttributedString.Key.foregroundColor: fontColor
                ]
            // ,                   // text color
            //NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue
            let attributeString = NSAttributedString(string: text, attributes: myAttributes)
            
            textLayer.string = attributeString //text
            
            // 4
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.isWrapped = true
            textLayer.alignmentMode = CATextLayerAlignmentMode.center
            textLayer.contentsScale = UIScreen.main.scale
            self.layer.addSublayer(textLayer)
            
        } else {
            textLayer.removeFromSuperlayer()
        }
    }
    
    fileprivate let textLayer = LWTextLayer()
    
    
    
    init(size:CGFloat = 200, roundess:CGFloat = 2, borderWidth:CGFloat = 5, borderColor:UIColor = UIColor.blue, background:UIColor = UIColor.clear){
        self.roundness = roundess
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.background = background
        
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    func initialSetup() {
        
//        self.isUserInteractionEnabled = true
//        
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
//        tapRecognizer.delegate = self as? UIGestureRecognizerDelegate
//        tapRecognizer.numberOfTapsRequired = 1
//        tapRecognizer.numberOfTouchesRequired = 1
//        self.addGestureRecognizer(tapRecognizer)
        
         setNeedsLayout()
        
    }
   
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
     
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / roundness
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.backgroundColor = background.cgColor
        clipsToBounds = true
        
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: bounds.width / roundness)
        let mask = CAShapeLayer()
        
        mask.path = path.cgPath
        layer.mask = mask
        
        manageTextLayer()
        
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
