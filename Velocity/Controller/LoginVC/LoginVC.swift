//
//  LoginVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKCoreKit
import GoogleSignIn

class LoginVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtUserName: GBTextField!
    @IBOutlet weak var txtPassword: GBTextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: VFHGradientButton!
    @IBOutlet weak var lblSignupTitle: UILabel!
    @IBOutlet weak var nslcImgLogoTop: NSLayoutConstraint!
    @IBOutlet weak var nslcImgLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcImgLogoBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcStackContanierTop: NSLayoutConstraint!
    @IBOutlet weak var nslcStackContainerBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcBtnLoginTop: NSLayoutConstraint!
    @IBOutlet weak var nslcBtnLoginHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcBtnLoginBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcStackSignInOptionsTop: NSLayoutConstraint!
    @IBOutlet weak var nslcSignInOptionsBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcBtnSignUpBottom: NSLayoutConstraint!
    
    
//  local Declaration
    
    
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Methods
    func initialSetup() {
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            
        } else if DeviceType.IS_IPHONE_5 {
            nslcImgLogoHeight.constant = 80
            nslcImgLogoTop.constant = 10
            nslcImgLogoBottom.constant = 10
            nslcStackContanierTop.constant = 10
            nslcStackContainerBottom.constant = 0
            nslcBtnLoginTop.constant = 10
            nslcBtnSignUpBottom.constant = 10
        } else if DeviceType.IS_IPHONE_6 {
            
        } else if DeviceType.IS_IPHONE_6P {
            nslcImgLogoHeight.constant = 100
            nslcSignInOptionsBottom.constant = 20
            nslcBtnLoginBottom.constant = 20
        } else if DeviceType.IS_IPHONE_X {
            nslcImgLogoHeight.constant = 100
            nslcSignInOptionsBottom.constant = 20
            nslcBtnLoginBottom.constant = 20
        } else if DeviceType.IS_IPHONE_XR {
            nslcImgLogoHeight.constant = 121
            nslcImgLogoTop.constant = 40
            nslcSignInOptionsBottom.constant = 30
            nslcBtnLoginBottom.constant = 30
        } else {
            
        }
        
       txtUserName.rightImage = UIImage(named: "username") ?? UIImage.fontAwesomeIcon(name: .user, style: .regular, textColor: UIColor.black, size: CGSize(width: 25, height: 25))
        
       txtPassword.rightImage = UIImage(named: "password") ?? UIImage.fontAwesomeIcon(name: .user, style: .regular, textColor: UIColor.black, size: CGSize(width: 25, height: 25))
        
        let signupString = "Don't have an account? Sign Up Now"
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "OpenSans", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributed = NSMutableAttributedString(string: signupString, attributes: attributes)
        
        if let tcRange = signupString.range(of: "Sign Up Now") {
            
            let range = NSRange(tcRange, in: signupString)
            let font = UIFont(name: "OpenSans-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18)
            attributed.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(hex: "eb642d")], range: range)
        }
        lblSignupTitle.attributedText = attributed

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
    }
    
    @IBAction func didTappedForgotPassword(_ sender: UIButton) {
        let vc = UIStoryboard.loadForgotPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func didTappedLogin(_ sender: UIButton) {
        if let text = txtUserName.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please enter your email!", defaultActionTitle: "OK", complitionHandler: {
                self.txtUserName.becomeFirstResponder()
            })
        } else if let text = txtUserName.text, !text.isEmpty && !text.isValidEmail() {
            self.showAlertView(title: "", message: "Please enter valid email address!", defaultActionTitle: "OK", complitionHandler: {
                self.txtUserName.becomeFirstResponder()
            })
        } else if let text = txtPassword.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please enter your Password!", defaultActionTitle: "OK", complitionHandler: {
                self.txtPassword.becomeFirstResponder()
            })
        } else {
            guard let emailText = txtUserName.text, let passwordText = txtPassword.text else {
                return
            }
            appDelegate.showActivityControl()
            APILogin(email: emailText, password: passwordText) { (isSucced, message) in
                
                if isSucced {
                    GlobalManager.sharedInstance.setEmailAddress(String: emailText)
                    GlobalManager.sharedInstance.setPassword(String: passwordText)
                    
                    appDelegate.setHomeAfterLogin()
                } else {
                    self.showAlertView(title: "", message: message, defaultActionTitle: "OK", complitionHandler: {
                        
                    })
                }
            }
        }
        //appDelegate.setHomeAfterLogin()
    }
    
    @IBAction func didTappedSignUp(_ sender: UIButton) {
        
        if isFromSignUp() {
            self.navigationController?.popViewController(animated: true)
        } else {
            let signupVC = UIStoryboard.loadSignUpVC()
            self.navigationController?.pushViewController(signupVC, animated: true)
        }  
    }
    
    @IBAction func didTappedFacebook(_ sender: UIButton) {

        self.getFacebookUserInfo()
//        let loginManager = LoginManager()
//
//        if (AccessToken.current != nil){
////            appDelegate.showActivityControl()
//            loginManager.logIn(permissions: [.publicProfile, .email ], viewController: self) { (result) in
////                appDelegate.hideActivityControl()
//                switch result{
//                case .cancelled:
//                    print("Cancel button click")
//                case .success:
//                    let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
//                    let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
//                    let Connection = GraphRequestConnection()
//                    Connection.add(graphRequest) { (Connection, result, error) in
//                        let info = result as! [String : AnyObject]
//                        print(info["name"] as! String)
//                        if (error == nil) {
//
//                            if let resultData = result as? [String: Any] {
//                                var emailStr = ""
//                                var picture = ""
//                                if let email = resultData["email"] as? String {
//                                    emailStr = email
//                                }
//
//                                if let fName = resultData["first_name"] as? String, let lName = resultData["last_name"] as? String, emailStr.count == 0 {
//                                    emailStr = "\(fName)\(lName)@gmail.com"
//                                }
//
//                                if let pictureDict = resultData["picture"] as? [String: Any] , let pictureData = pictureDict["data"] as? [String: Any], let url = pictureData["url"] as? String {
//                                    picture = url
//                                }
//
//                                if emailStr.count > 0 {
//                                    self.callSocialLogin(email: emailStr, Picture: picture)
//                                    return
//                                }
//                            }
//                            appDelegate.hideActivityControl()
//                        } else {
//                            appDelegate.hideActivityControl()
//                        }
//
//                    }
//                    Connection.start()
//                default:
//                    print("??")
//                }
//            }
//        }
        
        

    }
    
    func getFacebookUserInfo(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email ], viewController: self) { (result) in
            switch result{
            case .cancelled:
                print("Cancel button click")
            case .success:
                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
                let Connection = GraphRequestConnection()
                Connection.add(graphRequest) { (Connection, result, error) in
                    let info = result as! [String : AnyObject]
                    print(info["name"] as! String)
                    if (error == nil) {
                        
                        if let resultData = result as? [String: Any] {
                            var emailStr = ""
                            var picture = ""
                            if let email = resultData["email"] as? String {
                                emailStr = email
                            }
                            
                            if let fName = resultData["first_name"] as? String, let lName = resultData["last_name"] as? String, emailStr.count == 0 {
                                emailStr = "\(fName)\(lName)@gmail.com"
                            }
                            
                            if let pictureDict = resultData["picture"] as? [String: Any] , let pictureData = pictureDict["data"] as? [String: Any], let url = pictureData["url"] as? String {
                                picture = url
                            }
                            
                            if emailStr.count > 0 {
                                self.callSocialLogin(email: emailStr, Picture: picture)
                                return
                            }
                        }
                        appDelegate.hideActivityControl()
                    } else {
                        appDelegate.hideActivityControl()
                    }
                    
                }
                Connection.start()
            default:
                print("??")
            }
        }
    }
    
    func callSocialLogin(email: String, Picture pictureURL: String) {
        
        APISocialLogin(email: email, picture: pictureURL) { (isSucced, message) in
            
            if isSucced {
                appDelegate.setHomeAfterLogin()
                
            } else {
                self.showAlertView(title: "", message: message, defaultActionTitle: "OK", complitionHandler: {
                    
                })
            }
        }
    }
    
    
    @IBAction func didTappedGoogle(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func isFromSignUp() -> Bool {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SignUpVC.self) {
                
                return true
            }
        }
        return false
    }
}



