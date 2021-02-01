//
//  VFHGradientButton.swift
//  
//
//  Created by Vishal Gohel on 09/08/18.
//  Copyright © 2018 Arusys. All rights reserved.
//

import UIKit

class VFHGradientButton: UIButton {

//    @IBInspectable var cornerRadius: CGFloat = 0 {
//        didSet {
//            setup()
//        }
//    }
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
    @IBInspectable var isGradientLayer: Bool = false {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var gradientColor: UIColor = .clear {
        didSet {
            setup()
        }
    }
    
    
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    @IBInspectable var animColor: UIColor = UIColor.blue
    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
        initialSetup()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
        initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func initialSetup() {
        
        //        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.addPulse))
        //        tapGestureRecogniser.numberOfTapsRequired = 1
        //        self.addGestureRecognizer(tapGestureRecogniser)
    }
    
    @objc func addPulse() {
        let pulse = Pulsing(numberOfPulses: 1, radius: self.bounds.height, position: CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2))
        pulse.animationDuration = 0.8
        pulse.backgroundColor = animColor.cgColor // UIColor.blue.cgColor
        
        self.layer.insertSublayer(pulse, below: self.titleLabel?.layer)
    }
    
    func setup() {
        
        let cornerRadius = self.bounds.height / 2
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius > 0
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = CGFloat(borderWidth)
        if isGradientLayer {
            setupView()
        } else {
            gradientLayer.colors = []
        }
        
    }
    private func setupView(){
        
        let dColor = gradientColor //(color: UIColor(hex: "0072bc"), position: Float(0.0))
        //let mColor = (color: UIColor(hex: "228fd6"), position: Float(0.5))
        if let lColor = gradientColor.lighter() {
            gradientLayer.colors = [dColor.cgColor, lColor.cgColor]
        }
        
       // gradientLayer.locations = [NSNumber(value: dColor.position), NSNumber(value: mColor.position), NSNumber(value: lColor.position)]
        
        //gradientLayer.locations  = [0, 1.0]//[0, 0.25]
        
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.setNeedsDisplay()
    }
    func jumpingAnimation() {
        
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration:0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: { [weak self] in
                        self?.transform = .identity
            },
                       completion: nil)
    }
    


}
