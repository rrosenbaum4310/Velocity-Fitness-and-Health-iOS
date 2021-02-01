//
//  UserDetail.swift
//  Velocity
//
//  Created by Hexagon on 01/10/19.
//

import Foundation

class LoginDetail: NSObject, NSCoding {
    
    var id: String
    var name: String
    var email: String
    var phone: String
    
    
    init( id: String, name: String, email: String, phone: String) {
        
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.init(id: id, name: name, email: email, phone: phone)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phone, forKey: "phone")
    }
}
