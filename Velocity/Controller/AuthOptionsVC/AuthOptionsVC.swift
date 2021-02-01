//
//  AuthOptionsVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit
import FontAwesome_swift

class AuthOptionsVC: UIViewController {
// MARK: - Declaration
    @IBOutlet weak var stackMainContainer: UIStackView!
    @IBOutlet weak var viewLogoContainer: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewOptionsContainer: UIView!
    @IBOutlet weak var btnLogin: VFHGradientButton!
    @IBOutlet weak var btnSignup: VFHGradientButton!
    
//  local Declaration
    
    
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
        
    }

    @IBAction func didTappedLogin(_ sender: UIButton) {
        let loginVc = UIStoryboard.loadLoginVC()
        self.navigationController?.pushViewController(loginVc, animated: true)
    }
    
    @IBAction func didTappedSignUp(_ sender: UIButton) {
        let signupVc = UIStoryboard.loadSignUpVC()
        self.navigationController?.pushViewController(signupVc, animated: true)
    }
    
}
