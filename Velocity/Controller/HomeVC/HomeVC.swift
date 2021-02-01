//
//  HomeVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit

class HomeVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var colSlider: UICollectionView!
    @IBOutlet weak var callPager: UIPageControl!
    
    
//  local Declaration
    let reuseIdentifier = "collSlider"
    fileprivate var bannersList = [Banner]()
    var timer: Timer?
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.setupNaviigationBarItem(withBackButton: false, withNotification: false)
        initialSetup()
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
        getBanners()
        
    }
    
    func getBanners() {
        APIGetBanners { (isSucceed, message, banners) in
            DispatchQueue.main.async(execute: {
                if let bannerList = banners {
                    self.bannersList = bannerList
                    self.colSlider.reloadData()
                    self.setPager()
                }
            })
        }
    }
    func setPager() {
       // if(NSString(format: "%@",(self.bannersList.count) as CVarArg) == 1){
        if(Int(self.bannersList.count) == 1){
            callPager.alpha = 0
        }
        callPager.numberOfPages = self.bannersList.count
        callPager.currentPage = 0
        startTimer()
    }
    /**
     Scroll to Next Cell
     */
    @objc func scrollToNextCell(){
        
        //get cell size
        let cellSize = CGSize(width: self.colSlider.frame.width, height: self.colSlider.frame.height)
        
        //get current content Offset of the Collection view
        let contentOffset = colSlider.contentOffset
        
        //scroll to next cell
        var rect = CGRect.zero
        rect.origin.x = contentOffset.x + cellSize.width
        
        if colSlider.contentSize.width <= colSlider.contentOffset.x + cellSize.width {
            rect.origin.x = 0
            callPager.currentPage = 0
        } else {
            rect.origin.x = contentOffset.x + cellSize.width
            callPager.currentPage += 1
        }
        
        rect.size = cellSize
        colSlider.scrollRectToVisible(rect, animated: true)
        
    }
    
    /**
     Invokes Timer to start Automatic Animation with repeat enabled
     */
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(self.scrollToNextCell), userInfo: nil, repeats: true)
        
//        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("scrollToNextCell"), userInfo: nil, repeats: true);
        
        
    }
}


extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.bannersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CollSliderCell else {
                let cellDefault = collectionView
                    .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
              
                return cellDefault
        }
        cell.backgroundColor = .white
        // Configure the cell
        let model = self.bannersList[indexPath.row]
        cell.configureCell(model)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}

extension HomeVC: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let path = self.colSlider.indexPathsForVisibleItems.first {
            callPager.currentPage = path.row
        }
    }
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}
extension HomeVC {
    // API Add Document
    func APIGetBanners( CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ bannerList:[Banner]?)-> Void) {
        let url = SERVERURL.getBanners
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let dataList = dictResponse["banners"] as? [[String: Any]] {
                        let bannersList = Banner.PopulateArray(array: dataList)
                        completion(true,message, bannersList)
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
