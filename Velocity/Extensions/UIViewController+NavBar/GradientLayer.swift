//
//  GradientLayer.swift
//  LynkedWorld
//
//  Created by Macbook on 17/11/17.
//  Copyright © 2017 Arusys. All rights reserved.
//

import UIKit
extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [(color:UIColor, position:Float)]) {
        self.init()
        self.frame = frame
        self.colors = []
        for data in colors {
            self.colors?.append(data.color.cgColor)
            self.locations?.append(NSNumber(value: data.position))
        }
        startPoint = CGPoint(x: 0, y: 0.5)
        endPoint = CGPoint(x: 1, y: 0.5)
//        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
//        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}
