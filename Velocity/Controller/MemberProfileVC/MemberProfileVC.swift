//
//  MemberProfileVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit
import SDWebImage

class MemberProfileVC: UIViewController, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate {
// MARK: - Declaration
    @IBOutlet weak var scrlContent: UIScrollView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgProfile: LWAvatarImageView!
    @IBOutlet weak var lblSubscriptionPeriod: UILabel!
    @IBOutlet weak var btnSubscription: VFHButton!
    @IBOutlet weak var btnCaptureProfile: UIButton!
    @IBOutlet weak var btnEditProfile: VFHButton!
    @IBOutlet weak var lblProfileTitle: UILabel!
    @IBOutlet weak var viewDetailContainer: UIView!
     @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var txtFitnessName: VFHTextField!
    
    
    @IBOutlet weak var nslcImgProfileHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcImgProfileTop: NSLayoutConstraint!
    @IBOutlet weak var nslcLblNameTop: NSLayoutConstraint!
    @IBOutlet weak var nslcBtnEditProfileBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcImgProfileBottom: NSLayoutConstraint!
    @IBOutlet weak var txtName: GBTextField!
    @IBOutlet weak var txtBenchPress: GBTextField!
    @IBOutlet weak var txtAge: GBTextField!
    @IBOutlet weak var txtBackSquat: GBTextField!
    @IBOutlet weak var txtDateJoined: GBTextField!
    @IBOutlet weak var txtDeadLift: GBTextField!
    @IBOutlet weak var txtHeight: GBTextField!
    @IBOutlet weak var txtmRow500: GBTextField!
    @IBOutlet weak var txtTimeTravel4KM: GBTextField!
    @IBOutlet weak var txtWeight: GBTextField!
    @IBOutlet weak var txtMaxBridge: GBTextField!
    @IBOutlet weak var nslcLblNameBottom: NSLayoutConstraint!
    @IBOutlet weak var nslcTxtFitnessNameHeight: NSLayoutConstraint!
    @IBOutlet weak var stackFitnessName: UIStackView!
    @IBOutlet weak var stackSubscribe: UIStackView!
    
    
//  local Declaration
    var picker:UIImagePickerController?=UIImagePickerController()
    var isEditingProfile = false
    var userDetail: UserDetail?
    var isFirstAttempt = true
    fileprivate var joinedDate: Date?
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    var imgSelectedProfile: UIImage?
    public enum ImageFormat {
        case png
        case jpeg(CGFloat)
    }
    let intImageWidth:Double = 150.0
    var isImgSelected = true
    var strFitnessName = ""
    
    var picker_BenchPress: UIPickerView! = UIPickerView()
    var picker_BackSquat: UIPickerView! = UIPickerView()
    var picker_Deadlift: UIPickerView! = UIPickerView()
    var picker_Weight: UIPickerView! = UIPickerView()
    
    var picker_500mRow: UIPickerView! = UIPickerView()
    var picker_4kmTimeTrial: UIPickerView! = UIPickerView()
    var picker_MaxBridge: UIPickerView! = UIPickerView()
    
    var arrWeight = [Int]()
    var arrMin = [Int]()
    var arrSecond = [Int]()
    
    var subWeightArray = [".0 Kg",".5 Kg"]

// MARK: - Controllers LifeCycle Methodsdid
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        btnCaptureProfile.isHidden = true
        txtFitnessName.placeHolderColor = .white
        txtFitnessName.delegate = self
        txtName.delegate = self
        txtBenchPress.delegate = self
        txtBackSquat.delegate = self
        txtDateJoined.delegate = self
        txtDeadLift.delegate = self
        txtHeight.delegate = self
        txtmRow500.delegate = self
        txtWeight.delegate = self
        txtTimeTravel4KM.delegate = self
        txtMaxBridge.delegate = self
        
