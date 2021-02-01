//
//  WeekDays.swift
//  Velocity
//
//  Created by Vishal Gohel on 08/03/19.
//

import Foundation
class WeekDays: NSObject {
    
    
    var firstDay = ""
    var firstDate = ""
    var secondDay = ""
    var secondDate = ""
    var thirdDay = ""
    var thirdDate = ""
    var fourthDay = ""
    var fourthDate = ""
    var fifthDay = ""
    var fifthDate = ""
    var sixthDay = ""
    var sixthDate = ""
    var seventhDay = ""
    var seventhDate = ""
    
    
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        
        if let strInput = dictionary["firstday"] as? String {
            firstDay = "\(strInput)"
        }
        if let strInput = dictionary["firstdate"] as? String {
            firstDate = "\(strInput)"
        }
        if let strInput = dictionary["secondday"] as? String {
            secondDay = "\(strInput)"
        }
        if let strInput = dictionary["seconddate"] as? String {
            secondDate = "\(strInput)"
        }
        if let strInput = dictionary["thirdday"] as? String {
            thirdDay = "\(strInput)"
        }
        if let strInput = dictionary["thirddate"] as? String {
            thirdDate = "\(strInput)"
        }
        
        if let strInput = dictionary["fourthday"] as? String {
            fourthDay = "\(strInput)"
        }
        if let strInput = dictionary["fourthdate"] as? String {
            fourthDate = "\(strInput)"
        }
        if let strInput = dictionary["fifthday"] as? String {
            fifthDay = "\(strInput)"
        }
        if let strInput = dictionary["fifthdate"] as? String {
            fifthDate = "\(strInput)"
        }
        if let strInput = dictionary["sixthday"] as? String {
            sixthDay = "\(strInput)"
        }
        if let strInput = dictionary["sixthdate"] as? String {
            sixthDate = "\(strInput)"
        }
        if let strInput = dictionary["seventhday"] as? String {
            seventhDay = "\(strInput)"
        }
        if let strInput = dictionary["seventhdate"] as? String {
            seventhDate = "\(strInput)"
        }
    }
    
    class func PopulateArray(array:[[String: Any]]) -> [CalendarEvents] {
        var result:[CalendarEvents] = []
        for item in array {
            let obj = CalendarEvents(Data: item)
            result.append(obj)
        }
        return result
    }
}
