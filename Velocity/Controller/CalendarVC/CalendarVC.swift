//
//  CalendarVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 20/02/19.
//

import UIKit
import FSCalendar

class CalendarVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {
// MARK: - Declaration
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
     @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
//  local Declaration
    let cellIdentifier = "cell"
    private let cellErrorIdentifier = "cellErrorMessageIdentifier"
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }()
    fileprivate var selectedDate = Date()
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    var calendarEvents = [CalendarEvents]()
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        self.calendar.delegate = self
        self.calendar.dataSource = self
        self.calendar.select(Date())
        
        self.tableView.tableFooterView = UIView()
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .month
        self.tableView.isHidden = true
        getCategoryEvents()
    }
    
    func getCategoryEvents() {
        let dateFM = dateFormatter
        dateFM.dateFormat = "yyyy-MM-dd"
        let dateString = dateFM.string(from: selectedDate)
        getCategoryNotes(date: dateString)
    }
    
    func getCategoryNotes(date: String) {
        
        guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        
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
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        selectedDate = date
        getCategoryEvents()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
    
    
    // MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.calendarEvents.count > 0) {
            print("dsdssdfd",self.calendarEvents[indexPath.row].eventid,self.calendarEvents.count)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventVC") as! EventVC
            vc.strEventId = "\(self.calendarEvents[indexPath.row].eventid)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    // MARK:- Target actions
    
    @IBAction func toggleClicked(sender: AnyObject) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }

}

extension CalendarVC {
    // API Add Document
    func APIGetUserEvents(_ userID: String, eventDate date: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ bannerList:[CalendarEvents]?)-> Void) {
        let url = SERVERURL.getCalendar + "&userid=\(userID)&eventdate=\(date)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["alluserevents"] as? [[String: Any]] {
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
}
