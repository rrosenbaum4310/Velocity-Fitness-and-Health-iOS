//
//  PaymentSubDetailVC.swift
//  Velocity
//
//  Created by Hexagon on 01/10/19.
//

import UIKit

class PaymentSubDetailVC: UIViewController {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    var strPlan_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
        let aArrTextField : [UITextField] = [txtFirstName,txtLastName,txtAddress1,txtAddress2,txtCity,txtState,txtPostalCode,txtEmail,txtPhoneNumber]
        for i in aArrTextField {
           i.layer.borderColor = UIColor.gray.cgColor
           i.layer.borderWidth = 1.0
           i.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 10)
        }
        if let decoded  = UserDefaults.standard.data(forKey: UserDefaults.keys.userDefaultsKey){
            if let decodedUser = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? User{
                let aStrFirstName = decodedUser.name
                var fullNameArr = aStrFirstName.components(separatedBy: " ")
                if fullNameArr.count > 1{
                    let firstName: String = fullNameArr[0]
                    let lastName: String = fullNameArr[1]
                    self.txtFirstName.text = firstName
                    self.txtLastName.text = lastName
                }else{
                    let firstName: String = fullNameArr[0]
                    self.txtFirstName.text = firstName
                }
                self.txtEmail.text = decodedUser.email
                self.txtPhoneNumber.text = decodedUser.phone
            }
            
            
        }
        // Do any additional setup after loading the view.
    }
    //MARK:- Navigation Setup
    func initialSetup() {
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
    }
    //MARK:- Button Action
    @IBAction func btnProceedAction(_ sender: UIButton) {
        if txtFirstName.text == "" {
            self.showAlertView(title: "", message: "Please enter your First Name.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else if txtLastName.text == ""{
            self.showAlertView(title: "", message: "Please enter your Last Name.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else if txtAddress1.text == ""{
            self.showAlertView(title: "", message: "Please enter your Address.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else if txtCity.text == ""{
            self.showAlertView(title: "", message: "Please enter your City.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else if txtState.text == ""{
            self.showAlertView(title: "", message: "Please enter your State.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else if txtEmail.text == ""{
            self.showAlertView(title: "", message: "Please enter your Email.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else if txtPhoneNumber.text == ""{
            self.showAlertView(title: "", message: "Please enter your phone number.", defaultActionTitle: "OK", complitionHandler: {
                
            })
            return
        }else{
            if txtEmail.text!.isValidEmail(){
                guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
                    return
                }
                
                self.APIPaymentProceed(FirstName: self.txtFirstName.text ?? "", LastName: self.txtLastName.text ?? "", Address1: self.txtAddress1.text ?? "", Address2: self.txtAddress2.text ?? "", City: self.txtCity.text ?? "", State: self.txtState.text ?? "", PostalCode: self.txtPostalCode.text ?? "", Email: self.txtEmail.text ?? "", PhoneNumber:self.txtPhoneNumber.text ?? "" , User_Id: user.userID) { (success, msg) in
                    if success{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CardDetailVC") as! CardDetailVC
                        vc.strPlan_id = self.strPlan_id
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        self.showAlertView(title: "", message: msg, defaultActionTitle: "OK", complitionHandler: {
                            
                        })
                    }
                }
            }else{
                self.showAlertView(title: "", message: "Please enter valid email.", defaultActionTitle: "OK", complitionHandler: {
                    
                })
            }
        }
    }
    //MARK:- API Calling Method
    func APIPaymentProceed(FirstName:String, LastName: String, Address1: String, Address2: String, City: String, State: String, PostalCode: String, Email: String, PhoneNumber: String, User_Id: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.afterPaymentUserDetailURL + "&lastname=\(LastName)&firstname=\(FirstName)&address1=\(Address1)&address2=\(Address2)&city=\(City)&state=\(State)&postalcode=\(PostalCode)&email=\(Email)&phone=\(PhoneNumber)&userid=\(User_Id)"
        ApiManager.sharedManager.cancelAllTasks()
        appDelegate.showActivityControl()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["error"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    completion(true,"Save SuccessFully!!")
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
