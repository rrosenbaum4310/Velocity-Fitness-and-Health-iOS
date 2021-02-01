//
//  NSAttributedString+HTML.swift
//  ServSearch
//
//  Created by Vishal Gohel on 9/19/17.
//  Copyright © 2017 Vishal Gohel. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
//    public convenience init?(HTMLString html: String, font: UIFont? = nil) throws {
//        
//        let options: [String: Any] = [
//            NSDocumentTypeDocumentAttribute.rawValue: NSHTMLTextDocumentType,
//            NSCharacterEncodingDocumentAttribute: NSNumber(value: String.Encoding.utf8.rawValue)
//        ]
//        
//        guard let data = html.data(using: .utf8, allowLossyConversion: true) else {
//            throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
//        }
//        
//        
//        if let font = font {
//            guard let attr = try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil) else {
//                throw NSError(domain: "Parse Error", code: 0, userInfo: nil)
//            }
//            var attrs = attr.attributes(at: 0, effectiveRange: nil)
//            attrs[NSFontAttributeName] = font
//            attr.setAttributes(attrs, range: NSRange(location: 0, length: attr.length))
//            self.init(attributedString: attr)
//        } else {
//            try? self.init(data: data, options: options, documentAttributes: nil)
//        }
//        
//    }
    
}

extension NSMutableAttributedString {
    func trimmedAttributedString(set: CharacterSet) -> NSMutableAttributedString {
        
        let invertedSet = set.inverted
        
        var range = (string as NSString).rangeOfCharacter(from: invertedSet)
        let loc = range.length > 0 ? range.location : 0
        
        range = (string as NSString).rangeOfCharacter(
            from: invertedSet, options: .backwards)
        let len = (range.length > 0 ? NSMaxRange(range) : string.count) - loc
        
        let r = self.attributedSubstring(from: NSMakeRange(loc, len))
        return NSMutableAttributedString(attributedString: r)
    }
}
