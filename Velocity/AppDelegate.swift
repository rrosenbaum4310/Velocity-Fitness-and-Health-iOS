//
//  AppDelegate.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookLogin
import FBSDKLoginKit
import FacebookCore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
     var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        if #available(iOS 10.0, *) {
            UINavigationBar.appearance().barTintColor = UIColor(hex: "000000")
        } else {
            UINavigationBar.appearance().backgroundColor = UIColor(hex: "000000")
        }
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().tintColor = UIColor.white
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
//        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        

        GIDSignIn.sharedInstance().clientID = DefaultValues.googleClientID
        
        
        if GlobalManager.sharedInstance.getLoginStatus(){
            appDelegate.setHomeAfterLogin()
        } else {
            //                appDelegate.setOrganizationListScreen()
            appDelegate.setLoginAuth()
        }
        
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: DefaultValues.paypalProductionClientID, PayPalEnvironmentSandbox: DefaultValues.paypalSandBoxClientID])
        
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
////        let appId: String = Settings.appId
////        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
////            return ApplicationDelegate.shared.application(app, open: url, options: options)
////        } else {
//////           return GIDSignIn.sharedInstance().handle(url as URL?,
//////                                                    sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//////                                                    annotation: options[UIApplication.OpenURLOptionsKey.annotation])
////            return GIDSignIn.sharedInstance().handle(url)
////        }
//
//       // return false
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let appId: String = FBSDKCoreKit.Settings.appID
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
            return ApplicationDelegate.shared.application(
                app,
                open: url,
                options: options
            )
        }else{
            return GIDSignIn.sharedInstance().handle(url)
        }
        
    }

    
    func setHomeAfterLogin() {
        guard let obj = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        if obj.paymentStatus == 1 {
            let homeNav = UIStoryboard.loadRootAfterLogin()
            
            let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
            homeNav.view.addSubview(snapshot);
            
            self.window?.rootViewController = homeNav;
            
            UIView.animate(withDuration: 0.3, animations: {() in
                snapshot.layer.opacity = 0;
                snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
            }, completion: {
                (value: Bool) in
                snapshot.removeFromSuperview();
                UIApplication.shared.statusBarStyle = .lightContent
            });
        } else {
            setCompulsarySubscription()
        }
    }
    
    func setCompulsarySubscription() {
        let subVC = UIStoryboard.loadSubscriptionVC()
        subVC.isCompulsarySelection = true
        let homeNav = UINavigationController(rootViewController: subVC)
        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
        homeNav.view.addSubview(snapshot);
        
        self.window?.rootViewController = homeNav;
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview();
            UIApplication.shared.statusBarStyle = .lightContent
        });
    }
    
    func setLoginAuth() {
        let loginVC = UIStoryboard.loadLoginAuth()
        let homeNav = UINavigationController(rootViewController: loginVC)
        let snapshot:UIView = (self.window?.snapshotView(afterScreenUpdates: true))!
        homeNav.view.addSubview(snapshot);
        
        self.window?.rootViewController = homeNav;
        
        UIView.animate(withDuration: 0.3, animations: {() in
            snapshot.layer.opacity = 0;
            snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
        }, completion: {
            (value: Bool) in
            snapshot.removeFromSuperview();
            UIApplication.shared.statusBarStyle = .default
        });
    }
    func logoutTapped() {
        
        self.window?.rootViewController?.showAlertView(message: "Are you sure you want to Logout?", defaultActionTitle: "Logout", cancelActionTitle: "Cancel", complitionHandler: { (isDefaultTapped) in
            
            if isDefaultTapped! {
                self.clearUserData()
                self.setLoginAuth()
                // self.setOrganizationListScreen()
            } else {
                
            }
        })
    }
    
    func clearUserData() {
        
        GlobalManager.sharedInstance.resetUserData()
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
            
            print(email)
            
        }
    }
}

extension AppDelegate {
    func showActivityControl() {
        window?.makeToastActivity()
        window?.isUserInteractionEnabled = false
    }
    
    func hideActivityControl() {
        window?.hideToastActivity()
        window?.isUserInteractionEnabled = true
    }
}
