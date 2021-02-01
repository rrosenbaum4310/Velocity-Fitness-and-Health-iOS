//
//  SubscriptionVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit

class SubscriptionVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var tblPackages: UITableView!
    @IBOutlet weak var btnProceed: VFHGradientButton!
    
    
//  local Declaration
    let cellIdentifier = "IdentifierSubscriptionCell"
    private let cellErrorIdentifier = "cellErrorMessageIdentifier"
    var membershipList = [Membership]()
    var selectedPlan = ""
    var isCompulsarySelection = false
    var payPalConfig = PayPalConfiguration()
    let items:NSMutableArray = NSMutableArray()
    
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnProceed.isUserInteractionEnabled = true
        initialSetup()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        if isCompulsarySelection {
            self.setupNaviigationBarItem(withBackButton: false, withNotification: false)
            self.setRightNavigationItems(title: "Log Out", selector: #selector(self.didTappedLogout(_:)))
//            if let image = UIImage(named: "logout") {
//                self.setRightNavigationItems(image: image, selector: #selector(self.didTappedLogout(_:)))
//            }
        } else {
            self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
        }
        
        
        tblPackages.tableFooterView = UIView()
        self.tblPackages.isHidden = true
        getMembershipList()
    }
    func getMembershipList() {
        
        APIGetMembership { (isSucceed, message, list) in
            DispatchQueue.main.async(execute: {
                if let objList = list {
                    self.membershipList = objList
                    let aArrFilter = self.membershipList.filter{
                        $0.membershipID == self.selectedPlan
                    }
                    if aArrFilter.count > 0{
                        if self.selectedPlan == aArrFilter[0].membershipID {
                            self.btnProceed.isUserInteractionEnabled = false
                        }else{
                            self.btnProceed.isUserInteractionEnabled = true
                        }
                    }
                    
                } else {
                    self.membershipList.removeAll()
                }
                self.manageLayout()
            })
        }
    }
    func manageLayout() {
        self.tblPackages.isHidden = false
        self.tblPackages.reloadData()
    }
    
    func saveMembershipPlan(planID: String) {
        
        guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        appDelegate.showActivityControl()
        APISaveMembership(user.userID, plan: planID) { (isSucceed, message) in
            DispatchQueue.main.async(execute: {
                self.APICallAfterPayment()
//                self.showAlertView(message: message, defaultActionTitle: "OK", complitionHandler: {
//                    if self.isCompulsarySelection {
//                        //appDelegate.setLoginAuth()
//                    } else {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                })
            })
        }
    }
    
    func APICallAfterPayment() {
        
        let email = GlobalManager.sharedInstance.getEmailAddress()
        let password = GlobalManager.sharedInstance.getPassword()
        
//        appDelegate.showActivityControl()
        APIAfterPaymentDone(email, password: password) { (isSucceed, message) in
            DispatchQueue.main.async(execute: {
                self.showAlertView(message: message, defaultActionTitle: "OK", complitionHandler: {
                    if self.isCompulsarySelection {
                        GlobalManager.sharedInstance.resetUserData()
                        appDelegate.setLoginAuth()
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }
    }
    
    @IBAction func didTappedSavePlan(_ sender: UIButton) {
        let obj = membershipList.filter { $0.isSelected }
        if obj.count == 0 {
            self.showAlertView(message: "Please select Membership plan!", defaultActionTitle: "OK") {
                
            }
        } else {
            if let plan = obj.first {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSubDetailVC") as! PaymentSubDetailVC
                vc.strPlan_id = plan.membershipID
                self.navigationController?.pushViewController(vc, animated: true)
//                openPaypalController(plan: plan)
//                appDelegate.showActivityControl()
//                saveMembershipPlan(planID: plan.membershipID)
            }
        }
    }
    @IBAction func didTappedLogout(_ sender: UIButton) {
        appDelegate.logoutTapped()
    }
    
    func openPaypalController(plan: Membership) {
        items.removeAllObjects()
        self.configurePaypal(strMarchantName: "Velocity")
    
        self.setItems(plan.title, noOfItem: "1", strPrice: plan.finalPrice, strCurrency: plan.currency, strSku: nil)
        self.goforPayNow(shipPrice: nil, taxPrice: nil, totalAmount: nil, strShortDesc: plan.title, strCurrency: plan.currency)
    }
    
    func setItems(_ strItemName:String?, noOfItem:String?, strPrice:String?, strCurrency:String?, strSku:String?) {
        let quantity : UInt = UInt(noOfItem!)!
        
        let item = PayPalItem.init(name: strItemName!, withQuantity: quantity, withPrice: decimal(with: strPrice), withCurrency: strCurrency!, withSku: strSku)
        items.add(item)
        print("\(items)")
    }
    //It will provide access to the card too for the payment.
    func decimal(with string: String?) -> NSDecimalNumber {
        guard let string = string else {
            return 0
        }
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: string) as? NSDecimalNumber ?? 0
    }
    func acceptCreditCards() -> Bool {
        return self.payPalConfig.acceptCreditCards
    }
    
    func setAcceptCreditCards(acceptCreditCards: Bool) {
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards()
    }
    
    //Set environment connection.
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    //Configure paypal and set Marchant Name
    func configurePaypal(strMarchantName:String) {
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = self.acceptCreditCards();
        payPalConfig.merchantName = strMarchantName
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")   //NSURL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]  // NSLocale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .payPal;
    
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
        
        PayPalMobile.preconnect(withEnvironment: environment)
        
    }
    
    
    
    //Start Payment for selected shopping items
    
    func goforPayNow(shipPrice:String?, taxPrice:String?, totalAmount:String?, strShortDesc:String?, strCurrency:String?) {
        
        var subtotal : NSDecimalNumber = 0
        
        var shipping : NSDecimalNumber = 0
        
        var tax : NSDecimalNumber = 0
        
        if items.count > 0 {

            subtotal = PayPalItem.totalPrice(forItems: items as [AnyObject])

        } else {
        
            subtotal = NSDecimalNumber(string: totalAmount)
            
        }
        
        
        
        // Optional: include payment details
        
        if (shipPrice != nil) {
            shipping = NSDecimalNumber(string: shipPrice)
        }
        if (taxPrice != nil) {
            tax = NSDecimalNumber(string: taxPrice)
        }
        var description = strShortDesc
        if (description == nil) {
            description = ""
        }
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        let total = subtotal.adding(shipping).adding(tax)
        let payment = PayPalPayment(amount: total, currencyCode: strCurrency!, shortDescription: description!, intent: .sale)
        
       // payment.items = items as [AnyObject]
        
        payment.paymentDetails = paymentDetails
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards();
        if self.payPalConfig.acceptCreditCards == true {
            print("We are able to do the card payment")
        }
        if (payment.processable) {
            UIApplication.shared.statusBarStyle = .default
             UIBarButtonItem.appearance().tintColor = UIColor.black
            let objVC = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            objVC?.navigationBar.barTintColor = UIColor(hex: "000000")
            self.present(objVC!, animated: true, completion: { () -> Void in
                print("Paypal Presented")
            })
        } else {
            print("Payment not processalbe: \(payment)")
        }
    }
}


// MARK: - TableView DataSource and Delegate
extension SubscriptionVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return membershipList.count > 0 ? membershipList.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if membershipList.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! SubscriptionCell
            let obj = membershipList[indexPath.row]
            cell.configureCell(model: obj)
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellErrorIdentifier, for: indexPath)
            // Configure the cell...
            cell.tag = indexPath.row
            cell.selectionStyle = .none
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

extension SubscriptionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        membershipList.forEach { (membership) in
            membership.isSelected = false
        }
        
        let obj = membershipList[indexPath.row]
        obj.isSelected = true
        membershipList[indexPath.row] = obj
        if selectedPlan == membershipList[indexPath.row].membershipID {
            self.btnProceed.isUserInteractionEnabled = false
        }else{
            self.btnProceed.isUserInteractionEnabled = true
        }
        tblPackages.reloadData()
    }
}
extension SubscriptionVC {
    // API Add Document
    func APIGetMembership(CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ bannerList:[Membership]?)-> Void) {
        let url = SERVERURL.getMembershipList
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let dataList = dictResponse["membership"] as? [[String: Any]] {
                    let list = Membership.PopulateArray(array: dataList, SelectedPlanID: self.selectedPlan)
                    completion(true, message, list)
                    return
                }
                completion(false, message, nil)
                
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!", nil)
            }
        }
    }
    func APISaveMembership(_ userID: String, plan planID: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.saveMembershipPlan + "&userid=\(userID)&plan=\(planID)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
           // appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    completion(true, "Subscription saved successfully")
                    return
                } else {
                    completion(false, message)
                }
                
                
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
    }
    func APIAfterPaymentDone(_ email: String, password aPassword: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String)-> Void) {
        let url = SERVERURL.afterPaymentDoneURL + "&email=\(email)&password=\(aPassword)"
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["userdata"] as? String, isStatus == "success" {
                    completion(true, "Subscription saved successfully")
                    return
                } else {
                    completion(false, message)
                }
                
                
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!")
            }
        }
    }
}

extension SubscriptionVC: PayPalPaymentDelegate {
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        paymentViewController.dismiss(animated: true) { () -> Void in
            UIApplication.shared.statusBarStyle = .lightContent
            UIBarButtonItem.appearance().tintColor = UIColor.white
            print("and Dismissed")
        }
        print("Payment cancel")

    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
        paymentViewController.dismiss(animated: true) { () -> Void in
            UIApplication.shared.statusBarStyle = .lightContent
            UIBarButtonItem.appearance().tintColor = UIColor.white
            print("and done")
            let obj = self.membershipList.filter { $0.isSelected }
            if let plan = obj.first {
                
                appDelegate.showActivityControl()
                self.saveMembershipPlan(planID: plan.membershipID)
            }
            
        }
        
        print("Paymane is going on")
        
    }
    
    
}
