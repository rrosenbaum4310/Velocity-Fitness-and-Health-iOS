//
//  NotesVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit
import SDWebImage

class NotesVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var tblNotes: UITableView!
    @IBOutlet weak var btnAddNotes: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblTimeSlot: UILabel!
    @IBOutlet weak var lblNotesTitle: UILabel!
    @IBOutlet weak var imgBgView: UIImageView!
    
    
//  local Declaration
    let cellIdentifier = "NoteDetailCellIdentifier"
    private let cellErrorIdentifier = "cellErrorMessageIdentifier"
    var type: VFHSessionType = .getStrong
    var category: Category?
    
    var categoryNotesList = [DateWiseNotes]()
    var categorySessionNoteList = [[String: Any]]()
    
    var isNotes = false
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isNotes{
            self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
            self.setRightNavigationItems(title: "Your Notes", selector: #selector(self.didTappedViewMore(_:)))
        }else{
            self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
        }
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
        self.tblNotes.tableFooterView = UIView()
        self.tblNotes.tableHeaderView = headerView
        tblNotes.isHidden = true
        if let categoryObj = category {
            type = categoryObj.type
            appDelegate.showActivityControl()
            lblHeaderTitle.text = categoryObj.title
            lblHeaderTitle.backgroundColor = .clear
            getCategoryNotes(category: categoryObj)
        }
        
//        if type == .getStrong {
//            lblHeaderTitle.text = "Get Strong"
//        } else if type == .getFit {
//            lblHeaderTitle.text = "Get Fit"
//        } else if type == .getConditioned {
//            lblHeaderTitle.text = "Get Conditioned"
//        } else {
//            lblHeaderTitle.text = "Boot Fit"
//        }
        
    }
    
    func getCategoryNotes(category: Category) {
        guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        self.imgBgView.isHidden = !isNotes
        if isNotes == false {
            APIGetCategoryNotes(user.userID, category: category.categoryID) { (isSucceed, message, list) in
                DispatchQueue.main.async(execute: {
                    if let objList = list {
                        
                        self.categoryNotesList = objList
                        
                    }
                    self.manageLayout()
                })
            }
        }else{
            APIGetSessionNotes(category: category.categoryID) { (isSucced, message, list) in
                DispatchQueue.main.async(execute: {
                    if let objList = list {
                        self.categorySessionNoteList = objList
                        for i in objList{
                            let imgUrl:String = i["backgroundimage"] as? String ?? ""
                            let urlNew = imgUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                            guard let url = URL(string: urlNew!) else {
                                self.imgBgView.image = UIImage(named: "get-strong")
                                return
                            }
                            self.imgBgView.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
                                if image == nil {
                                    
                                } else {
                                    self.imgBgView.image = image
                                }
                            }
                        }
                        
                    }
                    self.manageLayout()
                })
            }
        }
        
    }
    func manageLayout() {
        self.tblNotes.isHidden = false
        self.tblNotes.reloadData()
    }
    
    @IBAction func didTappedAddNotes(_ sender: Any) {
        let vc = UIStoryboard.loadNotesPopupVC()
        vc.category = category
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func didTappedViewMore(_ sender: UIButton) {
        let notesVC = UIStoryboard.loadNotesVC()
        notesVC.category = self.category
        notesVC.isNotes = false
        self.navigationController?.pushViewController(notesVC, animated: true)
    }
}

// MARK: - TableView DataSource and Delegate
extension NotesVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.categoryNotesList.count > 0) && isNotes == false ? self.categoryNotesList.count : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isNotes == false{
            guard self.categoryNotesList.count > 0 else {
                return 1
            }
            
            let noteObj = categoryNotesList[section]
            return (noteObj.notes.count > 0) ? noteObj.notes.count : 1
        }else{
            
            return categorySessionNoteList.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isNotes == false{
            if (self.categoryNotesList.count > 0) {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! NoteDetailCell
                let noteObj = categoryNotesList[indexPath.section]
                let obj = noteObj.notes[indexPath.row]
                
                cell.ConfigureCell(text: obj.notes, isEditIcon: true)
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
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoteSessionDetail") as! NoteSessionDetail
            let aStrNote = categorySessionNoteList[indexPath.row]["note"] as? String ?? ""
//            cell.lblNotes.text = aStrNote.html2String
            cell.lblNotes.setAttributedHtmlText(aStrNote)
            cell.viewSeparate.isHidden = categorySessionNoteList.count <= 1 
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (self.categoryNotesList.count > 0) ? 60 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard self.categoryNotesList.count > 0 else {
            return UIView()
        }
        
        let noteObj = categoryNotesList[section]
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "NotesHeaderCell") as! NotesHeaderCell
        headerCell.lblDate.text = noteObj.date
        headerCell.lblDuration.text = noteObj.difference
        headerCell.backgroundColor = .clear
        return headerCell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension NotesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if categoryNotesList.count > 0 && isNotes == false{
            let noteObj = categoryNotesList[indexPath.section]
            let note = noteObj.notes[indexPath.row]
            let vc = UIStoryboard.loadNotesPopupVC()
            vc.category = category
            vc.categoryNote = note
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
        
    }
}
extension NotesVC {
    // API Add Document
    func APIGetCategoryNotes(_ userID: String, category categoryID: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ bannerList:[DateWiseNotes]?)-> Void) {
        let url = SERVERURL.getDateWiseNotes + "&userid=\(userID)&catid=\(categoryID)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["notes"] as? [[String: Any]] {
                        let list = DateWiseNotes.PopulateArray(array: dataList, catID: categoryID, userID: userID)
                       // let filteredList = list.filter{ $0.categoryID == categoryID && $0.userID == userID }
                        let filteredList = list.filter { $0.notes.count > 0 }
                        completion(true, message, filteredList)
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
    func APIGetSessionNotes(category categoryID: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ bannerList:[[String: Any]]?)-> Void) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        let url = SERVERURL.getSessionNotes + "&catid=\(categoryID)&cdate=\(result)"
         ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print("werwerwer",dictResponse["sessionnotes"])
                
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["sessionnotes"] as? [[String: Any]] {
                        print("dataList --adi",dataList)
                        completion(true, "success", dataList)
                        return
                    }
                    completion(false,"Some error occured, Please try after some time!", nil)
                } else {
                    completion(false,"Some error occured, Please try after some time!", nil)
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!", nil)
            }
        }
    }
}
extension NotesVC: NotePopupDelegate {
    func didAddNewNote(_ controller: NotesPopupVC) {
        if let categoryObj = category {
            getCategoryNotes(category: categoryObj)
        }
    }
}
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html3AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html3AttributedString?.string ?? ""
    }
}
extension String {
    
    var utfData: Data {
        return Data(utf8)
    }
    
    var attributedHtmlString: NSAttributedString? {
        
        do {
            return try NSAttributedString(data: utfData,
                                          options: [
                                            .documentType: NSAttributedString.DocumentType.html,
                                            .characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}

extension UILabel {
    func setAttributedHtmlText(_ html: String) {
        if let attributedText = html.attributedHtmlString {
            self.attributedText = attributedText
        }
    }
}
