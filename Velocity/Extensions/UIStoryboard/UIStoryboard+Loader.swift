//
//  UIStoryboard+Loader.swift
//  ServSearch
//
//  Created by Vishal Gohel on 8/4/17.
//  Copyright © 2017 Vishal Gohel. All rights reserved.
//

import Foundation
import UIKit

fileprivate enum Storyboard : String {
    case main = "Main"
    case dashboard = "Dashboard"
    case home = "Home"
    case memberProfile = "MemberProfile"
    case training = "Training"
    case contact = "Contact"
    
    // add enum case for each storyboard in your project
}

fileprivate extension UIStoryboard {
    
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }
    
    static func loadFromDashboard(_ identifier: String) -> UIViewController {
        return load(from: .dashboard, identifier: identifier)
    }
    
    static func loadHomeInitialAfterLogin() -> UIViewController {
        return loadInitial(from: .dashboard)
    }
    
    static func loadFromHome(_ identifier: String) -> UIViewController {
        return load(from: .home, identifier: identifier)
    }
    static func loadFromMemberProfile(_ identifier: String) -> UIViewController {
        return load(from: .memberProfile, identifier: identifier)
    }
    static func loadFromTraining(_ identifier: String) -> UIViewController {
        return load(from: .training, identifier: identifier)
    }
    static func loadFromContact(_ identifier: String) -> UIViewController {
        return load(from: .contact, identifier: identifier)
    }
    
    // ... or use the main loading method directly when
    // instantiating view controller from a specific storyboard
    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
    
    static func loadInitial(from storyBoard: Storyboard) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        return uiStoryboard.instantiateInitialViewController()!
    }
    
}


// MARK: App View Controllers

extension UIStoryboard {
    
//    class func loadLandingNVC() -> LandingViewController {
//        return loadFromMain("LandingViewController") as! LandingViewController
//    }
   
    class func loadLoginAuth() -> AuthOptionsVC {
        return loadFromMain("AuthOptionsVC") as! AuthOptionsVC
    }
    
    class func loadLoginVC() -> LoginVC {
        return loadFromMain("LoginVC") as! LoginVC
    }
    class func loadForgotPasswordVC() -> ForgotPasswordVC {
        return loadFromMain("ForgotPasswordVC") as! ForgotPasswordVC
    }
    
    class func loadSignUpVC() -> SignUpVC {
        return loadFromMain("SignUpVC") as! SignUpVC
    }
    
    class func loadRootAfterLogin() -> UITabBarController {
        return loadHomeInitialAfterLogin() as! UITabBarController
    }
    class func loadNotesVC() -> NotesVC {
        return loadFromHome("NotesVC") as! NotesVC
    }
    
    class func loadNotesPopupVC() -> NotesPopupVC {
        return loadFromHome("NotesPopupVC") as! NotesPopupVC
    }
    
    class func loadVFHSessionsVC() -> VFHSessionsVC {
        return loadFromHome("VFHSessionsVC") as! VFHSessionsVC
    }
    
    class func loadSubscriptionVC() -> SubscriptionVC {
        return loadFromMemberProfile("SubscriptionVC") as! SubscriptionVC
    }
    
    class func loadTrainingGlossaryVC() -> TrainingGlossaryVC {
        return loadFromTraining("TrainingGlossaryVC") as! TrainingGlossaryVC
    }
    
    
    
    /*
     class func loadRootAfterLogin() -> UITabBarController {
     return loadHomeInitialAfterLogin() as! UITabBarController
     }
     
     // Load from Feed
     class func loadCommentOnCommentVC() -> CommentOnCommentVC {
     return loadFromFeed("CommentOnCommentVC") as! CommentOnCommentVC
     }
     //    class func loadFeedViewController() -> FeedViewController {
     //        return loadFromFeed("FeedViewController") as! FeedViewController
     //    }
     class func loadFeedViewController() -> FeedListVC {
     return loadFromFeed("FeedListVC") as! FeedListVC
     }
     
     class func loadPreviewAllMediaVC() -> PreviewAllMediaVC {
     return loadFromFeed("PreviewAllMediaVC") as! PreviewAllMediaVC
     }
     
     
     
     
     // Load from Main
     class func loadAuthLoginNav() -> LoginNavController {
     return loadFromMain("LoginNavController") as! LoginNavController
     }
 
 */
    
    
    
}

