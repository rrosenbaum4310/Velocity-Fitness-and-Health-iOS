//
//  Constant.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import Foundation
import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

enum NetworkEnvironment {
    case production
    case development
    case qa
    case demo
}

fileprivate var mainBaseURL : String {
    
    switch SERVERURL.environment {
//    case .production: return "http://demoservershosting.com"
//    case .development: return "http://demoservershosting.com"
//    case .qa: return "http://demoservershosting.com"
//    case .demo: return "http://demoservershosting.com"
        
    case .production: return "http://sampletemplates.net.in"
    case .development: return "http://sampletemplates.net.in"
    case .qa: return "http://sampletemplates.net.in"
    case .demo: return "http://sampletemplates.net.in"
        
    }
}

// All API URL
public struct SERVERURL {
    static let environment : NetworkEnvironment = .development
    static let baseURL = mainBaseURL
    
    static let socketURL        = mainBaseURL + ":2087"
    
    static let mainBaseAPIPath = mainBaseURL + "/vfh/api/api.php"

    static let login = "?action=login&"
    static let socialLogin = "?action=sociallogin&"
    static let forgotPassword = "?action=forgotpassword&"
    static let signup = "?action=signup&"
    static let getState = "?action=getstates"
    static let getBanners = "?action=getbanners"
    static let getCategories = "?action=getcategories"
    static let getCategoriesNotes = "?action=getcategorynotes"
    static let getDateWiseNotes = "?action=getdatewisenotes"
    static let getSessionNotes = "?action=getsessionnotesbydate"
    static let saveNotes = "?action=savenote"
    static let editNotes = "?action=editcategorynotes"
    static let getWeekDatesandDays = "?action=getweekDatesandDays"
    static let getUserEvents = "?action=getuserevents"
    static let getContent = "?action=getcontent"
    static let getCalendar	 = "?action=getallevents"
    static let getSessionVideos = "?action=getsessionvideos"
    static let getContactUsDetails = "?action=getcontactus"
    static let getMemberProfile = "?action=getuserprofile"
    static let getUserHistory = "?action=getuserhistory"
    static let getMembershipList = "?action=getmembership"
    static let saveMembershipPlan = "?action=savesubscription"
    static let getTrainingGlossary = "?action=gettrainingglossary"
    static let getEventData = "?action=geteventdata"
    static let editUserProfile = "?action=edituserprofileinput"
    static let getSessionVideosURL = "?action=getsessionvideos"
    static let afterPaymentDoneURL = "?action=afterpaymentdone"
    static let afterPaymentUserDetailURL = "?action=ezidebitpayee"
    static let creditCardDetailUrl = "?action=ezidebit_addcredit"
    static let saveSubscriptionUrl = "?action=savesubscription"
//action=afterpaymentdone&email=tester@gmail.com&password=123456
    
}

public struct ThemeColors {
    static let colorPrimary = UIColor(hex: "#6AA4FC")
    static let colorPrimaryDark = UIColor(hex: "#6AA4FC")
    static let colorAccent = UIColor(hex: "#D8232C")
    static let colorWhite = UIColor(hex: "#ffffff")
}

//MARK:- ScreenSize & DeviceType
// Check screen size with device type
public struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

public struct DefaultValues {
    static let googleClientID = "347929603383-0npi5rts1mich4t3pa4nj3a0airr22tv.apps.googleusercontent.com" //"658622624225-vrkfiqtcifcibb0p3f6a5kah0l5oss67.apps.googleusercontent.com"
    
    static let paypalProductionClientID = "AQytf7Wh2WdSVyX7Mq9RwYl-Cb1whsx21hFQtETAO_Q_KOKF8fvOqmcQho-FZGwftEUY75NQurMXoxgt"
    static let paypalSandBoxClientID = "ATCUApZUe4BCpKAjpJja7IA7qNqL0syLzzgEVGwBurwpDpv56z7Y7ITuIRsxY5pXfloVc1bzw0JzUySR"
}

public struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XR          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad //&& ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

extension UserDefaults {
    struct keys {
        static let deviceToken = "VFHDeviceToken"
        static let FCMToken = "VFHFCMToken"
        static let accessToken = "VFHAccessToken"
        static let userDefaultsKey = "userDetails"
        static let localAuthPinKey = "VFHlocalAuthPinKey"
        static let touchIDEnableStatus = "VFHTouchIDEnableStatus"
        static let isLoggedIn = "VFHIsLoggedIn"
        static let EmailAddress = "VFHEmailAddress"
        static let Password = "VFHPassword"
        static let Login_Detail = "VFHLoginDetail"
    }
}

extension Notification.Name {
    
    static let receivedUserData = Notification.Name("NotificationReceivedUserData")
    
}
