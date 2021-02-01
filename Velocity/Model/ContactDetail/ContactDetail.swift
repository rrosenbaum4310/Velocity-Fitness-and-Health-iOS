//
//  ContactDetail.swift
//  Velocity
//
//  Created by Vishal Gohel on 06/03/19.
//

import Foundation

class ContactDetail: NSObject {
    
    var email: String = ""
    var address: String = ""
    var webLink: String = ""
    var latitude: String = ""
    var longitude: String = ""
    
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        if let strInput = dictionary["email"] as? String {
            email = "\(strInput)"
        }
        if let strInput = dictionary["address"] as? String {
            address = "\(strInput)"
        }
        if let strInput = dictionary["weblink"] as? String {
            webLink = "\(strInput)"
        }
        if let strInput = dictionary["latitude"] as? String {
            latitude = "\(strInput)"
        }
        if let strInput = dictionary["longitude"] as? String {
            longitude = "\(strInput)"
        }
    }
    class func PopulateArray(array:[[String: Any]]) -> [ContactDetail] {
        
        var result:[ContactDetail] = []
        for item in array {
            let obj = ContactDetail(Data: item)
            result.append(obj)
        }
        return result
    }
}
