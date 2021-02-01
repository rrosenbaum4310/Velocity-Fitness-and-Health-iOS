//
//  User.swift
//  Velocity
//
//  Created by Vishal Gohel on 05/03/19.
//

import Foundation

class User: NSObject, NSCoding {
    var email = ""
    var name = ""
    var userID = ""
    var loginStatus = false
    var paymentStatus = 0
    var phone = ""
    
    override init() {
        super.init()
    }
    
    init(Data userData: [String: Any]) {
        super.init()
        
        if let uID = userData["id"] as? Int {
            userID = "\(uID)"
        } else if let uID = userData["id"] as? String {
            userID = "\(uID)"
        }
        if let uName = userData["name"] as? String {
            name = "\(uName)"
        }
        if let uName = userData["email"] as? String {
            email = "\(uName)"
        }
        if let uName = userData["phone"] as? String {
            phone = "\(uName)"
        }
        if let isValue = userData["loginstatus"] as? Bool {
            loginStatus = isValue
        } else if let isValue = userData["loginstatus"] as? String {
            if isValue == "1" {
                loginStatus = true
            } else {
                loginStatus = false
            }
        } else if let isValue = userData["loginstatus"] as? Int {
            if isValue == 1 {
                loginStatus = true
            } else {
                loginStatus = false
            }
        }
        
        if let isValue = userData["paymentstatus"] as? String {
            if isValue == "1" {
                paymentStatus = 1
            } else {
                paymentStatus = 0
            }
        } else if let isValue = userData["paymentstatus"] as? Int {
           paymentStatus = isValue
        }
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        
        if let cUserID = aDecoder.decodeObject(forKey: "USERPROFILEobj_UserID") as? String {
            userID = cUserID
        }
        if let cName = aDecoder.decodeObject(forKey: "USERPROFILEobj_UserName") as? String {
            name = cName
        }
        
        if let anEmail = aDecoder.decodeObject(forKey: "USERPROFILEobj_UserEmail") as? String {
            email = anEmail
        }
        
        if let cValue = aDecoder.decodeObject(forKey: "USERPROFILEobj_Phone") as? String {
            phone = cValue
        }
        
        paymentStatus = aDecoder.decodeInteger(forKey: "USERPROFILEobj_PaymentStatus")
        loginStatus = aDecoder.decodeBool(forKey: "USERPROFILEobj_loginStatus")
        
//        if let cValue = aDecoder.decodeInteger(forKey: "USERPROFILEobj_PaymentStatus") as? Int {
//            paymentStatus = cValue
//        }
//
//
//
//        if let cValue = aDecoder.decodeBool(forKey: "USERPROFILEobj_loginStatus") as? Bool {
//            loginStatus = cValue
//        }
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(userID, forKey: "USERPROFILEobj_UserID")
       
        aCoder.encode(name, forKey: "USERPROFILEobj_UserName")
        aCoder.encode(email, forKey: "USERPROFILEobj_UserEmail")
        aCoder.encode(phone, forKey: "USERPROFILEobj_Phone")
        aCoder.encode(paymentStatus, forKey: "USERPROFILEobj_PaymentStatus")
        //aCoder.encode(paymentStatus, forKey: "USERPROFILEobj_PaymentStatus")
        //aCoder.encode(paymentStatus, forKey: "USERPROFILEobj_PaymentStatus")
        aCoder.encode(loginStatus, forKey: "USERPROFILEobj_isActive")
    }
}

class UserDetail: NSObject {
    var userID = ""
    var name = ""
    var subStartDate = ""
    var subEndDate = ""
    var dob = ""
    var benchPress = ""
    var age = ""
    var backSquat = ""
    var deadLift = ""
    var mRow500 = ""
    var height = ""
    var weight = ""
    var imgURL = ""
    var plan = ""
    var timeTravel4KM = ""
    var fitnessName = ""
    var profiletitle = ""
    var max_bridge = ""
    override init() {
        super.init()
    }
    
