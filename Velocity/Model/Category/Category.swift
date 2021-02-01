//
//  Category.swift
//  Velocity
//
//  Created by Vishal Gohel on 06/03/19.
//

import Foundation

enum VFHSessionType {
    case getStrong
    case getFit
    case getConditioned
    case bootFit
}
class Category: NSObject {
    
    var categoryID = ""
    var title: String = ""
    var imageURL: String = ""
    var type: VFHSessionType = .getStrong
    
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        if let strInput = dictionary["catid"] as? String {
            categoryID = "\(strInput)"
        } else if let strInput = dictionary["catid"] as? Int {
            categoryID = "\(strInput)"
        }
        if let strInput = dictionary["title"] as? String {
            title = "\(strInput)"
        }
        if let strInput = dictionary["image"] as? String {
            imageURL = "\(strInput)"
        }
        
        if title.lowercased() == "getfit" {
            type = .getFit
        } else if title.lowercased() == "getstrong" {
            type = .getStrong
        } else if title.lowercased() == "getconditioned" {
            type = .getConditioned
        } else if title.lowercased() == "bootfit" {
            type = .bootFit
        }
        
        
    }
    class func PopulateArray(array:[[String: Any]]) -> [Category] {
        
        var result:[Category] = []
        for item in array {
            let obj = Category(Data: item)
            result.append(obj)
        }
        return result
    }
}
