//
//  TrainingGlossaryNote.swift
//  Velocity
//
//  Created by Vishal Gohel on 08/03/19.
//

import Foundation

class TrainingGlossaryNote: NSObject {
    
    
    var categoryID = ""
    var noteID = ""
    var message = ""
    
    
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        
        if let strInput = dictionary["message"] as? String {
            message = "\(strInput)"
        }
        if let strInput = dictionary["catid"] as? String {
            categoryID = "\(strInput)"
        }
        if let strInput = dictionary["id"] as? String {
            noteID = "\(strInput)"
        }
        
    }
    
    class func PopulateArray(array:[[String: Any]]) -> [TrainingGlossaryNote] {
        var result:[TrainingGlossaryNote] = []
        for item in array {
            let obj = TrainingGlossaryNote(Data: item)
            result.append(obj)
        }
        return result
    }
}
