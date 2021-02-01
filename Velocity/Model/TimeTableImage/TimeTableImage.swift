//
//  TimeTableImage.swift
//  Velocity
//
//  Created by Hexagon on 31/05/19.
//

import Foundation


class TimeTableImage: NSObject {
    var id = ""
    var image = ""
    
    
    override init() {
        super.init()
    }
    
    
    init(Data dictionary: [String: Any]) {
        
        if let strInput = dictionary["id"] as? String {
            id = "\(strInput)"
        }
        if let strInput = dictionary["image"] as? String {
            image = "\(strInput)"
        }
        
    }
    
    class func PopulateArray(array:[[String: Any]]) -> [TimeTableImage] {
        var result:[TimeTableImage] = []
        for item in array {
            let obj = TimeTableImage(Data: item)
            result.append(obj)
        }
        return result
    }
}
