//
//  SignUpVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit

class SignUpVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtName: GBTextField!
    @IBOutlet weak var txtGender: GBTextField!
    @IBOutlet weak var txtDOB: GBTextField!
    @IBOutlet weak var txtEmail: GBTextField!
  //  @IBOutlet weak var txtUserName: GBTextField!
    @IBOutlet weak var txtPassword: GBTextField!
    @IBOutlet weak var btnSignUp: VFHGradientButton!
    @IBOutlet weak var txPhoneNo: GBTextField!
    @IBOutlet weak var txtCity: GBTextField!
    @IBOutlet weak var txtState: GBTextField!
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var nslcImgLogoHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcImgLogoTop: NSLayoutConstraint!
    @IBOutlet weak var nslcImgLogoBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcStackOptionsTop: NSLayoutConstraint!
    @IBOutlet weak var nslcStackOptionsBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcBtnSignUpBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcBtnLoginBottom: NSLayoutConstraint!
    
    @IBOutlet weak var heightField: GBTextField!
    @IBOutlet weak var weightField: GBTextField!

    
//  local Declaration
    fileprivate var birthDate: Date?
    fileprivate var drpdwnIndex = 0
    fileprivate let genderList = ["Male", "Female"]
    fileprivate var arrStatesData = [String]()
    
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        txtName.delegate = self
        txtCity.delegate = self
        APIGetStates { (isSuccess, strMsg, arrData) in
            if isSuccess{
                self.arrStatesData = arrData
                print("sfdsfrt4",arrData)
            }else{
                self.showAlertView(title: "", message: strMsg, defaultActionTitle: "OK", complitionHandler: {
                    
                })
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        resetData()
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
            nslcStackOptionsTop.constant = 10
            nslcStackOptionsBottom.constant = 15
            nslcBtnSignUpBottom.constant = 20
        } else if DeviceType.IS_IPHONE_6 {
            
        } else if DeviceType.IS_IPHONE_6P {
            nslcImgLogoHeight.constant = 121
            nslcImgLogoTop.constant = 30
            nslcImgLogoBottom.constant = 30
            nslcBtnLoginBottom.constant = 10
        } else if DeviceType.IS_IPHONE_X {
            nslcImgLogoHeight.constant = 121
            nslcImgLogoTop.constant = 40
            nslcImgLogoBottom.constant = 50
            nslcBtnLoginBottom.constant = 10
        } else if DeviceType.IS_IPHONE_XR {
            nslcImgLogoHeight.constant = 121
            nslcImgLogoTop.constant = 40
            nslcImgLogoBottom.constant = 80
            nslcBtnSignUpBottom.constant = 100
            nslcBtnLoginBottom.constant = 10
        } else {
            
        }
        
        let signupString = "Have an account? Login"
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "OpenSans", size: 16) ?? UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.black]
        let attributed = NSMutableAttributedString(string: signupString, attributes: attributes)
        
        if let tcRange = signupString.range(of: "Login") {
            
            let range = NSRange(tcRange, in: signupString)
            let font = UIFont(name: "OpenSans-SemiBold", size: 18) ?? UIFont.systemFont(ofSize: 18)
            attributed.addAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(hex: "eb642d")], range: range)
        }
        lblLoginTitle.attributedText = attributed
    }
    
    func resetData() {
        txtName.text = ""
        txtGender.text = ""
        txtEmail.text = ""
        txtDOB.text = ""
        txtPassword.text = ""
    //    txtUserName.text = ""
        birthDate = nil
    }
    
    @IBAction func didTappedLogin(_ sender: UIButton) {
        navigateToLoginScreen()
    }
    
    func navigateToLoginScreen() {
        if isFromLogin() {
            self.navigationController?.popViewController(animated: true)
        } else {
            let loginVC = UIStoryboard.loadLoginVC()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    
    @IBAction func didTappedSignUp(_ sender: UIButton) {
        
        if let text = txtName.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please enter your name!", defaultActionTitle: "OK", complitionHandler: {
                self.txtName.becomeFirstResponder()
            })
        } else if let text = txtGender.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please select your gender!", defaultActionTitle: "OK", complitionHandler: {
                self.txtGender.becomeFirstResponder()
            })
        } else if let text = txtDOB.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please select your date of birth!", defaultActionTitle: "OK", complitionHandler: {
                self.txtDOB.becomeFirstResponder()
            })
        }
            //else if let text = heightField.text, text.isEmpty {
//            self.showAlertView(title: "", message: "Please enter height", defaultActionTitle: "OK", complitionHandler: {
//                self.heightField.becomeFirstResponder()
//            })
//        }else if let text = weightField.text, !text.isEmpty {
//            self.showAlertView(title: "", message: "Please enter weight", defaultActionTitle: "OK", complitionHandler: {
//                self.weightField.becomeFirstResponder()
//            })
//        }
        else if let text = txtEmail.text, !text.isEmpty && !text.isValidEmail() {
            self.showAlertView(title: "", message: "Please enter valid email address!", defaultActionTitle: "OK", complitionHandler: {
                self.heightField.becomeFirstResponder()
            })
        }
