//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import CloudKit
//import SlideMenuControllerSwift


// Alert Message Actions
extension UIViewController {
    
    func showAlertViewWithMessage(aStrMessage : String) {
        
        let alertController = UIAlertController(title: "", message:aStrMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showAlertView(message strMessage: String, defaultActionTitle dActionTitle: String, complitionHandler complition: @escaping() -> Void) {
        
        let alertController = UIAlertController(title: "", message:strMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: dActionTitle, style: .default) { (action:UIAlertAction!) in
            complition()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showAlertView(title aTitle:String, message strMessage: String, defaultActionTitle dActionTitle: String, complitionHandler complition: @escaping() -> Void) {
        
        let alertController = UIAlertController(title: title, message:strMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: dActionTitle, style: .default) { (action:UIAlertAction!) in
            complition()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    func showAlertView(message strMessage: String, defaultActionTitle dActionTitle: String, cancelActionTitle cActionTitle: String, complitionHandler complition: @escaping(_ isDefaultActionTapped:Bool?) -> Void) {
        let alertController = UIAlertController(title: "", message:strMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: dActionTitle, style: .default) { (action:UIAlertAction!) in
            complition(true)
        }
        let cancelAction = UIAlertAction(title: cActionTitle, style: .cancel) { (action:UIAlertAction!) in
            complition(false)
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showAlertView(title aTitle:String, message strMessage: String, defaultActionTitle dActionTitle: String, cancelActionTitle cActionTitle: String, complitionHandler complition: @escaping(_ isDefaultActionTapped:Bool?) -> Void) {
        let alertController = UIAlertController(title: aTitle, message:strMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: dActionTitle, style: .default) { (action:UIAlertAction!) in
            complition(true)
        }
        let cancelAction = UIAlertAction(title: cActionTitle, style: .cancel) { (action:UIAlertAction!) in
            complition(false)
        }
        alertController.addAction(OKAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func showAlertView(title aTitle:String, message strMessage: String, defaultActionTitle dActionTitle: String, complitionHandler complition: @escaping(_ isDefaultActionTapped:Bool?) -> Void) {
        let alertController = UIAlertController(title: aTitle, message:strMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: dActionTitle, style: .default) { (action:UIAlertAction!) in
            complition(true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    
    // Check for SKStoreProductViewController available or not (app rating).
    func checkStoreKitAvailibility() -> Bool {
        for bundle in Bundle.allFrameworks {
            if ((bundle.classNamed("SKStoreProductViewController")) != nil) {
                return true;
            }
        }
        return false;
    }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
//    func setNavigationBarItem() {
//        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
//        self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
//    }
//    
//    func removeNavigationBarItem() {
//        self.navigationItem.leftBarButtonItem = nil
//        self.navigationItem.rightBarButtonItem = nil
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
//    }
    
   
    
    
}
extension UIViewController {
    func getCurrentLocalTimeZone() -> String {
        
        return TimeZone.current.abbreviation() ?? ""
        
        //return TimeZone.current.localizedName(for: TimeZone.current.isDaylightSavingTime() ? .daylightSaving : .standard, locale: .current) ?? ""
    }
}
