
//
//  Extenstion.swift
//  IBN
//
//  Created by Naitik Patel on 04/12/15.
//  Copyright © 2015 Naitik Patel. All rights reserved.
//


import UIKit
import Alamofire
import AlamofireImage


extension Request {
    public func debugLog() -> Self {
        debugPrint("API Name :::::::::::::::::: %@",self.request!.url!,terminator: "\n\n")
        debugPrint(self)
        debugPrint(terminator:"\n\n")
        return self
    }
    
    static var acceptableImageContentTypes: Set<String> = [
        "image/tiff",
        "image/jpeg",
        "image/gif",
        "image/png",
        "image/ico",
        "image/x-icon",
        "image/bmp",
        "image/x-bmp",
        "image/x-xbitmap",
        "image/x-win-bitmap"
    ]
}
extension Float {
    var stringZeroDecimal:String{
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIColor {
    
    convenience init(clearRed:CGFloat,clearGreen:CGFloat,clearBlue:CGFloat){
        
        self.init(red: clearRed/255.0, green: clearGreen/255.0, blue: clearBlue/255, alpha: 1)
    }
}

extension UIImageView {
    func af_setImage(_ withURL: URL,placeholderImage:UIImage?) -> Void {
        
        
        self.af_setImage(withURL: withURL, placeholderImage: placeholderImage, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)
    }
}

extension UIImage {
    
   
    
    func resizeToWidth(_ width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func resizeToHeight(_ height:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: CGFloat(ceil(size.width * size.height/height)), height: height)))
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}
extension UILabel {
    func toAddPadding() -> Void {
        let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        self.drawText(in: self.frame.inset(by: insets))
//        self.drawText(in: UIEdgeInsetsInsetRect(self.frame, insets))
    }
    
    func heightWithAttributedWidth(_ width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else {
            return 0
        }
        return attributedText.heightWithWidth(width)
    }
    
    func truncateNumbers(_ length:Int) -> String {
        
        var concatedString = ""
        let labelText = self.text ?? ""
        
        if(labelText.isEmpty)
        {
            concatedString = ""
        }
        else
        {
            if(labelText.count > length)
            {
                if(labelText.count > 4)
                {
                    concatedString = "9999+"
                }
                else if(labelText.count > 3)
                {
                    concatedString = "999+"
                }
                else if(labelText.count > 2)
                {
                    concatedString = "99+"
                }
                else if(labelText.count > 1)
                {
                    concatedString = "9+"
                }
            }
            else
            {
                concatedString = labelText
            }
        }
        return concatedString
        
    }
    
    
    func setHTMLText(htmlString:String, font: UIFont )  {
      
        DispatchQueue.global(qos: .background).async {
            
        let data = htmlString.data(using: .utf8)!
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
                if let f3 = htmlString.applyTraitsFromFont(f1, to:f2) {
                    matt.addAttribute(
                        NSAttributedString.Key.font, value:f3, range:range)
                }
        }
        
          DispatchQueue.main.async {
            self.attributedText = matt
        }
            
     }
 }
    
}

extension NSAttributedString {
    func heightWithWidth(_ width: CGFloat) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return actualSize.height
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
}

extension Int {
    func toString() -> String? {
        return String(format:"%d",self)
    }
    
    func toAbs() -> Int {
        return abs(self)
    }
}

extension String {
    
    func truncateNumbers(_ length:Int) -> String {
        
        var concatedString = ""
        let labelText =  self 
        
        if(labelText.isEmpty)
        {
            concatedString = ""
        }
        else
        {
            if(labelText.count > length)
            {
                if(length == 4)
                {
                    concatedString = "9999+"
                }
                else if(length == 3)
                {
                    concatedString = "999+"
                }
                else if(length == 2)
                {
                    concatedString = "99+"
                }
                else if(length == 1)
                {
                    concatedString = "9+"
                }
            }
            else
            {
                concatedString = labelText
            }
        }
        return concatedString
        
    }
    
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    func toDoubleValue() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toFloat() -> Float? {
        return Float(self)
    }
    
    public var toJsonArray: [AnyObject]?{
        return (try? JSONSerialization.jsonObject(with: self.data(using: String.Encoding.utf8, allowLossyConversion: false)!, options: JSONSerialization.ReadingOptions.allowFragments)) as? [AnyObject]
        
    }
    
  

