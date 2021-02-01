//
//  Banner.swift
//  Velocity
//
//  Created by Vishal Gohel on 05/03/19.
//

import Foundation

class Banner: NSObject {
    
    var imageURL: String = ""
    
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        if let strInput = dictionary["image"] as? String {
            imageURL = "\(strInput)"
        }
    }
    class func PopulateArray(array:[[String: Any]]) -> [Banner] {
        
        var result:[Banner] = []
        for item in array {
            let obj = Banner(Data: item)
            result.append(obj)
        }
        return result
    }
}
