//
//  CategorySessionNote.swift
//  Velocity
//
//  Created by Hexagon on 08/05/19.
//

import Foundation

class SessionCategoryNote: NSObject {
    
    var catid = ""
    var note = ""
   
    
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        if let strInput = dictionary["catid"] as? String {
            catid = "\(strInput)"
        }
        if let strInput = dictionary["note"] as? String {
            note = "\(strInput)"
        }
    }
    
    class func PopulateArray(array:[[String: Any]]) -> [SessionCategoryNote] {
        var result:[SessionCategoryNote] = []
        for item in array {
            let obj = SessionCategoryNote(Data: item)
            result.append(obj)
        }
        return result
    }
}
