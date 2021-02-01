//
//  EventVC.swift
//  Velocity
//
//  Created by Hexagon on 10/05/19.
//

import UIKit
import SDWebImage
class EventVC: UIViewController {

    @IBOutlet weak var lblDescriptionTitle: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var txtViewDescripation: UITextView!
    @IBOutlet weak var imgEvent: UIImageView!
    var strEventId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
        // Do any additional setup after loading the view.
        lblDescriptionTitle.isHidden = true
        guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        self.APIGetUserDetails(user.userID, eventId: strEventId) { (isSuccess, msg, data) in
            guard let strUrl = data!["image"] as? String,let title = data!["title"] as? String,let starttime = data!["starttime"] as? String,let eventendtime = data!["eventendtime"] as? String,let description = data!["description"] as? String else {
                return
            }
            let urlString = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: urlString!) else {
                return
            }
            DispatchQueue.main.async {
                self.imgEvent.sd_setImage(with: url, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, error, type, imgURL) in
                    if image != nil {
                        self.imgEvent.image = image
                    }
                }

                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imgEvent.image = UIImage(data: data)
                    }
                }
                    self.lblDescriptionTitle.isHidden = false
                    self.lblHeader.text = title
                    self.lblTiming.text = "\(starttime) TO \(eventendtime)"
                    self.txtViewDescripation.attributedText = description.htmlToAttributedString
            }
        }
    }
    
    // API Add Document
    func APIGetUserDetails(_ userID: String,eventId:String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String, _ eventData: [String: Any]?)-> Void) {
        let url = SERVERURL.getEventData + "&userid=\(userID)&eventid=\(eventId)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let data = dictResponse["eventdetails"] as? [String: Any] {
                        
                        completion(true,message, data)
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

