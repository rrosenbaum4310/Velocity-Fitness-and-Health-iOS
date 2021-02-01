//
//  TrainingGlossaryVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit

class TrainingGlossaryVC: UIViewController {
// MARK: - Declaration
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tblTrainingDetails: UITableView!
    @IBOutlet weak var lblTrainingTimeslot: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
//  local Declaration
    let cellIdentifier = "NoteDetailCellIdentifier"
    private let cellErrorIdentifier = "cellErrorMessageIdentifier"
    var categoryEvent: CalendarEvents?
    var traningNotes = [TrainingGlossaryNote]()
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup() 
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
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
        self.tblTrainingDetails.tableFooterView = UIView()
        self.tblTrainingDetails.tableHeaderView = headerView
        self.tblTrainingDetails.isHidden = true
        if let obj = categoryEvent {
            lblTrainingTimeslot.text = "\(obj.startTime) to \(obj.endTime)"
        }
        getTrainingNotes()
    }
    func getTrainingNotes() {
        
        guard let obj = categoryEvent else {
            return
        }
        
        appDelegate.showActivityControl()
        APIGetTrainingNotes(obj.categoryID) { (isSucceed, message, list) in
            DispatchQueue.main.async(execute: {
                if let objList = list {
                    self.traningNotes = objList
                } else {
                    self.traningNotes.removeAll()
                }
                self.manageLayout()
            })
        }
    }
    func manageLayout() {
        self.tblTrainingDetails.isHidden = false
        self.tblTrainingDetails.reloadData()
    }
}

// MARK: - TableView DataSource and Delegate
extension TrainingGlossaryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.traningNotes.count > 0) ? self.traningNotes.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.traningNotes.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NoteDetailCell
            let obj = self.traningNotes[indexPath.row]
            
            cell.ConfigureCell(text: obj.message, isEditIcon: false)
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

extension TrainingGlossaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension TrainingGlossaryVC {
    // API Add Document
    
    func APIGetTrainingNotes(_ catID: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ noteList:[TrainingGlossaryNote]?)-> Void) {
        let url = SERVERURL.getTrainingGlossary + "&catid=\(catID)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                
                    if let dataList = dictResponse["glosssary"] as? [[String: Any]] {
                        let list = TrainingGlossaryNote.PopulateArray(array: dataList)
                        
                        completion(true,message, list)
                        return
                    }
                    completion(false,"Some error occured, Please try after some time!", nil)
                
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!", nil)
            }
        }
    }
    
}
