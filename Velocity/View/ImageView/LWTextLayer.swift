//
//  LWTextLayer.swift
//  LynkedWorld
//
//  Created by eash on 16/01/18.
//  Copyright © 2018 Arusys. All rights reserved.
//

import UIKit

class LWTextLayer: CATextLayer {
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
         super.init(layer: layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(layer: aDecoder)
    }
    
//    override func draw(in ctx: CGContext) {
//        let height = self.bounds.size.height
//        let fontSize = self.fontSize
//        let yDiff = (height-fontSize)/2 - fontSize/10
//
//        ctx.saveGState()
//        ctx.translateBy(x: 0.0, y: yDiff)
//        super.draw(in: ctx)
//        ctx.restoreGState()
//    }
    
    override open func draw(in ctx: CGContext) {
        var yDiff: CGFloat
        let fontSize: CGFloat
        let height = self.bounds.height
        
        if let attributedString = self.string as? NSAttributedString {
            fontSize = attributedString.size().height
            yDiff = (height-fontSize)/2
        } else {
            fontSize = self.fontSize
            yDiff = (height-fontSize)/2 - fontSize/10
        }
        
        ctx.saveGState()
        ctx.translateBy(x: 0.0, y: yDiff)
        super.draw(in: ctx)
        ctx.restoreGState()
    }
    
}
