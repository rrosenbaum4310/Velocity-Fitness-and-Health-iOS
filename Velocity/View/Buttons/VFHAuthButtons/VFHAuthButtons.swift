//
//  VFHAuthButtons.swift
//
//
//  Created by Macbook on 13/12/17.
//  Copyright © 2017 Arusys. All rights reserved.
//

import UIKit

class VFHAuthButtons: UIButton {
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
