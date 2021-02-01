//
//  ExcerciseVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 03/04/19.
//

import UIKit
import AVKit
import BDKCollectionIndexView

class ExcerciseVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var colVideoContainer: UICollectionView!
    @IBOutlet weak var lblErrorMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    
//  local Declaration
    var indexView: BDKCollectionIndexView!
    var isFirstAttempt = true
    let reuseIdentifier = "collSlider"
    var videoList = [String: [Video]]()
    var allVideoList: [Video] = []
    let alphabetsChars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    let searchController = UISearchController(searchResultsController: nil)
    var searchKey = ""
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.showActivityControl()
        getCategoryVideos()
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
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){
            
//            if let newvalue = change?[.newKey]{
//                let newsize  = newvalue as! CGSize
//            }
        }
    }
    
    // MARK: - Methods
    func initialSetup() {
        self.setupNaviigationBarItem(withBackButton: false, withNotification: false)
        
        let indexWidth: CGFloat = 28
        
        let frm = CGRect(x: colVideoContainer.frame.size.width - indexWidth, y: colVideoContainer.frame.size.height, width: indexWidth, height: colVideoContainer.frame.size.height)
        
        
        indexView = BDKCollectionIndexView(frame: frm, indexTitles: nil)
        indexView.addTarget(self, action: #selector(self.indexViewValueChanged(sender:)), for: .valueChanged)
        view.addSubview(indexView)
        indexView.touchStatusViewAlpha = 0
        indexView.translatesAutoresizingMaskIntoConstraints = false
        indexView.topAnchor.constraint(equalTo: colVideoContainer.topAnchor, constant: 0).isActive = true
        indexView.bottomAnchor.constraint(equalTo: colVideoContainer.bottomAnchor, constant: 0).isActive = true
        indexView.leadingAnchor.constraint(equalTo: colVideoContainer.trailingAnchor, constant: 0).isActive = true
        indexView.widthAnchor.constraint(equalToConstant: indexWidth).isActive = true
        indexView.indexTitles = alphabetsChars
        
        appDelegate.showActivityControl()
        getCategoryVideos()
        setupSearchViewController()
    }
    func setupSearchViewController() {
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.isActive = true
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Search Excercise"
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
           // self.tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        
        
    }
    @objc func indexViewValueChanged(sender: BDKCollectionIndexView) {
        
        let title = sender.currentIndexTitle
        
        let allKeys = Array(videoList.keys).sorted()
        
        if let val = title,  let indexObj = allKeys.index(of: val) {
            let path = IndexPath(row: 0, section: indexObj)
            colVideoContainer.scrollToItem(at: path, at: .top, animated: false)
            
            if indexObj != allKeys.count - 1 {
                colVideoContainer.contentOffset = CGPoint(x: colVideoContainer.contentOffset.x,
                                                          y: colVideoContainer.contentOffset.y - 50.0)
            }
            
        }
    
        
        
//        let path = NSIndexPath(forItem: 0, inSection: )
//        colVideoContainer.scrollToItemAtIndexPath(path, atScrollPosition: .Top, animated: false)
//        // If you're using a collection view, bump the y-offset by a certain number of points
//        // because it won't otherwise account for any section headers you may have.
//        colVideoContainer.contentOffset = CGPoint(x: colVideoContainer.contentOffset.x,
//                                                  y: colVideoContainer.contentOffset.y - 45.0)
    }
    func resetMemberShipData() {
        if !isFirstAttempt {
            getCategoryVideos()
        }
    }
    func getCategoryVideos() {
        
        isFirstAttempt = false
        APISessionVideos { (isSucceed, message, list) in
            DispatchQueue.main.async(execute: {
                if let objList = list {
                    self.allVideoList = objList
                    self.manageVideoListArray(list: objList, searchText: "")
                    //self.videoList = objList
                } else {
                    self.videoList.removeAll()
                }
                self.manageVideoLayout()
            })
        }
    }
    
    func manageVideoListArray(list: [Video], searchText: String) {
        
        var vList = [String: [Video]]()
        
        let filteredList = (searchText.count > 0) ? list.filter { $0.title.lowercased().hasPrefix(searchText.lowercased()) } : list
        
        if searchText.count > 0 && filteredList.count == 0 {
            lblErrorMessage.text = "Exercise video not found"
        }
        
        if searchText.count == 0 {
            lblErrorMessage.text = "Exercise video not added."
        }
        
        for value in alphabetsChars {
            let filteredList = filteredList.filter { $0.title.lowercased().hasPrefix(value.lowercased()) }
            if filteredList.count > 0 {
                vList[value] = filteredList
            }
        }
        self.videoList = vList
    }
    
    
    func manageVideoLayout() {
        let allKeys = videoList.keys
        if allKeys.count > 0 {
            self.colVideoContainer.isHidden = false
            self.lblErrorMessage.isHidden = true
            self.indexView.isHidden = false
        } else {
            self.colVideoContainer.isHidden = true
            self.lblErrorMessage.isHidden = false
            self.indexView.isHidden = true
        }
        self.colVideoContainer.reloadData()
    }
    
}
extension ExcerciseVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let allKeys = videoList.keys
        return allKeys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let allKeys = Array(videoList.keys).sorted()
        let keyVal = allKeys[section]
        return videoList[keyVal]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header: CollHeaderCell!
        
        if kind == UICollectionView.elementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as? CollHeaderCell
            
            let allKeys = Array(videoList.keys).sorted()
            let keyVal = allKeys[indexPath.section]
            
            header.lblTitle.text = keyVal
            return header
        } else {
            
            return UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.size.width, height: 0))
        }
        

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
        
        let allKeys = Array(videoList.keys).sorted()
        let keyVal = allKeys[indexPath.section]
        
        if let list = videoList[keyVal] {
            let obj = list[indexPath.row]
            cell.configureVideoCell(obj)
        }
        
        
        //cell.configureVideoCell()
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        return cell
    }
    
    
    
}

extension ExcerciseVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let width = collectionView.bounds.size.width - ((padding * 2)) //(collectionView.bounds.size.width / 2) - (padding * 2)
        let height = width * (2.5/4)
        return CGSize(width: width, height: height)  //collectionView.bounds.size
    }
}

extension ExcerciseVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let allKeys = Array(videoList.keys).sorted()
        let keyVal = allKeys[indexPath.section]
        
        if let list = videoList[keyVal] {
            let obj = list[indexPath.row]
            playVideo(video: obj)
        }
        
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


extension ExcerciseVC {
    // API Add Document
    
    func APISessionVideos(CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ videoList:[Video]?)-> Void) {
        let url = SERVERURL.getTrainingGlossary //getSessionVideosURL
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["glosssary"] as? [[String: Any]] {
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

extension ExcerciseVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        
        if allVideoList.count > 0 {
            var searchValue = ""
            if let searchText = searchController.searchBar.text,
                !searchText.isEmpty {
                //            pageCounter = 1
                //            self.isHasMore = true
                            searchValue = searchText
                //            isSearching = true
            }
            self.manageVideoListArray(list: allVideoList, searchText: searchValue)
            self.manageVideoLayout()
        }
        
       
//        searchKey = searchValue
//        apiCall(key: searchValue)
        
    }
}
