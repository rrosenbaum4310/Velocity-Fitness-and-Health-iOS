//
//  UIViewController+NavBar.swift
//  LynkedWorld
//
//  Created by Macbook on 17/11/17.
//  Copyright © 2017 Arusys. All rights reserved.
//

import UIKit
import SDWebImage
extension UIViewController {
    
    func setupNavigationControllerItem() {
        
        if let img = UIImage(named: "logo-black") {
            let imageView = UIImageView(image:img)
            self.navigationItem.titleView = imageView
        }
        
        
        setupNavigationBarBackground()
        setupLeftBarItems(isMenu: false, isBack: false, isSearch: true)
        setupRightBarItems(isNotification: true)
//        setupSearchController()
    }
    
    
    func setupNaviigationBarItem(withBackButton isBack: Bool, withNotification isNotification: Bool) {
        
        setLogoInTitle()
        setupLeftBarItems(isMenu: false, isBack: isBack, isSearch: false)
        setupRightBarItems(isNotification: isNotification)
        
    }
    
    
    
    func setNavigationBarTitle(title value: String) {
        self.navigationItem.title = value
    }
    
    func setLogoInTitle() {
        
        if let img = UIImage(named: "action-logo") {
            let imageView = UIImageView(image:img)
            navigationItem.titleView = imageView
        }
    }
    
    func setupNavigationBarBackground() {
//        let darkColor   = UIColor(red: 3.0/255.0, green: 143.0/255.0, blue: 192.0/255.0, alpha: 1.0)
//        let lightColor  = UIColor(red: 3.0/255.0, green: 158.0/255.0, blue: 165.0/255.0, alpha: 1.0)
//        let dColor = (color: UIColor(hex: "168DCA"), position: Float(0.0))
//        let mColor = (color: UIColor(hex: "168DCA"), position: Float(0.5))
//        let lColor = (color: UIColor(hex: "168DCA"), position: Float(1.0))
////        UIColor(hex: "168DCA")
//        navigationController?.navigationBar.setGradientBackground(colors: [dColor, mColor, lColor])
//        navigationController?.navigationBar.setBottomBorderColor(color: .white, height: 0.5)
    }
    
    func setupSearchController() {
        
//        let jobsVC = UIStoryboard.loadJobListingVC()
//
//        let searchController = UISearchController(searchResultsController: jobsVC)
//        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.sizeToFit()
//        searchController.hidesNavigationBarDuringPresentation = true
//        searchController.searchBar.barStyle = .default
//        self.definesPresentationContext = true
//        self.extendedLayoutIncludesOpaqueBars = true
//        if #available(iOS 11.0, *) {
//            searchController.searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        } else {
//
//        }
      //  navigationItem.titleView = searchController.searchBar
        
//        let searchColor = UIColor.clear //UIColor(hex: "7EB4C0")
//        let btnSearch = LWButton(type: .custom)
//        btnSearch.cornerRadius = 3
//        btnSearch.borderWidth = 1
//        btnSearch.borderColor = searchColor
//        btnSearch.backgroundColor = UIColor(white: 1.0, alpha: 0.77)
//        btnSearch.setImage(#imageLiteral(resourceName: "search"), for: .normal)
//        btnSearch.setTitleColor(UIColor.black, for: .normal)
//        btnSearch.setTitle("Search", for: .normal)
//        btnSearch.contentHorizontalAlignment = .left
//        btnSearch.contentEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
//        btnSearch.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 0)
//        btnSearch.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 14)
//        let btnWidth: CGFloat = CGFloat.greatestFiniteMagnitude
//        let btnHeight: CGFloat = 35
//        btnSearch.frame = CGRect(x: 0, y: 0, width: btnWidth, height: btnHeight)
//        btnSearch.addTarget(self, action: #selector(self.SearchTapped), for: .touchUpInside)
//        navigationItem.titleView = btnSearch
    }
    
    
    
    fileprivate func setupLeftBarItems(isMenu: Bool, isBack: Bool, isSearch: Bool = false) {
        
        var barItems = [UIBarButtonItem]()
        
        if isBack {
            let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backTapped))
            barItems.append(leftBtn)
        }
//        if isSearch {
//            let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "search-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.SearchTapped))
//            barItems.append(leftBtn)
//        }
        if barItems.count == 0 {
            navigationItem.hidesBackButton = true
        }
        
        navigationItem.leftBarButtonItems = barItems
    }
    
    fileprivate func setupLeftBarItemsWithoutBackAnim(isMenu: Bool, isBack: Bool) {
        
        var barItems = [UIBarButtonItem]()
        if isMenu {
//            let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.menuTapped))
//            barItems.append(leftBtn)
        }
        if isBack {
            let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backTappedWithoutAnimate))
            barItems.append(leftBtn)
        }
        navigationItem.leftBarButtonItems = barItems
    }
    
    
    
    
    fileprivate func setupRightBarItems(isNotification: Bool) {
        
        let barItems = [UIBarButtonItem]()
        if isNotification {
           // let leftBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "notification").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.menuTapped))
            
//            let leftBtn = BadgeBarButtonItem(image: #imageLiteral(resourceName: "bell-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.menuTapped))
//            leftBtn.badgeNumber = 0 //GlobalManager.sharedInstance.getNotificationCount()
//            barItems.append(leftBtn)
        }
        navigationItem.rightBarButtonItems = barItems
    }
    
    func setRightNavigationItems(title: String, selector: Selector) {
        let barItem = BarButtonItems(title: title, selector: selector)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func setRightNavigationItems(image: UIImage, selector: Selector) {
        let barItem = BarButtonItems(image: image, selector: selector)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func setRightNavigationItems(barButtonItems: [UIBarButtonItem]) {
        self.navigationItem.rightBarButtonItems = barButtonItems
    }
    
    func setLeftNavigationItems(title: String, selector: Selector) {
        let barItem = BarButtonItems(title: title, selector: selector)
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func setLeftNavigationItems(image: UIImage, selector: Selector) {
        let barItem = BarButtonItems(image: image, selector: selector)
        self.navigationItem.leftBarButtonItem = barItem
    }
    
    func setLeftNavigationItems(barButtonItems: [UIBarButtonItem]) {
        self.navigationItem.leftBarButtonItems = barButtonItems
    }
    
    
    private func BarButtonItems(title: String, selector: Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        let myFont = UIFont(name: "OpenSans-Semibold", size: 14)
        let strWidth = title.width(withConstraintedHeight: 30, font: myFont!)
        btn.setTitle(title, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: strWidth, height: 30)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        let item = UIBarButtonItem(customView: btn)
        return item
    }
    
    private func BarButtonItems(image: UIImage, selector: Selector) -> UIBarButtonItem {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.setImage(image, for: .normal)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.addTarget(self, action: selector, for: .touchUpInside)
        let item = UIBarButtonItem(customView: btn)
        return item
    }
    
//    @objc fileprivate func menuTapped() {
//        let jobsVC = UIStoryboard.loadNotificationVC()
//        self.navigationController?.pushViewController(jobsVC, animated: true)
//    }
    @objc fileprivate func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc fileprivate func backTappedWithoutAnimate() {
        self.navigationController?.popViewController(animated: false)
    }
    
}

extension UINavigationBar {
    
}






