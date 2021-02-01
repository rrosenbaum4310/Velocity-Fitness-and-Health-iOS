//
//  StringExtension.swift
//  MMS
//
//  Created by iOS3 on 11/07/17.
//  Copyright © 2017 iOS3. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    
    //MARK:-
    /**
        Encode URL String by adding percent encoding
        - Returns: Encoded string
     */
    func encodeURLString() -> String {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }

    /**
        Decode URL String by removing percent encoding
        - Returns: Decoded string
     */
    func decodeURLString() -> String {
        return self.removingPercentEncoding!
    }
    
    /**
        Remove white space from string
        - Returns: String
     */
    func removeWhiteSpace() -> String {
        let str = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return str
    }
    
    //MARK:-
    /**
        Check for Valid Email string or not
        - Returns: Return true if its valid email else false
     */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /**
        Check for valid URL or not
        - Returns: Return true if its valid url else false
     */
    func isValidURL() -> Bool {
        let urlRegEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: self)
    }
    
        
    func isValidForUrl() -> Bool {
        
        if(self.hasPrefix("http") || self.hasPrefix("https")){
            return true
        }
        return false
    }
    func verifyUrl() -> Bool {
        // create NSURL instance
        if let url = URL(string: self) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    //MARK:-
    /**
        Convert double String into Date
        - Returns: Date
     */
    func convertIntoDate() -> Date? {
        if let timeStamp = Double(self) {
            return Date(timeIntervalSince1970: TimeInterval(timeStamp / 1000))
        }
        return nil
    }
    
    /**
        Convert String into Date
        - Parameters:
            - format: format of date
        - Returns: return Date if its in proper format else nil
     */
    func convertIntoDate(format strFormat:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    
    /**
     Get Height of string
     - Returns: CGFloat value
     */
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    /**
     Get Height of string
     - Returns: CGFloat value
     */
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width) + 10
    }
    
    /**
     Get Range of string
     - Returns: NSRange
     */
