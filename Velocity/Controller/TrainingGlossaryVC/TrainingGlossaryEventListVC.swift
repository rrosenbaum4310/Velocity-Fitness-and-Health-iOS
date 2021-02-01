//
//  TrainingGlossaryEventListVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 08/03/19.
//

import UIKit

class TrainingGlossaryEventListVC: UIViewController {
    // MARK: - Declaration
    @IBOutlet var btnWeekDays: [VFHButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewEvents: UIView!
    
    
    //  local Declaration
    var viewLine = UIView()
    let reuseIdentifier = "collSlider"
    var weekDays: WeekDays?
    var calendarEvents = [CalendarEvents]()
    var videoList = [Video]()
    let cellIdentifier = "cell"
    private let cellErrorIdentifier = "cellErrorMessageIdentifier"
    fileprivate var isFirstLoadCompleted = false
    // MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        if isFirstLoadCompleted {
            getWeekDays()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
        super.viewDidDisappear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            
            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                
                if let obj = object as? UITableView {
                    if obj === tableView {
                        if calendarEvents.count > 0 {
                            self.viewLine.isHidden = false
                            if newsize.height > 0 {
                                var rect = CGRect(x: 30, y: 21, width: 1, height: 50)
                                
//                                if newsize.height > tableView.frame.size.height {
//                                    rect.size.height = newsize.height
//                                } else {
//                                    rect.size.height = tableView.frame.size.height
//                                }
                                rect.size.height = newsize.height
                                self.viewLine.frame = rect
                            } else {
                                self.viewLine.isHidden = true
                            }
                        } else {
                            self.viewLine.isHidden = true
                        }
                        
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    // MARK: - Methods
    func initialSetup() {
        self.setupNaviigationBarItem(withBackButton: false, withNotification: false)
        self.viewContainer.isHidden = true
        self.tableView.tableFooterView = UIView()
        viewLine.backgroundColor = UIColor(hex: "EB642D")
        viewLine.isHidden = true
        
        self.tableView.addSubview(viewLine)
        getWeekDays()
    }
    func getWeekDays() {
        isFirstLoadCompleted = true
        appDelegate.showActivityControl()
        APIGetWeekDays { (isSucceed, message, dataObj) in
            DispatchQueue.main.async(execute: {
                if let obj = dataObj {
                    self.viewContainer.isHidden = false
                    self.weekDays = obj
                    self.setLayoutContent()
                    self.getCategoryNotes(date: obj.firstDate)
                }
            })
        }
    }
    func setLayoutContent() {
        if let obj = weekDays {
            btnWeekDays.forEach { (sender) in
                
                switch sender.tag {
                case 0:
                    sender.setTitle(obj.firstDay, for: .normal)
                    setBtnWeekdaysLayout(sender: sender, isSelected: true)
                    break
                case 1:
                    sender.setTitle(obj.secondDay, for: .normal)
                    setBtnWeekdaysLayout(sender: sender)
                    break
                case 2:
                    sender.setTitle(obj.thirdDay, for: .normal)
                    setBtnWeekdaysLayout(sender: sender)
                    break
                case 3:
                    sender.setTitle(obj.fourthDay, for: .normal)
                    setBtnWeekdaysLayout(sender: sender)
                    break
                case 4:
                    sender.setTitle(obj.fifthDay, for: .normal)
                    setBtnWeekdaysLayout(sender: sender)
                    break
                case 5:
                    sender.setTitle(obj.sixthDay, for: .normal)
                    setBtnWeekdaysLayout(sender: sender)
                    break
                case 6:
                    sender.setTitle(obj.seventhDay, for: .normal)
                    setBtnWeekdaysLayout(sender: sender)
                    break
                    
                default :
                    setBtnWeekdaysLayout(sender: sender)
                    break
                }
            }
        }
        
    }
    
    func setBtnWeekdaysLayout(sender: UIButton, isSelected: Bool = false) {
        if isSelected {
            sender.backgroundColor = UIColor.black
            sender.tintColor = UIColor.white
        } else {
            sender.backgroundColor = UIColor.white
            sender.tintColor = UIColor.black
        }
    }
    
    func getCategoryNotes(date: String) {
        
        guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        
        videoList.removeAll()
        APIGetUserEvents(user.userID, eventDate: date) { (isSucceed, message, list) in
            DispatchQueue.main.async(execute: {
                if let objList = list {
                    self.calendarEvents = objList
                } else {
                    self.calendarEvents.removeAll()
                }
                self.manageLayout()
            })
        }
    }
    func manageLayout() {
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    @IBAction func didTappedWeekDays(_ sender: UIButton) {
        
        btnWeekDays.forEach { (sender) in
            setBtnWeekdaysLayout(sender: sender)
        }
        setBtnWeekdaysLayout(sender: sender, isSelected: true)
        if let obj = weekDays {
            var dateStr = ""
            
            switch sender.tag {
            case 0:
                dateStr = obj.firstDate
                break
            case 1:
                dateStr = obj.secondDate
                break
            case 2:
                dateStr = obj.thirdDate
                break
            case 3:
                dateStr = obj.fourthDate
                break
            case 4:
                dateStr = obj.fifthDate
                break
            case 5:
                dateStr = obj.sixthDate
                break
            case 6:
                dateStr = obj.seventhDate
                break
                
            default :
                dateStr = ""
                break
            }
            if dateStr.count > 0 {
                self.getCategoryNotes(date: dateStr)
            }
        }
    }
    
    
}


// MARK: - TableView DataSource and Delegate
extension TrainingGlossaryEventListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (calendarEvents.count > 0) ? calendarEvents.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.calendarEvents.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CalendarEventCell
            let obj = self.calendarEvents[indexPath.row]
            
            cell.ConfigureCell(obj)
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

extension TrainingGlossaryEventListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.calendarEvents[indexPath.row]
        
        let vc = UIStoryboard.loadTrainingGlossaryVC()
        vc.categoryEvent = obj
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension TrainingGlossaryEventListVC {
    // API Add Document
    func APIGetWeekDays( CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ weekDays: WeekDays?)-> Void) {
        let url = SERVERURL.getWeekDatesandDays
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let dataList = dictResponse["weekDatesandDays"] as? [String: Any] {
                    let obj = WeekDays(Data: dataList)
                    completion(true,message, obj)
                    return
                }
                completion(false,"Some error occured, Please try after some time!", nil)
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!", nil)
            }
        }
    }
    func APIGetUserEvents(_ userID: String, eventDate date: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ eventList:[CalendarEvents]?)-> Void) {
        let url = SERVERURL.getUserEvents + "&userid=\(userID)&eventdate=\(date)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["allevents"] as? [[String: Any]] {
                        let list = CalendarEvents.PopulateArray(array: dataList)
                        
                        completion(true,message, list)
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
    
    func APISessionVideos(_ categoryID: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ videoList:[Video]?)-> Void) {
        let url = SERVERURL.getSessionVideos + "&cat_id=\(categoryID)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["allvideos"] as? [[String: Any]] {
                        let list = Video.PopulateArray(array: dataList)
                        
                        completion(true,message, list)
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
    
    
    
}