    public func isValidPhone() -> Bool {
//        let PHONE_REGEX = "^\\+?[1-9]\\d{4,14}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
//        let result =  phoneTest.evaluateWithObject(self)
//        return result
        
        let regex = try? NSRegularExpression(pattern: "^\\+?[1-9]\\d{4,14}$", options: .caseInsensitive)
        return regex?.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
  
    public var toThumbURL: URL?{
        
        var url:URL?
        if(self != "")
        {
            var escapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            url = URL.init(string: escapedString)
            
            let strLastPathComponent = url?.lastPathComponent
            var strImagePath = (url?.deletingLastPathComponent().absoluteString)!
            strImagePath = strImagePath + "thumb_small/"
            strImagePath = strImagePath + strLastPathComponent!
            escapedString = strImagePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            url = URL.init(string: escapedString)
        }
        else
        {
            url = URL.init(string:"a")
        }
        return url
        
        
    }
    
    public var toURL: URL?{
        
        var url:URL?
        if(self != "")
        {
            var escapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            url = URL.init(string: escapedString)
            let strLastPathComponent = url?.lastPathComponent
            var strImagePath = (url?.deletingLastPathComponent().absoluteString)!
            strImagePath = strImagePath + "medium/"
            strImagePath = strImagePath + strLastPathComponent!
            escapedString = strImagePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            url = URL.init(string: escapedString)
        }
        else
        {
            url = URL.init(string:"a")
        }
        return url
        
        
    }
    
    public var toLargeURL: URL?{
        
        var url:URL?
        if(self != "")
        {
            var escapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            url = URL.init(string: escapedString)
            let strLastPathComponent = url?.lastPathComponent
            var strImagePath = (url?.deletingLastPathComponent().absoluteString)!
            strImagePath = strImagePath + "large/"
            strImagePath = strImagePath + strLastPathComponent!
            escapedString = strImagePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            url = URL.init(string: escapedString)
        }
        else
        {
            url = URL.init(string:"a")
        }
        return url
        
        
    }
    
    
    public var toOriginalURL: URL?{
        
        var url:URL?
        if(self != "")
        {
            let escapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            url = URL.init(string: escapedString)
//            let strLastPathComponent = url?.lastPathComponent
//            var strImagePath = (url?.URLByDeletingLastPathComponent?.absoluteString)!
//            strImagePath = strImagePath.stringByAppendingString("medium/")
//            strImagePath = strImagePath.stringByAppendingString(strLastPathComponent!)
//            escapedString = strImagePath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            url = NSURL.init(string: escapedString)
        }
        else
        {
            url = URL.init(string:"a")
        }
        return url
        
        
    }

}


extension UIViewController {
    
    func isUIViewControllerPresentedAsModal() -> Bool {
        if((self.presentingViewController) != nil) {
            return true
        }
        
        if(self.presentingViewController?.presentedViewController == self) {
            return true
        }
        
        if(self.navigationController?.presentingViewController?.presentedViewController == self.navigationController) {
            return true
        }
        
        if((self.tabBarController?.presentingViewController?.isKind(of: UITabBarController.self)) != nil) {
            return true
        }
        
        return false
    }
}

extension UITextView {
    public func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.10
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}

extension Foundation.Date {
    
    public func getDateWithFormate(_ formate:String)->String!{

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = formate
        let date = dateFormatter.string(from: self)
        return date
    }
    public static func convertStringToGiventformate(_ dateinString:String,currntStringForamte:String,convertedtoformate:String)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = currntStringForamte
        return dateFormatter.date(from: dateinString)?.getDateWithFormate(convertedtoformate) ?? dateinString
        
    }
    public static func convertStringToGiventformateInDate(_ dateinString:String,currntStringForamte:String)->Foundation.Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = currntStringForamte
        return dateFormatter.date(from: dateinString) ?? Foundation.Date()
        
    }
    
    var age:Int {
        return (Calendar.current as NSCalendar).components(.year, from: self, to: Foundation.Date(), options:.wrapComponents).year!
    }
    
    func yearsFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func daysFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Foundation.Date) -> Int{
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    func offsetFrom(_ date:Foundation.Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }


}

