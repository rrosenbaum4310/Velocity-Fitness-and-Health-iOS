//
//  TermAndConditionVC.swift
//  Velocity
//
//  Created by Hexagon on 09/05/19.
//

import UIKit

class TermAndConditionVC: UIViewController {
    @IBOutlet weak var lblTilte: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtViewDetail: UITextView!
    
    var intContentType = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.APIGetUserEvents(intContentType) { (isSuccess, msg, arrData) in
            print("fsdfd",arrData)
            DispatchQueue.main.async(execute: {
                if let title = arrData!["title"] as? String{
                    self.lblTilte.text = title
                }
                if let description = arrData!["description"] as? String{
                    self.txtViewDetail.attributedText = description.htmlToAttributedString
                }
            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
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
extension TermAndConditionVC {
    // API Add Document
    func APIGetUserEvents(_ contentid: Int, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ bannerList:[String:Any]?)-> Void) {
        let url = SERVERURL.getContent + "&contentid=\(contentid)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                
                    if let dataList = dictResponse["content"] as? [String : Any] {
                        print("gdfdffg",dataList)
                        completion(true,message, dataList)
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
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
