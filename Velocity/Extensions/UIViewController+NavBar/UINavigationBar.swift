//
//  UINavigationBar.swift
//  LynkedWorld
//
//  Created by Macbook on 17/11/17.
//  Copyright © 2017 Arusys. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    func setGradientBackground(colors: [(color:UIColor, position:Float)]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
        
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomBorderView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
    }
    
    func getGradientImage(colors: [(color:UIColor, position:Float)]) -> UIImage? {
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        return gradientLayer.creatGradientImage()
    }
    
}

//extension UINavigationController {
//
//    func backToViewController(vc: Any) {
//        // iterate to find the type of vc
//        for element in viewControllers as Array {
//
//            if type(of: element) == type(of: vc) {
//                self.popToViewController(element, animated: true)
//                break
//            }
//
////            if "\(element.dynamicType).Type" == "\(vc.dynamicType)" {
////                self.popToViewController(element, animated: true)
////                break
////            }
//        }
//    }
//
//}