    init(Data userData: [String: Any]) {
        super.init()
        
        if let uID = userData["id"] as? Int {
            userID = "\(uID)"
        } else if let uID = userData["id"] as? String {
            userID = "\(uID)"
        }
        if let uName = userData["name"] as? String {
            name = "\(uName)"
        }
        if let strInput = userData["fitnessname"] as? String {
            fitnessName = "\(strInput)"
        }
        if let uName = userData["substartdate"] as? String {
            subStartDate = "\(uName)"
        }
        if let uName = userData["subenddate"] as? String {
            subEndDate = "\(uName)"
        }
        if let strInput = userData["dateofjoining"] as? String {
            let strDate = self.convertDateFormater(strInput)
            dob = "\(strDate)"
        }
        if let strInput = userData["bench_press"] as? String {
            benchPress = "\(strInput)"
        }
        if let strInput = userData["age"] as? CVarArg {
            age = "\(strInput)"
        }
        if let strInput = userData["back_squat"] as? String {
            backSquat = "\(strInput)"
        }
        if let strInput = userData["deadlift"] as? String {
            deadLift = "\(strInput)"
        }
        if let strInput = userData["500m_row"] as? String {
            mRow500 = "\(strInput)"
        }
        if let strInput = userData["time_trial"] as? String {
            timeTravel4KM = "\(strInput)"
        }
        if let strInput = userData["height"] as? String {
            height = "\(strInput)"
        }
        if let strInput = userData["weight"] as? String {
            weight = "\(strInput)"
        }
        if let strInput = userData["max_bridge"] as? String {
            max_bridge = "\(strInput)"
        }
        if let strInput = userData["image"] as? String {
            imgURL = "\(strInput)"
        }
        
        if let strInput = userData["plan"] as? String {
            plan = "\(strInput)"
        }
        
        if let strInput = userData["profiletitle"] as? String {
            profiletitle = "\(strInput)"
        }
        
        
    }
    class func PopulateArray(array:[[String: Any]]) -> [UserDetail] {
        
        var result:[UserDetail] = []
        for item in array {
            let obj = UserDetail(Data: item)
            result.append(obj)
        }
        return result
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
}
class UserHistory: NSObject {
    var _id = ""
    var bench_press = ""
    var back_squat = ""
    var deadlift = ""
    var mRow500 = ""
    var height = ""
    var weight = ""
    var time_trial = ""
    var fitnessname = ""
    var max_bridge = ""
    var createddate = ""
    
    override init() {
        super.init()
    }
    
    init(Data userData: [String: Any]) {
        super.init()
        
        if let id = userData["id"] as? Int {
            _id = "\(id)"
        } else if let id = userData["id"] as? String {
            _id = "\(id)"
        }
        if let bench_press = userData["bench_press"] as? String {
            self.bench_press = "\(bench_press)"
        }
        if let back_squat = userData["back_squat"] as? String {
            self.back_squat = "\(back_squat)"
        }
        if let uName = userData["deadlift"] as? String {
            self.deadlift = "\(uName)"
        }
        if let mRow500 = userData["500m_row"] as? String {
            self.mRow500 = "\(mRow500)"
        }
        
        if let height = userData["height"] as? String {
            self.height = "\(height)"
        }
        if let weight = userData["weight"] as? String {
            self.weight = "\(weight)"
        }
        if let time_trial = userData["time_trial"] as? String {
            self.time_trial = "\(time_trial)"
        }
        if let fitnessname = userData["fitnessname"] as? String {
            self.fitnessname = "\(fitnessname)"
        }
        if let strInput = userData["500m_row"] as? String {
            mRow500 = "\(strInput)"
        }
        if let max_bridge = userData["max_bridge"] as? String {
            self.max_bridge = "\(max_bridge)"
        }
        if let strInput = userData["height"] as? String {
            height = "\(strInput)"
        }
        if let strInput = userData["weight"] as? String {
            weight = "\(strInput)"
        }
        if let strInput = userData["max_bridge"] as? String {
            max_bridge = "\(strInput)"
        }
            
        if let strInput = userData["createddate"] as? String {
//            let strDate = self.convertDateFormater(strInput)
            self.createddate = "\(strInput)"
        }
        
        
        
    }
    class func PopulateArray(array:[[String: Any]]) -> [UserDetail] {
        
        var result:[UserDetail] = []
        for item in array {
            let obj = UserDetail(Data: item)
            result.append(obj)
        }
        return result
    }
    func convertDateFormater(_ date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return  dateFormatter.string(from: date!)
        
    }
}
