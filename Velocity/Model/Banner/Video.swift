//
//  Video.swift
//  Velocity
//
//  Created by Vishal Gohel on 08/03/19.
//

import Foundation
class Video: NSObject {
    
    var imageURL: String = ""
    var title: String = ""
    var thumbnail:String = ""
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        if let strInput = dictionary["video"] as? String {
            imageURL = "\(strInput)"
        }
        if let strInput = dictionary["title"] as? String {
            title = "\(strInput)"
        }
        if let strInput = dictionary["thumbnail"] as? String {
            thumbnail = "\(strInput)"
        }
    }
    class func PopulateArray(array:[[String: Any]]) -> [Video] {
        
        var result:[Video] = []
        for item in array {
            let obj = Video(Data: item)
            result.append(obj)
        }
        return result
    }
}