extension LoginVC: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
//            let userId = user.userID ?? ""                  // For client-side use only!
//            let idToken = user.authentication.idToken ?? "" // Safe to send to the server
//            let fullName = user.profile.name ?? ""
            let givenName = user.profile.givenName ?? ""
            let familyName = user.profile.familyName ?? ""
            let email = user.profile.email
            // ...
            var emailValue = ""
            let picture = user.profile.imageURL(withDimension: 480)?.absoluteString ?? ""
            
            if let emailStr = email, emailStr.count > 0 {
                emailValue = emailStr
            } else {
                if givenName.count > 0 || familyName.count > 0 {
                    emailValue = "\(givenName)\(familyName)@gmail.com"
                }
            }
            if emailValue.count > 0 {
                self.callSocialLogin(email: emailValue, Picture: picture)
                return
            } 
        }
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print("efrewr",error)
        // Perform any operations when the user disconnects from app here.
        // ...
    }
}

//extension LoginVC: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print("\(error.localizedDescription)")
//        } else {
//            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            // ...
//        }
//    }
//
//
//}

extension LoginVC {
    // API Add Document
    func APILogin(email:String, password: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.login + "email=\(email)&password=\(password)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                 print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["userdata"] as? [String: Any] {
                        let user = User(Data: dataList)
                        
                        GlobalManager.sharedInstance.setCurrentUser(aUser: user)
                        completion(true,message)
                        return
                    }
                    completion(false,"Some error occured, Please try after some time!")
                } else {
                    completion(false,message)
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
    }
    func APISocialLogin(email:String, picture: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.socialLogin + "email=\(email)&picture=\(picture)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["user"] as? [String: Any] {
                        let user = User(Data: dataList)
                        GlobalManager.sharedInstance.setEmailAddress(String: email)
                        GlobalManager.sharedInstance.setCurrentUser(aUser: user)
                        completion(true,message)
                        return
                    }
                    completion(false,"Some error occured, Please try after some time!")
                } else {
                    completion(false,message)
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
    }
}

