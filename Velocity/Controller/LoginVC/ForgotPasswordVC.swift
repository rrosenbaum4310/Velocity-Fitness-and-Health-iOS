//
//  ForgotPasswordVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 09/03/19.
//

import UIKit

class ForgotPasswordVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var txtEmail: GBTextField!
    @IBOutlet weak var btnCancel: VFHGradientButton!
    @IBOutlet weak var btnSendPassword: VFHGradientButton!
    
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
        
        
    }
    
    @IBAction func didTappedSendPAssword(_ sender: Any) {
        if let text = txtEmail.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please enter your Email Address!", defaultActionTitle: "OK", complitionHandler: {
                self.txtEmail.becomeFirstResponder()
            })
        } else if let text = txtEmail.text, !text.isEmpty && !text.isValidEmail() {
            self.showAlertView(title: "", message: "Please enter valid email address!", defaultActionTitle: "OK", complitionHandler: {
                            self.txtEmail.becomeFirstResponder()
            })
        } else {
            
            guard let emailText = txtEmail.text else {
                return
            }
            appDelegate.showActivityControl()
            APIForgotPassword(email: emailText) { (isSucced, message) in
                
                if isSucced {
                    self.showAlertView(title: "", message: message, defaultActionTitle: "OK", complitionHandler: {
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self.showAlertView(title: "", message: message, defaultActionTitle: "OK", complitionHandler: {
                        
                    })
                }
            }
        }
    }
    
    @IBAction func didTappedCancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
extension ForgotPasswordVC {
    // API Add Document
    func APIForgotPassword(email:String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.forgotPassword + "email=\(email)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    completion(true,"Your Login details have been sent to your email")
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