        txtFitnessName.attributedPlaceholder = NSAttributedString(string: "Enter your training goals here",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        for i in 1...250 {
         //   if i%10 == 0 {
                self.arrWeight.append(i)
            //}
        }
        for i in 1...60 {
            self.arrMin.append(i)
        }
        for i in 0...59 {
            self.arrSecond.append(i)
        }
        picker_BenchPress.delegate = self
        picker_BenchPress.dataSource = self
        txtBenchPress.inputView = picker_BenchPress
        
        picker_BackSquat.delegate = self
        picker_BackSquat.dataSource = self
        txtBackSquat.inputView = picker_BackSquat
        
        picker_Deadlift.delegate = self
        picker_Deadlift.dataSource = self
        txtDeadLift.inputView = picker_Deadlift
        
        picker_Weight.delegate = self
        picker_Weight.dataSource = self
        txtWeight.inputView = picker_Weight
        
        picker_500mRow.delegate = self
        picker_500mRow.dataSource = self
        txtmRow500.inputView = picker_500mRow
        
        picker_4kmTimeTrial.delegate = self
        picker_4kmTimeTrial.dataSource = self
        txtTimeTravel4KM.inputView = picker_4kmTimeTrial
        
        picker_MaxBridge.delegate = self
        picker_MaxBridge.dataSource = self
        txtMaxBridge.inputView = picker_MaxBridge
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNaviigationBarItem(withBackButton: false, withNotification: false)
//        viewContainer.isHidden = true
        if !isImgSelected {
            isImgSelected = true
            resetMemberShipData()
        }
        
        self.setLeftNavigationItems(title: "History", selector: #selector(self.didUserHistory(_:)))
        self.setRightNavigationItems(title: "Log Out", selector: #selector(self.didTappedLogout(_:)))
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
            nslcImgProfileHeight.constant = 60
            nslcTxtFitnessNameHeight.constant = 25
        } else if DeviceType.IS_IPHONE_5 {
            nslcImgProfileHeight.constant = 80
            nslcImgProfileBottom.constant = 10
            nslcLblNameTop.constant = 5
            nslcLblNameBottom.constant = 5
            nslcImgProfileTop.constant = 15
            let font = UIFont(name: "OpenSans-SemiBold", size: 8) ?? UIFont.systemFont(ofSize: 8)
            btnSubscription.titleLabel?.font = font
            nslcTxtFitnessNameHeight.constant = 25
            
        } else if DeviceType.IS_IPHONE_6 {
            //nslcLblNameTop.constant = 5
            nslcLblNameBottom.constant = 10
        } else if DeviceType.IS_IPHONE_6P {
            nslcImgProfileHeight.constant = 120
        } else if DeviceType.IS_IPHONE_X {
            nslcImgProfileHeight.constant = 100
        } else if DeviceType.IS_IPHONE_XR {
            nslcImgProfileHeight.constant = 120
        }
        viewContainer.isHidden = true
        appDelegate.showActivityControl()
        getMemberDetails()
    }
    
    func resetMemberShipData() {
        if !isFirstAttempt {
            resetDefaults()
            getMemberDetails()
        }
    }
    
    func getMemberDetails() {
        
        guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        isFirstAttempt = false
        
        APIGetUserDetails(user.userID) { (isSucceed, message, list) in
            //DispatchQueue.main.async(execute: {
                if let obj = list {
                    self.userDetail = obj
                }
                self.manageLayout()
            //})
        }
    }
    func manageLayout() {
        
        if let model = userDetail {
           
            txtName.text = model.name
            txtBenchPress.text = model.benchPress
            txtAge.text = model.age
            txtBackSquat.text = model.backSquat
            txtDateJoined.text = model.dob
            txtDeadLift.text = model.deadLift
            txtHeight.text = model.height
            txtmRow500.text = model.mRow500
            txtWeight.text = model.weight
            txtTimeTravel4KM.text = model.timeTravel4KM
            txtMaxBridge.text = model.max_bridge
            txtFitnessName.text = model.fitnessName
            lblProfileTitle.text = model.profiletitle
            
//            if model.subStartDate.count > 0 && model.subEndDate.count > 0 {
//                lblSubscriptionPeriod.text = "\(model.subStartDate) - \(model.subEndDate)"
//                lblSubscriptionPeriod.isHidden = false
//            } else if model.subStartDate.count > 0 {
//                lblSubscriptionPeriod.text = "\(model.subStartDate)"
//                lblSubscriptionPeriod.isHidden = false
//            } else {
//                lblSubscriptionPeriod.isHidden = true
//            }
            
            if model.dob.count > 0 {
                if let dt = dateFormatter.date(from: model.dob) {
                    self.joinedDate = dt
                }
            }
            
            if model.imgURL.count > 0 {
                let urlString = model.imgURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                guard let url = URL(string: urlString!) else {
                    imgProfile.image = UIImage(named: "get-strong")
                    return
                }
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            if let img = UIImage(data: data){
                                self.imgSelectedProfile = self.cropToBounds(image: img, width: self.intImageWidth, height: self.intImageWidth)
                                self.imgProfile.image = self.cropToBounds(image: img, width: self.intImageWidth, height: self.intImageWidth)
                            }else{
                                self.imgProfile.image = UIImage(named: "get-strong")
                            }
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.imgProfile.image = UIImage(named: "get-strong")
                        }
                    }
                }
//                self.imgProfile.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
//                    if image == nil {
//                        self.imgProfile.image = UIImage(named: "get-strong")
//                    } else {
//                        self.imgProfile.image = image
//                        self.imgSelectedProfile = image
//                    }
//                }
            } else {
                imgProfile.image = UIImage(named: "get-strong")
            }
            
        } else {
            txtFitnessName.text = ""
            txtName.text = ""
            txtBenchPress.text = ""
            txtAge.text = ""
            txtBackSquat.text = ""
            txtDateJoined.text = ""
            txtDeadLift.text = ""
            txtHeight.text = ""
            txtmRow500.text = ""
            txtWeight.text = ""
            txtTimeTravel4KM.text = ""
            lblProfileTitle.text = ""
        }
        viewContainer.isHidden = false
    }
    
    func resetDefaults() {
        txtFitnessName.isUserInteractionEnabled = false
//        lblProfileTitle.isUserInteractionEnabled = false
        btnCaptureProfile.isHidden = true
        isEditingProfile = false
        imgSelectedProfile = nil
        viewDetailContainer.isUserInteractionEnabled = false
        btnEditProfile.setTitle("Edit Profile", for: .normal)
        btnEditProfile.backgroundColor = UIColor.white
        btnEditProfile.tintColor = UIColor.black
    }
    
    @IBAction func didTappedLogout(_ sender: UIButton) {
        appDelegate.logoutTapped()
    }
    @IBAction func didUserHistory(_ sender: UIButton) {
        
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserHistoryVC") as! UserHistoryVC
            self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    @IBAction func didTappedEditProfile(_ sender: UIButton) {
        
        if !isEditingProfile {
            txtFitnessName.isUserInteractionEnabled = true
            btnCaptureProfile.isHidden = false
            isEditingProfile = true
            viewDetailContainer.isUserInteractionEnabled = true
            lblProfileTitle.isUserInteractionEnabled = false
            sender.setTitle("Save Profile", for: .normal)
            sender.backgroundColor = UIColor.black
            sender.tintColor = UIColor.white
        } else {
            
//            if self.imgSelectedProfile == nil {
//                self.showAlertView(title: "", message: "Please select your profile picture!", defaultActionTitle: "OK", complitionHandler: {
//
//                })
//            } else {
                saveEditMemberDetails()
//            }
        }
    }
    
    func saveEditMemberDetails() {
        guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        var pictureStr: Data?
//        imgSelectedProfile
        if let img = self.imgProfile.image {
            let imgData = img.jpegData(compressionQuality: 0.0)
            pictureStr = imgData //convertImageTobase64(format: .jpeg(0.0), image: img) ?? "" //imgData?.base64EncodedString(options: .lineLength64Characters) ?? ""
//            if pictureStr.count > 0 {
//                pictureStr = "data:image/jpeg;base64, \(pictureStr)"
//            }
        }
        
        appDelegate.showActivityControl()
        APIEditUserDetails(user.userID, name: txtName.text ?? "", fitnessName: txtFitnessName.text ?? "", benchPress: txtBenchPress.text ?? "", age: txtAge.text ?? "", dateOfJoining: txtDateJoined.text ?? "", backSquat: txtBackSquat.text ?? "", deadLift: txtDeadLift.text ?? "", mRow500: txtmRow500.text ?? "", height: txtHeight.text ?? "", weight: txtWeight.text ?? "", timeTravel4KM: txtTimeTravel4KM.text ?? "", max_bridge: txtMaxBridge.text ?? "", picture: pictureStr) { (isSucceed, message) in
            DispatchQueue.main.async(execute: {
                self.showAlertView(message: message, defaultActionTitle: "OK", complitionHandler: {
                    if isSucceed {
                        self.resetDefaults()
                        self.getMemberDetails()
                    }
                })
            })
        }
    }
    func convertImageTobase64(format: ImageFormat, image:UIImage) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = image.pngData() //UIImagePNGRepresentation(image)
        case .jpeg(let compression): imageData = image.jpegData(compressionQuality: compression) //UIImageJPEGRepresentation(image, compression)
        }
        return imageData?.base64EncodedString()
    }

    
    @IBAction func didTappedReneval(_ sender: UIButton) {
        navigateToSubscription()
    }
    
    @IBAction func didTappedSubscription(_ sender: UIButton) {
        navigateToSubscription()
    }
    @IBAction func didTappedSubmit(_ sender: UIButton) {
        isEditingProfile = false
        viewDetailContainer.isUserInteractionEnabled = false
        btnSubmit.isHidden = true
    }
    
    func navigateToSubscription() {
        let subVC = UIStoryboard.loadSubscriptionVC()
        
        if let obj = self.userDetail {
            subVC.selectedPlan = obj.plan
        }
        
        self.navigationController?.pushViewController(subVC, animated: true)
    }
    
    @IBAction func didTappedPhotoCapture(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Set Profile Image", message: "", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        actionSheet.addAction(cancelActionButton)
        
        let captureActionButton = UIAlertAction(title: "Capture", style: .default) { (_) in
            self.openCamera()
        }
        actionSheet.addAction(captureActionButton)
        let galleryActionButton = UIAlertAction(title: "Gallery", style: .default) { (_) in
            self.openGallary()
        }
        actionSheet.addAction(galleryActionButton)
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        actionSheet.popoverPresentationController?.barButtonItem = UIBarButtonItem(customView: sender)
        present(actionSheet, animated: true) {
            
        }
        
    }
    
    
    func openGallary()
    {
        picker?.delegate = self
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            picker!.allowsEditing = false
            picker?.delegate = self
            picker!.sourceType = UIImagePickerController.SourceType.camera
            picker!.cameraCaptureMode = .photo
            present(picker!, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Camera Not Found", message: "This device has no Camera", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style:.default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        isImgSelected = true
        if let image = info[.originalImage] as? UIImage {
            
            imgProfile.image = cropToBounds(image: image, width: self.intImageWidth, height: self.intImageWidth)
            imgSelectedProfile = cropToBounds(image: image, width: self.intImageWidth, height: self.intImageWidth)
            
            dismiss(animated: false) {
                
            }
        } else {
            
        }
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isImgSelected = true
        dismiss(animated: true) {
        }
        
    }
   // MARK:- External Method
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x:posX,y: posY,width: cgwidth,height:  cgheight)
        
        // Create bitmap image from context using the rect
        //let imageRef: CGImage = CGImageCreateWithImageInRect(contextImage.cgImage!, rect)!
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}

