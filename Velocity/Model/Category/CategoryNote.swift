//
//  CategoryNote.swift
//  Velocity
//
//  Created by Vishal Gohel on 06/03/19.
//

import Foundation

class DateWiseNotes: NSObject {
    var date = ""
    var difference = ""
    var notes = [CategoryNote]()
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        if let strInput = dictionary["date"] as? String {
            let dateFull = strInput.convertIntoDate(format: "yyyy-MM-dd HH:mm:ss") ?? Date()
            let strDate = dateFull.convertIntoLocalTimeZoneString(format: "yyyy-MM-dd")
            date = "\(strDate)"
            let calendar = Calendar.current
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: dateFull)
            let date2 = calendar.startOfDay(for: Date())
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            if let days = components.day {
                if days > 0 {
                    difference = "\(days) Days ago"
                } else {
                    difference = "Today"
                }
            }
            
        }
        if let dicInput = dictionary["notesdate"] as? [[String: Any]] {
            notes = CategoryNote.PopulateArray(array: dicInput)
        }
        
    }
    
    class func PopulateArray(array:[[String: Any]]) -> [DateWiseNotes] {
        var result:[DateWiseNotes] = []
        for item in array {
            let obj = DateWiseNotes(Data: item)
            result.append(obj)
        }
        return result
    }
    
    class func PopulateArray(array:[[String: Any]], catID: String, userID: String) -> [DateWiseNotes] {
        var result:[DateWiseNotes] = []
        for item in array {
            let obj = DateWiseNotes(Data: item)
            obj.notes = obj.notes.filter { $0.categoryID == catID && $0.userID == userID }
            result.append(obj)
        }
        return result
    }
    
}


class CategoryNote: NSObject {
    
    var noteID = ""
    var categoryID = ""
    var userID = ""
    var notes: String = ""
    
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        if let strInput = dictionary["id"] as? String {
            noteID = "\(strInput)"
        }
        if let strInput = dictionary["notes"] as? String {
            notes = "\(strInput)"
        }
        if let strInput = dictionary["categoryid"] as? String {
            categoryID = "\(strInput)"
        }
        if let strInput = dictionary["userid"] as? String {
            userID = "\(strInput)"
        }
    }
    
    class func PopulateArray(array:[[String: Any]]) -> [CategoryNote] {
        var result:[CategoryNote] = []
        for item in array {
            let obj = CategoryNote(Data: item)
            result.append(obj)
        }
        return result
    }
}
