//
//  CardDetailVC.swift
//  Velocity
//
//  Created by Hexagon on 01/10/19.
//

import UIKit

class CardDetailVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtOwnerName: UITextField!
    @IBOutlet weak var viewCardNumBg: UIView!
    @IBOutlet weak var viewExpiryBg: UIView!
    
    @IBOutlet weak var txtCardNum1: UITextField!
    @IBOutlet weak var txtCardNum2: UITextField!
    @IBOutlet weak var txtCardNum3: UITextField!
    @IBOutlet weak var txtCardNum4: UITextField!
    
    @IBOutlet weak var txtExpiryMonth: UITextField!
    @IBOutlet weak var txtExpiryYear: UITextField!
    
    var strPlan_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        txtOwnerName.layer.borderColor = UIColor.lightGray.cgColor
        txtOwnerName.layer.borderWidth = 1
        txtOwnerName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 10)
        let aArrTextField:[UITextField] = [txtCardNum1,txtCardNum2,txtCardNum3,txtCardNum4,txtExpiryMonth,txtExpiryYear]
        for i in aArrTextField {
            i.delegate = self
            i.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        }
        let aArrView : [UIView] = [viewCardNumBg,viewExpiryBg]
        for i in aArrView {
            i.layer.borderColor = UIColor.lightGray.cgColor
            i.layer.borderWidth = 1
        }
        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange(_ textField : UITextField){
        let length = textField.text?.count
        print("erewr",length)
        switch textField {
        case txtCardNum1:
            if length == 4{
                self.txtCardNum2.becomeFirstResponder()
            }
        case txtCardNum2:
            if length == 4{
                self.txtCardNum3.becomeFirstResponder()
            }
        case txtCardNum3:
            if length == 4{
                self.txtCardNum4.becomeFirstResponder()
            }
        case txtCardNum4:
            if length == 4{
                self.txtExpiryMonth.becomeFirstResponder()
            }
        case txtExpiryMonth:
            if length == 2{
                self.txtExpiryYear.becomeFirstResponder()
            }
        case txtExpiryYear:
            if length == 4{
                self.txtExpiryYear.resignFirstResponder()
            }
        default:
            print("default")
        }
    }
    //MARK:- Navigation Setup
    func initialSetup() {
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
    }
    //MARK:- UITextFieldDelegate Method
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case txtCardNum1:
            return range.location < 4
        case txtCardNum2:
            return range.location < 4
        case txtCardNum3:
            return range.location < 4
        case txtCardNum4:
            return range.location < 4
        case txtExpiryMonth:
            return range.location < 2
        case txtExpiryYear:
            return range.location < 4
        default:
            return range.location < 100
        }
    }

    //MARK:- Button Action

    @IBAction func btnProceedAction(_ sender: UIButton) {
        if txtOwnerName.text == "" {
            self.showAlertView(title: "", message: "Please enter card owner name.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else if txtCardNum1.text == "" || txtCardNum2.text == "" || txtCardNum3.text == "" || txtCardNum4.text == ""{
            self.showAlertView(title: "", message: "Please enter card number.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else if txtExpiryMonth.text == "" || txtExpiryYear.text == ""{
            self.showAlertView(title: "", message: "Please enter expiry.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else{
            guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
                return
            }
            let aStrCardNum = self.txtCardNum1.text! + self.txtCardNum2.text! + self.txtCardNum3.text! + self.txtCardNum4.text!
            APICardDetail(creditcard_owner_name: self.txtOwnerName.text ?? "", creditcard_number: aStrCardNum, expiry_year: self.txtExpiryYear.text ?? "", expiry_month: self.txtExpiryMonth.text ?? "", User_Id: user.userID) { (success, msg) in
                if success{
                    self.APISaveScription(plan_Id: self.strPlan_id, User_Id: user.userID, CompletionHandler: { (success, msg) in
                        if success{
                            self.showAlertView(title: "", message: msg, defaultActionTitle: "OK", complitionHandler: {
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                        }else{
                            self.showAlertView(title: "", message: "Some error occured, Please try after some time!", defaultActionTitle: "OK", complitionHandler: {
                                
                            })
                        }
                    })
                }else{
                    self.showAlertView(title: "", message: msg, defaultActionTitle: "OK", complitionHandler: {
                        
                    })
                }
            }
        }
    }
    //MARK:- API Calling Method
    func APICardDetail(creditcard_owner_name:String, creditcard_number: String, expiry_year: String, expiry_month: String, User_Id: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.creditCardDetailUrl + "&userid=\(User_Id)&creditcard_owner=\(creditcard_owner_name)&creditcard_number=\(creditcard_number)&expiryyear=\(expiry_year)&expirymonth=\(expiry_month)"
        ApiManager.sharedManager.cancelAllTasks()
        appDelegate.showActivityControl()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["error"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let msg = dictResponse["messgae"] as? String{
                        completion(true,msg)
                    }
                } else {
                    completion(false,message)
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
    }
    func APISaveScription(plan_Id: String, User_Id: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.saveSubscriptionUrl + "&userid=\(User_Id)&plan=\(plan_Id)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["error"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let msg = dictResponse["message"] as? String{
                        completion(true,msg)
                    }else{
                        completion(true,"Subsription saved successfully")
                    }
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
