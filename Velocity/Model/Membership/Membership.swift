//
//  Membership.swift
//  Velocity
//
//  Created by Vishal Gohel on 06/03/19.
//

import Foundation


class Membership: NSObject {
    
    var membershipID = ""
    var title: String = ""
    var price: String = ""
    var days: String = ""
    var finalPrice = ""
    var currency = ""
    var isSubscribed = false
    var isSelected = false
    override init() {
        super.init()
    }
    
    init(Data dictionary: [String: Any]) {
        if let strInput = dictionary["id"] as? String {
            membershipID = "\(strInput)"
        }
        if let strInput = dictionary["title"] as? String {
            title = "\(strInput)"
        }
        if let strInput = dictionary["price"] as? String {
            price = "\(strInput)"
            
            finalPrice = price.replacingOccurrences(of: "$", with: "")
            finalPrice = finalPrice.replacingOccurrences(of: "AUD", with: "")
            currency = "AUD"
            
        }
        if let strInput = dictionary["days"] as? String {
            days = "\(strInput)"
        }
    }
    class func PopulateArray(array:[[String: Any]]) -> [Membership] {
        
        var result:[Membership] = []
        for item in array {
            let obj = Membership(Data: item)
            result.append(obj)
        }
        return result
    }
    class func PopulateArray(array:[[String: Any]], SelectedPlanID planID: String) -> [Membership] {
        
        var result:[Membership] = []
        for item in array {
            let obj = Membership(Data: item)
            
            if planID.count > 0 && planID == obj.membershipID {
                obj.isSelected = true
            }
            
            result.append(obj)
        }
        return result
    }
}