extension Foundation.Date {
    func isGreaterThanDate(_ dateToCompare: Foundation.Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(_ dateToCompare: Foundation.Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(_ dateToCompare: Foundation.Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func addDays(_ daysToAdd: Int) -> Foundation.Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Foundation.Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
    func addHours(_ hoursToAdd: Int) -> Foundation.Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Foundation.Date = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Foundation.Date {
        let timezone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: TimeInterval = TimeInterval(timezone.secondsFromGMT(for: self))
        return Foundation.Date(timeInterval: seconds, since: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Foundation.Date {
        let timezone: TimeZone = TimeZone.autoupdatingCurrent
        let seconds: TimeInterval = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Foundation.Date(timeInterval: seconds, since: self)
    }
}

//extension NSLayoutConstraint {
//    
//    override public var description: String {
//        let id = identifier ?? ""
//        return "id: \(id), constant: \(constant)" //you may print whatever you want here
//    }
//}

extension UITextField{
    

    
    public func setLeftImgViewWithTheme(_ imgName:String!)->Void{
        
        self.layoutIfNeeded()
        let leftViewForImg = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height))
        let imgView = UIImageView(image: UIImage(named: imgName)!)
        imgView.frame = CGRect(x: 0, y: 0, width: leftViewForImg.frame.size.width - (leftViewForImg.frame.size.width/2), height: leftViewForImg.frame.size.height - (leftViewForImg.frame.height/2))
        imgView.center = leftViewForImg.center
        imgView.contentMode = .scaleAspectFit
        leftViewForImg.addSubview(imgView)
        self.leftView = leftViewForImg
        self.leftViewMode = .always
        
    }
    

    
}


extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(_ label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension UIScreen {
    
    enum SizeType: CGFloat {
        case unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 1920.0
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .unknown }
        return sizeType
    }
}

extension Array {
  
//    mutating func removeObject<U: AnyObject>(object: U) -> Element? {
//        if count > 0 {
//            for index in startIndex ..< endIndex {
//                if (self[index] as! U) === object
//                {
//                    return self.removeAtIndex(index)
//                }
//            }
//        }
//        return nil
//    }

 
  
    mutating func removeObjectFromArray<T>(_ obj: T) where T : Equatable {
        self = self.filter({$0 as? T != obj})
    }
 
    func contains<T>(_ obj: T) -> Bool where T : Equatable {
            return self.filter({$0 as? T == obj}).count > 0
    }
    
    func containsObject(object: Any) -> Bool
    {
        if let anObject: AnyObject = object as? AnyObject
        {
            for obj in self
            {
                if let anObj: AnyObject = obj as? AnyObject
                {
                    if anObj === anObject { return true }
                }
            }
        }
        return false
    }
    
    
}
extension Dictionary {
    
    public var toJsonString: String?{
        return NSString(data:try! JSONSerialization.data(withJSONObject: self as AnyObject, options: JSONSerialization.WritingOptions.prettyPrinted), encoding:String.Encoding.utf8.rawValue) as String?
        
    }
    
}
extension UIButton {
    
    //    This method sets an image and title for a UIButton and
    //    repositions the titlePosition with respect to the button image.
    //    Add additionalSpacing between the button image & title as required
    //    For titlePosition, the function only respects UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft and UIViewContentModeRight
    //    All other titlePositions are ignored
    @objc func set(image anImage: UIImage?, title: NSString!, titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        self.imageView?.contentMode = .center
        self.setImage(anImage, for: state)
        
        positionLabelRespectToImage(title!, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .center
        self.setTitle(title! as String, for: state)
    }
    
    fileprivate func positionLabelRespectToImage(_ title: NSString, position: UIView.ContentMode, spacing: CGFloat) {
        let imageSize = self.imageRect(forContentRect: self.frame)
        let titleFont = self.titleLabel?.font!
        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height/2 + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: -(imageSize.height/2), left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
    
    func af_setBackgroundImageForState(_ state:UIControl.State, URL: URL!, placeHolderImage: UIImage?) {
        
        self.af_setBackgroundImage(for: state, url: URL, placeholderImage: placeHolderImage, filter: nil, progress: nil, progressQueue: DispatchQueue.main, completion: nil)
    }
    
}
extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }


}

extension UITableView {
    //set the tableHeaderView so that the required height can be determined, update the header's frame and set it again
    func setAndLayoutTableHeaderView(_ header: UIView) {
        self.tableHeaderView = header
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let height = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let width = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width

        var frame = header.frame
        frame.size.height = height
        frame.size.width = width

        header.frame = frame
        self.tableHeaderView = header
    }
}

extension UIGestureRecognizer {
    fileprivate class GestureAction {
        var action: (UIGestureRecognizer) -> Void
        
        init(action: @escaping (UIGestureRecognizer) -> Void) {
            self.action = action
        }
    }
    
    fileprivate struct AssociatedKeys {
        static var ActionName = "action"
    }
    
    fileprivate var gestureAction: GestureAction? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionName, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionName) as? GestureAction }
    }
    
    
    /**
     Convenience initializer, associating an action closure with the gesture recognizer (instead of the more traditional target/action).
     
     - parameter action: The closure for the recognizer to execute. There is no pre-logic to conditionally invoke the closure or not (e.g. only invoke the closure if the gesture recognizer is in a particular state). The closure is merely invoked directly; all handler logic is up to the closure.
     
     - returns: The UIGestureRecognizer.
     */
    public convenience init(action: @escaping (UIGestureRecognizer) -> Void) {
        self.init()
        gestureAction = GestureAction(action: action)
        addTarget(self, action: #selector(UIGestureRecognizer.handleAction(_:)))
    }
    
    @objc dynamic fileprivate func handleAction(_ recognizer: UIGestureRecognizer) {
        gestureAction?.action(recognizer)
    }
}