//    func nsRange(from range: Range<Index>) -> NSRange {
//        let lower = UTF16View.Index(range.lowerBound, within: utf16)
//        let upper = UTF16View.Index(range.upperBound, within: utf16)
//        return NSRange(location: utf16.startIndex.distance(to: lower), length: lower!.distance(to: upper))
//    }
//    
//    func convertIntoAttributed() -> NSMutableAttributedString {
//    
//        let data = self.data(using: .utf8)!
//        let att = try! NSAttributedString.init(
//            data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//            documentAttributes: nil)
//        let matt = NSMutableAttributedString(attributedString:att)
//        matt.trimmingWhiteSpace()
//        matt.enumerateAttribute(
//            NSFontAttributeName,
//            in:NSMakeRange(0,matt.length),
//            options:.longestEffectiveRangeNotRequired) { value, range, stop in
//                let f1 = value as! UIFont
//                let f2 = UIFont(name:"OpenSans", size:14)!
//                if let f3 = applyTraitsFromFont(f1, to:f2) {
//                    matt.addAttribute(
//                        NSFontAttributeName, value:f3, range:range)
//                }
//        }
//        return matt
//    }
//
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
    
    func convertIntoAttributed(fontSize: CGFloat) -> NSMutableAttributedString {
        //let resultString = self.replacingOccurrences(of:".*<img\\b[^>]+\\bsrc=\"([^\"]*)\"[^>]*>.*" , with: "", options: [String.CompareOptions.caseInsensitive, String.CompareOptions.regularExpression], range: self.range(of: self))
        let str = self.replacingOccurrences(of: "\n", with: "<br />")
        let data = str.data(using: .utf8)!
        let att = try? NSAttributedString.init(
            data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
       // Modified by
        var matt = NSMutableAttributedString(attributedString:att ?? NSAttributedString.init(string: ""))
        matt = matt.trimmedAttributedString(set: CharacterSet.whitespacesAndNewlines)
        matt.enumerateAttribute(
            NSAttributedString.Key.font,
            in:NSMakeRange(0,matt.length),
            options:.longestEffectiveRangeNotRequired) { value, range, stop in
                let f1 = value as! UIFont
                let f2 = UIFont(name:"OpenSans", size:fontSize)!
                if let f3 = applyTraitsFromFont(f1, to:f2) {
                    matt.addAttribute(
                        NSAttributedString.Key.font, value:f3, range:range)
                }
        }
        return matt
    }
    
    func convertIntoAttributed(font: UIFont) -> NSMutableAttributedString {
        
        let data = self.data(using: .utf8)!
        let att = try! NSAttributedString.init(
            data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        var matt = NSMutableAttributedString(attributedString:att)
        matt = matt.trimmedAttributedString(set: CharacterSet.whitespacesAndNewlines)
        matt.enumerateAttribute(
            NSAttributedString.Key.font,
            in:NSMakeRange(0,matt.length),
            options:.longestEffectiveRangeNotRequired) { value, range, stop in
                let f1 = value as! UIFont
                let f2 = font //UIFont(name:"OpenSans", size:fontSize)!
                if let f3 = applyTraitsFromFont(f1, to:f2) {
                    matt.addAttribute(
                        NSAttributedString.Key.font, value:f3, range:range)
                }
        }
        return matt
    }
    
    func convertIntoAttributed(font: UIFont, isUnderlineRemoved: Bool) -> NSMutableAttributedString {
        
        let data = self.data(using: .utf8)!
        let att = try! NSAttributedString.init(
            data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        var matt = NSMutableAttributedString(attributedString:att)
        matt = matt.trimmedAttributedString(set: CharacterSet.whitespacesAndNewlines)
        matt.enumerateAttribute(
            NSAttributedString.Key.font,
            in:NSMakeRange(0,matt.length),
            options:.longestEffectiveRangeNotRequired) { value, range, stop in
                let f1 = value as! UIFont
                let f2 = font //UIFont(name:"OpenSans", size:fontSize)!
                if let f3 = applyTraitsFromFont(f1, to:f2) {
                    matt.addAttribute(
                        NSAttributedString.Key.font, value:f3, range:range)
                }
        }
        if isUnderlineRemoved {
            matt.enumerateAttribute(NSAttributedString.Key.underlineStyle, in: NSMakeRange(0,matt.length), options: .longestEffectiveRangeNotRequired) { (value, range, stop) in
                if (value != nil) {
                    matt.addAttribute(NSAttributedString.Key.underlineStyle, value: 0, range: range)
                    //[res addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleNone) range:range];
                }
            }
        }
        
        return matt
    }
    
    
    
    func convertIntoAttributed(font: UIFont , completionHandler:@escaping ( NSMutableAttributedString ) -> ())  {
        
      DispatchQueue.global(qos: .background).async {
        
            let data = self.data(using: .utf8)!
        let att = try! NSAttributedString.init(
            data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        var matt = NSMutableAttributedString(attributedString:att)
        matt = matt.trimmedAttributedString(set: CharacterSet.whitespacesAndNewlines)
        matt.enumerateAttribute(
            NSAttributedString.Key.font,
            in:NSMakeRange(0,matt.length),
            options:.longestEffectiveRangeNotRequired) { value, range, stop in
                let f1 = value as! UIFont
                let f2 = font //UIFont(name:"OpenSans", size:fontSize)!
                if let f3 = self.applyTraitsFromFont(f1, to:f2) {
                    matt.addAttribute(
                        NSAttributedString.Key.font, value:f3, range:range)
                }
        }
       
            completionHandler(matt)
            
        }
        
    }
    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    func convertHtml(font: UIFont) -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        
        guard let attr = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) else {
               return NSAttributedString()
            }
        var attrs = attr.attributes(at: 0, effectiveRange: nil)
        attrs[NSAttributedString.Key.font] = font
        attr.setAttributes(attrs, range: NSRange(location: 0, length: attr.length))
            
        return NSAttributedString(attributedString: attr)
    }

     func applyTraitsFromFont(_ f1: UIFont, to f2: UIFont) -> UIFont? {
        let t = f1.fontDescriptor.symbolicTraits
        if let fd = f2.fontDescriptor.withSymbolicTraits(t) {
            return UIFont.init(descriptor: fd, size: 0)
        }
        return nil
    }
    
    func stripHTMLTag() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text ?? self
    }
    func encode() -> String {
        let data = self.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    func decode() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
}

extension String {
    var pairs: [String] {
        var result: [String] = []
        let characters = Array(self)
        stride(from: 0, to: count, by: 2).forEach {
            result.append(String(characters[$0..<min($0+2, count)]))
        }
        return result
    }
    mutating func insert(separator: String, every n: Int) {
        self = inserting(separator: separator, every: n)
    }
    func inserting(separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        stride(from: 0, to: count, by: n).forEach {
            result += String(characters[$0..<min($0+n, count)])
            if $0+n < count {
                result += separator
            }
        }
        return result
    }
}

extension NSAttributedString {
    
    var trailingNewlineChopped: NSAttributedString {
        if string.hasSuffix("\n") {
            return self.attributedSubstring(from: NSRange(location: 0, length: length - 1))
        } else {
            return self
        }
    }
}
public extension String {
    
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
}