//        } else if let text = txtUserName.text, text.isEmpty {
//            self.showAlertView(title: "", message: "Please enter your Username!", defaultActionTitle: "OK", complitionHandler: {
//                self.txtUserName.becomeFirstResponder()
//            })
         else if let text = txtPassword.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please enter your Password!", defaultActionTitle: "OK", complitionHandler: {
                self.txtPassword.becomeFirstResponder()
            })
        }else if let text = txPhoneNo.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please enter your Phone number", defaultActionTitle: "OK", complitionHandler: {
                self.txPhoneNo.becomeFirstResponder()
            })}else if let text = txtCity.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please enter your City", defaultActionTitle: "OK", complitionHandler: {
                self.txtCity.becomeFirstResponder()
            })}else if let text = txtState.text, text.isEmpty {
            self.showAlertView(title: "", message: "Please enter your State", defaultActionTitle: "OK", complitionHandler: {
                self.txtState.becomeFirstResponder()
            })}else {
            
            guard let nameText = txtName.text, let genderText = txtGender.text, let dobText = txtDOB.text, let heightText = heightField.text, let weightText = weightField.text, let emailText = txtEmail.text, let passwordText = txtPassword.text, let phoneNoText = txPhoneNo.text, let cityText = txtCity.text , let stateText = txtState.text else {
                return
            }
            appDelegate.showActivityControl()
            APISignUp(name: nameText, email: emailText, username: "", height:heightText, weight:weightText, gender: genderText, dob: dobText, password: passwordText, phoneNo: phoneNoText,city:cityText, state: stateText) { (isSucced, message) in
                if isSucced {
                    self.showAlertView(title: "", message: message, defaultActionTitle: "OK", complitionHandler: {
                        self.navigateToLoginScreen()
                    })
                } else {
                    self.showAlertView(title: "", message: message, defaultActionTitle: "OK", complitionHandler: {
                    
                    })
                }
            }
        }
    }
    
    func isFromLogin() -> Bool {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                
                return true
            }
        }
        return false
    }
    
    
}
extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == txtName || textField == txtCity {
//            textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
//            return false
//        }else{
//            return true
//        }
//        
//    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDOB {
            textField.inputView = pickerDate()
        } else if textField == txtGender {
            textField.inputView = pickerDropDown()
        }else if textField == txtState{
            textField.inputView = pickerStateDropDown()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let delegate = self.textDelegate, let text = textField.text {
//            if type != .date && type != .autoComplete {
//                delegate.textfield(self, didChangedText: text, atIndex: self.tag)
//            }
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func pickerDate() -> UIDatePicker {
        
      //  let toDate = NSDate()
        // let fromDate = Calendar.current.date(byAdding: .year, value: -19, to: toDate as Date)
        
        let datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = TimeZone(abbreviation: "UTC")
        datePicker.maximumDate = Date()
        if let date = self.birthDate {
            datePicker.date = date
        } else {
            let date = Date()
            
            datePicker.date = date
            self.birthDate = date
            let strVal = date.convertIntoString(format: "yyyy-MM-dd")
            txtDOB.text = strVal //dateFormatter1.string(from: dtd!)
            
//            if let delegate = self.textDelegate, let text = self.text {
//                if type == .date {
//                    delegate.textfield(self, didChangedText: text, atIndex: self.tag)
//                }
//            }
        }
        
        datePicker.addTarget(self, action: #selector(didBirthDateChanged(_:)), for: .valueChanged)
        return datePicker
    }
    
    @objc func didBirthDateChanged(_ sender: UIDatePicker) {
        let strVal = sender.date.convertIntoString(format: "yyyy-MM-dd")
        txtDOB.text = strVal
        self.birthDate = sender.date
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == heightField)
        {
            let maxLength = 2
            let currentString: NSString = heightField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if(textField == weightField)
        {
            let maxLength = 3
            let currentString: NSString = weightField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if(textField == txPhoneNo)
               {
                   let maxLength = 10
                   let currentString: NSString = txPhoneNo.text! as NSString
                   let newString: NSString =
                       currentString.replacingCharacters(in: range, with: string) as NSString
                   return newString.length <= maxLength
               }
        return true;
    }
    func pickerDropDown() -> LWPickerView {
        
        
            let drpdwnPicker = LWPickerView(type: .string, input: genderList)
            drpdwnPicker.selectedIndex = self.drpdwnIndex
            let value = genderList[self.drpdwnIndex]
            txtGender.text = value
            drpdwnPicker.onInputStringSelected = {(index: Int) in
                self.drpdwnIndex = index
                let value = self.genderList[index]
                self.txtGender.text = value
            }
            return drpdwnPicker
    }
    
    func pickerStateDropDown() -> LWPickerView {
        
        
        let drpdwnPicker = LWPickerView(type: .string, input: arrStatesData)
        drpdwnPicker.selectedIndex = self.drpdwnIndex
        let value = arrStatesData[self.drpdwnIndex]
        txtState.text = value
        drpdwnPicker.onInputStringSelected = {(index: Int) in
            self.drpdwnIndex = index
            let value = self.arrStatesData[index]
            self.txtState.text = value
        }
        return drpdwnPicker
    }
    
}


extension SignUpVC {
    func APISignUp(name: String, email:String, username: String, height: String, weight: String, gender: String, dob: String, password: String,phoneNo:String,city:String,state:String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.signup + "height=\(height)&weight=\(weight)&email=\(email)&password=\(password)&name=\(name)&dob=\(dob)&gender=\(gender)&phone=\(phoneNo)&city=\(city)&state=\(state)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    
                    completion(true,message)
                } else {
                    completion(false,message)
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
        
    }
    func APIGetStates(ComplitionHandler completion:@escaping (_ isSucceed: Bool, _ message: String, _ arrData:[String])-> Void) {
        let url = SERVERURL.getState
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    guard let data = dictResponse["stateslist"] as? [[String:String]] else{
                        completion(false,"Some error occured, Please try after some time!", [""])
                        return
                    }
                    var aArrData = [String]()
                    for i in data{
                        guard let strStateName = i["statename"] as? String else{
                            return
                        }
                        aArrData.append(strStateName)
                    }
                    completion(true,message, aArrData)
                } else {
                    completion(false,message, [""])
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!", [""])
            }
        }
    }
}
