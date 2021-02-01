//
//  TimeTableVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit
import AVKit

class TimeTableVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var colVideoContainer: UICollectionView!
    @IBOutlet var btnWeekDays: [VFHButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewEvents: UIView!
    @IBOutlet weak var viewVideoContainer: UIView!
    @IBOutlet weak var nslcColVideoHeight: NSLayoutConstraint!
    @IBOutlet weak var nslcTblEventsHeight: NSLayoutConstraint!
    
//  local Declaration
    var viewLine = UIView()
    let reuseIdentifier = "collSlider"
    var weekDays: WeekDays?
    var calendarEvents = [[String:Any]]()
    var videoList = [Video]()
    let cellIdentifier = "CalendarEventImageCell"//"cell"
    private let cellErrorIdentifier = "cellErrorMessageIdentifier"
    
    
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
            self.colVideoContainer.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
        self.colVideoContainer.removeObserver(self, forKeyPath: "contentSize")
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
                 self.viewLine.isHidden = true
                if let obj = object as? UITableView {
                    if obj === tableView {
                        if calendarEvents.count > 0 {
                            tableView.isScrollEnabled = false
                            self.viewEvents.isHidden = false
                            nslcTblEventsHeight.constant = newsize.height
                        } else {
                            self.viewEvents.isHidden = true
                        }
                        
                    }
                    self.view.layoutIfNeeded()
                } else if let objCol = object as? UICollectionView {
                    if objCol == colVideoContainer {
                        if videoList.count > 0 {
                            self.viewVideoContainer.isHidden = false
                            nslcColVideoHeight.constant = newsize.height
                            
                        } else {
                            self.viewVideoContainer.isHidden = true
                        }

                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
// MARK: - Methods
    func initialSetup() {
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
        self.viewContainer.isHidden = false
        self.tableView.tableFooterView = UIView()
        viewLine.backgroundColor = UIColor(hex: "EB642D")
        viewLine.isHidden = true
        viewVideoContainer.isHidden = true
        self.tableView.addSubview(viewLine)
        //getWeekDays()
        self.getCategoryNotes(date: "")
    }
    func getWeekDays() {
        
        appDelegate.showActivityControl()
        APIGetWeekDays { (isSucceed, message, dataObj) in
            DispatchQueue.main.async(execute: {
                if let obj = dataObj {
                    self.viewContainer.isHidden = false
                    self.weekDays = obj
                    self.setLayoutContent()
//                    self.getCategoryNotes(date: obj.firstDate)
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
        self.viewVideoContainer.isHidden = true
        videoList.removeAll()
        APIGetUserEvents(user.userID, eventDate: date) { (isSucceed, message, list, videos) in
            DispatchQueue.main.async(execute: {
                if let objList = list {
                    self.calendarEvents = objList
                } else {
                    self.calendarEvents.removeAll()
                }
                
                if let vList = videos {
                    self.videoList = vList
                } else {
                    self.videoList.removeAll()
                }
 
                self.manageLayout()
            })
        }
    }
    func manageLayout() {
        self.tableView.isHidden = false
        self.tableView.reloadData()
        self.colVideoContainer.reloadData()
    }
    func getCategoryVideos(categoryID: String) {
        appDelegate.showActivityControl()
        APISessionVideos(categoryID) { (isSucceed, message, list) in
            DispatchQueue.main.async(execute: {
                if let objList = list {
                    self.videoList = objList
                } else {
                    self.videoList.removeAll()
                }
                self.manageVideoLayout()
            })
        }
    }
    func manageVideoLayout() {
        if self.videoList.count > 0 {
            viewVideoContainer.isHidden = false
        } else {
            viewVideoContainer.isHidden = true
        }
        self.colVideoContainer.reloadData()
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

extension TimeTableVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollSliderCell else {
                let cellDefault = collectionView
                    .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                
                return cellDefault
        }
        cell.backgroundColor = .clear
        // Configure the cell
        
        let obj = videoList[indexPath.row]
        cell.configureVideoCell(obj)
        
        //cell.configureVideoCell()
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        // Configure the cell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}

extension TimeTableVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 5
        let width = (collectionView.bounds.size.width / 2) - (padding * 2)
        let height = width * 1.2 //* (2.5/4)
        return CGSize(width: width, height: height)
        
        //return CGSize(width: 100, height: 100)  //collectionView.bounds.size
    }
}

extension TimeTableVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = videoList[indexPath.row]
        playVideo(video: obj)
    }
    
    func playVideo(video: Video) {
        if video.imageURL.count > 0 {
            let urlString = video.imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let videoURL = URL(string: urlString!) else {
                return
            }
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}

// MARK: - TableView DataSource and Delegate
extension TimeTableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (calendarEvents.count > 0) ? calendarEvents.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (self.calendarEvents.count > 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! CalendarEventImageCell //CalendarEventCell
            let obj = self.calendarEvents[indexPath.row]
            cell.ConfigureImageCell(obj)
//            cell.ConfigureCell(obj)
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

extension TimeTableVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let obj = self.calendarEvents[indexPath.row]
//        getCategoryVideos(categoryID: obj.categoryID)
 //       let obj = self.calendarEvents[indexPath.row]
//        
//        let vc = UIStoryboard.loadTrainingGlossaryVC()
//        vc.categoryEvent = obj
//        self.navigationController?.pushViewController(vc, animated: true)
       // openImage(imageURL: obj.offer)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? CalendarEventImageCell else {
            return
        }
        
        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.imgEventPoster
        }
        
        present(ImageViewerController(configuration: configuration), animated: true)
        
        
    }
    
    
    func openImage(imageURL: String) {
//        guard let url = URL(string: imageURL) else {
//            return
//        }
//
//        let images = [
//            LightboxImage(imageURL: url)
//        ]
//
//        // Create an instance of LightboxController.
//        let controller = LightboxController(images: images)
//
//        // Set delegates.
//        controller.pageDelegate = self
//        controller.dismissalDelegate = self
//
//        // Use dynamic background.
//        controller.dynamicBackground = true
//
//        // Present your controller.
//        present(controller, animated: true, completion: nil)
        
    }
    
}

//extension TimeTableVC: LightboxControllerPageDelegate {
//    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
//        
//    }
//    
//    
//}
//extension TimeTableVC: LightboxControllerDismissalDelegate {
//    func lightboxControllerWillDismiss(_ controller: LightboxController) {
//        
//    }
//    
//    
//}


extension TimeTableVC {
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
    func APIGetUserEvents(_ userID: String, eventDate date: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ eventList:[[String:Any]]?, _ videoList:[Video]?)-> Void) {
        let url = SERVERURL.getUserEvents //+ "&userid=\(userID)"// "&eventdate=\(date)"
        ApiManager.sharedManager.cancelAllTasks()
        print("sdfdfdfserfe",url)
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    
                    var imgList = [[String:Any]]()
                    var vList = [Video]()
                    if let dataList = dictResponse["timetableimage"] as? [String: Any] {
//                        let list = CalendarEvents.PopulateArray(array: dataList)
                        imgList = [dataList]
                    }
                    if let dataList = dictResponse["allvideos"] as? [[String: Any]] {
                        let list = Video.PopulateArray(array: dataList)
                        vList = list
                    }
                    completion(true,message, imgList, vList)
                    return
                } else {
                    completion(false,message, nil, nil)
                }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!", nil, nil)
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