extension MemberProfileVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFitnessName {
            self.txtFitnessName.text = ""
            self.txtFitnessName.placeholder = ""
        }else{
            if txtFitnessName.text == ""{
                self.txtFitnessName.text =  ""
                self.txtFitnessName.placeholder = "Enter your training goals here"
            }
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDateJoined {
            textField.inputView = pickerDate()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 100
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
        
        let datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = TimeZone(abbreviation: "UTC")
        datePicker.maximumDate = Date()
        if let date = self.joinedDate {
            datePicker.date = date
        } else {
            let date = Date()
            datePicker.date = date
            self.joinedDate = date
            let strVal = date.convertIntoString(format: "dd/MM/yyyy")
            txtDateJoined.text = strVal //dateFormatter1.string(from: dtd!)
            
        }
        
        datePicker.addTarget(self, action: #selector(didBirthDateChanged(_:)), for: .valueChanged)
        return datePicker
    }
    
    @objc func didBirthDateChanged(_ sender: UIDatePicker) {
        let strVal = sender.date.convertIntoString(format: "dd/MM/yyyy")
        txtDateJoined.text = strVal
        self.joinedDate = sender.date
        
    }
    
    
}

extension MemberProfileVC {
    // API Add Document
    func APIGetUserDetails(_ userID: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String, _ userDetail: UserDetail?)-> Void) {
        let url = SERVERURL.getMemberProfile + "&userid=\(userID)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let data = dictResponse["userdetails"] as? [String: Any] {
                       let detail = UserDetail(Data: data)
                        completion(true,message, detail)
                        return
                    }
                    completion(false,"Some error occured, Please try after some time!", nil)
                } else {
                    completion(false,message, nil)
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!", nil)
            }
        }
    }
    
    func APIEditUserDetails(_ userID: String, name:String, fitnessName:String, benchPress: String, age: String, dateOfJoining: String, backSquat: String, deadLift: String, mRow500: String, height: String, weight: String, timeTravel4KM: String, max_bridge: String, picture: Data? = nil, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.editUserProfile + "&userid=\(userID)&name=\(name)&fitnessname=\(fitnessName)&age=\(age)&dateofjoining=\(dateOfJoining)&back_squat=\(backSquat)&deadlift=\(deadLift)&500m_row=\(mRow500)&height=\(height)&weight=\(weight)&bench_press=\(benchPress)&time_trial=\(timeTravel4KM)&max_bridge=\(max_bridge)"
        
        var param = [String: Data]()
        
        if let objData = picture {
            param["profile_pic"] = objData
        }
        ApiManager.sharedManager.cancelAllTasks()
        
        ApiManager.sharedManager.requestForPostWithMultipleMedia(urlQuery: url, dictParam: [:], uploadImageArray: param) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    completion(true,"Your profile has been updated.")
                } else {
                    completion(false,message)
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
        
//        ApiManager.sharedManager.requestForPost(urlQuery: url, dictParam: NSDictionary(dictionary: param)) { (response, error) in
//            appDelegate.hideActivityControl()
//            if error == nil, let dictResponse = response as? [String: Any] {
//                print(dictResponse)
//                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
//                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
//                    completion(true,"Profile Submitted")
//                } else {
//                    completion(false,message)
//                }
//            } else {
//                print(error?.localizedDescription as Any)
//                completion(false,"Some error occured, Please try after some time!")
//            }
//        }
//        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
//            appDelegate.hideActivityControl()
//            if error == nil, let dictResponse = response as? [String: Any] {
//                print(dictResponse)
//                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
//                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
//                    if let data = dictResponse["userdetails"] as? [String: Any] {
//                        let detail = UserDetail(Data: data)
//                        completion(true,message, detail)
//                        return
//                    }
//                    completion(false,"Some error occured, Please try after some time!", nil)
//                } else {
//                    completion(false,message, nil)
//                }
//            } else {
//                print(error?.localizedDescription as Any)
//                completion(false,"Some error occured, Please try after some time!", nil)
//            }
//        }
    }
    
    

    
    
}
extension MemberProfileVC: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if  pickerView == picker_BackSquat || pickerView == picker_Deadlift || pickerView == picker_Weight {
            return 1
        }
        else if pickerView == picker_BenchPress {
            return 2
        }
        else{
            return 2
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case picker_BackSquat,picker_Deadlift,picker_Weight:
        return arrWeight.count
        case picker_BenchPress:
             if component == 0 {
        return arrWeight.count
            }
             return subWeightArray.count
        case picker_500mRow,picker_4kmTimeTrial,picker_MaxBridge:
        return arrMin.count
        default:
        return 0
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case picker_BenchPress:
             if component == 0 {
            return "\(arrWeight[row]) "
            }
             else{
                return "\(subWeightArray[row])"

            }
        case picker_BackSquat:
            return "\(arrWeight[row]) Kg"
        case picker_Deadlift:
            return "\(arrWeight[row]) Kg"
        case picker_Weight:
            return "\(arrWeight[row]) Kg"
        case picker_500mRow:
            if component == 0 {
                return "\(arrMin[row]) m"
            }else{
                return "\(arrSecond[row]) s"
            }
            
        case picker_4kmTimeTrial:
            if component == 0 {
                return "\(arrMin[row]) m"
            }else{
                return "\(arrSecond[row]) s"
            }
        case picker_MaxBridge:
            if component == 0 {
                return "\(arrMin[row]) m"
            }else{
                return "\(arrSecond[row]) s"
            }
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case picker_BenchPress:
        //    txtBenchPress.text = "\(arrWeight[row]) "
            var kgs = ""
            if(component == 0)
            {
                 txtBenchPress.text = "\(Int(pickerView.selectedRow(inComponent: 0)+1))kg"
            }
            else{
                txtBenchPress.text = "\(Int(pickerView.selectedRow(inComponent: 0)+1))\(subWeightArray[row])"

            }

        case picker_BackSquat:
            txtBackSquat.text = "\(arrWeight[row]) kg"
        case picker_Deadlift:
            txtDeadLift.text = "\(arrWeight[row]) kg"
        case picker_Weight:
            txtWeight.text = "\(arrWeight[row]) kg"
        case picker_500mRow:
            
            txtmRow500.text = "\(Int(pickerView.selectedRow(inComponent: 0)+1))m \(pickerView.selectedRow(inComponent: 1))s"
        case picker_4kmTimeTrial:
            txtTimeTravel4KM.text = "\(Int(pickerView.selectedRow(inComponent: 0)+1))m \(pickerView.selectedRow(inComponent: 1))s"
        case picker_MaxBridge:
            txtMaxBridge.text = "\(Int(pickerView.selectedRow(inComponent: 0)+1))m \(pickerView.selectedRow(inComponent: 1))s"
        default:
            print("none")
        }
    }
}
