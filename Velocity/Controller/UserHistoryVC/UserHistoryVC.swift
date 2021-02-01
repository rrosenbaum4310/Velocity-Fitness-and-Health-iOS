//
//  UserHistoryVC.swift
//  Velocity
//
//  Created by Hexagon on 11/11/19.
//

import UIKit

class UserHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    

    
    @IBOutlet weak var tblView: UITableView!
    var arrData = [UserHistory]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        tblView.cellLayoutMarginsFollowReadableWidth = false
        self.getMemberHistory()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    //MARK:- Navigation Setup
    func initialSetup() {
        self.setupNaviigationBarItem(withBackButton: true, withNotification: false)
    }
    
    //MARK:- TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrData.isEmpty ? 0 : self.arrData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tblCellUserHistory", for: indexPath) as! tblCellUserHistory
            let index = indexPath.row - 1
            cell.lblDate_Time.text = arrData[index].createddate
            cell.lblBenchPress.text = arrData[index].bench_press
            cell.lblBackSquat.text = arrData[index].back_squat
            cell.lblDeadLift.text = arrData[index].deadlift
            cell.lbl500m.text = arrData[index].mRow500
//            cell.lblHeight.text = arrData[index].height
            cell.lblWeight.text = arrData[index].weight
            cell.lblTimeTrial.text = arrData[index].time_trial
            cell.lblFitnessName.text = arrData[index].fitnessname
            cell.lblMaxBridge.text = arrData[index].max_bridge
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        }
        return 50
    }
   //MARK:- External Method
    func getMemberHistory() {
        
        guard let user = GlobalManager.sharedInstance.getCurrentUser() else {
            return
        }
        APIGetUserHistory(user.userID) { (isSucceed, message, list) in
            //DispatchQueue.main.async(execute: {
                if let obj = list {
                    self.arrData = obj
                    self.tblView.isHidden = self.arrData.isEmpty
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                }else{
                
                    self.showAlertView(message: message, defaultActionTitle: "OK", complitionHandler: {
                        self.tblView.isHidden = true
                    })
            }
           
            //})
        }
        
    }
}
extension UserHistoryVC{
    func APIGetUserHistory(_ userID: String, CompletionHandler completion:@escaping (_ isSucceed: Bool, _ message: String, _ userDetail: [UserHistory]?)-> Void) {
        let url = SERVERURL.getUserHistory + "&userid=\(userID)"
        ApiManager.sharedManager.cancelAllTasks()
        ApiManager.sharedManager.requestForGet(urlQuery: url) { (response, error) in
            appDelegate.hideActivityControl()
            if error == nil, let dictResponse = response as? [String: Any] {
                print(dictResponse)
                let message = dictResponse["message"] as? String ?? "Some error occured, Please try after some time!"
                if let isStatus = dictResponse["status"] as? String, isStatus == "success" {
                    if let data = dictResponse["userhistory"] as? [[String: Any]] {
                        var aArrData = [UserHistory]()
                        for i in data {
                            let detail = UserHistory(Data: i)
                            aArrData.append(detail)
                        }
                        completion(true,message, aArrData)
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
