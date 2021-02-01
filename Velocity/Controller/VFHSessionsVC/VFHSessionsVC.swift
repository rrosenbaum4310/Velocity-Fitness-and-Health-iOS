//
//  VFHSessionsVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit
import SDWebImage

class VFHSessionsVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var stackMainContainer: UIStackView!
    @IBOutlet var imgSessionCollection: [UIImageView]!
    @IBOutlet var btnSessionCollection: [UIButton]!
    @IBOutlet weak var colSession: UICollectionView!
    
//  local Declaration
    fileprivate var categoryList = [Category]()
    let reuseIdentifier = "collSlider"
    
  //   let deviceType = UIDevice.currentDevice().deviceType
    
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
        getCategories()
    }

    func getCategories() {
        appDelegate.showActivityControl()
        APIGetCategories { (isSucceed, message, list) in
            DispatchQueue.main.async(execute: {
                if let objList = list {
                    self.categoryList = objList
                    self.colSession.reloadData()
//                    self.setLayoutContent()
                }
            })
        }
    }
    func setLayoutContent() {
        
        for (index, obj) in categoryList.enumerated() {
            
            if index < 4 {
                let imgView = imgSessionCollection[index]
                let btnSession = btnSessionCollection[index]
                
                btnSession.setTitle("#\(obj.title)", for: .normal)
                if obj.imageURL.count > 0 {
                    let urlString = obj.imageURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    guard let url = URL(string: urlString!) else {
                        imgView.image = UIImage(named: "get-strong")
                        return
                    }
                   imgView.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
                        if image == nil {
                            
                        } else {
                            
                        }
                    }
                } else {
                    imgView.image = UIImage(named: "get-strong")
                }
                
            }
            
        }
    }
    
    @IBAction func didTappedSession(_ sender: UIButton) {
        
        let obj = categoryList[sender.tag]
        UserDefaults.standard.set(obj.categoryID, forKey: "subCatIDInfo")
        self.performSegue(withIdentifier: "DetailPageInfo", sender: nil)

    }
    
    @IBAction func didTappedGetStrong(_ sender: UIButton) {
        
        let notesVC = UIStoryboard.loadNotesVC()
        notesVC.type = .getStrong
        self.navigationController?.pushViewController(notesVC, animated: true)
        
    }
    @IBAction func didTappedGetFit(_ sender: UIButton) {
        let notesVC = UIStoryboard.loadNotesVC()
        notesVC.type = .getFit
        self.navigationController?.pushViewController(notesVC, animated: true)
    }
    @IBAction func didTappedGetConditioned(_ sender: UIButton) {
        let notesVC = UIStoryboard.loadNotesVC()
        notesVC.type = .getConditioned
        self.navigationController?.pushViewController(notesVC, animated: true)
    }
    @IBAction func didTappedBootFit(_ sender: UIButton) {
        let notesVC = UIStoryboard.loadNotesVC()
        notesVC.type = .bootFit
        self.navigationController?.pushViewController(notesVC, animated: true)
    }
    
}
extension VFHSessionsVC {
    // API Add Document
    func APIGetCategories( CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ bannerList:[Category]?)-> Void) {
        let url = SERVERURL.getCategories
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["categories"] as? [[String: Any]] {
                        let list = Category.PopulateArray(array: dataList)
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

extension VFHSessionsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollSessionsCell else {
                let cellDefault = collectionView
                    .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                
                return cellDefault
        }
        cell.backgroundColor = .clear
        // Configure the cell
        
        let obj = categoryList[indexPath.row]
        cell.configureCell(obj)
        
        cell.btnTitle.tag = indexPath.row
        cell.btnTitle.removeTarget(nil, action: nil, for: .allEvents)
        cell.btnTitle.addTarget(self, action: #selector(self.didTappedSession(_:)), for: .touchUpInside)
        
        //cell.configureVideoCell()
        
        cell.contentView.layer.cornerRadius = 5
        cell.contentView.layer.masksToBounds = true
        
        // Configure the cell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
extension VFHSessionsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        let padding: CGFloat = 10
//        let width = (collectionView.bounds.size.width / 2) - (padding * 2)
        //let height = width * (1.45)
        let width = (collectionView.bounds.size.width) - (padding * 2)
     //   let height = width * (2.5/4)
         if(self.view.frame.size.height == 808){
        return CGSize(width: width, height: 168)
        }
        if(self.view.frame.size.height == 724){
        return CGSize(width: width, height: 147)
        }
        if(self.view.frame.size.height == 672){
        return CGSize(width: width, height: 143)
        }
        if(self.view.frame.size.height == 603){
        return CGSize(width: width, height: 125)
        }
         return CGSize(width: width, height: 101)
        
        //return CGSize(width: 100, height: 100)  //collectionView.bounds.size

    }
}

extension VFHSessionsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

/*
 if(self.view.frame.size.height == 896){
        let padding: CGFloat = 10
//        let width = (collectionView.bounds.size.width / 2) - (padding * 2)
        //let height = width * (1.45)
        let width = (collectionView.bounds.size.width) - (padding * 2)
        let height = width * (2.5/4)
        return CGSize(width: width, height: 140)
        }
        else if(self.view.frame.size.height == 667){
        let padding: CGFloat = 10
        let width = (collectionView.bounds.size.width) - (padding * 2)
        let height = width * (2.5/4)
        return CGSize(width: width, height: 125)
        }
       else if(self.view.frame.size.height == 568){
       let padding: CGFloat = 10
        let width = (collectionView.bounds.size.width) - (padding * 2)
        let height = width * (2.5/4)
        return CGSize(width: width, height: 110)
        }
*/
