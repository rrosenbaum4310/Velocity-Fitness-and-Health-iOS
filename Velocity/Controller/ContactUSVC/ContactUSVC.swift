//
//  ContactUSVC.swift
//  Velocity
//
//  Created by Vishal Gohel on 14/02/19.
//

import UIKit
import MapKit
import MessageUI
class ContactUSVC: UIViewController, MFMailComposeViewControllerDelegate {
// MARK: - Declaration
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblWeblink: UILabel!
    @IBOutlet weak var stackMainContainer: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collVIew: UICollectionView!
    
    
//  local Declaration
    fileprivate var contactObj: ContactDetail?
    let arrTitle = ["Terms and Conditions","Privacy Policy"]
    
// MARK: - Controllers LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        collVIew.delegate = self
        collVIew.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNaviigationBarItem(withBackButton: false, withNotification: false)
        getContactDetails()
        
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
        lblEmail.text = ""
        lblAddress.text = ""
        lblWeblink.text = ""
        stackMainContainer.isHidden = true
        getContactDetails()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEmailLabel(sender:)))
        lblEmail.isUserInteractionEnabled = true
        lblEmail.addGestureRecognizer(tapGesture)
        
        let tapURLGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapWebURLLinkLabel(sender:)))
        lblWeblink.isUserInteractionEnabled = true
        lblWeblink.addGestureRecognizer(tapURLGesture)
    }
    @objc
    func tapEmailLabel(sender:UITapGestureRecognizer) {
        print("tap working")
        
        if let text = lblEmail.text, text.count > 0 {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([text])
                mail.setMessageBody("", isHTML: true)
                
                present(mail, animated: true)
            } else {
                // show failure alert
            }
        }
        
    }
    
    @objc
    func tapWebURLLinkLabel(sender:UITapGestureRecognizer) {
        print("tap working")
        
        if let text = lblWeblink.text, text.count > 0 {
            var urlString = text
            if !text.lowercased().contains("http://") || !text.lowercased().contains("https://") {
                urlString = "http://" + text
            }
            let strUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let url = URL(string: strUrl!) else { return }
            UIApplication.shared.open(url, options: [:]) { (isSucceed) in
                
            }
        }
        
    }
    
    func getContactDetails() {
        appDelegate.showActivityControl()
        APIGetContactDetails { (isSucceed, message, contact) in
            DispatchQueue.main.async(execute: {
                if let obj = contact {
                    self.contactObj = obj
                    self.setDetails()
                }
            })
        }
    }
    
    func setDetails() {
        if let obj = contactObj {
            lblEmail.text = obj.email
            lblAddress.text = obj.address
            lblWeblink.text = obj.webLink
            stackMainContainer.isHidden = false
            
            if obj.latitude.count > 0 && obj.longitude.count > 0 {
                
                guard let latn = NumberFormatter().number(from: obj.latitude), let longn = NumberFormatter().number(from: obj.longitude) else { return }
                let latitude = CGFloat(truncating: latn)
                let longitude = CGFloat(truncating: longn)
                let annotation = MKPointAnnotation()
                annotation.title = "Velocity Fitness and Health"
                annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                mapView.addAnnotation(annotation)
//                mapView.fitAll()
                mapView.showAnnotations([annotation], animated: true)
            } 
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)

        let alertController = UIAlertController(title: title, message: "Mail Sent Successfully", preferredStyle: .alert)
                           let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                           }
                           alertController.addAction(OKAction)
                           self.present(alertController, animated: true, completion: nil)
        
    }
}
extension ContactUSVC {
    // API Add Document
    func APIGetContactDetails( CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String,_ contactDetail:ContactDetail?)-> Void) {
        let url = SERVERURL.getContactUsDetails
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                //if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                if let dataList = dictResponse["contactus"] as? [String: Any] {
                    let obj = ContactDetail(Data: dataList)
                    completion(true,message, obj)
                    return
                } else {
                    completion(false,"Some error occured, Please try after some time!", nil)
                }
                
                //} else {
                  //  completion(false,message, nil)
               // }
            } else {
                print(error?.localizedDescription as Any)
                completion(false,"Some error occured, Please try after some time!", nil)
            }
        }
    }
}
extension MKMapView {
    /// when we call this function, we have already added the annotations to the map, and just want all of them to be displayed.
    func fitAll() {
        var zoomRect            = MKMapRect.null;
        for annotation in annotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect       = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect            = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
    /// we call this function and give it the annotations we want added to the map. we display the annotations if necessary
    func fitAll(in annotations: [MKAnnotation], andShow show: Bool) {
        var zoomRect:MKMapRect  = MKMapRect.null
        
        for annotation in annotations {
            let aPoint          = MKMapPoint(annotation.coordinate)
            let rect            = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
            
            if zoomRect.isNull { //MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        if(show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
}
extension ContactUSVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitle.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollCellContactUs", for: indexPath) as! CollCellContactUs
        cell.btnTitle.setTitle(arrTitle[indexPath.row], for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermAndConditionVC") as! TermAndConditionVC
        vc.intContentType = indexPath.row == 0 ? 3 : 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width/2 - 5, height: collectionView.bounds.size.height - 5)
    }
    
}
