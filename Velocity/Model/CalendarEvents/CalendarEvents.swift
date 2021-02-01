//
//  CalendarEvents.swift
//  Velocity
//
//  Created by Vishal Gohel on 07/03/19.
//

import Foundation


class CalendarEvents: NSObject {
    
    
    var categoryID = ""
    var userID = ""
    var title = ""
    var startTime = ""
    var endTime = ""
    var offer = ""
    var eventid = ""
    
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        
        if let strInput = dictionary["title"] as? String {
            title = "\(strInput)"
        }
        if let strInput = dictionary["categoryid"] as? String {
            categoryID = "\(strInput)"
        }
        if let strInput = dictionary["userid"] as? String {
            userID = "\(strInput)"
        }
        if let strInput = dictionary["starttime"] as? String {
            startTime = "\(strInput)"
        }
        if let strInput = dictionary["eventendtime"] as? String {
            endTime = "\(strInput)"
        }
        if let strInput = dictionary["offer"] as? String {
            offer = "\(strInput)"
        }
        if let strInput = dictionary["eventid"] as? String {
            eventid = "\(strInput)"
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
