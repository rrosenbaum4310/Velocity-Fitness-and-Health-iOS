//
//  DashBoardTabController.swift
//  Velocity
//
//  Created by Vishal Gohel on 15/02/19.
//

import UIKit

class DashBoardTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.unselectedItemTintColor = .white
        self.tabBar.tintColor = UIColor(hex: "eb642d")
        // Do any additional setup after loading the view.
        
        
//        if let font = UIFont(name: "OpenSans", size: UIFont.systemFontSize) {
//            let appearance = UITabBarItem.appearance(whenContainedInInstancesOf: [DashBoardTabController.self])
//            //appearance.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
//            appearance.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
//        }
        
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension DashBoardTabController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if  selectedViewController == nil || viewController == selectedViewController {
            return true
        }
        
        let fromView = selectedViewController?.view
        let toView = viewController.view
        
        UIView.transition(from: fromView!, to: toView!, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        
        return true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let nav = viewController as? UINavigationController {
            nav.popToRootViewController(animated: true)
            if tabBarController.selectedIndex == 1 {
                if let controller = nav.viewControllers.first as? MemberProfileVC {
                    controller.isImgSelected = false
                    controller.resetMemberShipData()
                } else if let controller = nav.viewControllers.first as? ExcerciseVC {
                    controller.resetMemberShipData()
                }
                
            }
        }
    }
    
}
extension UITabBar {
    // Workaround for iOS 11's new UITabBar behavior where on iPad, the UITabBar inside
    // the Master view controller shows the UITabBarItem icon next to the text
    override open var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        return super.traitCollection
    }
}
